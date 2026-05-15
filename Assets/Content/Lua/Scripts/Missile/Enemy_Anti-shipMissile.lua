local trackedMissiles = {}--记录所有正在被引导的导弹。
local function isTargetMissile(item)
    if not item or item.Removed then return false end
    if not item.Prefab then return false end
    return item.Prefab.Identifier.Value == "antishipMissile_Enemy"
end
local function getRandomMainSubHull()
    if not Submarine.MainSub then return nil end

    local candidates = {}
    for hull in Hull.HullList do
        if hull
        and not hull.Removed
        and hull.Submarine == Submarine.MainSub then
            table.insert(candidates, hull)
        end
    end

    if #candidates <= 0 then return nil end
    return candidates[math.random(1, #candidates)]
end
local function getRandomPointInHull(hull)   
    if not hull then return nil end
    return hull.WorldPosition
end
local function registerMissile(item)
    if not isTargetMissile(item) then return end
    if trackedMissiles[item.ID] then return end

    local hull = getRandomMainSubHull()

    trackedMissiles[item.ID] = {
        item = item,
        targetHull = hull
    }
end
local function ensureMissileTarget(data)
    if not data then return end

    local hull = data.targetHull
    if hull == nil
    or hull.Removed
    or hull.Submarine ~= Submarine.MainSub then
        hull = getRandomMainSubHull()
        data.targetHull = hull
        data.targetPos = getRandomPointInHull(hull)
        return
    end

    if data.targetPos == nil then
        data.targetPos = getRandomPointInHull(hull)
    end
end

local function updateMissile(data, dt)
    local item = data.item
    if not item or item.Removed or not item.body then return false end

    ensureMissileTarget(data)
    if not data.targetPos then return true end

    local targetPos = data.targetHull.WorldPosition
    if not targetPos then return true end
    local currentPos = item.WorldPosition
    local toTarget = targetPos - currentPos
    local dist = toTarget.Length()

    if dist < 100 then
        if SERVER or not Game.IsMultiplayer then
            TLHF.GiveItem("antishipMissile_Enemy_Boom",item,true)
            Entity.Spawner.AddEntityToRemoveQueue(item)
        end
        return false
    end

    local dir = Vector2.Normalize(toTarget)
    item.body.LinearVelocity = dir * 25

    local desiredAngle = math.atan2(dir.Y, dir.X)
    local currentAngle = item.body.Rotation
    local angleDiff = desiredAngle - currentAngle

    while angleDiff > math.pi do
        angleDiff = angleDiff - 2 * math.pi
    end
    while angleDiff < -math.pi do
        angleDiff = angleDiff + 2 * math.pi
    end

    local rotationSpeed = 8
    item.body.AngularVelocity = angleDiff * rotationSpeed
    return true
end
Hook.Add("AntiShipHoming_Enemy.OnActive", "EnemyMissileRegister", function(effect, deltaTime, item, targets, worldPosition)
    registerMissile(item)
end)
Hook.Add("think", "EnemyMissileThink", function()
    for id, data in pairs(trackedMissiles) do
        local ok = updateMissile(data, 1 / 60)
        if not ok then
            trackedMissiles[id] = nil
        end
    end
end)