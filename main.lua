--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")

-- Add to Player GUI
ScreenGui.Name = "Seb X"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
MainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Main Frame Glow
local mainGlow = Instance.new("UIStroke")
mainGlow.Thickness = 5
mainGlow.Color = Color3.fromRGB(0, 255, 150)
mainGlow.Transparency = 0.4
mainGlow.Parent = MainFrame

-- Sidebar
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Sidebar
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Content Frame
ContentFrame.Size = UDim2.new(1, -120, 1, 0)
ContentFrame.Position = UDim2.new(0, 120, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -80, 0, 5)
MinimizeButton.Text = "━"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Parent = MainFrame

local minimized = false
local RestoreButton = Instance.new("TextButton")
RestoreButton.Size = UDim2.new(0, 60, 0, 30)
RestoreButton.Position = UDim2.new(0, 10, 1, -40)
RestoreButton.Text = "Show"
RestoreButton.Font = Enum.Font.GothamBold
RestoreButton.TextSize = 16
RestoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RestoreButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RestoreButton.BorderSizePixel = 0
RestoreButton.Visible = false
RestoreButton.Parent = ScreenGui

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Visible = not minimized
    RestoreButton.Visible = minimized
end)

RestoreButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    RestoreButton.Visible = false
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.Text = "✖"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Page Management
local pages = {}
local function switchToPage(pageName)
    for name, page in pairs(pages) do
        page.Visible = (name == pageName)
    end
end

-- Sidebar Button Creator
local function createSidebarButton(text, parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.BorderSizePixel = 0
    button.Parent = parent

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end)

    button.MouseButton1Click:Connect(callback)
end

-- Default Home Page
local homePage = Instance.new("Frame")
homePage.Size = UDim2.new(1, 0, 1, 0)
homePage.BackgroundTransparency = 1
homePage.Parent = ContentFrame
pages["Home"] = homePage

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, -10, 0, 40)
welcomeLabel.Position = UDim2.new(0, 5, 0, 10)
welcomeLabel.Text = "Welcome to Seb X!"
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 24
welcomeLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Parent = homePage

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 120)
infoLabel.Position = UDim2.new(0, 5, 0, 60)
infoLabel.Text = "What's New:\n- Tracers for debugging\n- Aim practice trainer\n- Modern UI design!"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 18
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextWrapped = true
infoLabel.BackgroundTransparency = 1
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = homePage

createSidebarButton("Home", Sidebar, function() switchToPage("Home") end)

-- Features Page
local featuresPage = Instance.new("Frame")
featuresPage.Size = UDim2.new(1, 0, 1, 0)
featuresPage.BackgroundTransparency = 1
featuresPage.Visible = false
featuresPage.Parent = ContentFrame
pages["Features"] = featuresPage

local featuresLabel = Instance.new("TextLabel")
featuresLabel.Size = UDim2.new(1, -10, 0, 40)
featuresLabel.Position = UDim2.new(0, 5, 0, 10)
featuresLabel.Text = "Features"
featuresLabel.Font = Enum.Font.GothamBold
featuresLabel.TextSize = 24
featuresLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
featuresLabel.BackgroundTransparency = 1
featuresLabel.Parent = featuresPage

-- Add Tracers Button to Features Page
local function addTracers()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local part = Instance.new("Part", workspace)
            part.Size = Vector3.new(0.1, 0.1, 0.1)
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 1 -- Invisible part to attach the tracer

            local beam = Instance.new("Beam", part)
            beam.FaceCamera = true
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)) -- Red line
            beam.Width0 = 0.1
            beam.Width1 = 0.1
            beam.Attachment0 = Instance.new("Attachment", part)
            beam.Attachment1 = Instance.new("Attachment", player.Character:FindFirstChild("HumanoidRootPart"))

            -- Update tracer position
            game:GetService("RunService").RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    part.Position = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
                else
                    part:Destroy()
                end
            end)
        end
    end
end

local tracersButton = Instance.new("TextButton")
tracersButton.Size = UDim2.new(1, -10, 0, 40)
tracersButton.Position = UDim2.new(0, 5, 0, 150)
tracersButton.Text = "Toggle Tracers"
tracersButton.Font = Enum.Font.GothamBold
tracersButton.TextSize = 16
tracersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tracersButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
tracersButton.Parent = pages["Features"]

tracersButton.MouseButton1Click:Connect(function()
    addTracers()
end)
local function toggleAimbot()
    local aimEnabled = false

    -- Function to check if a player is on the same team as the local player
    local function isOnSameTeam(player)
        return player.Team == game.Players.LocalPlayer.Team
    end

    -- Function to find the nearest enemy
    local function getNearestEnemy()
        local player = game.Players.LocalPlayer
        local nearestEnemy = nil
        local shortestDistance = math.huge

        for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Team ~= player.Team then
                local character = otherPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid").Health > 0 then
                    -- Check if the enemy is visible (no wall between player and enemy)
                    local origin = workspace.CurrentCamera.CFrame.Position
                    local direction = (character.HumanoidRootPart.Position - origin).unit
                    local ray = Ray.new(origin, direction * 1000)
                    local hit, position = workspace:FindPartOnRay(ray, player.Character)

                    if hit and hit:IsDescendantOf(character) then
                        local distance = (character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            nearestEnemy = character.HumanoidRootPart
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
        return nearestEnemy
    end

    -- Update aimbot position if enabled
    game:GetService("RunService").RenderStepped:Connect(function()
        if aimEnabled then
            local target = getNearestEnemy()
            if target then
                local camera = workspace.CurrentCamera
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end
    end)

    -- Toggle aimbot on or off
    return function()
        aimEnabled = not aimEnabled
    end
end

local aimbotToggle = toggleAimbot()

local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(1, -10, 0, 40)
aimbotButton.Position = UDim2.new(0, 5, 0, 200)
aimbotButton.Text = "Toggle Aimbot"
aimbotButton.Font = Enum.Font.GothamBold
aimbotButton.TextSize = 16
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
aimbotButton.Parent = pages["Features"]

aimbotButton.MouseButton1Click:Connect(function()
    aimbotToggle()
end)

createSidebarButton("Features", Sidebar, function() switchToPage("Features") end)

-- Settings Page
local settingsPage = Instance.new("Frame")
settingsPage.Size = UDim2.new(1, 0, 1, 0)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false
settingsPage.Parent = ContentFrame
pages["Settings"] = settingsPage

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, -10, 0, 40)
settingsLabel.Position = UDim2.new(0, 5, 0, 10)
settingsLabel.Text = "Settings"
settingsLabel.Font = Enum.Font.GothamBold
settingsLabel.TextSize = 24
settingsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Parent = settingsPage

-- Additional settings can be added here

createSidebarButton("Settings", Sidebar, function() switchToPage("Settings") end)

-- Default Page
switchToPage("Home")
