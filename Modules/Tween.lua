local TweenAPI = {}

local function IsValid(Object)
	return typeof(Object) == "Instance" and Object.Parent ~= nil
end

local function GetEase(EasingStyle)
	local Easings = (_G.EasingAPI and _G.EasingAPI.Functions) or {}

	if _G.EasingAPI and _G.EasingAPI.Get then
		return _G.EasingAPI.Get(EasingStyle)
	end

	return Easings[EasingStyle] or function(T)
		return T
	end
end

function TweenAPI:Create(Object, Speed, Target, EasingStyle)
	local Tween = {}

	Tween.Object = Object
	Tween.Speed = Speed or 10
	Tween.Target = Target
	Tween.EasingFunc = GetEase(EasingStyle or "Linear")

	Tween.Active = false
	Tween.Paused = false
	Tween.Completed = nil

	Tween.Id = "TweenAPI_" .. tostring(math.random(1000000, 9999999))

	Tween.Elapsed = 0
	Tween.TotalTime = 0
	Tween.LastTime = 0

	function Tween:Play()
		if not IsValid(self.Object) or not IsValid(self.Target) then return end
		if self.Active then return end

		self.Active = true
		self.Paused = false
		self.Elapsed = 0
		self.LastTime = os.clock()

		local StartX = self.Object.Position.X
		local StartY = self.Object.Position.Y
		local StartZ = self.Object.Position.Z

		local GoalX = self.Target.Position.X
		local GoalY = self.Target.Position.Y
		local GoalZ = self.Target.Position.Z

		local DeltaX = GoalX - StartX
		local DeltaY = GoalY - StartY
		local DeltaZ = GoalZ - StartZ

		local Distance = math.sqrt(DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ)
		self.TotalTime = Distance / self.Speed

		task.spawn(function()
			while self.Active and IsValid(self.Object) do
				if self.Paused then
					task.wait(0.1)
					self.LastTime = os.clock()
					continue
				end

				local Now = os.clock()
				local Dt = Now - self.LastTime
				self.LastTime = Now

				self.Elapsed += Dt

				local Alpha = 0
				if self.TotalTime > 0 then
					Alpha = math.min(self.Elapsed / self.TotalTime, 1)
				else
					Alpha = 1
				end

				local Eased = self.EasingFunc(Alpha)

				local NewX = StartX + (DeltaX * Eased)
				local NewY = StartY + (DeltaY * Eased)
				local NewZ = StartZ + (DeltaZ * Eased)

				self.Object.Position = Vector3.new(NewX, NewY, NewZ)

				if Alpha >= 1 then
					self.Active = false
					if self.Completed then
						self.Completed()
					end
					break
				end

				task.wait()
			end
		end)
	end

	function Tween:Pause()
		self.Paused = true
	end

	function Tween:Cancel()
		self.Active = false
	end

	return Tween
end

return TweenAPI
