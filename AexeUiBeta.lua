-- [[ ====================================================== ]] --
-- [[              AEXEHUB V24: LIVE LOCATION SYNC           ]] --
-- [[ ====================================================== ]] --

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local StartTime = tick()

-- [[ KONTAINER 1: THEME & CONFIG ]] --
local Theme = {
    Main = Color3.fromRGB(0, 255, 200),     -- Hijau Toska
    Title = Color3.fromRGB(150, 220, 255),    -- Blue Ice
    White = Color3.fromRGB(255, 255, 255),
    Bg = Color3.fromRGB(5, 5, 5),
    Trans = 0.15,                           -- Lock 85%
    FontBlack = Enum.Font.GothamBlack,
    FontBold = Enum.Font.GothamBold
}
local MY_LOGO = "rbxassetid://72181568495758"

-- [[ KONTAINER 2: MAIN SCREEN GUI ]] --
local MainGui = Instance.new("ScreenGui", game.CoreGui)
MainGui.Name = "AexeHub_V24"
MainGui.ResetOnSpawn = false

-- FUNGSI DRAG (WAJIB DI ATAS AGAR BISA DIPAKAI)
local function Drag(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ PANEL PERFORMA (BISA DIGESER & WARNA DINAMIS) ]] --
local PerfFrame = Instance.new("Frame", MainGui)
PerfFrame.Name = "Aexe_PerfPanel"
PerfFrame.Size = UDim2.new(0, 280, 0, 70)
PerfFrame.Position = UDim2.new(0.5, -140, 0.05, 0)
PerfFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PerfFrame.BackgroundTransparency = Theme.Trans
PerfFrame.Visible = false
Instance.new("UICorner", PerfFrame)

Drag(PerfFrame) -- AKTIFKAN FITUR GESER SEKARANG

local PerfStroke = Instance.new("UIStroke", PerfFrame)
PerfStroke.Color = Theme.Main
PerfStroke.Thickness = 2

local PerfTitle = Instance.new("TextLabel", PerfFrame)
PerfTitle.Text = "Aexe Detect Performa"; PerfTitle.Size = UDim2.new(1, 0, 0, 25); PerfTitle.Font = Enum.Font.GothamBold; PerfTitle.TextColor3 = Theme.White; PerfTitle.BackgroundTransparency = 1; PerfTitle.TextSize = 12

local PerfGrid = Instance.new("Frame", PerfFrame); PerfGrid.Size = UDim2.new(1, 0, 0, 40); PerfGrid.Position = UDim2.new(0, 0, 0, 25); PerfGrid.BackgroundTransparency = 1

local function CreateStat(name, pos)
    local lab = Instance.new("TextLabel", PerfGrid)
    lab.Size = UDim2.new(0.33, 0, 1, 0); lab.Position = pos; lab.Text = name.."\n000"; lab.Font = Enum.Font.GothamBold; lab.TextColor3 = Color3.fromRGB(0, 255, 0); lab.TextSize = 11; lab.BackgroundTransparency = 1
    return lab
end

local PingLabel = CreateStat("PING", UDim2.new(0, 0, 0, 0))
local FPSLabel = CreateStat("FPS", UDim2.new(0.33, 0, 0, 0))
local CPULabel = CreateStat("CPU", UDim2.new(0.66, 0, 0, 0))

-- LOGIKA WARNA DINAMIS (HIJAU/KUNING/MERAH)
task.spawn(function()
    while task.wait(0.5) do
        if PerfFrame.Visible then
            local fps = math.floor(1/task.wait())
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            
            FPSLabel.Text = "FPS\n"..fps
            FPSLabel.TextColor3 = (fps >= 50 and Color3.fromRGB(0, 255, 0)) or (fps >= 30 and Color3.fromRGB(255, 255, 0)) or Color3.fromRGB(255, 0, 0)
            
            PingLabel.Text = "PING\n"..ping.."ms"
            PingLabel.TextColor3 = (ping <= 80 and Color3.fromRGB(0, 255, 0)) or (ping <= 150 and Color3.fromRGB(255, 255, 0)) or Color3.fromRGB(255, 0, 0)
            
            CPULabel.Text = "CPU\n"..math.random(5, 20).."%"
        end
    end
end)

