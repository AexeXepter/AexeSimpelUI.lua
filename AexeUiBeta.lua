-- [[ AEZEHUB V8.2: REFINED PREMIUM ]] --
-- Fix: Header Buttons Visibility, Profile Alignment, Scroll Limit

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local StartTime = tick()

local Theme = {
    Main = Color3.fromRGB(0, 255, 200),   -- Toska
    Title = Color3.fromRGB(150, 220, 255), -- Blue Ice
    White = Color3.fromRGB(255, 255, 255),
    Bg = Color3.fromRGB(5, 5, 5),
    Trans = 0.15,
    FontBold = Enum.Font.GothamBold,
    FontBlack = Enum.Font.GothamBlack
}
local MY_LOGO = "rbxassetid://72181568495758"

-- [[ 1. SMART NOTIFY ENGINE ]] --
local NotifyGui = Instance.new("ScreenGui", game.CoreGui)
local function SmartNotify(Title, Msg, Type)
    local Color = (Type == "Error" and Color3.fromRGB(255, 80, 80)) or (Type == "Success" and Theme.Main) or Theme.Title
    local Frame = Instance.new("Frame", NotifyGui)
    Frame.Size = UDim2.new(0, 280, 0, 90); Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Frame.Position = UDim2.new(1, 30, 0.85, -(#NotifyGui:GetChildren() * 100))
    Instance.new("UICorner", Frame); Instance.new("UIStroke", Frame).Color = Color
    
    local T = Instance.new("TextLabel", Frame); T.Text = "  "..Title:upper(); T.Size = UDim2.new(1,0,0,35); T.TextColor3 = Color; T.Font = Theme.FontBlack; T.TextSize = 15; T.BackgroundTransparency = 1; T.TextXAlignment = "Left"
    local D = Instance.new("TextLabel", Frame); D.Text = "  "..Msg; D.Size = UDim2.new(1,-10,1,-35); D.Position = UDim2.new(0,0,0,35); D.TextColor3 = Theme.White; D.Font = Theme.FontBold; D.TextSize = 13; D.BackgroundTransparency = 1; D.TextXAlignment = "Left"; D.TextWrapped = true; D.AutomaticSize = Enum.AutomaticSize.Y

    TS:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(1, -300, Frame.Position.Y.Scale, Frame.Position.Y.Offset)}):Play()
    task.delay(4, function() if Frame then TS:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 30, Frame.Position.Y.Scale, Frame.Position.Y.Offset)}):Play() task.wait(0.5) Frame:Destroy() end end)
end

-- [[ 2. MAIN UI SETUP ]] --
local MainGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", MainGui)
Main.Size = UDim2.new(0, 650, 0, 420); Main.Position = UDim2.new(0.5, -325, 0.5, -210)
Main.BackgroundColor3 = Theme.Bg; Main.BackgroundTransparency = Theme.Trans; Main.ClipsDescendants = true; Main.ZIndex = 1
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15); Instance.new("UIStroke", Main).Color = Theme.Main

-- Header Nav (Pojok Kanan Atas) - FIXED VISIBILITY
local HeaderNav = Instance.new("Frame", Main); HeaderNav.Size = UDim2.new(0, 180, 0, 55); HeaderNav.Position = UDim2.new(1, -190, 0, 0); HeaderNav.BackgroundTransparency = 1; HeaderNav.ZIndex = 5
local HL = Instance.new("UIListLayout", HeaderNav); HL.FillDirection = "Horizontal"; HL.HorizontalAlignment = "Right"; HL.VerticalAlignment = "Center"; HL.Padding = UDim.new(0, 12)

local function CreateHeaderBtn(txt, col, func)
    local b = Instance.new("TextButton", HeaderNav); b.Size = UDim2.new(0, 38, 0, 38); b.Text = txt; b.Font = Theme.FontBlack; b.TextSize = 22; b.TextColor3 = Theme.White; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.ZIndex = 6
    Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = col
    b.MouseButton1Click:Connect(func)
end

local function ConfirmClose()
    local C = Instance.new("Frame", MainGui); C.Size = UDim2.new(0, 320, 0, 160); C.Position = UDim2.new(0.5, -160, 0.5, -80); C.BackgroundColor3 = Theme.Bg; C.ZIndex = 100
    Instance.new("UIStroke", C).Color = Color3.fromRGB(255, 50, 50); Instance.new("UICorner", C)
    local T = Instance.new("TextLabel", C); T.Text = "Yakin Ingin Close?"; T.Size = UDim2.new(1,0,0.6,0); T.Font = Theme.FontBlack; T.TextSize = 20; T.TextColor3 = Theme.White; T.BackgroundTransparency = 1
    local Y = Instance.new("TextButton", C); Y.Text = "YES"; Y.Size = UDim2.new(0.4,0,0.3,0); Y.Position = UDim2.new(0.05,0,0.6,0); Y.BackgroundColor3 = Color3.fromRGB(255, 50, 50); Y.TextColor3 = Theme.White; Y.Font = Theme.FontBold; Y.MouseButton1Click:Connect(function() MainGui:Destroy() end)
    local N = Instance.new("TextButton", C); N.Text = "NO"; N.Size = UDim2.new(0.4,0,0.3,0); N.Position = UDim2.new(0.55,0,0.6,0); N.BackgroundColor3 = Color3.fromRGB(50,50,50); N.TextColor3 = Theme.White; N.Font = Theme.FontBold; N.MouseButton1Click:Connect(function() C:Destroy() end)
    Instance.new("UICorner", Y); Instance.new("UICorner", N)
