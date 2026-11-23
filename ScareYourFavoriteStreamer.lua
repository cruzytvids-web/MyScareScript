-- Robscript Team - Scare Your Favorite Streamer
-- Airflow UI hub for the Roblox experience "Scare Your Favorite Streamer" (place 121011978933862).
-- Client-side automation only: knock on doors, scare streamers, steal packages, carry them home,
-- place and open them, train Speed and Scare, claim rewards and buy upgrades.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local CollectionService = game:GetService("CollectionService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Every reload replaces the instance id, so loops left over from an older copy stop by themselves.
local instanceId = tostring(os.time()) .. "-" .. tostring(math.random(100000, 999999))
if getgenv then
	getgenv().RobscriptTeamScareInstance = instanceId
end

local function alive()
	if not getgenv then
		return true
	end
	return getgenv().RobscriptTeamScareInstance == instanceId
end

local UI_SOURCES = {
	"https://raw.githubusercontent.com/bobloscript/Robly_Airflow/main/Source.luau",
	"https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau",
}

local Airflow
for _, url in ipairs(UI_SOURCES) do
	local ok, library = pcall(function()
		return loadstring(game:HttpGet(url))()
	end)
	if ok and type(library) == "table" and type(library.CreateWindow) == "function" then
		Airflow = library
		break
	end
end

if not Airflow then
	error("[Robscript Team] Airflow UI could not be loaded")
end

local THEME = {
	Background = Color3.fromHex("#0A0A0C"),
	Surface = Color3.fromHex("#141418"),
	Surface2 = Color3.fromHex("#1A1A20"),
	Surface3 = Color3.fromHex("#2A2A33"),
	Stroke = Color3.fromHex("#26262E"),
	StrokeHover = Color3.fromHex("#3C3C49"),
	Accent = Color3.fromHex("#FF3B7F"),
	AccentDark = Color3.fromHex("#1A0710"),
	Text = Color3.fromHex("#F5F5F7"),
	Muted = Color3.fromHex("#8D8D99"),
}

Airflow.ThemePresets.Robscript = THEME
Airflow:SetDefaultTheme(THEME)

Airflow:AddLanguage("ru", {
	Name = "Русский",
	Flag = "ru",
	Strings = {
		["farm, training, visuals, settings"] = "фарм, тренировка, визуалы, настройки",
		["Logs"] = "Логи",
		["Farm"] = "Фарм",
		["Training"] = "Тренировка",
		["Automation"] = "Автоматизация",
		["Visuals"] = "Визуалы",
		["Teleport"] = "Телепорт",
		["Settings"] = "Настройки",
		["Activity"] = "Активность",
		["Nothing yet"] = "Пока пусто",
		["Status"] = "Статус",
		["Steal loop"] = "Цикл кражи",
		["Knock, scare, steal, teleport home, open"] = "Стук, испуг, кража, телепорт домой, открытие",
		["House picking"] = "Выбор дома",
		["Best I can scare"] = "Лучший по шансу",
		["Nearest"] = "Ближайший",
		["Highest tier"] = "Высший ранг",
		["Any"] = "Любой",
		["Min chance"] = "Мин. шанс",
		["Houses below this scare chance are skipped"] = "Дома с шансом ниже пропускаются",
		["Carry speed"] = "Скорость переноски",
		["Minimum speed while carrying a package home"] = "Минимальная скорость при переноске пакета домой",
		["Open packages"] = "Открывать пакеты",
		["Opens packages lying on your base"] = "Открывает пакеты на вашей базе",
		["Try this house now"] = "Попробовать этот дом",
		["Teleports to the door and runs one full attempt"] = "Телепорт к двери и полная попытка",
		["Auto Train Speed"] = "Авто-тренировка Speed",
		["Stands on the treadmill and farms Speed"] = "Стоит на дорожке и качает Speed",
		["Auto Train Scare"] = "Авто-тренировка Scare",
		["Stands at the scare trainer and farms Prank"] = "Стоит у тренажёра и качает Prank",
		["Speed gain"] = "Прирост Speed",
		["Scare gain"] = "Прирост Scare",
		["Claim rewards"] = "Забирать награды",
		["Claims index, daily, playtime and offline rewards"] = "Забирает награды индекса, дня, времени и оффлайна",
		["Claim interval"] = "Интервал наград",
		["Seconds between reward claims"] = "Секунд между получением наград",
		["Claim now"] = "Забрать сейчас",
		["Auto upgrades"] = "Авто-апгрейды",
		["Buys treadmill, trainer, base and fans when affordable"] = "Покупает дорожку, тренера, базу и фанатов",
		["Keep cash"] = "Резерв денег",
		["Never spend below this amount"] = "Не тратить ниже этой суммы",
		["Houses ESP"] = "ESP домов",
		["Shows houses with tier, chance and distance"] = "Показывает дома: ранг, шанс, дистанция",
		["Packages ESP"] = "ESP пакетов",
		["Shows packages in houses"] = "Показывает пакеты в домах",
		["Players ESP"] = "ESP игроков",
		["Highlights other players"] = "Подсвечивает других игроков",
		["Best house"] = "Лучший дом",
		["Highlights the house the farm will use"] = "Подсвечивает дом, который выберет фарм",
		["Walk speed"] = "Скорость ходьбы",
		["Overrides humanoid walk speed"] = "Переопределяет скорость персонажа",
		["Jump power"] = "Сила прыжка",
		["Overrides humanoid jump power"] = "Переопределяет силу прыжка",
		["Noclip"] = "Ноклип",
		["Walk through walls"] = "Проход сквозь стены",
		["Anti AFK"] = "Анти-АФК",
		["Keeps you in the server"] = "Не даёт выкинуть с сервера",
		["Go home"] = "Домой",
		["Teleport to your base"] = "Телепорт на вашу базу",
		["Go to house"] = "К дому",
		["Teleport to the door of the selected house"] = "Телепорт к двери выбранного дома",
		["State"] = "Состояние",
		["Idle"] = "Ожидание",
		["Running"] = "Работает",
		["Cash"] = "Деньги",
		["Slots"] = "Слоты",
		["Treadmill"] = "Дорожка",
		["Trainer"] = "Тренер",
		["Base"] = "База",
		["Fans"] = "Фанаты",
		["Objective"] = "Задача",
		["Carry"] = "Переноска",
		["Chance"] = "Шанс",
		["Session"] = "Сессия",
		["Houses"] = "Дома",
		["Configs"] = "Конфиги",
		["Theme"] = "Тема",
		["Loaded"] = "Загружено",
		["Robscript Team is ready"] = "Robscript Team готов",
		["package"] = "пакет",
		["none"] = "нет",
		["Houses found"] = "Найдено домов",
		["No house with a chance right now"] = "Сейчас нет дома с шансом",
	},
})

local Window = Airflow:CreateWindow({
	Name = "Robscript Team",
	LoadingSubtitle = "farm, training, visuals, settings",
	ToggleUIKeybind = "RightControl",
	Size = UDim2.fromOffset(780, 540),
	Backdrop = { Weather = "Fireflies", Tint = 0.35 },
	Theme = THEME,
	ConfigurationSaving = { Enabled = true, FolderName = "RobscriptTeamScare" },
	Home = {
		Title = "Robscript Team",
		Welcome = "Welcome back,",
		Tier = "v1.3",
		Stats = { "Players", "Session", "FPS", "Ping", "Game", "Executor" },
	},
})

---------------------------------------------------------------------
-- Game access
---------------------------------------------------------------------

local Shared = ReplicatedStorage:FindFirstChild("Shared")
local Config = nil
local Odds = nil
if Shared then
	local configModule = Shared:FindFirstChild("Config")
	if configModule then
		local ok, result = pcall(require, configModule)
		if ok and type(result) == "table" then
			Config = result
		end
	end
	local oddsModule = Shared:FindFirstChild("Odds")
	if oddsModule then
		local ok, result = pcall(require, oddsModule)
		if ok and type(result) == "table" then
			Odds = result
		end
	end
end

local World = workspace:FindFirstChild("World")
local HousesFolder = World and World:FindFirstChild("Houses")
local PlotsFolder = World and World:FindFirstChild("Plots")

local TEXT = {
	knock = "Knock on a Door!",
	prank = "Scare the Streamer!",
	steal = "Steal the Package!",
	run = "RUN!!",
	home = "Go to your base!",
	place = "Place your Package!",
	open = "Open the Package!",
}
if Config and type(Config.Text) == "table" then
	for key, value in pairs(TEXT) do
		if type(Config.Text[key]) == "string" then
			TEXT[key] = Config.Text[key]
		end
	end
end

local TIER_RANK = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Epic = 4,
	Legendary = 5,
	Mythic = 6,
	Cosmic = 7,
	Spectral = 8,
	Eternal = 9,
	Divine = 10,
	Prismatic = 15,
	Infinity = 16,
	Omega = 17,
	Immortal = 18,
	Ultimate = 19,
        Majestic = 20,
        Apex = 21,
}

