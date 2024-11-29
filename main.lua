--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Settings
local aimbotEnabled = false
local tracersEnabled = true
local espEnabled = false
local autoDodgeEnabled = false
local aimRadius = 300
local tracerThickness = 2
local aimSmoothing = 5
local tracers = {}
local espBoxes = {}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = aimRadius
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Transparency = 1
FOVCircle.Filled = false
FOVCircle.Visible = true

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 600)
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Dragging Functionality
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Aimbot & Modes GUI"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 20
TitleLabel.Parent = TitleBar

-- Add Toggle Buttons
local function addToggleButton(parent, name, position, callback)
    local Button = Instance.new("TextButton")
    Button.Text = name .. ": OFF"
    Button.Size = UDim2.new(0, 360, 0, 50)
    Button.Position = UDim2.new(0, 20, 0, position)
    Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 18
    Button.Parent = parent

    Button.MouseButton1Click:Connect(function()
        local state = callback()
        Button.Text = name .. ": " .. (state and "ON" or "OFF")
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
end

-- Add Settings Toggles
addToggleButton(MainFrame, "Aimbot", 60, function()
    aimbotEnabled = not aimbotEnabled
    return aimbotEnabled
end)

addToggleButton(MainFrame, "Auto Dodge", 120, function()
    autoDodgeEnabled = not autoDodgeEnabled
    return autoDodgeEnabled
end)

addToggleButton(MainFrame, "ESP (Wallhack)", 180, function()
    espEnabled = not espEnabled
    return espEnabled
end)

addToggleButton(MainFrame, "Tracers", 240, function()
    tracersEnabled = not tracersEnabled
    return tracersEnabled
end)

addToggleButton(MainFrame, "Show FOV Circle", 300, function()
    FOVCircle.Visible = not FOVCircle.Visible
    return FOVCircle.Visible
end)

-- Update FOV Circle
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = aimRadius
end)

-- Visibility and Team Check
local function isEnemy(player)
    if player.Team and LocalPlayer.Team then
        return player.Team ~= LocalPlayer.Team
    end
    return true
end

local function isVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 1000
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, direction, rayParams)
    return result and result.Instance == targetPart
end

-- Get Closest Target
local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = aimRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isEnemy(player) and player.Character:FindFirstChild("HumanoidRootPart") then
            local head = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if onScreen and distance < shortestDistance and isVisible(head) then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPart = target.Character:FindFirstChild("Head")
            local direction = (targetPart.Position - Camera.CFrame.Position).Unit
            local targetCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, aimSmoothing / 100)
        end
    end
end)

-- Auto Dodge Logic
local function dodgeThreat()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart

    -- Loop through all moving objects in the workspace
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("BasePart") and object.Velocity.Magnitude > 10 then
            local distance = (object.Position - humanoidRootPart.Position).Magnitude
            if distance < 15 then -- Dodge if within a 15-stud radius
                local dodgeDirection = (humanoidRootPart.Position - object.Position).Unit * 10
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + dodgeDirection
                break
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if autoDodgeEnabled then
        dodgeThreat()
    end
end)

-- ESP Logic
RunService.RenderStepped:Connect(function()
    for _, esp in ipairs(espBoxes) do
        esp:Remove()
    end
    espBoxes = {}

    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and isEnemy(player) then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local espBox = Drawing.new("Text")
                        espBox.Text = player.Name
                        espBox.Position = Vector2.new(headPos.X, headPos.Y - 20)
                        espBox.Color = Color3.fromRGB(255, 0, 0)
                        espBox.Size = 16
                        espBox.Visible = true
                        table.insert(espBoxes, espBox)
                    end
                end
            end
        end
    end
end)

-- Tracers Logic
RunService.RenderStepped:Connect(function()
    for _, tracer in ipairs(tracers) do
        tracer:Remove()
    end
    tracers = {}

    if tracersEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local tracerLine = Drawing.new("Line")
                    tracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    tracerLine.To = Vector2.new(rootPos.X, rootPos.Y)
                    tracerLine.Color = Color3.fromRGB(255, 0, 0)
                    tracerLine.Thickness = tracerThickness
                    tracerLine.Visible = true
                    table.insert(tracers, tracerLine)
                end
            end
        end
    end
end)