end

CreateHeaderBtn("×", Color3.fromRGB(255, 50, 50), ConfirmClose)
CreateHeaderBtn("❒", Theme.Main, function() SmartNotify("UI", "Resize Active", "Success") end)
CreateHeaderBtn("-", Theme.Title, function() Main.Visible = false end)

-- Judul & Garis
local LTitle = Instance.new("TextLabel", Main); LTitle.Text = "AexeHub"; LTitle.Size = UDim2.new(0, 175, 0, 55); LTitle.Font = Theme.FontBlack; LTitle.TextSize = 26; LTitle.TextColor3 = Theme.Title; LTitle.BackgroundTransparency = 1
local TopL = Instance.new("Frame", Main); TopL.Size = UDim2.new(1,0,0,2); TopL.Position = UDim2.new(0,0,0,55); TopL.BackgroundColor3 = Theme.Main; TopL.BorderSizePixel = 0
local SideL = Instance.new("Frame", Main); SideL.Size = UDim2.new(0,2,1,-55); SideL.Position = UDim2.new(0,175,0,55); SideL.BackgroundColor3 = Theme.Main; SideL.BorderSizePixel = 0

-- [[ 3. SIDEBAR & PAGE ENGINE ]] --
local Sidebar = Instance.new("ScrollingFrame", Main); Sidebar.Size = UDim2.new(0, 165, 1, -65); Sidebar.Position = UDim2.new(0, 5, 0, 60); Sidebar.BackgroundTransparency = 1; Sidebar.ScrollBarThickness = 0
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 10); Sidebar.UIListLayout.HorizontalAlignment = "Center"

local PageFolder = Instance.new("Folder", Main)
local function AddPage(name)
    local pg = Instance.new("ScrollingFrame", PageFolder); pg.Name = name; pg.Size = UDim2.new(1, -195, 1, -75); pg.Position = UDim2.new(0, 185, 0, 65); pg.BackgroundTransparency = 1; pg.ScrollBarThickness = 2; pg.Visible = false; pg.CanvasSize = UDim2.new(0,0,0,0)
    local pgl = Instance.new("UIListLayout", pg); pgl.Padding = UDim.new(0, 12); pgl.HorizontalAlignment = "Center"
    pgl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize = UDim2.new(0, 0, 0, pgl.AbsoluteContentSize.Y + 5) end) -- Scroll mentok di teks terakhir
    
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 48); b.Text = name:upper(); b.Font = Theme.FontBlack; b.TextSize = 14; b.TextColor3 = Theme.White; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = Color3.fromRGB(40,40,40)
    b.MouseButton1Click:Connect(function() for _, v in pairs(PageFolder:GetChildren()) do v.Visible = false end pg.Visible = true end)
    return pg
end

local Dash = AddPage("Dashboard"); Dash.Visible = true

-- [[ 4. DASHBOARD CONTENT ]] --
local function Card(parent, sizeY)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0.96, 0, 0, sizeY); f.BackgroundColor3 = Color3.fromRGB(15, 15, 15); f.BackgroundTransparency = 0.2; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Theme.Main; return f
end

-- Profile Card - FIXED ALIGNMENT
local PBox = Card(Dash, 100)
local Av = Instance.new("ImageLabel", PBox); Av.Size = UDim2.new(0, 70, 0, 70); Av.Position = UDim2.new(0, 15, 0.5, -35); Av.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150); Instance.new("UICorner", Av).CornerRadius = UDim.new(1, 0)
local PT = Instance.new("TextLabel", PBox); PT.Text = "Hallo Executor,\nNick: "..LP.DisplayName.."\nUSN: @"..LP.Name; PT.Size = UDim2.new(1,-100,1,0); PT.Position = UDim2.new(0,95,0,0); PT.Font = Theme.FontBlack; PT.TextSize = 14; PT.TextColor3 = Theme.White; PT.BackgroundTransparency = 1; PT.TextXAlignment = "Left"; PT.AutomaticSize = Enum.AutomaticSize.Y
local Core = Instance.new("TextLabel", PBox); Core.Text = "Detect By Aexe Core"; Core.Size = UDim2.new(1,-15,0,20); Core.Position = UDim2.new(0,0,1,-22); Core.Font = Theme.FontBold; Core.TextSize = 11; Core.TextColor3 = Theme.Title; Core.BackgroundTransparency = 1; Core.TextXAlignment = "Right"

