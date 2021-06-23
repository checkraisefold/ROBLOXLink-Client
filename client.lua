local webSock
local plr = game:GetService("Players").LocalPlayer

local proto = false
if not syn and WebSocket and not PROTOSMASHER_LOADED then 
    webSock = WebSocket.connect("ws://localhost:9002/") 
elseif PROTOSMASHER_LOADED then
	proto = true
	webSock = WebSocket.new("ws://localhost:9002/")
elseif syn then
    webSock = syn.websocket.connect("ws://localhost:9002/") 
end

if proto then 
    webSock:ConnectToServer() 
end

game:GetService("RunService").RenderStepped:Connect(function()
    -- awful position serialization technique below
    local charCf = CFrame.new(0,0,0)
    local camCf = CFrame.new(0,0,0)
    
    local charPosTable = {0,0,0}
    local camPosTable = {0,0,0}
    
    local charTopTable = {0,0,0}
    local camTopTable = {0,0,0}
    
    local charFrontTable = {0,0,0}
    local camFrontTable = {0,0,0}

    if workspace.CurrentCamera and plr.Character and plr.Character:FindFirstChild("Head") then
        camCf = workspace.CurrentCamera.CFrame
        charCf = plr.Character:FindFirstChild("Head").CFrame
        
        camPosTable = {camCf.X, camCf.Y, camCf.Z}
        charPosTable = {charCf.X, charCf.Y, charCf.Z}
        
        camTopTable = {camCf.UpVector.X, camCf.UpVector.Y, camCf.UpVector.Z}
        charTopTable = {charCf.UpVector.X, charCf.UpVector.Y, charCf.UpVector.Z}
        
        camFrontTable = {-camCf.LookVector.X, -camCf.LookVector.Y, -camCf.LookVector.Z}
        charFrontTable = {-charCf.LookVector.X, -charCf.LookVector.Y, -charCf.LookVector.Z}
    end
    
    local final = game:GetService("HttpService"):JSONEncode({charPosTable, charFrontTable, charTopTable, camPosTable, camFrontTable, camTopTable, game.PlaceId, tostring(plr.UserId) .. "_" .. tostring(plr.TeamColor)})
    webSock:Send(final)
end)