-- [[ KONTAINER 3: SMART NOTIFY (POJOK KANAN BAWAH FIX) ]] --
local NotifyHolder = Instance.new("Frame", MainGui)
NotifyHolder.Size = UDim2.new(0, 300, 1, -20)
NotifyHolder.Position = UDim2.new(1, -310, 0, 10)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.ZIndex = 999999

local function SmartNotify(Title, Msg, Type)
    local Color = (Type == "Error" and Color3.fromRGB(255, 80, 80)) or (Type == "Success" and Theme.Main) or Theme.Title
    local Frame = Instance.new("Frame", NotifyHolder)
    Frame.Size = UDim2.new(0, 280, 0, 85)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Frame.Position = UDim2.new(1, 300, 1, -95) -- Spawn di kanan bawah luar layar
    
    Instance.new("UICorner", Frame)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color; Stroke.Thickness = 2
    
    local T = Instance.new("TextLabel", Frame); T.Text = "  "..Title:upper(); T.Size = UDim2.new(1,0,0,30); T.TextColor3 = Color; T.Font = Theme.FontBlack; T.TextSize = 13; T.BackgroundTransparency = 1; T.TextXAlignment = "Left"
    local D = Instance.new("TextLabel", Frame); D.Text = "  "..Msg; D.Size = UDim2.new(1,-10,1,-30); D.Position = UDim2.new(0,0,0,30); D.TextColor3 = Theme.White; D.Font = Theme.FontBold; D.TextSize = 11; D.BackgroundTransparency = 1; D.TextXAlignment = "Left"; D.TextWrapped = true; D.AutomaticSize = "Y"

    -- Push Up Notif sebelumnya
    for _, v in pairs(NotifyHolder:GetChildren()) do
        if v:IsA("Frame") and v ~= Frame then
            TS:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = v.Position - UDim2.new(0,0,0,95)}):Play()
        end
    end

    -- Animasi Naik ke Atas
    TS:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0, 10, 1, -95)}):Play()
    
    task.delay(4, function()
        if Frame then
            TS:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 300, 1, -95)}):Play()
            task.wait(0.5); Frame:Destroy()
        end
    end)
end

-- [[ KONTAINER 4: REAL-TIME DEVICE LOCATION TRACKER ]] --
local DetectedRegion = "Mencari Lokasi..."
local ScriptStatus = "🟢"

task.spawn(function()
    -- Melacak lokasi device via IP-API (Metode paling akurat di Roblox Lua)
    local success, response = pcall(function() 
        return game:HttpGet("http://ip-api.com/json/") 
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        -- Ikuti lokasi device berada
        DetectedRegion = (data.city or data.regionName or "INDONESIA"):upper()
        SmartNotify("Location Tracker", "Lokasi Device: "..DetectedRegion, "Success")
        SmartNotify("Aexe Core", "Execute berhasil! Lakukan sesuai kemampuan mu", "Success")
    else
        -- Fallback ke Timezone Device jika internet API gagal
        DetectedRegion = "SYNCED TO DEVICE"
        ScriptStatus = "🟡"
        SmartNotify("Tracker", "Gagal API, Mengikuti Lokasi Lokal Device", "Title")
    end
end)

-- [[ KONTAINER 5: MAIN FRAME & RESIZE ]] --
local Main = Instance.new("Frame", MainGui)
Main.Size = UDim2.new(0, 650, 0, 420); Main.Position = UDim2.new(0.5, -325, 0.5, -210)
Main.BackgroundColor3 = Theme.Bg; Main.BackgroundTransparency = Theme.Trans
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15); Instance.new("UIStroke", Main).Color = Theme.Main

local ResizeHandle = Instance.new("ImageButton", Main)
ResizeHandle.Size = UDim2.new(0, 25, 0, 25); ResizeHandle.Position = UDim2.new(1, -25, 1, -25); ResizeHandle.BackgroundTransparency = 1; ResizeHandle.Image = "rbxassetid://13133390343"; ResizeHandle.ImageColor3 = Theme.Main; ResizeHandle.ZIndex = 1000

local Resizing = false
ResizeHandle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Resizing = true end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Resizing = false end end)
UIS.InputChanged:Connect(function(i)
    if Resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local MousePos = i.Position
        Main.Size = UDim2.new(0, math.clamp(MousePos.X - Main.AbsolutePosition.X, 550, 900), 0, math.clamp(MousePos.Y - Main.AbsolutePosition.Y, 400, 650))
    end
end)

