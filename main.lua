local module = {}

function module.AskForKey(loaduri)
	local Dex = game:GetObjects("rbxassetid://88564883394790")[1]
	Dex.Name = "KeyGui"
	Dex.Parent = game.Players.LocalPlayer.PlayerGui
	local script = Dex.LocalScript
	print(game.PlaceId)
	local function RequestKey()
		if game.PlaceId ~= 0 then
			if game.PlaceId ~= 93891389502681 then
				local HttpService = game:GetService("HttpService")
				local http = (http and http.request) or (syn and syn.request) or request -- Roblox will know these soon.

				local player = game.Players.LocalPlayer
				local prefix = player.Name
				local key

				-- STEP 1: Generate key from backend using player's name
				local generate = http({
					Url = "https://editnew93-key-system-production.up.railway.app/backend/GenerateKey",
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = HttpService:JSONEncode({
						prefix = prefix
					})
				})

				local result = HttpService:JSONDecode(generate.Body)
				if result.success then
					return result.key
				else
					return "Not Success!"
				end
			else
				local remote = game:GetService("ReplicatedStorage"):WaitForChild("GenerateKeyFunction")

				local result = remote:InvokeServer()
				if result.success then
					return result.key
				else
					return "Not Success!"
				end
			end
		end
	end

	local function checkKey()
		local HttpService = game:GetService("HttpService")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local remote = ReplicatedStorage:WaitForChild("CheckKeyRemote")

		local key = script.Parent.Frame.TextBox.Text
		local placeId = game.PlaceId

		local function checkKeyWithJJSploitHttp(key)
			local http = (http and http.request) or (syn and syn.request) or request

			local body = HttpService:JSONEncode({ key = key })

			local response = http({
				Url = "https://editnew93-key-system-production.up.railway.app/backend/IsKeyAvailable",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = body
			})

			local result = HttpService:JSONDecode(response.Body)
			return result.success and result.available
		end

		local isValid

		if placeId == 93891389502681 then
			-- Use RemoteFunction to ask server to do the Roblox HTTP Post
			local result = remote:InvokeServer(key)
			isValid = result.success and result.available
		else
			-- Use exploit http request directly
			isValid = checkKeyWithJJSploitHttp(key)
		end

		if isValid then
			script.Parent:Destroy()
			game.Lighting.Blur:Destroy()
			loadstring(game:HttpGet(loaduri))()
		else
			script.Parent.Frame.Text.Text = "Incorrect. Please Try Again."
			script.Parent.Frame.Text.TextColor3 = Color3.new(1, 0, 0)
			local Tween = game.TweenService:Create(script.Parent.Frame.Text, TweenInfo.new(0.5), {TextColor3 = Color3.new(1, 1, 1)})
			Tween:Play()			
		end
	end
	script.Parent.Frame.Enter.MouseButton1Click:Connect(checkKey)
	local function TweenEnter()
		local Blur = Instance.new("BlurEffect")
		Blur.Name = "Blur"
		Blur.Size = 0
		Blur.Parent = game.Lighting
		local TweenBlur = game.TweenService:Create(game.Lighting.Blur, TweenInfo.new(0.5), {Size = 24})
		script.Parent.Frame.Visible = true
		for _, i in pairs(script.Parent.Frame:GetChildren()) do
			if i:IsA("TextLabel") then
				i.TextTransparency = 1
				local TweenText = game.TweenService:Create(i, TweenInfo.new(0.5), {TextTransparency = 0})
				TweenText:Play()
			end
			if i:IsA("TextButton") then
				i.Transparency = 1
				local TweenText = game.TweenService:Create(i, TweenInfo.new(0.5), {Transparency = 0})
				TweenText:Play()
			end
			if i:IsA("TextBox") then
				i.Transparency = 1
				local TweenText = game.TweenService:Create(i, TweenInfo.new(0.5), {Transparency = 0})
				TweenText:Play()
			end

		end
		script.Parent.Frame.BackgroundTransparency = 1
		local TweenNormal = game.TweenService:Create(script.Parent.Frame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
		TweenNormal:Play()
		TweenBlur:Play()
	end

	wait(2)
	TweenEnter()
	script.Parent.Get.Back.MouseButton1Click:Connect(function()
		script.Parent.Frame.Visible = true
		script.Parent.Get.Visible = false
	end)

	local function GetKey()
		script.Parent.Frame.Visible = false
		script.Parent.Get.Visible = true
		script.Parent.Get.TextBox.Visible = false
		script.Parent.Get.Back.Visible = false
		for i = 1, 40 do
			local time = 40 - i
			script.Parent.Get.Text.Text = "Please Wait "..time.." seconds."
			wait(1)
		end
		script.Parent.Get.Text.Text = "Requesting, Please wait..."
		local key = RequestKey()
		if key == "Not Success!" then
			script.Parent.Get.Text.Text = "An Error has occured. Requesting Again..."
			key = RequestKey()
			if key == "Not Success!" then
				script.Parent.Get.Text.Text = "An Error has occured again. Requesting Again..."
				key = RequestKey()
				if key == "Not Success!" then
					script.Parent.Get.Text.Text = "Unable to get a key. Try again later."
					script.Parent.Get.Back.Visible = true
				else
					script.Parent.Get.Text.Text = "Success!"
					script.Parent.Get.TextBox.Text = key
					script.Parent.Get.TextBox.Visible = true
					script.Parent.Get.Back.Visible = true
				end
			else
				script.Parent.Get.Text.Text = "Success!"
				script.Parent.Get.TextBox.Text = key
				script.Parent.Get.TextBox.Visible = true
				script.Parent.Get.Back.Visible = true
			end
		else
			script.Parent.Get.Text.Text = "Success!"
			script.Parent.Get.TextBox.Text = key
			script.Parent.Get.TextBox.Visible = true
			script.Parent.Get.Back.Visible = true
		end
	end
	script.Parent.Frame.Get.MouseButton1Click:Connect(GetKey)
end

return module
