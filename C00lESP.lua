-- Настройки
local COLORS = {
    Killer = Color3.fromRGB(255, 50, 50),    -- Красный
    Survivor = Color3.fromRGB(50, 255, 50),  -- Зеленый
    Computer = Color3.fromRGB(255, 255, 50)  -- Желтый
}

-- Пути к объектам
local PATHS = {
    Killers = "GameAssets.Teams.Killer",
    Survivors = "GameAssets.Teams.Survivor",
    Computers = "GameAssets.Debris.Cleanable.Computer.Model" -- Полный путь к компьютеру
}

-- Поиск объекта по пути
local function findObject(path)
    local current = workspace
    for _, name in ipairs(string.split(path, ".")) do
        current = current:FindFirstChild(name)
        if not current then return nil end
    end
    return current
end

-- Создание ESP
local function createESP(obj, text, color)
    -- Удаляем старые элементы
    for _, child in ipairs(obj:GetChildren()) do
        if child:IsA("Highlight") or child.Name == "ESP_BILLBOARD" then
            child:Destroy()
        end
    end

    -- Подсветка
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_HIGHLIGHT"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.9
    highlight.Parent = obj

    -- Текст
    if text then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_BILLBOARD"
        billboard.Adornee = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj
        billboard.Size = UDim2.new(5, 0, 2, 0)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.LightInfluence = 0
        billboard.Parent = obj

        local label = Instance.new("TextLabel")
        label.Text = text
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 18
        label.TextStrokeTransparency = 0.5
        label.Parent = billboard
    end
end

-- Получение здоровья
local function getHealth(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    return humanoid and math.floor(humanoid.Health) or "N/A"
end

-- Основная функция
local function updateESP()
    -- Убийцы
    local killerFolder = findObject(PATHS.Killers)
    if killerFolder then
        for _, killer in ipairs(killerFolder:GetChildren()) do
            if killer:IsA("Model") then
                createESP(killer, "KILLER", COLORS.Killer)
            end
        end
    end

    -- Выжившие (с здоровьем)
    local survivorFolder = findObject(PATHS.Survivors)
    if survivorFolder then
        for _, survivor in ipairs(survivorFolder:GetChildren()) do
            if survivor:IsA("Model") then
                local health = getHealth(survivor)
                createESP(survivor, "HP: "..health, COLORS.Survivor)
            end
        end
    end

    -- Компьютеры (исправленный путь)
    local computer = findObject(PATHS.Computers)
    if computer then
        createESP(computer, "COMPUTER", COLORS.Computer)
    end
    
    -- Дополнительный поиск компьютеров (на всякий случай)
    for _, comp in ipairs(workspace:GetDescendants()) do
        if comp.Name == "Computer" and comp:IsA("Model") then
            createESP(comp, "COMPUTER", COLORS.Computer)
        end
    end
end

-- Автообновление
local runESP = true
while runESP do
    updateESP()
    wait(1.5)
end