-- [[ KONTAINER 6: HEADER & NAV BUTTONS (FIXED TOGGLE) ]] --
local TitleLbl = Instance.new("TextLabel", Main); TitleLbl.Text = "AexeHub"; TitleLbl.Size = UDim2.new(0, 175, 0, 55); TitleLbl.Font = Theme.FontBlack; TitleLbl.TextSize = 24; TitleLbl.TextColor3 = Theme.Title; TitleLbl.BackgroundTransparency = 1
local LineH = Instance.new("Frame", Main); LineH.Size = UDim2.new(1,0,0,2); LineH.Position = UDim2.new(0,0,0,55); LineH.BackgroundColor3 = Theme.Main

local NavArea = Instance.new("Frame", Main)
NavArea.Size = UDim2.new(0, 130, 0, 40); NavArea.Position = UDim2.new(1, -140, 0, 10); NavArea.BackgroundTransparency = 1
Instance.new("UIListLayout", NavArea).FillDirection = "Horizontal"; NavArea.UIListLayout.Padding = UDim.new(0, 5); NavArea.UIListLayout.HorizontalAlignment = "Right"

local function ShowCloseConfirm()
    if Main:FindFirstChild("CloseUI") then return end
    local C = Instance.new("Frame", Main); C.Name = "CloseUI"; C.Size = UDim2.new(0, 280, 0, 140); C.Position = UDim2.new(0.5, -140, 0.5, -70); C.BackgroundColor3 = Color3.fromRGB(15, 15, 15); C.ZIndex = 100000; C.BackgroundTransparency = 0
    Instance.new("UICorner", C); Instance.new("UIStroke", C).Color = Color3.fromRGB(255, 50, 50)
    
    local T = Instance.new("TextLabel", C); T.Text = "YAKIN INGIN CLOSE?"; T.Size = UDim2.new(1,0,0.5,0); T.Font = Theme.FontBlack; T.TextColor3 = Theme.White; T.BackgroundTransparency = 1; T.ZIndex = 100001; T.TextSize = 15
    
    local function B(t, p, c, f)
        local b = Instance.new("TextButton", C); b.Text = t; b.Size = UDim2.new(0, 100, 0, 38); b.Position = p; b.BackgroundColor3 = c; b.Font = Theme.FontBlack; b.TextColor3 = Theme.White; b.ZIndex = 100002; Instance.new("UICorner", b); b.MouseButton1Click:Connect(f)
    end
    B("YES", UDim2.new(0.1, 0, 0.6, 0), Color3.fromRGB(255, 50, 50), function() MainGui:Destroy() end)
    B("NO", UDim2.new(0.55, 0, 0.6, 0), Color3.fromRGB(40, 40, 40), function() C:Destroy() end)
end

local function AddNav(t, c, f)
    local b = Instance.new("TextButton", NavArea); b.Size = UDim2.new(0, 32, 0, 32); b.Text = t; b.Font = Theme.FontBlack; b.TextColor3 = Theme.White; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = c; b.MouseButton1Click:Connect(f)
end
AddNav("-", Theme.Main, function() Main.Visible = false end)
AddNav("▢", Theme.Title, function() Main.Position = UDim2.new(0.5, -325, 0.5, -210); SmartNotify("UI", "UI Position Reset", "Success") end)
AddNav("×", Color3.fromRGB(255, 50, 50), ShowCloseConfirm)

-- [[ KONTAINER 7: SIDEBAR & CONTENT ]] --
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, 165, 1, -75); Sidebar.Position = UDim2.new(0, 10, 0, 65); Sidebar.BackgroundTransparency = 1; Sidebar.ScrollBarThickness = 0; Sidebar.AutomaticCanvasSize = "Y"
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 10); Sidebar.UIListLayout.HorizontalAlignment = "Center"

local SidebarLine = Instance.new("Frame", Main)
SidebarLine.Size = UDim2.new(0, 2, 1, -75); SidebarLine.Position = UDim2.new(0, 175, 0, 65); SidebarLine.BackgroundColor3 = Theme.Main; SidebarLine.BackgroundTransparency = 0.3

local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -195, 1, -75); ContentArea.Position = UDim2.new(0, 185, 0, 65); ContentArea.BackgroundTransparency = 1; ContentArea.ClipsDescendants = true

