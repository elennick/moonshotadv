local wf = require 'libs.windfield'
local json = require 'libs.json'

require 'src.player'
require 'src.rotatingplanet'
require 'src.turret'
require 'src.background'
require 'src.bullet'
require 'src.missile'
require 'src.wall'

local lastJumped = 0
local jumpLimit = 0.5 --how often can the player jump... lower numbers are faster
local bulletLifetime = 10 --how long a bullet lives before being destroyed (if it doesnt collide with something first)
local missileLifetime = 20

local currentLevelName = nil
local currentLevel = 1
local levels = nil
local turrets = {}
local planets = {}
local walls = {}
bullets = {}
missiles = {}

function love.load()
    math.randomseed(os.time())
    local major, minor, revision, codename = love.getVersion()
    print("running with LÖVE version: " .. major .. "." .. minor .. "." .. revision .. " " .. codename)

    local levelsJson = readFile("./levels/levels.json")
    levels = json.decode(levelsJson)

    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 0)

    world:addCollisionClass('Bullet', { ignores = { 'Bullet' } })
    world:addCollisionClass('Missile', { ignores = { 'Bullet', 'Missile' } })
    world:addCollisionClass('Planet')
    world:addCollisionClass('Player')
    world:addCollisionClass('Wall')

    background = Background:new()
    loadLevel(currentLevel)

    local music = love.audio.newSource("audio/music/manystars.ogg", 'static')
    music:setLooping(true)
    music:play()
end

function love.draw()
    background:draw()
    for i in ipairs(turrets) do
        love.graphics.setColor(1, 1, 1, 1)
        turrets[i]:draw()
    end
    for i in ipairs(planets) do
        love.graphics.setColor(1, 1, 1, 1)
        planets[i]:draw()
    end
    for i in ipairs(bullets) do
        love.graphics.setColor(1, 1, 1, 1)
        bullets[i]:draw()
    end
    for i in ipairs(missiles) do
        love.graphics.setColor(1, 1, 1, 1)
        missiles[i]:draw()
    end
    for i in ipairs(walls) do
        love.graphics.setColor(1, 1, 1, 1)
        walls[i]:draw()
    end
    player:draw()
    --world:draw()

    local levelText = "Level " .. currentLevel .. " - " .. currentLevelName
    love.graphics.print(levelText, love.graphics.getFont(), 25, 675, 0, 2, 2)
end

function love.update(dt)
    --figure out what the closest planet is
    if table.getn(planets) > 0 then
        closestPlanet = planets[1]
        for i in ipairs(planets) do
            local distanceBetweenPlayerAndCurrentClosest = distanceBetweenEntities(player, closestPlanet)
            local distanceBetweenPlayerAndThisPlanet = distanceBetweenEntities(player, planets[i])
            if distanceBetweenPlayerAndCurrentClosest > distanceBetweenPlayerAndThisPlanet then
                closestPlanet = planets[i]
            end
        end
    end

    vectorXTowardClosestPlanet = closestPlanet:getX() - player:getX();
    vectorYTowardClosestPlanet = closestPlanet:getY() - player:getY();

    --apply gravity towards the closest planet
    if not player:getBox():enter('Planet') then
        player:applyLinearImpulse(vectorXTowardClosestPlanet, vectorYTowardClosestPlanet)
    else
        player:getBox():setLinearVelocity(0, 0)
        player:getBox():setAngularVelocity(0)
        if closestPlanet:getType() == 'moon' then
            currentLevel = currentLevel + 1
            loadLevel(currentLevel)
            return
        end
    end

    if player:getBox():enter('Bullet') or player:getBox():enter('Missile') then
        restartLevel()
    end

    --handle input
    if love.keyboard.isDown("escape") then
        love.event.quit() --remove this before finalizing, create a real menu with an exit option
    end

    lastJumped = lastJumped + dt
    if love.keyboard.isDown("up") and lastJumped > jumpLimit then
        --TODO make jump distance independent of planet size
        player:getBox():setLinearVelocity(-vectorXTowardClosestPlanet * 8, -vectorYTowardClosestPlanet * 8)
        lastJumped = 0
    end

    isMovingLeft = false
    isMovingRight = false
    if love.keyboard.isDown("right") and lastJumped > jumpLimit then
        --clockwise
        isMovingRight = true
        player:getBox():applyLinearImpulse(vectorYTowardClosestPlanet / 2, -vectorXTowardClosestPlanet / 2)
    end
    if love.keyboard.isDown("left") and lastJumped > jumpLimit then
        --counterclockwise
        isMovingLeft = true
        player:getBox():applyLinearImpulse(-vectorYTowardClosestPlanet / 2, vectorXTowardClosestPlanet / 2)
    end

    --update all entities in the world
    world:update(dt)
    background:update(dt)

    for i in ipairs(turrets) do
        turrets[i]:update(dt)
    end

    for i in ipairs(planets) do
        planets[i]:update(dt)
    end

    for i in ipairs(walls) do
        walls[i]:update(dt)
    end

    for i, bullet in ipairs(bullets) do
        if bullet:getBox():enter('Planet') or bullet:getTimeAlive() > bulletLifetime then
            bullet:destroy(i)
        else
            bullet:update(dt)
        end
    end
    for i, missile in ipairs(missiles) do
        if missile:getBox():enter('Planet') or missile:getTimeAlive() > missileLifetime then
            missile:destroy(i)
        else
            missile:update(dt)
        end
    end

    --angle the player feet-down towards the closest planet
    local angleTo = math.atan2(vectorYTowardClosestPlanet, vectorXTowardClosestPlanet)
    player:update(dt, angleTo)
