-- [[ ====================================================== ]] --
-- [[              AEXEHUB V0. 1 GACOR MODE ADMIN            ]] --
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
MainGui.Name = "AexeHub_V24"; MainGui.ResetOnSpawn = false

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
