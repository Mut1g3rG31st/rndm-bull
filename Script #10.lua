-- ========================================================
-- EIGENSTÄNDIGES AUTO-DRIVE + FLIEGENDE FAHR-PLATTE
-- ========================================================

-- EINSTELLUNGEN
local TOGGLE_KEY = Enum.KeyCode.X  -- Taste zum EIN-/AUSSCHALTEN
local SPEED_BOOST = 300            -- Deine Wunschgeschwindigkeit (jetzt noch höher möglich!)
local STEER_SPEED = 4.5            -- Lenkschärfe bei A/D

-- Globale Instanzen
local autoDriveEnabled = false
local antiFlipGyro = nil
local drivingPlate = nil

-- Services
local player = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")

-- Benachrichtigungen
local function sendNotification(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2
        })
    end)
end

-- Funktion zum sicheren Aufräumen aller erstellten Objekte
local function cleanupObjects()
    if antiFlipGyro then 
        pcall(function() antiFlipGyro:Destroy() end)
        antiFlipGyro = nil 
    end
    if drivingPlate then 
        pcall(function() drivingPlate:Destroy() end)
        drivingPlate = nil 
    end
end

-- Aktivierung per Keybind
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY then
        autoDriveEnabled = not autoDriveEnabled
        if autoDriveEnabled then
            sendNotification("Auto-Drive & Platte", "AKTIVIERT (Tempo: " .. SPEED_BOOST .. ")")
        else
            sendNotification("Auto-Drive & Platte", "DEAKTIVIERT")
            cleanupObjects()
        end
    end
end)

-- Physik- und Plattform-Loop
task.spawn(function()
    while true do
        task.wait(0.01) -- Sehr schnelle Frequenz für präzise Platten-Synchronisation
        
        if not autoDriveEnabled then continue end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
            cleanupObjects()
            continue 
        end

        -- Sitz in der Nähe finden
        local seat = nil
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("VehicleSeat") then
                local d = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if d < 15 then
                    seat = obj
                    break
                end
            end
        end

        if seat then
            -- 1. Anti-Flip (Überschlagschutz)
            if not antiFlipGyro or antiFlipGyro.Parent ~= seat then
                cleanupObjects() -- Altes Setup löschen
                
                antiFlipGyro = Instance.new("BodyGyro")
                antiFlipGyro.MaxTorque = Vector3.new(1000000, 0, 1000000)
                antiFlipGyro.P = 15000
                antiFlipGyro.Parent = seat
            end

            -- 2. Die mitfahrende Platte erstellen, falls sie fehlt
            if not drivingPlate or drivingPlate.Parent ~= workspace then
                drivingPlate = Instance.new("Part")
                drivingPlate.Size = Vector3.new(50, 1, 50) -- Größe der Platte (50x50 Studs)
                drivingPlate.Anchored = true
                drivingPlate.Material = Enum.Material.SmoothPlastic
                drivingPlate.Color = Color3.fromRGB(0, 255, 150) -- Neongrün (Kann auf Transparenz gesetzt werden)
                
                -- HINWEIS: Wenn die Platte unsichtbar sein soll, entferne die zwei "--" vor der nächsten Zeile:
                -- drivingPlate.Transparency = 1 
                
                drivingPlate.Parent = workspace
            end

            -- 3. Die Platte exakt unter den Rädern des Autos positionieren
            -- Hält die Platte immer genau 3.5 Einheiten unter dem Sitz-Mittelpunkt
            drivingPlate.CFrame = CFrame.new(seat.Position - Vector3.new(0, 3.5, 0)) * CFrame.Angles(0, seat.CFrame.Rotation.Y, 0)

            -- 4. Bewegungsvektoren (Absolut flach auf der Platte halten)
            local rawLook = seat.CFrame.LookVector
            local flatLook = Vector3.new(rawLook.X, 0, rawLook.Z).Unit

            -- Vorwärts / Rückwärts (W / S)
            if uis:IsKeyDown(Enum.KeyCode.W) then
                -- Y-Geschwindigkeit wird auf 0 gesetzt, da die Platte dich trägt
                seat.AssemblyLinearVelocity = Vector3.new(flatLook.X * SPEED_BOOST, 0, flatLook.Z * SPEED_BOOST)
            elseif uis:IsKeyDown(Enum.KeyCode.S) then
                seat.AssemblyLinearVelocity = Vector3.new(-flatLook.X * (SPEED_BOOST / 2), 0, -flatLook.Z * (SPEED_BOOST / 2))
            else
                -- Sofort stoppen, wenn kein Gas gegeben wird (verhindert Rutschen auf der Platte)
                seat.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end

            -- Lenken auf der Platte (A / D)
            if uis:IsKeyDown(Enum.KeyCode.A) then
                seat.AssemblyAngularVelocity = Vector3.new(0, STEER_SPEED, 0)
            elseif uis:IsKeyDown(Enum.KeyCode.D) then
                seat.AssemblyAngularVelocity = Vector3.new(0, -STEER_SPEED, 0)
            else
                seat.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end

            -- Ausrichtungssperre aktualisieren
            antiFlipGyro.CFrame = CFrame.new(Vector3.new(0,0,0)) * seat.CFrame.Rotation
        else
            -- Wenn du aussteigst, Objekte sicher entfernen
            cleanupObjects()
        end
    end
end)

sendNotification("Platten-Drive geladen", "Drücke '" .. TOGGLE_KEY.Name .. "' zum Fahren!")