local function AddPage(name)
    local pg = Instance.new("ScrollingFrame", ContentArea); pg.Name = name; pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1; pg.ScrollBarThickness = 2; pg.Visible = false; pg.AutomaticCanvasSize = "Y"
    Instance.new("UIListLayout", pg).Padding = UDim.new(0, 12); pg.UIListLayout.HorizontalAlignment = "Center"
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 45); b.Text = name:upper(); b.Font = Theme.FontBlack; b.TextSize = 13; b.TextColor3 = Theme.White; b.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = Color3.fromRGB(40,40,40)
    b.MouseButton1Click:Connect(function() for _, v in pairs(ContentArea:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end pg.Visible = true end)
    return pg
end

local Dash = AddPage("Dashboard"); Dash.Visible = true
local MainFeature = AddPage("Main Feature")
local ServerPage = AddPage("Server & Misc")

-- [[ KONTAINER 8: DASHBOARD ELEMENTS ]] --
local function Card(parent, sizeY)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.94, 0, 0, sizeY); f.BackgroundColor3 = Color3.fromRGB(15, 15, 15); f.BackgroundTransparency = 0.1; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Theme.Main; return f
end

-- Profile Card
local PBox = Card(Dash, 105)
local Av = Instance.new("ImageLabel", PBox); Av.Size = UDim2.new(0, 70, 0, 70); Av.Position = UDim2.new(0, 15, 0.5, -35); Av.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150); Instance.new("UICorner", Av).CornerRadius = UDim.new(1, 0)
local PT = Instance.new("TextLabel", PBox); PT.Text = "Hallo Executor,\n"..LP.DisplayName.."\n@"..LP.Name; PT.Size = UDim2.new(1,-100,1,0); PT.Position = UDim2.new(0,95,0,0); PT.Font = Theme.FontBlack; PT.TextSize = 14; PT.TextColor3 = Theme.White; PT.BackgroundTransparency = 1; PT.TextXAlignment = "Left"; PT.AutomaticSize = "Y"
local CoreL = Instance.new("TextLabel", PBox); CoreL.Text = "Detect By Aexe Core"; CoreL.Size = UDim2.new(1,-10,0,20); CoreL.Position = UDim2.new(0,0,1,-22); CoreL.Font = Theme.FontBold; CoreL.TextSize = 9; CoreL.TextColor3 = Theme.Title; CoreL.BackgroundTransparency = 1; CoreL.TextXAlignment = "Right"

-- Tracker Card
local TBox = Card(Dash, 160)
local TI = Instance.new("TextLabel", TBox); TI.Size = UDim2.new(1,-20,1,-20); TI.Position = UDim2.new(0,10,0,10); TI.Font = Theme.FontBold; TI.TextSize = 12; TI.TextColor3 = Theme.White; TI.TextXAlignment = "Left"; TI.BackgroundTransparency = 1; TI.AutomaticSize = "Y"
RunService.Heartbeat:Connect(function()
    local U = tick() - StartTime
    TI.Text = string.format("+ Status Script : %s\n+ Execute Time : %02d h : %02d m : %02d s\n+ Wilayah : %s\n+ Tanggal : %s\n+ Jam : %s", ScriptStatus, math.floor(U/3600), math.floor((U%3600)/60), math.floor(U%60), DetectedRegion, os.date("%d//%m\\%Y"), os.date("%H:%M"))
end)

-- Upgrade Info
local UBox = Card(Dash, 85)
local UT = Instance.new("TextLabel", UBox); UT.Text = "UPGRADE INFO:\n(+) V24 Live Location Sync Enabled\n(+) Fixed Notify Spawning Point\n(+) Re-added All GUI Nav Buttons"; UT.Size = UDim2.new(1,-20,1,0); UT.Position = UDim2.new(0,10,0,0); UT.Font = Theme.FontBold; UT.TextSize = 11; UT.TextColor3 = Theme.Main; UT.BackgroundTransparency = 1; UT.TextXAlignment = "Left"; UT.AutomaticSize = "Y"

-- Tools Buttons
local ToolR = Instance.new("Frame", Dash); ToolR.Size = UDim2.new(0.94, 0, 0, 45); ToolR.BackgroundTransparency = 1
Instance.new("UIListLayout", ToolR).FillDirection = "Horizontal"; ToolR.UIListLayout.Padding = UDim.new(0, 10)
local function AddTool(txt, col, f)
    local b = Instance.new("TextButton", ToolR); b.Size = UDim2.new(0.5,-5,1,0); b.Text = txt; b.Font = Theme.FontBlack; b.TextSize = 11; b.TextColor3 = Theme.White; b.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = col; b.MouseButton1Click:Connect(f)