end

function distanceBetweenEntities(entity1, entity2)
    return distanceFrom(entity1:getX(), entity1:getY(), entity2:getX(), entity2:getY())
end

function distanceFrom(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function readFile(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function clearLevel()
    for i in ipairs(planets) do
        planets[i]:getBox():destroy()
    end
    for i in ipairs(bullets) do
        bullets[i]:getBox():destroy()
    end
    for i in ipairs(missiles) do
        missiles[i]:getBox():destroy()
    end
    for i in ipairs(walls) do
        walls[i]:getBox():destroy()
    end

    planets = {}
    turrets = {}
    walls = {}
    bullets = {}
    missiles = {}
    player = nil
end

function restartLevel()
    loadLevel(currentLevel)
end

function loadLevel(level)
    clearLevel()

    local levelToLoad = levels[level]

    local playerToLoad = levelToLoad.entities.player
    player = Player:new(playerToLoad.startPosition.x, playerToLoad.startPosition.y)

    local planetsToLoad = levelToLoad.entities.planets
    for i in ipairs(planetsToLoad) do
        table.insert(planets, RotatingPlanet:new({ x = planetsToLoad[i].position.x,
                                                   y = planetsToLoad[i].position.y,
                                                   size = planetsToLoad[i].size,
                                                   type = planetsToLoad[i].type }))
    end

    local turretsToLoad = levelToLoad.entities.turrets
    if turretsToLoad ~= nil then
        for i in ipairs(turretsToLoad) do
            table.insert(turrets, Turret:new({ x = turretsToLoad[i].position.x,
                                               y = turretsToLoad[i].position.y,
                                               type = turretsToLoad[i].type,
                                               startAngle = turretsToLoad[i].startAngle,
                                               firingSpeed = turretsToLoad[i].firingSpeed,
                                               projectileSpeed = turretsToLoad[i].projectileSpeed,
                                               shouldTrackPlayer = turretsToLoad[i].tracksPlayer }))
        end
    end

    local wallsToLoad = levelToLoad.entities.walls
    if wallsToLoad ~= nil then
        for i in ipairs(wallsToLoad) do
            table.insert(walls, Wall:new({ x = wallsToLoad[i].position.x,
                                           y = wallsToLoad[i].position.y,
                                           w = wallsToLoad[i].size.w,
                                           h = wallsToLoad[i].size.h }))
        end
    end

    currentLevelName = levelToLoad.name
end