local TIER_COLORS = {
	Common = Color3.fromRGB(166, 166, 168),
	Uncommon = Color3.fromRGB(106, 180, 31),
	Rare = Color3.fromRGB(49, 217, 246),
	Epic = Color3.fromRGB(171, 73, 184),
	Legendary = Color3.fromRGB(248, 205, 66),
	Mythic = Color3.fromRGB(237, 0, 247),
	Cosmic = Color3.fromRGB(155, 95, 190),
	Spectral = Color3.fromRGB(216, 0, 1),
	Eternal = Color3.fromRGB(255, 120, 120),
	Divine = Color3.fromRGB(255, 240, 175),
	Prismatic = Color3.fromRGB(255, 105, 200),
	Infinity = Color3.fromRGB(70, 130, 255),
	Omega = Color3.fromRGB(40, 235, 130),
	Immortal = Color3.fromRGB(0, 225, 200),
	Ultimate = Color3.fromRGB(255, 170, 30),
        Majestic = Color3.fromRGB(255, 215, 100),
        Apex = Color3.fromRGB(255, 50, 50),
}

-- Tier number for every house name, and the recommended Scare for that tier.
local TIER_NUMBER = {}
local TIER_REQUIRED = {}
local TIER_SPEED = {}
if Config and type(Config.Tiers) == "table" then
	for index, row in ipairs(Config.Tiers) do
		if type(row) == "table" and type(row.name) == "string" then
			TIER_NUMBER[row.name] = index
			local houseIndex = Config.HouseOfTier and Config.HouseOfTier[index]
			local houseRow = houseIndex and Config.Houses and Config.Houses[houseIndex]
			if type(houseRow) == "table" then
				TIER_REQUIRED[index] = tonumber(houseRow.recPrank) or 0
				TIER_SPEED[index] = tonumber(houseRow.recSpeed) or 0
			end
		end
	end
end

local TIER_OPTIONS = {
	"Best I can scare",
	"Nearest",
	"Highest tier",
	"Any",
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
	"Cosmic",
	"Spectral",
	"Eternal",
	"Divine",
        "Majestic",
        "Apex",
}

local function fire(name, ...)
	if not Shared then
		return false
	end
	local net = Shared:FindFirstChild("Net")
	local remote = net and net:FindFirstChild(name)
	if remote and remote:IsA("RemoteEvent") then
		remote:FireServer(...)
		return true
	end
	return false
end

local function attr(name)
	return LocalPlayer:GetAttribute(name)
end

local function humanoid()
	local chr = LocalPlayer.Character
	return chr and chr:FindFirstChildOfClass("Humanoid")
end

local function root()
	local chr = LocalPlayer.Character
	return chr and chr:FindFirstChild("HumanoidRootPart")
end

-- Noclip is manual now: the farm teleports home instead of walking, so it is only useful
-- when the player moves around by hand.
local noclipConnection = nil

