local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local wf = require 'libs.windfield'

require 'src.player'
require 'src.rotatingplanet'
require 'src.background'

local entities = {}
local planets = {}
local lastJumped = 0
local jumpLimit = 0.5 --how often can the player jump... lower numbers are faster

function love.load()
    math.randomseed(os.time())
    local major, minor, revision, codename = love.getVersion()
    print("running with LÖVE version: " .. major .. "." .. minor .. "." .. revision .. " " .. codename)

    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 0)

    background = Background:new()
    player = Player:new(700, 0, 0)

    planet1Image = love.graphics.newImage("image/planets/Baren.png")
    planet1 = RotatingPlanet:new(700, 300, 4, planet1Image, .1, 'Planet1')
    table.insert(planets, planet1)

    planet2Image = love.graphics.newImage("image/planets/Ice.png")
    planet2 = RotatingPlanet:new(400, 400, 3, planet2Image, .2, 'Planet2')
    table.insert(planets, planet2)

    planet3Image = love.graphics.newImage("image/planets/Lava.png")
    planet3 = RotatingPlanet:new(950, 200, 4, planet3Image, -.2, 'Planet3')
    table.insert(planets, planet3)

    planet4Image = love.graphics.newImage("image/planets/Terran.png")
    planet4 = RotatingPlanet:new(850, 600, 5, planet4Image, -.05, 'Planet4')
    table.insert(planets, planet4)
end

function love.draw()
    background:draw()
    for i in ipairs(entities) do
        love.graphics.setColor(1, 1, 1, 1)
        entities[i]:draw()
    end
    for i in ipairs(planets) do
        love.graphics.setColor(1, 1, 1, 1)
        planets[i]:draw()
    end
    player:draw()

    --world:draw()
end

function love.update(dt)
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

    if not player:getBox():enter(closestPlanet:getCollisionClass()) then
        player:applyLinearImpulse(vectorXTowardClosestPlanet, vectorYTowardClosestPlanet)
    else
        player:getBox():setLinearVelocity(0, 0)
        player:getBox():setAngularVelocity(0)
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
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

    --local xvel, yvel = player:getBox():getLinearVelocity()
    --player:getBox():setLinearVelocity(math.min(xvel, 20), math.min(yvel, 20))

    world:update(dt)
    background:update(dt)
    for i in ipairs(entities) do
        entities[i]:update(dt)
    end
    for i in ipairs(planets) do
        planets[i]:update(dt)
    end

    local angleTo = math.atan2(vectorYTowardClosestPlanet, vectorXTowardClosestPlanet)
    player:update(dt, angleTo)
end

function distanceBetweenEntities(entity1, entity2)
    return distanceFrom(entity1:getX(), entity1:getY(), entity2:getX(), entity2:getY())
end

function distanceFrom(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