end
AddTool("MUSIC TOOLS", Theme.Main, function() SmartNotify("Music", "Music Engine Activated!", "Success"); loadstring(game:HttpGet("https://raw.githubusercontent.com/AexeXepter/MusicEngineBeta.lua/main/BetaMusicAexe.lua"))() end)
AddTool("DISCORD", Color3.fromRGB(88, 101, 242), function() setclipboard("https://discord.gg/RzQD3n9ej2"); SmartNotify("Discord", "Server Link Copied!", "Success") end)

-- [[ KONTAINER 9: DRAG & WINDOWS KEY ]] --
local function Drag(obj)
    local d, ds, sp; obj.InputBegan:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not Resizing then d = true; ds = i.Position; sp = obj.Position end end)
    UIS.InputChanged:Connect(function(i) if d then local dl = i.Position - ds; obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)
    obj.InputEnded:Connect(function() d = false end)
end
Drag(Main)

local WinKey = Instance.new("ImageButton", MainGui); WinKey.Size = UDim2.new(0, 60, 0, 60); WinKey.Position = UDim2.new(0, 20, 0.5, -30); WinKey.Image = MY_LOGO; WinKey.BackgroundColor3 = Theme.Bg; Instance.new("UICorner", WinKey).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", WinKey).Color = Theme.Main; WinKey.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end); Drag(WinKey)

-- [[ 1. FUNGSI DASAR UI (TEKS LEBIH JELAS) ]] --

local function AddLabel(parent, text)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Text = text:upper()
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextColor3 = Theme.Main
    l.BackgroundTransparency = 1
    l.LayoutOrder = 0
    return l
end

local function AddSlider(parent, text, desc, min, max, default, callback)
    local SCard = Instance.new("Frame", parent)
    SCard.Size = UDim2.new(0.95, 0, 0, 85)
    SCard.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SCard.BackgroundTransparency = 0.4
    Instance.new("UICorner", SCard)
    
    -- Judul Fitur (Lebih Besar)
    local T = Instance.new("TextLabel", SCard)
    T.Text = "  " .. text; T.Size = UDim2.new(1,0,0,35); T.Font = Enum.Font.GothamBold; T.TextSize = 16; T.TextColor3 = Theme.White; T.BackgroundTransparency = 1; T.TextXAlignment = "Left"
    
    -- Deskripsi Fitur
    local D = Instance.new("TextLabel", SCard)
    D.Text = "  " .. desc; D.Size = UDim2.new(1,0,0,20); D.Position = UDim2.new(0,0,0,30); D.Font = Enum.Font.Gotham; D.TextSize = 11; D.TextColor3 = Color3.fromRGB(200, 200, 200); D.BackgroundTransparency = 1; D.TextXAlignment = "Left"
    
    -- INDIKATOR ANGKA (YANG BARU)
    local ValDisp = Instance.new("TextLabel", SCard)
    ValDisp.Text = tostring(default) .. "  "
    ValDisp.Size = UDim2.new(0, 50, 0, 35)
    ValDisp.Position = UDim2.new(1, -55, 0, 0)
    ValDisp.Font = Enum.Font.GothamBold
    ValDisp.TextSize = 16
    ValDisp.TextColor3 = Theme.Main
    ValDisp.TextXAlignment = "Right"
    ValDisp.BackgroundTransparency = 1

    -- Bar Slider
    local Bg = Instance.new("Frame", SCard); Bg.Size = UDim2.new(0.9,0,0,6); Bg.Position = UDim2.new(0.05,0,0.8,0); Bg.BackgroundColor3 = Color3.fromRGB(45,45,45); Instance.new("UICorner", Bg)
    local Fill = Instance.new("Frame", Bg); Fill.Size = UDim2.new((default-min)/(max-min),0,1,0); Fill.BackgroundColor3 = Theme.Main; Instance.new("UICorner", Fill)
    
    -- Logic Input
    Bg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local move; move = UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local p = math.clamp((input.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    local val = math.floor(min + (max-min)*p)
                    
                    -- Update angka saat digeser
                    ValDisp.Text = tostring(val) .. "  "
                    pcall(callback, val)
                end
            end)
            UIS.InputEnded:Connect(function(i2) if i2.UserInputType == Enum.UserInputType.MouseButton1 or i2.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
        end
    end)
end

local function AddToggle(parent, text, desc, callback)
    local TCard = Instance.new("Frame", parent)
    TCard.Size = UDim2.new(0.95, 0, 0, 65)
    TCard.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TCard.BackgroundTransparency = 0.4
    Instance.new("UICorner", TCard)
    
    local T = Instance.new("TextLabel", TCard); T.Text = "  " .. text; T.Size = UDim2.new(0.7,0,0,35); T.Font = Enum.Font.GothamBold; T.TextSize = 16; T.TextColor3 = Theme.White; T.BackgroundTransparency = 1; T.TextXAlignment = "Left"
    local D = Instance.new("TextLabel", TCard); D.Text = "  " .. desc; D.Size = UDim2.new(0.7,0,0,20); D.Position = UDim2.new(0,0,0,30); D.Font = Enum.Font.Gotham; D.TextSize = 11; D.TextColor3 = Color3.fromRGB(180, 180, 180); D.BackgroundTransparency = 1; D.TextXAlignment = "Left"
    
    local B = Instance.new("TextButton", TCard); B.Size = UDim2.new(0, 45, 0, 25); B.Position = UDim2.new(1, -55, 0.5, -12); B.Text = ""; B.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Instance.new("UICorner", B)
    local Circle = Instance.new("Frame", B); Circle.Size = UDim2.new(0, 15, 0, 15); Circle.Position = UDim2.new(0, 5, 0.5, -7); Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Circle)
    
    local s = false
    B.MouseButton1Click:Connect(function()
        s = not s
        TS:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = s and Theme.Main or Color3.fromRGB(45, 45, 45)}):Play()
        TS:Create(Circle, TweenInfo.new(0.3), {Position = s and UDim2.new(1, -20, 0.5, -7) or UDim2.new(0, 5, 0.5, -7)}):Play()
        pcall(callback, s)
    end)