local function setNoclip(on)
	if on then
		if noclipConnection then
			return
		end
		noclipConnection = RunService.Stepped:Connect(function()
			local chr = LocalPlayer.Character
			if not chr then
				return
			end
			for _, part in ipairs(chr:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
		local chr = LocalPlayer.Character
		if chr then
			for _, part in ipairs(chr:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end

local function teleport(position)
	local hrp = root()
	if not hrp or not position then
		return false
	end
	hrp.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
	hrp.AssemblyLinearVelocity = Vector3.zero
	return true
end

local function promptOf(instance, actionText)
	local fallback
	for _, descendant in ipairs(instance:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") then
			if actionText == nil or descendant.ActionText == actionText then
				return descendant
			end
			fallback = fallback or descendant
		end
	end
	return fallback
end

local function waitPrompt(prompt, timeout)
	if not prompt then
		return false
	end
	local deadline = os.clock() + (timeout or 4)
	while os.clock() < deadline do
		if prompt.Enabled then
			return true
		end
		task.wait(0.05)
	end
	return prompt.Enabled
end

local function firePrompt(prompt, timeout)
	if not waitPrompt(prompt, timeout) then
		return false
	end
	return pcall(fireproximityprompt, prompt)
end

local function formatMoney(value)
	local cash = tonumber(value) or 0
	if cash >= 1e12 then
		return string.format("$%.2fT", cash / 1e12)
	elseif cash >= 1e9 then
		return string.format("$%.2fB", cash / 1e9)
	elseif cash >= 1e6 then
		return string.format("$%.2fM", cash / 1e6)
	elseif cash >= 1e3 then
		return string.format("$%.2fK", cash / 1e3)
	end
	return "$" .. tostring(math.floor(cash))
end

local function formatCompact(value)
	local number = tonumber(value) or 0
	if number >= 1e9 then
		return string.format("%.1fB", number / 1e9)
	elseif number >= 1e6 then
		return string.format("%.1fM", number / 1e6)
	elseif number >= 1e3 then
		return string.format("%.1fk", number / 1e3)
	end
	return tostring(math.floor(number))
end

---------------------------------------------------------------------
-- Logs tab
---------------------------------------------------------------------

local LogsTab = Window:CreateTab({ Name = "Logs", Icon = "scroll-text" })
local LogBox = LogsTab:CreateGroupbox({ Name = "Activity", Side = "Left" })
local Log = LogBox:CreateLog({
	Name = "Activity",
	MaxEntries = 300,
	MaxRows = 18,
	Timestamps = true,
	EmptyText = "Nothing yet",
})
local StatsBox = LogsTab:CreateGroupbox({ Name = "Status", Side = "Right" })

local function push(text)
	Log:Push(text)
end

StatsBox:CreateStatus({
	Name = "Cash",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		return "<Success>" .. formatMoney(attr("Cash")) .. "</Success>"
	end,
})

StatsBox:CreateStatus({
	Name = "Objective",
	Style = "Row",
	UpdateRate = 0.5,
	Update = function()
		return "<Accent>" .. tostring(attr("Objective") or "-") .. "</Accent>"
	end,
})

StatsBox:CreateStatus({
	Name = "Carry",
	Style = "Row",
	UpdateRate = 0.5,
	Update = function()
		if attr("Carry") == "pc" then
			return "<Warning>package</Warning>"
		end
		return "<Muted>none</Muted>"
	end,
})

StatsBox:CreateStatus({
	Name = "Slots",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		return tostring(attr("SlotsUsed") or 0) .. " / " .. tostring(attr("SlotCap") or 0)
	end,
})

StatsBox:CreateStatus({
	Name = "Treadmill",
	Style = "Row",
	UpdateRate = 2,
	Update = function()
		return "lvl " .. tostring(attr("TreadLevel") or 1)
	end,
})

StatsBox:CreateStatus({
	Name = "Trainer",
	Style = "Row",
	UpdateRate = 2,
	Update = function()
		return "lvl " .. tostring(attr("TrainerLevel") or 1)
	end,
})

StatsBox:CreateStatus({
	Name = "Base",
	Style = "Row",
	UpdateRate = 2,
	Update = function()
		return "lvl " .. tostring(attr("BaseLevel") or 1)
	end,
})

StatsBox:CreateStatus({
	Name = "Fans",
	Style = "Row",
	UpdateRate = 2,
	Update = function()
		return "lvl " .. tostring(attr("MinionLevel") or 1)
	end,
})

---------------------------------------------------------------------
-- Houses and base helpers
---------------------------------------------------------------------

local function houseTier(house)
	local door = house:FindFirstChild("Door")
	local prompt = door and door:FindFirstChildOfClass("ProximityPrompt")
	local label = prompt and prompt.ObjectText or ""
	return (string.gsub(label, " House$", ""))
end

local function houseDoorPosition(house)
	local door = house:FindFirstChild("Door")
	if door and door:IsA("BasePart") then
		return door.Position
	end
	local anyPart = house:FindFirstChildWhichIsA("BasePart", true)
	return anyPart and anyPart.Position or nil
end

local function scareChance(tierName)
	local rank = TIER_RANK[tierName]
	local required = rank and TIER_REQUIRED[rank]
	if not required or not Odds or type(Odds.chance) ~= "function" then
		return nil
	end
	local prank = tonumber(attr("Prank")) or 0
	local ok, chance = pcall(Odds.chance, prank, required)
	if ok and type(chance) == "number" then
		return chance
	end
	return nil
end

local function listHouses()
	local result = {}
	if not HousesFolder then
		return result
	end
	for _, house in ipairs(HousesFolder:GetChildren()) do
		if house:IsA("Model") and house:FindFirstChild("Door") then
			local tier = houseTier(house)
			result[#result + 1] = {
				model = house,
				name = house.Name,
				tier = tier,
				rank = TIER_RANK[tier] or 0,
				position = houseDoorPosition(house),
				chance = scareChance(tier),
				requiredSpeed = TIER_SPEED[TIER_RANK[tier] or 0],
			}
		end
	end
	return result
end

-- The chase starts the moment the streamer is scared, so a house whose recommended Speed is above
-- the current Speed stat just feeds the chaser. High tiers ask for tens of thousands of Speed, so
-- the requirement has to be part of the house pick, not only the scare chance.
local lastKnownSpeed = 0
local function playerSpeed()
	local current = tonumber(attr("Speed"))
	if current and current > 0 then
		lastKnownSpeed = current
		return current
	end
	-- Respawn and teleports can blank the attribute for a moment; falling back to 0 would make the
	-- picker drop to Common for that tick.
	return lastKnownSpeed
end

local function canOutrun(house)
	local need = tonumber(house and house.requiredSpeed)
	if not need or need <= 0 then
		return true
	end
	return playerSpeed() >= need
end

local function myPlot()
	local index = attr("PlotIndex")
	if not PlotsFolder or index == nil then
		return nil
	end
	return PlotsFolder:FindFirstChild("Plot_" .. tostring(index))
end

-- Placing and opening only arm while the character stands ON its own plot, so the home point
-- is inside the fenced yard in front of the counter, not in the aisle next to it.
local function basePosition()
	local plot = myPlot()
	if not plot then
		return nil
	end
	local floorPart = plot:FindFirstChild("Floor")
	local counter = plot:FindFirstChild("CounterHost")
	local floorY = floorPart and floorPart.Position.Y or 0

	if counter and counter:IsA("BasePart") then
		local look = counter.CFrame.LookVector
		local flat = Vector3.new(look.X, 0, look.Z)
		if flat.Magnitude < 0.1 then
			flat = Vector3.new(-1, 0, 0)
		end
		local spot = counter.Position + flat.Unit * 12
		return Vector3.new(spot.X, floorY, spot.Z)
	end

	if floorPart and floorPart:IsA("BasePart") then
		return floorPart.Position
	end
	return nil
end

local function machinePad(kind)
	local plot = myPlot()
	if not plot then
		return nil
	end
	local model = plot:FindFirstChild(kind == "tread" and "Treadmill" or "Trainer")
	local pad = model and model:FindFirstChild("Pad")
	if pad and pad:IsA("BasePart") then
		return pad
	end
	return nil
end

---------------------------------------------------------------------
-- Shared state
---------------------------------------------------------------------

local Settings = {
	tierPreference = "Best I can scare",
	minChance = 50,
	carrySpeed = 72,
	openPackages = true,
	claimInterval = 20,
	keepCash = 0,
	speedValue = 40,
	jumpValue = 60,
	placePackages = true,
	equipBest = true,
	noclip = false,
}

local FarmToggle
local ClaimToggle
local UpgradeToggle
local OpenToggle
local TrainSpeedToggle
local TrainScareToggle
local SpeedToggle
local JumpToggle

local chooseHouse
local attempt
local claimAll
local tryUpgrades
local trainStep

local houseCooldown = {}
local tierBlocked = {}
local tierFails = {}
local trainRates = { speed = 0, scare = 0 }

---------------------------------------------------------------------
-- Bag / placement / opening
---------------------------------------------------------------------

local function clientState()
	local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
	local client = playerScripts and playerScripts:FindFirstChild("Client")
	local stateModule = client and client:FindFirstChild("State")
	if not stateModule then
		return nil
	end
	local ok, state = pcall(require, stateModule)
	if ok and type(state) == "table" then
		return state
	end
	return nil
end

local function bagPackages()
	local result = {}
	local state = clientState()
	if not state then
		return result
	end
	for _, entry in pairs(state.bag or {}) do
		if type(entry) == "table" and entry.kind == "pc" and entry.uid then
			result[#result + 1] = entry
		end
	end
	return result
end

-- Takes a package from the bag, walks it to the counter and fires the Place prompt.
local function ghostModule()
	local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
	local client = playerScripts and playerScripts:FindFirstChild("Client")
	local module = client and client:FindFirstChild("PlaceGhost")
	if not module then
		return nil
	end
	local ok, result = pcall(require, module)
	if ok and type(result) == "table" then
		return result
	end
	return nil
end

-- Packages are placed the same way the game does it: PlaceFromBag spawns a ghost and the
-- PlaceGhost module confirms it. Without the confirmation the package stays in the bag.
local function placeFromBag(maxCount)
	local packages = bagPackages()
	if #packages == 0 then
		return false
	end
	-- The Place action is rejected from the aisle, so step onto the plot before firing it.
	local spot, hrp = basePosition(), root()
	if spot and hrp then
		local flat = Vector3.new(hrp.Position.X - spot.X, 0, hrp.Position.Z - spot.Z)
		if flat.Magnitude > 4 then
			teleport(spot)
			task.wait(0.35)
		end
	end
	local ghost = ghostModule()
	local limit = math.min(#packages, maxCount or 3)
	local placed = 0
	for index = 1, limit do
		local entry = packages[index]
		fire("PlaceFromBag", entry.uid)
		task.wait(0.9)
		if ghost and type(ghost.place) == "function" then
			local ok = pcall(ghost.place)
			if ok then
				placed = placed + 1
			end
		end
		task.wait(0.5)
	end
	return placed > 0
end
-- Fires every enabled "Open" prompt on packages lying on our plot. `stepTo` walks the character
-- onto each package first, because the prompt only arms while standing on the plot.
local function openPackages(stepTo)
	local plot = myPlot()
	if not plot then
		return 0
	end
	local opened = 0
	local items = plot:FindFirstChild("Items")
	if not items then
		return 0
	end
	for _, package in ipairs(items:GetChildren()) do
		for _, descendant in ipairs(package:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") and descendant.ActionText == "Open" and descendant.Enabled then
				-- The prompt only arms on the plot, and each package lies in its own spot.
				if stepTo then
					local host = package:FindFirstChild("HpHost") or package:FindFirstChildWhichIsA("BasePart", true)
					if host and host:IsA("BasePart") then
						teleport(host.Position)
						task.wait(0.25)
					end
				end
				if pcall(fireproximityprompt, descendant) then
					opened = opened + 1
					task.wait(0.35)
				end
				break
			end
		end
	end
	return opened
end

local function openAndEquip(stepTo)
	local opened = openPackages(stepTo)
	if opened > 0 and Settings.equipBest then
		fire("EquipBest")
	end
	return opened
end

---------------------------------------------------------------------
-- Farm tab
---------------------------------------------------------------------

local FarmTab = Window:CreateTab({ Name = "Farm", Icon = "ghost" })
local FarmBox = FarmTab:CreateGroupbox({ Name = "Steal loop", Side = "Left" })
local FarmStatusBox = FarmTab:CreateGroupbox({ Name = "Status", Side = "Right" })

FarmToggle = FarmBox:CreateToggle({
	Name = "Steal loop",
	Desc = "Knock, scare, steal, carry home, open",
	Flag = "ScareFarmLoop",
	CurrentValue = false,
	Callback = function(on)
		if on then
			push("<Success>Running</Success> steal loop")
		else
			push("<Muted>Idle</Muted> - steal loop stopped")
		end
	end,
})

FarmBox:CreateDropdown({
	Name = "House picking",
	Options = TIER_OPTIONS,
	CurrentOption = "Best I can scare",
	Flag = "ScareHouseTier",
	Callback = function(option)
		Settings.tierPreference = option
		task.spawn(function()
			task.wait(0.2)
			local house = chooseHouse()
			if house then
				push("<Accent>House picking</Accent> " .. option .. " -> " .. house.name .. " (" .. house.tier .. ")")
			end
		end)
	end,
})

FarmBox:CreateSlider({
	Name = "Min chance",
	Desc = "Houses below this scare chance are skipped",
	Range = { 0, 100 },
	Increment = 5,
	Suffix = " %",
	CurrentValue = 50,
	Flag = "ScareMinChance",
	Callback = function(value)
		Settings.minChance = value
	end,
})

FarmBox:CreateSlider({
	Name = "Carry speed",
	Desc = "Minimum speed while carrying a package home",
	Range = { 20, 140 },
	Increment = 4,
	Suffix = " studs",
	CurrentValue = 72,
	Flag = "ScareCarrySpeed",
	Callback = function(value)
		Settings.carrySpeed = value
	end,
})

FarmBox:CreateToggle({
	Name = "Place packages",
	Desc = "Places stolen packages on your base",
	Flag = "ScarePlacePackages",
	CurrentValue = true,
	Callback = function(on)
		Settings.placePackages = on
	end,
})

OpenToggle = FarmBox:CreateToggle({
	Name = "Open packages",
	Desc = "Opens packages lying on your base",
	Flag = "ScareOpenPackages",
	CurrentValue = true,
})

FarmBox:CreateButton({
	Name = "Try this house now",
	Desc = "Teleports to the door and runs one full attempt",
	Icon = "door-open",
	Style = "Primary",
	Callback = function()
		task.spawn(function()
			local house = chooseHouse()
			if not house then
				push("<Error>No house with a chance right now</Error>")
				return
			end
			attempt(house)
		end)
	end,
})

FarmStatusBox:CreateStatus({
	Name = "State",
	Style = "Row",
	Pin = true,
	UpdateRate = 0.5,
	Update = function()
		if FarmToggle and FarmToggle.Value then
			return "<Success>Running</Success>"
		end
		return "<Muted>Idle</Muted>"
	end,
})

FarmStatusBox:CreateStatus({
	Name = "Chance",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		if type(chooseHouse) ~= "function" then
			return "<Muted>-</Muted>"
		end
		local ok, house = pcall(chooseHouse)
		if not ok or not house then
			return "<Muted>-</Muted>"
		end
		local chance = house.chance
		local text = chance and string.format("%d%%", math.floor(chance)) or "?"
		local need = tonumber(house.requiredSpeed)
		if need and need > 0 then
			text = text .. " | spd " .. formatCompact(need) .. (canOutrun(house) and "" or " !")
		end
		return string.format("<Accent>%s</Accent> %s", house.tier, text)
	end,
})

FarmStatusBox:CreateStatus({
	Name = "Cash",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		return formatMoney(attr("Cash"))
	end,
})

chooseHouse = function()
	local houses = listHouses()
	if #houses == 0 then
		return nil
	end

	local now = os.clock()
	local free, ready = {}, {}
	for _, house in ipairs(houses) do
		local untilTime = houseCooldown[house.name]
		local busy = false
		for _, child in ipairs(house.model:GetChildren()) do
			if string.sub(child.Name, 1, 4) == "Run_" then
				busy = true
				break
			end
		end
		if not untilTime or untilTime <= now then
			ready[#ready + 1] = house
			if not busy then
				free[#free + 1] = house
			end
		end
	end
	if #free > 0 then
		ready = free
	elseif #ready == 0 then
		ready = houses
	end

	-- A tier that caught us once gets a rest; the loop drops a tier and retries later.
	local blockNow = os.clock()
	local openHouses = {}
	for _, house in ipairs(ready) do
		local untilTime = tierBlocked[house.rank]
		if not untilTime or untilTime <= blockNow then
			openHouses[#openHouses + 1] = house
		end
	end
	if #openHouses > 0 then
		ready = openHouses
	end
	local preference = Settings.tierPreference

	if preference == "Nearest" then
		local hrp = root()
		if not hrp then
			return ready[1]
		end
		local best, bestDistance
		for _, house in ipairs(ready) do
			if house.position then
				local distance = (house.position - hrp.Position).Magnitude
				if not bestDistance or distance < bestDistance then
					best, bestDistance = house, distance
				end
			end
		end
		return best
	end

	if preference == "Highest tier" then
		local best
		for _, house in ipairs(ready) do
			if not best or house.rank > best.rank then
				best = house
			end
		end
		return best
	end

	if preference == "Any" then
		return ready[math.random(1, #ready)]
	end

	if preference ~= "Best I can scare" then
		local wanted = TIER_RANK[preference]
		if wanted then
			for _, house in ipairs(ready) do
				if house.rank == wanted then
					return house
				end
			end
		end
		preference = "Best I can scare"
	end

	-- Best I can scare: rank first, chance second. Sorting by chance alone used to hand a Common
	-- house at 99% over an Epic at 60% whenever the top tiers were on cooldown or under the
	-- chance threshold, which looked like the farm was ignoring the good houses.
	local ranked = {}
	for _, house in ipairs(ready) do
		if canOutrun(house) then
			ranked[#ranked + 1] = house
		end
	end
	table.sort(ranked, function(a, b)
		if a.rank ~= b.rank then
			return a.rank > b.rank
		end
		return (a.chance or 0) > (b.chance or 0)
	end)

	for _, house in ipairs(ranked) do
		if (house.chance or 0) >= Settings.minChance then
			return house
		end
	end
	-- Everything is under Min chance: still take the highest tier, never the easy low one.
	for _, house in ipairs(ranked) do
		if (house.chance or 0) > 0 then
			return house
		end
	end
	if ranked[1] then
		return ranked[1]
	end

	-- Speed is still below every requirement: take the cheapest house so the farm keeps moving.
	local easiest
	for _, house in ipairs(ready) do
		if not easiest or (tonumber(house.requiredSpeed) or 0) < (tonumber(easiest.requiredSpeed) or 0) then
			easiest = house
		end
	end
	return easiest or ready[1]
end

---------------------------------------------------------------------
-- Core actions
---------------------------------------------------------------------

-- The character usually ends up inside the house and gets stuck on the walls.
-- The door sits on the front wall, so Floor -> Door gives the outward direction.
local function houseFront(house)
	local door = house.model:FindFirstChild("Door")
	if not door or not door:IsA("BasePart") then
		return nil
	end
	local floorPart = house.model:FindFirstChild("Floor") or house.model:FindFirstChild("Carpet")
	local outward = Vector3.new(0, 0, 1)
	if floorPart and floorPart:IsA("BasePart") then
		local flat = Vector3.new(door.Position.X - floorPart.Position.X, 0, door.Position.Z - floorPart.Position.Z)
		if flat.Magnitude > 0.1 then
			outward = flat.Unit
		end
	end
	return door, outward
end

local function knock(house)
	local door, outward = houseFront(house)
	if not door then
		return false
	end
	teleport(door.Position + outward * 7)
	task.wait(0.35)
	return firePrompt(door:FindFirstChildOfClass("ProximityPrompt"), 3)
end

local function waitStreamer(house, timeout)
	local deadline = os.clock() + (timeout or 10)
	while os.clock() < deadline do
		for _, child in ipairs(house.model:GetChildren()) do
			if string.sub(child.Name, 1, 4) == "Run_" then
				local prompt = promptOf(child, "SCARE!")
				if prompt and prompt.Enabled then
					return prompt
				end
			end
		end
		task.wait(0.1)
	end
	return nil
end

local function scare(house)
	local prompt = waitStreamer(house, 10)
	if not prompt then
		return false
	end
	if not firePrompt(prompt, 4) then
		return false
	end
	task.wait(1.0)
	return attr("Objective") == TEXT.steal
end

local function steal(house)
	local package = house.model:FindFirstChild("Package")
	if not package then
		return false
	end
	if not firePrompt(promptOf(package, "Steal"), 3) then
		return false
	end
	task.wait(0.6)
	return attr("Carry") == "pc"
end

-- Walking the package home is the slow part, but it is the only delivery the server accepts:
-- a CFrame jump and a tween are both rubber-banded back, so the character runs the whole way.
local function leaveHouse(house)
	local door, outward = houseFront(house)
	if not door or not outward then
		return
	end
	teleport(door.Position + outward * 12)
	task.wait(0.45)
end

local function carryHome(speed)
	if attr("Carry") ~= "pc" then
		return false
	end
	local hrp, hum = root(), humanoid()
	local target = basePosition()
	if not hrp or not hum or not target then
		return false
	end

	local previousSpeed = hum.WalkSpeed
	local previousJump = hum.JumpPower
	local previousJumpHeight = hum.JumpHeight

	-- Never slow the character down: the game already scales walk speed with the Speed stat.
	hum.WalkSpeed = math.max(previousSpeed, speed)
	setNoclip(true)

	local deadline = os.clock() + 60
	local lastPosition = hrp.Position
	local lastCheck = os.clock()
	while os.clock() < deadline do
		if attr("Carry") ~= "pc" then
			break
		end
		local distance = (target - hrp.Position).Magnitude
		if distance < 10 then
			break
		end

		hum:MoveTo(target)
		task.wait(0.15)

		-- Stuck on geometry: hop towards the base instead of waiting for the chaser.
		if os.clock() - lastCheck > 1.2 then
			if (hrp.Position - lastPosition).Magnitude < 3 then
				local direction = Vector3.new(target.X - hrp.Position.X, 0, target.Z - hrp.Position.Z)
				if direction.Magnitude > 1 then
					teleport(hrp.Position + direction.Unit * 14)
					task.wait(0.25)
				end
			end
			lastPosition = hrp.Position
			lastCheck = os.clock()
		end
	end
	if attr("Carry") == "pc" then
		teleport(target)
		task.wait(1.3)
	end

	hum.WalkSpeed = previousSpeed
	hum.JumpPower = previousJump
	hum.JumpHeight = previousJumpHeight

	if not Settings.noclip then
		setNoclip(false)
	end

	return attr("Carry") ~= "pc"
end

attempt = function(house)
	houseCooldown[house.name] = os.clock() + 12

	if attr("Carry") == "pc" then
		push("<Warning>Already carrying a package</Warning> - running home")
		if carryHome(Settings.carrySpeed) then
			push("<Success>Package is home</Success>")
			return true
		end
		push("<Error>Lost the package</Error>")
		return false
	end

	if not knock(house) then
		push("<Warning>Knock failed</Warning> at " .. house.name)
		return false
	end
	local chanceText = house.chance and string.format(" (%d%%)", math.floor(house.chance)) or ""
	push("<Accent>Knocked</Accent> " .. house.name .. " " .. house.tier .. chanceText)

	if not scare(house) then
		push("<Warning>Not scared</Warning> " .. house.name .. " - next house")
		return false
	end
	push("<Success>Scared</Success> " .. house.name)

	if not steal(house) then
		push("<Warning>Steal failed</Warning>")
		return false
	end
	push("<Success>Stole a package</Success> - running home")

	leaveHouse(house)

	if not carryHome(Settings.carrySpeed) then
		push("<Error>Caught on the way</Error> - cooling this house down")
		houseCooldown[house.name] = os.clock() + 60
		-- One catch used to bench the whole tier for two minutes and the picker slid down to
		-- Common. Rest the tier only after it keeps catching, and only briefly.
		tierFails[house.rank] = (tierFails[house.rank] or 0) + 1
		if tierFails[house.rank] >= 3 then
			tierFails[house.rank] = 0
			tierBlocked[house.rank] = os.clock() + 45
			push("<Muted>Tier rested for 45s after 3 catches</Muted>")
		end
		return false
	end
	tierFails[house.rank] = 0

	push("<Success>Package is home</Success>")
	task.wait(0.5)
	if Settings.placePackages then
		placeFromBag(2)
	end
	if Settings.openPackages then
		task.wait(0.4)
		openAndEquip(true)
	end
	return true
end

task.spawn(function()
	while alive() do
		task.wait(0.4)
		if FarmToggle.Value then
			local house = chooseHouse()
			if house then
				pcall(attempt, house)
			else
				task.wait(2)
			end
		end
	end
end)

---------------------------------------------------------------------
-- Training tab
---------------------------------------------------------------------

local TrainTab = Window:CreateTab({ Name = "Training", Icon = "dumbbell" })
local TrainBox = TrainTab:CreateGroupbox({ Name = "Auto training", Side = "Left" })
local TrainStatusBox = TrainTab:CreateGroupbox({ Name = "Status", Side = "Right" })

TrainSpeedToggle = TrainBox:CreateToggle({
	Name = "Auto Train Speed",
	Desc = "Stands on the treadmill and farms Speed",
	Flag = "ScareTrainSpeed",
	CurrentValue = false,
	Callback = function(on)
		if on then
			if TrainScareToggle.Value then
				TrainScareToggle:Set(false, true)
			end
			push("<Success>Training Speed</Success>")
		end
	end,
})

TrainScareToggle = TrainBox:CreateToggle({
	Name = "Auto Train Scare",
	Desc = "Stands at the scare trainer and farms Prank",
	Flag = "ScareTrainScare",
	CurrentValue = false,
	Callback = function(on)
		if on then
			if TrainSpeedToggle.Value then
				TrainSpeedToggle:Set(false, true)
			end
			push("<Success>Training Scare</Success>")
		end
	end,
})

TrainStatusBox:CreateStatus({
	Name = "Speed",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		return string.format("%s (+%s/s)", tostring(attr("Speed") or 0), tostring(math.floor(trainRates.speed)))
	end,
})

TrainStatusBox:CreateStatus({
	Name = "Scare",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		return string.format("%s (+%s/s)", tostring(attr("Prank") or 0), tostring(math.floor(trainRates.scare)))
	end,
})

TrainStatusBox:CreateStatus({
	Name = "State",
	Style = "Row",
	UpdateRate = 0.5,
	Update = function()
		return tostring(attr("Station") or "none")
	end,
})

local TRAIN_OFFSETS = {
	Vector3.new(-4, 3, 0),
	Vector3.new(4, 3, 0),
	Vector3.new(0, 4, 0),
	Vector3.new(0, 3, 4),
	Vector3.new(0, 3, -4),
}

-- One training tick: make sure we stand on the machine, the game sets Station when we do.
trainStep = function(kind)
	if attr("Carry") == "pc" then
		return
	end
	local pad = machinePad(kind)
	if not pad then
		return
	end
	if attr("Station") == kind then
		local hrp = root()
		if hrp and (hrp.Position - pad.Position).Magnitude > 8 then
			teleport(pad.Position + TRAIN_OFFSETS[1])
		end
		return
	end
	for _, offset in ipairs(TRAIN_OFFSETS) do
		teleport(pad.Position + offset)
		local deadline = os.clock() + 0.9
		while os.clock() < deadline do
			if attr("Station") == kind then
				return
			end
			task.wait(0.1)
		end
	end
end

task.spawn(function()
	while alive() do
		task.wait(1)
		if TrainSpeedToggle.Value then
			pcall(trainStep, "tread")
		elseif TrainScareToggle.Value then
			pcall(trainStep, "trainer")
		end
	end
end)

task.spawn(function()
	local lastSpeed = tonumber(attr("Speed")) or 0
	local lastPrank = tonumber(attr("Prank")) or 0
	local lastClock = os.clock()
	while alive() do
		task.wait(1)
		local now = os.clock()
		local elapsed = math.max(0.1, now - lastClock)
		lastClock = now
		local speed = tonumber(attr("Speed")) or lastSpeed
		local prank = tonumber(attr("Prank")) or lastPrank
		trainRates.speed = math.max(0, (speed - lastSpeed) / elapsed)
		trainRates.scare = math.max(0, (prank - lastPrank) / elapsed)
		lastSpeed = speed
		lastPrank = prank
	end
end)

---------------------------------------------------------------------
-- Automation tab
---------------------------------------------------------------------

local AutoTab = Window:CreateTab({ Name = "Automation", Icon = "settings-2" })
local ClaimBox = AutoTab:CreateGroupbox({ Name = "Claim rewards", Side = "Left" })
local UpgradeBox = AutoTab:CreateGroupbox({ Name = "Auto upgrades", Side = "Right" })

ClaimToggle = ClaimBox:CreateToggle({
	Name = "Claim rewards",
	Desc = "Claims index, daily, playtime and offline rewards",
	Flag = "ScareClaimRewards",
	CurrentValue = true,
})

ClaimBox:CreateSlider({
	Name = "Claim interval",
	Desc = "Seconds between reward claims",
	Range = { 5, 120 },
	Increment = 5,
	Suffix = " s",
	CurrentValue = 20,
	Flag = "ScareClaimInterval",
	Callback = function(value)
		Settings.claimInterval = value
	end,
})

ClaimBox:CreateButton({
	Name = "Claim now",
	Icon = "gift",
	Callback = function()
		claimAll()
		push("<Success>Claimed rewards</Success>")
	end,
})

UpgradeToggle = UpgradeBox:CreateToggle({
	Name = "Auto upgrades",
	Desc = "Buys treadmill, trainer, base and fans when affordable",
	Flag = "ScareAutoUpgrade",
	CurrentValue = true,
})

UpgradeBox:CreateSlider({
	Name = "Keep cash",
	Desc = "Never spend below this amount",
	Range = { 0, 50 },
	Increment = 1,
	Suffix = " %",
	CurrentValue = 0,
	Flag = "ScareKeepCash",
	Callback = function(value)
		Settings.keepCash = value / 100
	end,
})

local ItemBox = AutoTab:CreateGroupbox({ Name = "Items", Side = "Left" })

ItemBox:CreateToggle({
	Name = "Equip best",
	Desc = "Equips your best items right after packages are opened",
	Flag = "ScareEquipBest",
	CurrentValue = true,
	Callback = function(on)
		Settings.equipBest = on
	end,
})

ItemBox:CreateButton({
	Name = "Equip best now",
	Icon = "swords",
	Callback = function()
		fire("EquipBest")
		push("<Success>Equipped best items</Success>")
	end,
})

local joinClaimed = false

claimAll = function()
	fire("ClaimAllIndex")
	fire("ClaimMutIndex")
	fire("ClaimDaily")
	fire("ClaimGift", 1)
	fire("OfflineClaim")
	if not joinClaimed then
		joinClaimed = true
		fire("JoinClaim")
	end
end

local PRICE_SOURCES = {
	{ key = "tread", attribute = "TreadLevel", tableKey = "Treadmill" },
	{ key = "trainer", attribute = "TrainerLevel", tableKey = "Trainer" },
	{ key = "base", attribute = "BaseLevel", tableKey = "Base" },
	{ key = "minions", attribute = "MinionLevel", tableKey = "Minions" },
}

local function nextPrice(entry)
	if not Config then
		return nil
	end
	local source = Config[entry.tableKey]
	if type(source) ~= "table" or type(source.prices) ~= "table" then
		return nil
	end
	local level = tonumber(attr(entry.attribute)) or 1
	local price = source.prices[level]
	if type(price) ~= "number" then
		return nil
	end
	return price
end

tryUpgrades = function()
	local cash = tonumber(attr("Cash")) or 0
	local affordable = {}
	for _, entry in ipairs(PRICE_SOURCES) do
		local price = nextPrice(entry)
		if price and cash >= price * (1 + Settings.keepCash) then
			affordable[#affordable + 1] = { key = entry.key, price = price }
		end
	end
	if #affordable == 0 then
		return false
	end
	table.sort(affordable, function(a, b)
		return a.price < b.price
	end)
	for _, entry in ipairs(affordable) do
		fire("SignBuy", entry.key)
		task.wait(0.2)
	end
	push("<Success>Upgraded</Success>")
	return true
end

task.spawn(function()
	local lastClaim = 0
	while alive() do
		task.wait(1)
		if ClaimToggle.Value and os.clock() - lastClaim >= Settings.claimInterval then
			lastClaim = os.clock()
			claimAll()
		end
	end
end)

task.spawn(function()
	while alive() do
		task.wait(1.5)
		if UpgradeToggle.Value then
			pcall(tryUpgrades)
		end
	end
end)

task.spawn(function()
	while alive() do
		task.wait(3)
		-- Never touch the plot while the farm is running or a package is being carried: the hop
		-- onto the packages would drag the character away from the run.
		if OpenToggle.Value and not FarmToggle.Value and attr("Carry") ~= "pc" then
			pcall(openAndEquip, true)
		end
	end
end)

---------------------------------------------------------------------
-- Visuals
---------------------------------------------------------------------

local VisualTab = Window:CreateTab({ Name = "Visuals", Icon = "eye" })
local EspBox = VisualTab:CreateGroupbox({ Name = "ESP", Side = "Left" })
local MoveBox = VisualTab:CreateGroupbox({ Name = "Movement", Side = "Right" })

local ESP = { houses = true, packages = true, players = true, best = false }

local espFolder = Instance.new("Folder")
espFolder.Name = "RobscriptTeamESP"
pcall(function()
	espFolder.Parent = CoreGui
end)
if not espFolder.Parent then
	espFolder.Parent = LocalPlayer:FindFirstChild("PlayerGui")
end

local anchorFolder = Instance.new("Folder")
anchorFolder.Name = "RobscriptTeamAnchors"
anchorFolder.Parent = workspace

local houseLabels = {}
local packageLabels = {}
local playerHighlights = {}
local bestLabel = nil

local function makeBillboard(text, color, size)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "RT_ESP"
	billboard.Size = size or UDim2.fromOffset(190, 32)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 5000
	billboard.LightInfluence = 0

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 0.25
	label.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
	label.BorderSizePixel = 0
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextColor3 = color or Color3.fromRGB(245, 245, 247)
	label.Text = text
	label.Parent = billboard

	return billboard, label
end

local function makeAnchor(name, position)
	local anchor = Instance.new("Part")
	anchor.Name = name
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanQuery = false
	anchor.CanTouch = false
	anchor.Transparency = 1
	anchor.Size = Vector3.new(0.2, 0.2, 0.2)
	anchor.Position = position
	anchor.Parent = anchorFolder
	return anchor
end

local function refreshHouseLabels()
	local hrp = root()
	if not hrp then
		return
	end
	local alive = {}
	for _, house in ipairs(listHouses()) do
		if house.position then
			alive[house.model] = true
			local entry = houseLabels[house.model]
			if not entry then
				local color = TIER_COLORS[house.tier] or Color3.fromRGB(245, 245, 247)
				local anchor = makeAnchor("RT_HouseAnchor", house.position + Vector3.new(0, 7, 0))
				local billboard, label = makeBillboard("", color)
				billboard.Adornee = anchor
				billboard.Parent = espFolder
				entry = { anchor = anchor, label = label, billboard = billboard }
				houseLabels[house.model] = entry
			end
			entry.billboard.Enabled = ESP.houses
			if ESP.houses then
				local distance = math.floor((house.position - hrp.Position).Magnitude)
				local chance = house.chance and string.format("%d%%", math.floor(house.chance)) or "?"
				local need = tonumber(house.requiredSpeed)
				local speedTag = ""
				if need and need > 0 then
					speedTag = string.format(" - spd %s%s", formatCompact(need), canOutrun(house) and "" or " !")
				end
				entry.label.Text = string.format("%s - %s - %s - %dm%s", house.name, house.tier, chance, distance, speedTag)
			end
		end
	end
	for model, entry in pairs(houseLabels) do
		if not alive[model] then
			entry.billboard:Destroy()
			entry.anchor:Destroy()
			houseLabels[model] = nil
		end
	end
end

local function refreshPackageLabels()
	local hrp = root()
	if not hrp then
		return
	end
	local seen = {}
	for _, package in ipairs(CollectionService:GetTagged("PAS_Package")) do
		local host = package:FindFirstChild("HpHost")
		if host and host:IsA("BasePart") then
			seen[package] = true
			local entry = packageLabels[package]
			if not entry then
				local billboard, label = makeBillboard("Package", Color3.fromRGB(255, 59, 127), UDim2.fromOffset(150, 26))
				billboard.Adornee = host
				billboard.Parent = espFolder
				entry = { label = label, billboard = billboard }
				packageLabels[package] = entry
			end
			entry.billboard.Enabled = ESP.packages
			if ESP.packages then
				local distance = math.floor((host.Position - hrp.Position).Magnitude)
				entry.label.Text = "Package - " .. tostring(distance) .. "m"
			end
		end
	end
	for package, entry in pairs(packageLabels) do
		if not seen[package] or not package.Parent then
			entry.billboard:Destroy()
			packageLabels[package] = nil
		end
	end
end

local function refreshBest()
	if not ESP.best then
		if bestLabel then
			bestLabel.billboard:Destroy()
			bestLabel.anchor:Destroy()
			bestLabel = nil
		end
		return
	end
	local house = chooseHouse()
	if not house or not house.position then
		return
	end
	if not bestLabel then
		local anchor = makeAnchor("RT_BestAnchor", house.position + Vector3.new(0, 11, 0))
		local billboard, label = makeBillboard("BEST", Color3.fromRGB(255, 59, 127), UDim2.fromOffset(220, 40))
		billboard.Adornee = anchor
		billboard.Parent = espFolder
		bestLabel = { billboard = billboard, label = label, anchor = anchor }
	end
	bestLabel.anchor.Position = house.position + Vector3.new(0, 11, 0)
	local chance = house.chance and string.format("%d%%", math.floor(house.chance)) or "?"
	bestLabel.label.Text = string.format("BEST: %s (%s, %s)", house.name, house.tier, chance)
end

local function refreshPlayers()
	if not ESP.players then
		for player, highlight in pairs(playerHighlights) do
			highlight:Destroy()
			playerHighlights[player] = nil
		end
		return
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local highlight = playerHighlights[player]
			if not highlight or not highlight.Parent then
				highlight = Instance.new("Highlight")
				highlight.Name = "RT_PlayerESP"
				highlight.FillColor = Color3.fromRGB(255, 59, 127)
				highlight.FillTransparency = 0.75
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.Parent = espFolder
				playerHighlights[player] = highlight
			end
			highlight.Adornee = player.Character
		end
	end
end

EspBox:CreateToggle({
	Name = "Houses ESP",
	Desc = "Shows houses with tier, chance and distance",
	Flag = "ScareEspHouses",
	CurrentValue = true,
	Callback = function(on)
		ESP.houses = on
	end,
})

EspBox:CreateToggle({
	Name = "Packages ESP",
	Desc = "Shows packages in houses",
	Flag = "ScareEspPackages",
	CurrentValue = true,
	Callback = function(on)
		ESP.packages = on
	end,
})

EspBox:CreateToggle({
	Name = "Players ESP",
	Desc = "Highlights other players",
	Flag = "ScareEspPlayers",
	CurrentValue = true,
	Callback = function(on)
		ESP.players = on
		refreshPlayers()
	end,
})

EspBox:CreateToggle({
	Name = "Best house",
	Desc = "Highlights the house the farm will use",
	Flag = "ScareEspBest",
	CurrentValue = false,
	Callback = function(on)
		ESP.best = on
	end,
})

MoveBox:CreateToggle({
	Name = "Noclip",
	Desc = "Walk through walls",
	Flag = "ScareNoclip",
	CurrentValue = false,
	Callback = function(on)
		Settings.noclip = on
		setNoclip(on)
	end,
})

SpeedToggle = MoveBox:CreateToggle({
	Name = "Walk speed",
	Desc = "Overrides humanoid walk speed",
	Flag = "ScareSpeedHack",
	CurrentValue = false,
})

MoveBox:CreateSlider({
	Name = "Walk speed",
	Range = { 16, 1000 },
	Increment = 5,
	Suffix = " studs/s",
	CurrentValue = 40,
	Flag = "ScareSpeedValue",
	Callback = function(value)
		Settings.speedValue = value
	end,
})

MoveBox:CreateInput({
	Name = "Exact speed",
	Desc = "Any value, no cap",
	PlaceholderText = "e.g. 2500",
	Numeric = true,
	Flag = "ScareSpeedExact",
	Callback = function(text)
		local value = tonumber(text)
		if value and value > 0 then
			Settings.speedValue = value
		end
	end,
})

JumpToggle = MoveBox:CreateToggle({
	Name = "Jump power",
	Desc = "Overrides humanoid jump power",
	Flag = "ScareJumpHack",
	CurrentValue = false,
})

MoveBox:CreateSlider({
	Name = "Jump power",
	Range = { 50, 200 },
	Increment = 5,
	CurrentValue = 60,
	Flag = "ScareJumpValue",
	Callback = function(value)
		Settings.jumpValue = value
	end,
})

MoveBox:CreateToggle({
	Name = "Anti AFK",
	Desc = "Keeps you in the server",
	Flag = "ScareAntiAfk",
	CurrentValue = true,
	Callback = function(on)
		if on then
			LocalPlayer.Idled:Connect(function()
				pcall(function()
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.new())
				end)
			end)
		end
	end,
})

task.spawn(function()
	while alive() do
		task.wait(0.2)
		local hum = humanoid()
		if hum then
			if SpeedToggle.Value and attr("Carry") ~= "pc" then
				hum.WalkSpeed = Settings.speedValue
			end
			if JumpToggle.Value then
				if hum.UseJumpPower then
					hum.JumpPower = Settings.jumpValue
				else
					hum.JumpHeight = Settings.jumpValue / 5
				end
			end
		end
	end
end)

task.spawn(function()
	while alive() do
		task.wait(0.6)
		pcall(refreshHouseLabels)
		pcall(refreshPackageLabels)
		pcall(refreshPlayers)
		pcall(refreshBest)
	end
end)

---------------------------------------------------------------------
-- Teleport tab
---------------------------------------------------------------------

local TeleportTab = Window:CreateTab({ Name = "Teleport", Icon = "map-pin" })
local TeleportBox = TeleportTab:CreateGroupbox({ Name = "Teleport", Side = "Left" })
local InfoBox = TeleportTab:CreateGroupbox({ Name = "Status", Side = "Right" })

local teleportTier = "Common"

TeleportBox:CreateDropdown({
	Name = "House tier",
	Options = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Spectral", "Eternal", "Divine", "Majestic", "Apex" },
	CurrentOption = "Common",
	Flag = "ScareTeleportTier",
	Callback = function(option)
		teleportTier = option
	end,
})

TeleportBox:CreateButton({
	Name = "Go to house",
	Desc = "Teleport to the door of the selected house",
	Icon = "door-open",
	Callback = function()
		local wanted = TIER_RANK[teleportTier]
		local target
		for _, house in ipairs(listHouses()) do
			if house.rank == wanted then
				target = house
				break
			end
		end
		if target and target.position then
			teleport(target.position + Vector3.new(0, 0, 7))
			push("Teleported to " .. target.name .. " (" .. target.tier .. ")")
		end
	end,
})

TeleportBox:CreateButton({
	Name = "Go home",
	Desc = "Teleport to your base",
	Icon = "house",
	Callback = function()
		local target = basePosition()
		if target then
			teleport(target)
			push("Teleported home")
		end
	end,
})

local sessionStart = os.clock()

InfoBox:CreateStatus({
	Name = "Session",
	Style = "Row",
	UpdateRate = 5,
	Update = function()
		local seconds = math.floor(os.clock() - sessionStart)
		return string.format("%dm %02ds", math.floor(seconds / 60), seconds % 60)
	end,
})

InfoBox:CreateStatus({
	Name = "Houses",
	Style = "Row",
	UpdateRate = 5,
	Update = function()
		return "Houses found: " .. tostring(#listHouses())
	end,
})

---------------------------------------------------------------------
-- Settings + bridge
---------------------------------------------------------------------

local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "settings" })
SettingsTab:CreateConfigManager({ Name = "Configs", Side = "Left" })
SettingsTab:CreateThemeManager({ Name = "Theme", Side = "Right" })

if getgenv then
	getgenv().RobscriptTeamScare = {
		Settings = Settings,
		Farm = function(on)
			FarmToggle:Set(on and true or false)
		end,
		Train = function(which)
			TrainSpeedToggle:Set(which == "speed")
			TrainScareToggle:Set(which == "scare")
		end,
		Chosen = function()
			local house = chooseHouse()
			if not house then return "none" end
			return house.name .. " " .. house.tier .. " " .. tostring(house.chance)
		end,
		AttemptBest = function()
			return attempt(chooseHouse())
		end,
		AttemptHouse = function(name)
			for _, house in ipairs(listHouses()) do
				if house.name == name then
					return attempt(house)
				end
			end
			return false
		end,
		Claim = function()
			claimAll()
		end,
		OpenPackages = function()
			return openPackages()
		end,
		PlaceFromBag = function()
			return placeFromBag()
		end,
		Chances = function()
			local list = {}
			for _, house in ipairs(listHouses()) do
				list[#list + 1] = string.format("%s %s %s%%", house.name, house.tier,
					house.chance and string.format("%d", math.floor(house.chance)) or "?")
			end
			return list
		end,
		ListHouses = listHouses,
		Destroy = function()
			pcall(function()
				Window:Destroy()
			end)
		end,
	}
end

Window:LoadAutoload()

Window:Notify({
	Title = "Loaded",
	Content = "Robscript Team is ready",
	Type = "Success",
})

push("<Accent>Robscript Team</Accent> loaded for Scare Your Favorite Streamer")
push("<Muted>Press RightControl to hide the UI</Muted>")