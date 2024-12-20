
local Unstable = {}

-- Themes
Unstable.Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(255, 255, 255),
        Button = Color3.fromRGB(30, 30, 30)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(0, 0, 0),
        Button = Color3.fromRGB(220, 220, 220)
    }
}

-- Destroy existing GUI if already present
function Unstable:DestroyExisting()
    local existingGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Unstable")
    if existingGui then
        existingGui:Destroy()
    end
end

-- Initialize the Unstable UI
function Unstable:Create(config)
    self:DestroyExisting()

    -- Create new GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "Unstable"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = config.Size or UDim2.fromOffset(600, 400)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = config.Theme.Background or Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0.1, 0)
    uiCorner.Parent = mainFrame

    local selfGui = {MainFrame = mainFrame, ScreenGui = gui, Theme = config.Theme, Tabs = {}}
    setmetatable(selfGui, {__index = self})
    return selfGui
end

-- Create a Tab
function Unstable:Tab(config)
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = config.Name or "New Tab"
    tabFrame.Size = UDim2.new(1, 0, 0.9, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = #self.Tabs == 0
    tabFrame.Parent = self.MainFrame

    table.insert(self.Tabs, tabFrame)
    return setmetatable({Parent = tabFrame, Theme = self.Theme}, {__index = self})
end

-- Create a Button
function Unstable:Button(config)
    local button = Instance.new("TextButton")
    button.Size = config.Size or UDim2.new(0.4, 0, 0.1, 0)
    button.Position = config.Position or UDim2.new(0.3, 0, 0.1 * #self.Parent:GetChildren(), 0)
    button.Text = config.Name or "Button"
    button.BackgroundColor3 = self.Theme.Button or Color3.fromRGB(30, 30, 30)
    button.TextColor3 = self.Theme.Text or Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Parent = self.Parent

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0.1, 0)
    uiCorner.Parent = button

    if config.Callback then
        button.MouseButton1Click:Connect(config.Callback)
    end

    return button
end

-- Create a Toggle
function Unstable:Toggle(config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = config.Size or UDim2.new(0.4, 0, 0.1, 0)
    toggleFrame.BackgroundColor3 = self.Theme.Button or Color3.fromRGB(30, 30, 30)
    toggleFrame.Parent = self.Parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = config.Name or "Toggle"
    label.TextColor3 = self.Theme.Text or Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.3, 0, 0.8, 0)
    toggleButton.Position = UDim2.new(0.7, 0, 0.1, 0)
    toggleButton.Text = "Off"
    toggleButton.BackgroundColor3 = self.Theme.Accent or Color3.fromRGB(50, 50, 50)
    toggleButton.TextColor3 = self.Theme.Text or Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Parent = toggleFrame

    local state = false
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.Text = state and "On" or "Off"
        if config.Callback then
            config.Callback(state)
        end
    end)

    return toggleFrame
end

-- Create a Dropdown
function Unstable:Dropdown(config)
    local dropdown = Instance.new("TextButton")
    dropdown.Size = config.Size or UDim2.new(0.4, 0, 0.1, 0)
    dropdown.Position = config.Position or UDim2.new(0.3, 0, 0.1 * #self.Parent:GetChildren(), 0)
    dropdown.Text = config.Name or "Select..."
    dropdown.BackgroundColor3 = self.Theme.Button
    dropdown.TextColor3 = self.Theme.Text
    dropdown.TextScaled = true
    dropdown.Parent = self.Parent

    local items = config.Items or {}
    dropdown.MouseButton1Click:Connect(function()
        print("Dropdown items:", table.concat(items, ", "))
        if config.Callback then
            config.Callback(items[1]) -- Example: return the first item
        end
    end)

    return dropdown
end

-- Create a Slider
function Unstable:Slider(config)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = config.Size or UDim2.new(0.4, 0, 0.1, 0)
    sliderFrame.BackgroundColor3 = self.Theme.Button
    sliderFrame.Parent = self.Parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Text = config.Name or "Slider"
    label.TextColor3 = self.Theme.Text
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Parent = sliderFrame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0.7, 0, 0.5, 0)
    slider.Position = UDim2.new(0.3, 0, 0.25, 0)
    slider.BackgroundColor3 = self.Theme.Accent
    slider.TextColor3 = self.Theme.Text
    slider.Text = tostring(config.Default or 0)
    slider.TextScaled = true
    slider.Parent = sliderFrame

    local value = config.Default or 0
    slider.MouseButton1Click:Connect(function()
        value = math.clamp(value + 1, config.Min or 0, config.Max or 100)
        slider.Text = tostring(value)
        if config.Callback then
            config.Callback(value)
        end
    end)

    return sliderFrame
