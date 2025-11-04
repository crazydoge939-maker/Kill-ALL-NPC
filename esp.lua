Script ALL SCRIPT

local autoKill = false
local killIntervalSeconds = 5
local killedNamesCount = {} -- таблица для подсчета убитых за текущий период

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "Humanoid"

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Вкл"
toggleButton.Parent = ScreenGui

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, 250, 0, 150)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
infoLabel.Text = "Убитых: 0\n"
infoLabel.TextWrapped = true
infoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Parent = ScreenGui

local function updateGUI()
    local text = "Убитых: " .. tostring(table.concat({tostring(killedCount)}, ", ")) .. "\n"
    for name, count in pairs(killedNamesCount) do
        text = text .. name .. " x" .. count .. "\n"
    end
    infoLabel.Text = text
end

toggleButton.MouseButton1Click:Connect(function()
    autoKill = not autoKill
    if autoKill then
        toggleButton.Text = "Выкл"
    else
        toggleButton.Text = "Вкл"
    end
end)

while true do
    wait(killIntervalSeconds)
    if autoKill then
        -- Обнуляем таблицу перед новым подсчетом
        killedNamesCount = {}
        local killedThisCycle = false
        local totalKilled = 0

        for _, npc in pairs(workspace:GetChildren()) do
            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 and npc ~= game.Players.LocalPlayer.Character then
                -- Убиваем NPC
                humanoid.Health = 0
                local name = npc.Name
                killedNamesCount[name] = (killedNamesCount[name] or 0) + 1
                totalKilled = totalKilled + 1
                print("Убит: " .. name)
                killedThisCycle = true
            end
        end

        -- Обновляем общее количество убитых
        killedCount = killedCount + totalKilled

        -- Обновляем GUI
        updateGUI()

        -- Выводим в консоль текущие данные
        print("Последний период убито NPC:")
        for name, count in pairs(killedNamesCount) do
            print(name .. ": " .. count)
        end
    end
end
