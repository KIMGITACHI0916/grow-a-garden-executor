-- Grow a Garden Executor Script for Delta
-- Place this in your executor and run in-game

if game.CoreGui:FindFirstChild("GardenExecutorGui") then
    game.CoreGui.GardenExecutorGui:Destroy()
end

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GardenExecutorGui"
gui.ResetOnSpawn = false

local buttons = {
    Seeds = {
        "Moon Melon","Candy Blossom","Blood Banana","Cocovine","Bendboo","Moon Mango","Rosy Delight","Pitcher Plant",
        "Hive Fruit","Moonglow","Parasol Flower","Purple Dahlia","Sugar Apple","Elephant Ears","Beanstalk","Ember lily",
        "Moon blossom","Sunflower","Rainbow elephant ears","Rainbow sunflower","Rainbow ember lily","rainbow candy blossom",
        "rainbow moon blossom","rainbow sugar apple","rainbow moon mango","rainbow moon melon"
    },
    Crops = {
        "Default","Golden","Rainbow","Wet","Chilled","Frozen","Choc","Moonlit","Windstruck","Pollinated","Bloodlit","Burnt",
        "Verdant","Wiltproof","Plasma","HoneyGlazed","Heavenly","Twisted","Drenched","Cloudtouched","Fried","Cooked",
        "Zombified","Molten","Sundried","Aurora","Shocked","Paradisal","Alienlike","Celestial","Galactic","Disco",
        "Meteoric","Voidtouched","Dawnbound"
    },
    Pets = {
        "Dragonfly","Disco Bee","Raccoon","Mimic Octopus","Fennec Fox","Hyacinth macaw","Petal Bee","Giant Ant Butterfly",
        "Capybara","Queen Bee","Praying Mantis","Silver monkey","Snail","Seal","Moth","Cooked Owl","Polar bear","Dog",
        "Golden Lab","Cat","Orange tabby","Redfox","Squirrel","Moon cat","Star Fish"
    },
    ["Seed Packs"] = {
        "Normal seed pack","Exotic normal seed pack","Exotic seed pack","Night seed pack","Premium night seed pack",
        "Summer seed pack","Exotic summer seed pack","Flower seed pack","Exotic flower seed pack","Crafter Seed pack",
        "Exotic crafter seed pack"
    },
    Eggs = {
        "Premium Night egg","Premium Bug egg","Premium Paradise egg","PremiumBee egg","Premium Anti-bee egg","Premium Oasis egg"
    }
}

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
frame.Position = UDim2.new(0.1, 0, 0.15, 0)
frame.Size = UDim2.new(0, 450, 0, 400)
frame.Active = true
frame.Draggable = true
frame.Name = "MainFrame"
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Grow a Garden Executor"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 27
title.TextColor3 = Color3.fromRGB(255,255,255)

-- Category Buttons
local categories = {"Seeds","Crops","Pets","Seed Packs","Eggs"}
local catBtns = {}
for i,cat in ipairs(categories) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 85, 0, 30)
    btn.Position = UDim2.new(0,(i-1)*0.2,0,45)
    btn.BackgroundColor3 = Color3.fromRGB(50,70,100)
    btn.Text = cat
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Name = cat.."Btn"
    catBtns[cat] = btn
end

-- Item List Frame
local itemFrame = Instance.new("Frame", frame)
itemFrame.Position = UDim2.new(0, 10, 0, 85)
itemFrame.Size = UDim2.new(1, -20, 1, -95)
itemFrame.BackgroundTransparency = 1
itemFrame.Name = "ItemFrame"

local uiList = Instance.new("UIListLayout", itemFrame)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 4)

-- Manual Controls (for Pets/Crops)
local manualFrame = Instance.new("Frame", frame)
manualFrame.Position = UDim2.new(1, 10, 0, 85)
manualFrame.Size = UDim2.new(0, 180, 0, 120)
manualFrame.BackgroundTransparency = 0.2
manualFrame.BackgroundColor3 = Color3.fromRGB(40,50,60)
manualFrame.Visible = false
manualFrame.Name = "ManualFrame"