end

-- Create a Keybind
function Unstable:Keybind(config)
    local keybindButton = Instance.new("TextButton")
    keybindButton.Size = config.Size or UDim2.new(0.4, 0, 0.1, 0)
    keybindButton.Position = config.Position or UDim2.new(0.3, 0, 0.1 * #self.Parent:GetChildren(), 0)
    keybindButton.Text = config.Name or "Keybind"
    keybindButton.BackgroundColor3 = self.Theme.Button
    keybindButton.TextColor3 = self.Theme.Text
    keybindButton.TextScaled = true
    keybindButton.Parent = self.Parent

    local key = config.Keybind or Enum.KeyCode.E
    keybindButton.MouseButton1Click:Connect(function()
        print("Press any key to bind...")
        local inputConnection
        inputConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                keybindButton.Text = tostring(key)
                if config.Callback then
                    config.Callback(key)
                end
                inputConnection:Disconnect()
            end
        end)
    end)

    return keybindButton
end

-- Create a Prompt
function Unstable:Prompt(config)
    local promptFrame = Instance.new("Frame")
    promptFrame.Size = config.Size or UDim2.new(0.5, 0, 0.3, 0)
    promptFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    promptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    promptFrame.BackgroundColor3 = self.Theme.Button
    promptFrame.Parent = self.MainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.6, 0)
    label.Text = config.Title or "Prompt"
    label.TextColor3 = self.Theme.Text
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Parent = promptFrame

    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0.4, 0)
    buttonFrame.Position = UDim2.new(0, 0, 0.6, 0)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = promptFrame

    for name, callback in pairs(config.Buttons or {}) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.5, -5, 1, 0)
        button.Text = name
        button.TextScaled = true
        button.BackgroundColor3 = self.Theme.Accent
        button.TextColor3 = self.Theme.Text
        button.Parent = buttonFrame

        button.MouseButton1Click:Connect(function()
            callback()
            promptFrame:Destroy()
        end)
    end

    return promptFrame
end

-- Create a Notification
function Unstable:Notification(config)
    local notification = Instance.new("TextLabel")
    notification.Size = config.Size or UDim2.new(0.3, 0, 0.1, 0)
    notification.Position = UDim2.new(0.5, 0, 0, -50)
    notification.AnchorPoint = Vector2.new(0.5, 0.5)
    notification.BackgroundColor3 = self.Theme.Button
    notification.TextColor3 = self.Theme.Text
    notification.Text = config.Text or "Notification"
    notification.TextScaled = true
    notification.Parent = self.MainFrame

    task.delay(config.Duration or 3, function()
        notification:Destroy()
        if config.Callback then
            config.Callback()
        end
    end)

    return notification
end

-- Create a Credit
function Unstable:Credit(config)
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Size = config.Size or UDim2.new(1, 0, 0.1, 0)
    creditLabel.Position = config.Position or UDim2.new(0, 0, 1, -50)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Text = (config.Name or "Unknown") .. " - " .. (config.Description or "Contributor")
    creditLabel.TextColor3 = self.Theme.Text
    creditLabel.TextScaled = true
    creditLabel.Parent = self.MainFrame

    return creditLabel
end
-- The functions follow the verified implementations provided earlier.

return Unstable