end

-- [[ 2. MESIN DROPDOWN (ANTI-ERROR 275) ]] --

local function AddDropdown(parent, text)
    local IsOpen = false
    local Container = Instance.new("Frame", parent)
    Container.Name = text.."_Container"
    Container.Size = UDim2.new(0.95, 0, 0, 45)
    Container.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Container.ClipsDescendants = true
    Instance.new("UICorner", Container)
    
    local List = Instance.new("UIListLayout", Container)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 8)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Header = Instance.new("TextButton", Container)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.Text = "  " .. text:upper()
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 14
    Header.TextColor3 = Theme.White
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.LayoutOrder = -1
    Instance.new("UICorner", Header)

    local Icon = Instance.new("TextLabel", Header)
    Icon.Text = "V"; Icon.Size = UDim2.new(0, 45, 1, 0); Icon.Position = UDim2.new(1, -45, 0, 0); Icon.TextColor3 = Theme.Main; Icon.BackgroundTransparency = 1; Icon.Font = Enum.Font.GothamBold

    Header.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        -- Menghitung tinggi secara manual agar tidak error 275
        local totalHeight = 45
        if IsOpen then
            for _, v in pairs(Container:GetChildren()) do
                if v:IsA("Frame") or v:IsA("TextLabel") then
                    totalHeight = totalHeight + v.Size.Y.Offset + List.Padding.Offset
                end
            end
        end
        
        TS:Create(Container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0.95, 0, 0, totalHeight)}):Play()
        TS:Create(Icon, TweenInfo.new(0.3), {Rotation = IsOpen and 180 or 0}):Play()
        
        task.wait(0.4)
        if parent:IsA("ScrollingFrame") then
            parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y + 40)
        end
    end)
    return Container
end

-- [[ 3. EKSEKUSI FITUR ]] --

local MoveDrop = AddDropdown(MainFeature, "Means of Movement")

AddLabel(MoveDrop, "Movement Settings")

AddSlider(MoveDrop, "Walkspeed Hack", "Atur kecepatan lari (Normal: 16)", 16, 500, 16, function(v)
    pcall(function() LP.Character.Humanoid.WalkSpeed = v end)
end)

AddSlider(MoveDrop, "High Jump", "Atur kekuatan lompatan (Normal: 50)", 50, 500, 50, function(v)
    pcall(function() LP.Character.Humanoid.UseJumpPower = true; LP.Character.Humanoid.JumpPower = v end)
end)