local ageLabel = Instance.new("TextLabel", manualFrame)
ageLabel.Position = UDim2.new(0, 10, 0, 10)
ageLabel.Size = UDim2.new(0, 60, 0, 24)
ageLabel.Text = "Age:"
ageLabel.BackgroundTransparency = 1
ageLabel.TextColor3 = Color3.fromRGB(255,255,255)
ageLabel.TextSize = 16

local ageBox = Instance.new("TextBox", manualFrame)
ageBox.Position = UDim2.new(0, 70, 0, 10)
ageBox.Size = UDim2.new(0, 90, 0, 24)
ageBox.Text = "0"
ageBox.ClearTextOnFocus = false

local weightLabel = Instance.new("TextLabel", manualFrame)
weightLabel.Position = UDim2.new(0, 10, 0, 44)
weightLabel.Size = UDim2.new(0, 60, 0, 24)
weightLabel.Text = "Weight:"
weightLabel.BackgroundTransparency = 1
weightLabel.TextColor3 = Color3.fromRGB(255,255,255)
weightLabel.TextSize = 16

local weightBox = Instance.new("TextBox", manualFrame)
weightBox.Position = UDim2.new(0, 70, 0, 44)
weightBox.Size = UDim2.new(0, 90, 0, 24)
weightBox.Text = "0"
weightBox.ClearTextOnFocus = false

local applyBtn = Instance.new("TextButton", manualFrame)
applyBtn.Position = UDim2.new(0, 20, 0, 78)
applyBtn.Size = UDim2.new(0, 140, 0, 28)
applyBtn.Text = "Apply"
applyBtn.BackgroundColor3 = Color3.fromRGB(80,170,90)
applyBtn.TextColor3 = Color3.fromRGB(255,255,255)
applyBtn.TextSize = 18

-- Helper to clear itemFrame
local function clearItems()
    for _,c in pairs(itemFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
end

local function showManualControls(isPet)
    manualFrame.Visible = true
    ageLabel.Visible = isPet
    ageBox.Visible = isPet
end

local function hideManualControls()
    manualFrame.Visible = false
end

local currentCat = nil
local selectedItem = nil

-- Category button logic
for cat, btn in pairs(catBtns) do
    btn.MouseButton1Click:Connect(function()
        clearItems()
        hideManualControls()
        currentCat = cat
        selectedItem = nil
        for _,item in ipairs(buttons[cat]) do
            local itemBtn = Instance.new("TextButton", itemFrame)
            itemBtn.Size = UDim2.new(1, 0, 0, 30)
            itemBtn.BackgroundColor3 = Color3.fromRGB(60,100,120)
            itemBtn.Text = item
            itemBtn.TextColor3 = Color3.fromRGB(255,255,255)
            itemBtn.Font = Enum.Font.SourceSans
            itemBtn.TextSize = 16
            itemBtn.Name = "ItemBtn_"..item
            itemBtn.MouseButton1Click:Connect(function()
                selectedItem = item
                if cat == "Pets" then
                    showManualControls(true)
                elseif cat == "Crops" then
                    showManualControls(false)
                else
                    hideManualControls()
                    -- Do your spawn logic here:
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Executor",
                        Text = "Spawned "..item.." ("..cat..")",
                        Duration = 2
                    })
                end
            end)
        end
    end)
end

-- Apply button logic for manual controls
applyBtn.MouseButton1Click:Connect(function()
    if not selectedItem then return end
    local age, weight = tonumber(ageBox.Text) or 0, tonumber(weightBox.Text) or 0
    local msg
    if currentCat == "Pets" then
        msg = "Spawned "..selectedItem.." (Age: "..age..", Weight: "..weight..")"
        -- Insert your pet spawning logic using age/weight here
    elseif currentCat == "Crops" then
        msg = "Spawned "..selectedItem.." (Weight: "..weight..")"
        -- Insert your crop spawning logic using weight here
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "Executor",
        Text = msg,
        Duration = 2
    })
end)

-- Default to Seeds tab
catBtns["Seeds"].MouseButton1Click:Fire()

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- END OF SCRIPT
