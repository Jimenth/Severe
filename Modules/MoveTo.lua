local Offsets = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/Severe/refs/heads/main/Modules/Offsets.lua"))()

Instance.declare({ class = "Humanoid", name = "MoveTo", callback = {
    method = function(self, Position, Yield)
        local HumanoidRootPart = self.Parent:FindFirstChild("HumanoidRootPart")
        local Finished = false

        local function Main()
            while true do
                local Current = HumanoidRootPart.Position
                if math.abs(Current.X - Position.X) <= 1 and math.abs(Current.Z - Position.Z) <= 1 then
                    break
                end
                memory.writevector(self, Offsets.Humanoid.MoveToPoint, Position)
                memory.writeu8(self, Offsets.Humanoid.IsWalking, 1)
                task.wait()
            end
            Finished = true
        end

        task.spawn(Main)

        if Yield then
            while not Finished do
                task.wait()
            end
        end
    end,
}})