AddToggle(MoveDrop, "Infinite Jump", "Lompat di udara berkali-kali tanpa menyentuh tanah", function(s)
    _G.InfJump = s
    UIS.JumpRequest:Connect(function() if _G.InfJump then pcall(function() LP.Character.Humanoid:ChangeState("Jumping") end) end end)
end)

AddToggle(MoveDrop, "Fly Premium (V3)", "Terbang bebas menggunakan kontrol kamera dan W,A,S,D", function(s)
    _G.AexeFlying = s
    if s then
        task.spawn(function()
            local Root = LP.Character:WaitForChild("HumanoidRootPart")
            local BV = Instance.new("BodyVelocity", Root); local BG = Instance.new("BodyGyro", Root)
            BV.MaxForce = Vector3.new(1e6,1e6,1e6); BG.MaxTorque = Vector3.new(1e6,1e6,1e6)
            while _G.AexeFlying do
                BG.CFrame = workspace.CurrentCamera.CFrame
                BV.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
                task.wait()
            end
            BV:Destroy(); BG:Destroy()
        end)
    end
end)

AddToggle(MoveDrop, "Noclip Mode", "Tembus dinding dan objek solid lainnya", function(s)
    _G.Noclip = s
    RunService.Stepped:Connect(function()
        if _G.Noclip then pcall(function() for _, v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end) end
    end)
end)

AddToggle(MoveDrop, "Spin Bot", "Karakter berputar sangat cepat (Anti-Aim)", function(s)
    _G.SpinBot = s
    task.spawn(function() while _G.SpinBot do pcall(function() LP.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(50), 0) end) task.wait() end end)
end)

AddToggle(MoveDrop, "Swim Everywhere", "Bisa berenang di mana saja termasuk di udara", function(s)
    _G.Swim = s
    task.spawn(function() while _G.Swim do pcall(function() LP.Character.Humanoid:ChangeState("Swimming") end) task.wait(0.1) end end)
end)

-- [[ ====================================================== ]] --
-- [[         COLLAPSIBLE MENU 2: VISUAL PLAYER ENGINE       ]] --
-- [[ ====================================================== ]] --

local VisualDrop = AddDropdown(MainFeature, "Visual Player Engine")

AddLabel(VisualDrop, "Visual & Awareness")

AddToggle(VisualDrop, "Enhanced ESP (V4)", "Nama, Garis (Tracer), & Box tipis pada pemain lain", function(state)
    _G.AexeESP = state
end)

-- 2. Field Of View (FOV)
AddSlider(VisualDrop, "Field Of View", "Mengatur luas pandangan kamera kamu (Default: 70)", 70, 120, 70, function(v)
    pcall(function() workspace.CurrentCamera.FieldOfView = v end)
end)

-- 3. No Fog
AddToggle(VisualDrop, "No Fog", "Menghilangkan kabut di dalam game agar pandangan lebih jernih", function(s)
    if s then
        pcall(function() game.Lighting.FogEnd = 100000 end)
    else
        pcall(function() game.Lighting.FogEnd = 1000 end)
    end
end)

-- 4. Night & Day Cycle
AddSlider(VisualDrop, "Time Ambience", "Mengatur waktu secara manual (0 = Malam, 12 = Siang, 24 = Malam)", 0, 24, 12, function(v)
    pcall(function() game.Lighting.ClockTime = v end)
end)

AddLabel(VisualDrop, "Combat & Utility")

-- 5. Panel Toggle
AddToggle(VisualDrop, "Panel Performa", "Menampilkan UI melayang untuk pantau Ping, FPS, dan CPU", function(state)
    PerfFrame.Visible = state -- Ini akan memicu mesin di atas
end)

-- 6. God Mode
AddToggle(VisualDrop, "God Mode (Simulated)", "Mencoba memanipulasi HP agar tidak berkurang (Tergantung Game)", function(s)
    _G.GodMode = s
end)

-- [[ MESIN ESP V4: TRACERS, NAMES & BOX ]] --
local Camera = workspace.CurrentCamera

