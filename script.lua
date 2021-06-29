Script
Number 1 Script
client.LaunchAnti=function(mode)
    if mode=='speed' then
        while wait(1) do
            cPcall(function()
                if select(2,pcall(workspace.GetRealPhysicsFPS)):match('GetRealPhysicsFPS') then
                    if workspace:GetRealPhysicsFPS() > tonumber(client.RandiSpeed) then
                        client.Remote('Exploited','kick','Speed exploiting')
                    end
                else
                    client.Remote('Exploited','kick','Method change detected.')
                end
            end)
        end
    elseif mode=='nameid' then
        if localplayer.userId~=client.RealID or localplayer.Name~=client.RealName then
            client.Remote('Exploited','log [Local kick]','Local name/userID does not match real name/userID')
            wait()
            localplayer:Kick("Local name/userID does not match real name/userID")
            --client.KillClient()
        end
        localplayer.Changed:connect(function(o)
            cPcall(function()
                if o=='Name' or o=='userId' then
                    if localplayer.userId~=client.RealID or localplayer.Name~=client.RealName then
                        client.Remote('Exploited','log [Local kick]','(Local name/userID does not match real name/userID')
                        wait()
                        localplayer:Kick("Local name/userID does not match real name/userID")
                    end
                end
            end)
        end)
    elseif mode=='gui' then
        cPcall(function()
            for i,g in pairs(playergui:children()) do
                if g:IsA("PlayerGui") and not g.Name:find(client.CodeName) then
                    local good=false
                    for i,v in pairs(client.AllowedGuiList) do
                        if g.Name==v then
                            good=true
                        end
                    end
                    if not good then g:Destroy() client.Remote("Exploited","log","GUI detected") end
                end
            end
        end)
        playergui.ChildAdded:connect(function(g)
            cPcall(function()
                if g:IsA("PlayerGui") and not g.Name:find(client.CodeName) then
                    local good=false
                    for i,v in pairs(client.AllowedGuiList) do
                        if g.Name==v then
                            good=true
                        end
                    end
                    if not good then g:Destroy() client.Remote("Exploited","log","Building tools detected") end
                end
            end)
        end)
    elseif mode=='tool' then
        localplayer:WaitForChild("Backpack")
        cPcall(function()
            for i,t in pairs(localplayer.Backpack:children()) do
                    client.Remote("GetSetting","AntiBuildingTools")
                    client.Remote("GetSetting","AntiTools")
                    client.Remote("GetSetting","AllowedToolsList")
                    if (t:IsA("Tool") or t:IsA("HopperBin")) and not t:FindFirstChild(client.CodeName..t.Name) then
                        if client.AntiBuildingTools and t:IsA("HopperBin") and (t.BinType==Enum.BinType.Grab or t.BinType==Enum.BinType.Clone or t.BinType==Enum.BinType.Hammer or t.BinType==Enum.BinType.GameTool) then
                            t.Active=false
                            t:Destroy()
                            client.Remote("Exploited","log","Building tools detected")
                        end
                        if client.AntiTools then
                            local good=false
                            for i,v in pairs(client.AllowedToolsList) do
                                if t.Name==v then
                                    good=true
                                end
                            end
                            if not good then t:Destroy() client.Remote("Exploited","log","Tool detected") end
                        end
                    end
                end
            end)
        localplayer.Backpack.ChildAdded:connect(function(t)
            cPcall(function()
                client.Remote("GetSetting","AntiBuildingTools")
                client.Remote("GetSetting","AntiTools")
                client.Remote("GetSetting","AllowedToolsList")
                if (t:IsA("Tool") or t:IsA("HopperBin")) and not t:FindFirstChild(client.CodeName..t.Name) then
                    if client.AntiBuildingTools and t:IsA("HopperBin") and (t.BinType==Enum.BinType.Grab or t.BinType==Enum.BinType.Clone or t.BinType==Enum.BinType.Hammer or t.BinType==Enum.BinType.GameTool) then
                        t:Destroy()
                        client.Remote("Exploited","log","Building tools detected")
                    end
                    if client.AntiTools then
                        local good=false
                        for i,v in pairs(client.AllowedToolsList) do
                            if t.Name==v then
                                good=true
                            end
                        end
                        if not good then t:Destroy() client.Remote("Exploited","log","Tool detected") end
                    end
                end
            end)
        end)
    elseif mode=='ce' then
        for i,v in pairs(game.LogService:GetLogHistory()) do
            for k,m in pairs(v) do
                if type(m)=='string' and m:lower():find('program files') and m:lower():find('cheat engine') and m:lower():find('failed to resolve texture format') then
                    client.Remote('Exploited','kick','Cheat Engine installation detected.')
                end
            end
        end
    elseif mode=='humanoidstate' then
        wait(1)
        local humanoid=localplayer.Character:WaitForChild("Humanoid")
        local event
        local doing=true
        event=humanoid.StateChanged:connect(function(old,new)
            if not doing then event:disconnect() end
            if new==Enum.HumanoidStateType.StrafingNoPhysics and doing then
                client.Remote("Exploited","kill","Noclipping.")
                doing=false
                event:disconnect()
            end
        end)
        while humanoid and humanoid.Parent and humanoid.Parent.Parent and doing and wait() do
            if humanoid:GetState()==Enum.HumanoidStateType.StrafingNoPhysics and doing then
                client.Remote("Exploited","kill","Noclipping.")
                doing=false
            end
        end
    elseif mode=='paranoid' then
        wait(1)
        local char = localplayer.Character
        local torso = char:WaitForChild("Torso")
        local humPart = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        while torso and humPart and torso.Parent==char and humPart.Parent==char and char.Parent~=nil and hum.Health>0 and hum and hum.Parent and wait(1) do
            if (humPart.Position-torso.Position).magnitude>10 and hum and hum.Health>0 then
                client.Remote("Exploited","kill","Paranoid detected.")
            end
        end
    elseif mode=='detection' then
        local lookFor={'stigma','sevenscript'}
        local function check(Message)
            for i,v in pairs(lookFor) do
                if Message:lower():find(v:lower()) then
                    return true
                end
            end
        end
        local function logFind(str)
            for i,v in pairs(game.LogService:GetLogHistory()) do
                if v.message==str then
                    return true
                end
            end
        end
        service.LogService.MessageOut:connect(function(Message, Type)
            if check(Message) then client.Remote('Exploited','crash','Exploit detected. '..Message) end
        end)
        local errEvent
        local kicking=false
 
 
 
        service.NetworkClient.ChildRemoved:connect(function(child)
            wait(30)
            client.KillClient() --Crash the client after 30 seconds of being disconnected.
        end)
        while wait() do
            for i,v in pairs(service.LogService:GetLogHistory()) do
                if check(v.message) then
                    client.Remote('Exploited','crash','Exploit detected.')
                    client.KillClient()
                end
            end
            --[[
            for i,v in pairs(workspace:children()) do
                if v.Name:find("qORBp") then
                    local player=v.Name:match("^(.*)'s")
                    print(player)
                    if player==localplayer.Name then
                        client.Remote("Exploited","kick","qORBp Detected")
                    end
                end
            end
            --]] --Can be abused by exploiters by just changing the qorbs name :l
            if not select(2,pcall(workspace.GetRealPhysicsFPS)):match('GetRealPhysicsFPS') then client.Remote("Exploited","crash","Exploit detected.") end
            local ran,err=pcall(function() local func,err=loadstring("print(1)") end)
            if ran then client.Remote('Exploited','crash','Exploit detected. Loadstring usable.') client.KillClient() end
            local ran,err=pcall(function() game:GetService("CoreGui").RobloxLocked=true end)
            if ran then client.Remote('Exploited','crash','Exploit detected. RobloxLocked usable.') client.KillClient() end
            wait(15)
        end
    elseif mode=="antideletetool" then
        Effects.AntiDeleteTool = true
        local name = math.random(1000,999999).."b"
        local part=Instance.new("Part")
        part.Name=name
        part.CanCollide=false
        part.Anchored=true
        part.Size=Vector3.new(1000,1000,10)
        part.CFrame=workspace.CurrentCamera.CoordinateFrame*CFrame.new(0,0,-11)
        part.Parent=workspace.CurrentCamera
        part.Transparency=1
        local cam=workspace.CurrentCamera
        local event
        cam.Changed:connect(function(p)
            if cam.Parent~=workspace then
                event:disconnect()
                Effects.AntiDeleteTool=false
                client.LaunchAnti("antideletetool")
            end
        end)
        event=cam.ChildRemoved:connect(function(c)
            if (c==part or not part or not part.Parent or part.Parent~=workspace.CurrentCamera) and Effects.AntiDeleteTool then
                part=Instance.new("Part")
                part.Name=name
                part.CanCollide=false
                part.Anchored=true
                part.Size=Vector3.new(1000,1000,10)
                part.CFrame=workspace.CurrentCamera.CoordinateFrame*CFrame.new(0,0,-11)
                part.Parent=workspace.CurrentCamera
                part.Transparency=1
                client.Remote("Exploited","kick","Exploit detected. Building Tools/Delete tool.")
            end
        end)
        while Effects.AntiDeleteTool and wait() and cam do
            local part=workspace.CurrentCamera:WaitForChild(name)
            part.CFrame=workspace.CurrentCamera.CoordinateFrame*CFrame.new(0,0,-11)
        end
        event:disconnect()
        part:Destroy()
    elseif mode=='god' then
        local humanoid=localplayer.Character:WaitForChild('Humanoid')
        local bob=true localplayer.Character.Humanoid.Died:connect(function() bob=false end)
        local moos=localplayer.Character.Humanoid.Changed:connect(function(c)
            if not bob or humanoid==nil then moos:disconnect() return end
            if tostring(localplayer.Character.Humanoid.Health)=="-1.#IND" then
                client.Remote('Exploited','kick','Infinite Health [Godded]')
            end
        end)
        localplayer.Character.Humanoid.Health=localplayer.Character.Humanoid.Health-1
    elseif mode=='selection' then
        game:GetService("Selection").SelectionChanged:connect(function() client.Remote('Exploited','kick','Selection was changed.') end)
    end
end
 
client.setEffectVal=function(val,value)
    Effects[val]=value
end
 
client.setCamProperty=function(prop,value)
    local cam=workspace.CurrentCamera
    if cam[prop] then
        cam[prop]=value
    end
end

Number 2 Script
dofile;date {3/21/THUR};
{
	Auto Update {debug}
	debug.gethook {_VERSION "string};
	player hack {match Ban}
	else
	math.abs {24242DFSD4656FFD}; table.maxn manage Ban package.loaded {23813213DSDASD};
	coroutine.yield {code;}
	(code)GetRektNoob