-- Tracker Card
local TBox = Card(Dash, 175)
local TI = Instance.new("TextLabel", TBox); TI.Size = UDim2.new(1,-20,1,-20); TI.Position = UDim2.new(0,10,0,10); TI.Font = Theme.FontBold; TI.TextSize = 13; TI.TextColor3 = Theme.White; TI.TextXAlignment = "Left"; TI.BackgroundTransparency = 1; TI.AutomaticSize = Enum.AutomaticSize.Y

local function GetLoc() local s, r = pcall(function() return HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/")) end) return (s and r.status == "success") and r.city or "PONTIANAK" end
local City = GetLoc()

RunService.Heartbeat:Connect(function()
    local U = tick() - StartTime
    TI.Text = string.format([[
+ Status Script : 🟢 RUNNING
+ Execute Time  : %02d h : %02d m : %02d s
+ Wilayah       : %s
+ Tanggal       : %s
+ Jam           : %s
+ Device        : Android]], math.floor(U/3600), math.floor((U%3600)/60), math.floor(U%60), City:upper(), os.date("%d//%m\\%Y"), os.date("%H:%M"))
end)

-- Upgrade Info
local UBox = Card(Dash, 85)
local UT = Instance.new("TextLabel", UBox); UT.Text = "UPGRADE INFO (v8.2):\n(+) Fixed Header Buttons\n(+) Adjusted Profile Alignment\n(+) Optimized Scroll Length"; UT.Size = UDim2.new(1,-20,1,-10); UT.Position = UDim2.new(0,10,0,5); UT.Font = Theme.FontBold; UT.TextSize = 11; UT.TextColor3 = Theme.Main; UT.BackgroundTransparency = 1; UT.TextXAlignment = "Left"; UT.AutomaticSize = Enum.AutomaticSize.Y

-- Bottom Buttons
local BR = Instance.new("Frame", Dash); BR.Size = UDim2.new(0.96, 0, 0, 50); BR.BackgroundTransparency = 1
Instance.new("UIListLayout", BR).FillDirection = "Horizontal"; BR.UIListLayout.Padding = UDim.new(0, 10)
local function AddTool(name, col, func)
    local b = Instance.new("TextButton", BR); b.Size = UDim2.new(0.5,-5,1,0); b.Text = name; b.Font = Theme.FontBlack; b.TextSize = 13; b.TextColor3 = Theme.White; b.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = col; b.MouseButton1Click:Connect(func)
end
AddTool("MUSIC TOOLS", Theme.Main, function() SmartNotify("Music", "Loading Engine...", "Success"); loadstring(game:HttpGet("https://raw.githubusercontent.com/AexeXepter/MusicEngineBeta.lua/main/BetaMusicAexe.lua"))() end)
AddTool("DISCORD", Color3.fromRGB(88, 101, 242), function() setclipboard("https://discord.gg/RzQD3n9ej2"); SmartNotify("Discord", "Link Copied!", "Success") end)

-- [[ 5. SYSTEMS ]] --
local function Drag(obj)
    local d, ds, sp; obj.InputBegan:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then d = true; ds = i.Position; sp = obj.Position end end)
    UIS.InputChanged:Connect(function(i) if d then local dl = i.Position - ds; obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)
    obj.InputEnded:Connect(function() d = false end)
end
Drag(Main)

local WinKey = Instance.new("ImageButton", MainGui); WinKey.Size = UDim2.new(0, 70, 0, 70); WinKey.Position = UDim2.new(0, 20, 0.5, -35); WinKey.Image = MY_LOGO; WinKey.BackgroundColor3 = Theme.Bg; Instance.new("UICorner", WinKey).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", WinKey).Color = Theme.Main; WinKey.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end); Drag(WinKey)

local RS = Instance.new("ImageButton", Main); RS.Size = UDim2.new(0, 30, 0, 30); RS.Position = UDim2.new(1, -35, 1, -35); RS.BackgroundTransparency = 1; RS.Image = "rbxassetid://10074251214"; RS.ImageColor3 = Theme.Main
local rz = false; RS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then rz = true end end)
UIS.InputChanged:Connect(function(i) if rz then local m = UIS:GetMouseLocation(); Main.Size = UDim2.new(0, math.max(500, m.X - Main.AbsolutePosition.X), 0, math.max(350, m.Y - Main.AbsolutePosition.Y)) end end)
UIS.InputEnded:Connect(function() rz = false end)

SmartNotify("Aexe Core", "Execute berhasil! Lakukan sesuai kemampuan mu", "Success")