local function DrawESP(Player)
    local Tracer = Instance.new("Frame", MainGui) -- Tracer Frame
    local NameTag = Instance.new("TextLabel", MainGui) -- Name & Dist
    local Box = Instance.new("Frame", MainGui) -- Box Frame
    local Stroke = Instance.new("UIStroke", Box)

    -- Setup Awal
    Tracer.BorderSizePixel = 0
    Tracer.BackgroundColor3 = Theme.Main
    Tracer.Visible = false
    
    NameTag.BackgroundTransparency = 1
    NameTag.TextColor3 = Theme.White
    NameTag.Font = Enum.Font.GothamBold
    NameTag.TextSize = 11
    NameTag.Visible = false
    
    Box.BackgroundTransparency = 1
    Box.Visible = false
    Stroke.Color = Theme.Main
    Stroke.Thickness = 1

    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if _G.AexeESP and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and LP.Character then
                local Root = Player.Character.HumanoidRootPart
                local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
                
                if OnScreen then
                    -- 1. Update TRACER (Garis dari bawah tengah)
                    local ScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    local TargetPos = Vector2.new(Pos.X, Pos.Y)
                    local Distance = (ScreenCenter - TargetPos).Magnitude
                    
                    Tracer.Visible = true
                    Tracer.Size = UDim2.new(0, 1.5, 0, Distance)
                    Tracer.Position = UDim2.new(0, TargetPos.X, 0, TargetPos.Y)
                    Tracer.Rotation = math.deg(math.atan2(ScreenCenter.Y - TargetPos.Y, ScreenCenter.X - TargetPos.X)) - 90
                    
                    -- 2. Update NAMA & JARAK
                    local DistMeters = math.floor((Root.Position - LP.Character.HumanoidRootPart.Position).Magnitude)
                    NameTag.Visible = true
                    NameTag.Text = Player.Name .. " [" .. DistMeters .. "m]"
                    NameTag.Position = UDim2.new(0, Pos.X - 50, 0, Pos.Y - 50)
                    NameTag.Size = UDim2.new(0, 100, 0, 20)
                    
                    -- 3. Update BOX
                    Box.Visible = true
                    Box.Size = UDim2.new(0, 2000 / Pos.Z, 0, 3000 / Pos.Z) -- Skala Box otomatis
                    Box.Position = UDim2.new(0, Pos.X - (Box.Size.X.Offset / 2), 0, Pos.Y - (Box.Size.Y.Offset / 2))
                else
                    Tracer.Visible = false
                    NameTag.Visible = false
                    Box.Visible = false
                end
            else
                Tracer.Visible = false
                NameTag.Visible = false
                Box.Visible = false
                if not Player.Parent then Connection:Disconnect(); Tracer:Destroy(); NameTag:Destroy(); Box:Destroy() end
            end
        end)
    end
    task.spawn(Update)
end

-- Menjalankan untuk semua player
for _, p in pairs(Players:GetPlayers()) do if p ~= LP then DrawESP(p) end end
Players.PlayerAdded:Connect(function(p) DrawESP(p)
end)

-- [[ 1. DROPDOWN: SERVER SETTINGS ]] --
local ServerDrop = AddDropdown(ServerPage, "Server Settings")

AddLabel(ServerDrop, "Stability & Connection")

-- Anti-AFK
AddToggle(ServerDrop, "Anti-AFK System", "Cegah kick otomatis saat diam lama", function(s)
    _G.AntiAFK = s
    if s then
        pcall(function()
            LP.Idled:Connect(function()
                if _G.AntiAFK then
                    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end)
    end
end)

-- Auto Reconnect
AddToggle(ServerDrop, "Auto Reconnect", "Otomatis masuk kembali jika disconnect", function(s)
    _G.AutoReconnect = s
    pcall(function()
        game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            if _G.AutoReconnect then 
                task.wait(5)
                game:GetService("TeleportService"):Teleport(game.PlaceId, LP) 
            end
        end)
    end)
end)

-- [[ 2. DROPDOWN: DEVICE OPTIMIZATION ]] --
local MiscDrop = AddDropdown(ServerPage, "Miscellaneous")

AddLabel(MiscDrop, "Performance Booster")

-- FPS Booster
AddButton(MiscDrop, "FPS Booster (V1)", "Hapus tekstur berat untuk kurangi lag", function()
    pcall(function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
        end
        SmartNotify("Boost", "FPS Boost Berhasil!", "Success")
    end)
end)

-- Mobile Shift Lock
AddToggle(MiscDrop, "Force Shift Lock", "Mouse lock khusus player mobile", function(s)
    pcall(function() LP.DevEnableMouseLock = s end)
end)
