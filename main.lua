local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local wf = require 'libs.windfield'

require 'src.player'
require 'src.animatedplanet'
require 'src.rotatingplanet'
require 'src.background'

local entities = {}
local planets = {}
local lastJumped = 0

function love.load()
    math.randomseed(os.time())
    local major, minor, revision, codename = love.getVersion()
    print("running with LÖVE version: " .. major .. "." .. minor .. "." .. revision .. " " .. codename)

    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 0)

    background = Background:new()

    player = Player:new(700, 0)
    table.insert(entities, player)

    planet1Image = love.graphics.newImage("image/planets/Baren.png")
    planet1 = RotatingPlanet:new(700, 300, 4, planet1Image, .001, 'Planet1')
    table.insert(planets, planet1)

    planet2Image = love.graphics.newImage("image/planets/Baren.png")
    planet2 = RotatingPlanet:new(400, 400, 4, planet2Image, -.0002, 'Planet2')
    table.insert(planets, planet2)

    planet3Image = love.graphics.newImage("image/planets/Baren.png")
    planet3 = RotatingPlanet:new(900, 200, 4, planet3Image, -.0002, 'Planet3')
    table.insert(planets, planet3)
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

    world:draw()
end

--todo figure out how to get consistent framerate / tick rate
function love.update(dt)
    world:update(dt)
    background:update(dt)
    for i in ipairs(entities) do
        entities[i]:update(dt)
    end
    for i in ipairs(planets) do
        planets[i]:update(dt)
    end

    if table.getn(planets) > 0 then
        closestPlanet = planets[1]
        for i in ipairs(planets) do
            --print('checking player  ' .. player:getCoords())
            --print('checking cplanet ' .. closestPlanet:getCoords())
            --print('checking iplanet ' .. planets[i]:getCoords())
            local distanceBetweenPlayerAndCurrentClosest = distanceBetweenEntities(player, closestPlanet)
            local distanceBetweenPlayerAndThisPlanet = distanceBetweenEntities(player, planets[i])
            if distanceBetweenPlayerAndCurrentClosest > distanceBetweenPlayerAndThisPlanet then
                closestPlanet = planets[i]
            end
        end
    end

    vectorX = closestPlanet:getX() - player:getX();
    vectorY = closestPlanet:getY() - player:getY();

    if not player:getBox():enter(closestPlanet:getCollisionClass()) then
        print 'not colliding'

        player:applyLinearImpulse(vectorX, vectorY)
    else
        print 'colliding'

        player:getBox():setLinearVelocity(0, 0)
        player:getBox():setAngularVelocity(0)
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    lastJumped = lastJumped + 1
    if love.keyboard.isDown("up") and lastJumped > 25 then
        player:getBox():setLinearVelocity(-vectorX * 8, -vectorY * 8)
        lastJumped = 0
    end

    isMoving = false
    if love.keyboard.isDown("right") and lastJumped > 25 then
        --clockwise
        isMoving = true
        player:getBox():applyLinearImpulse(vectorY / 2, -vectorX / 2)
    end
    if love.keyboard.isDown("left") and lastJumped > 25 then
        --counterclockwise
        isMoving = true
        player:getBox():applyLinearImpulse(-vectorY / 2, vectorX / 2)
    end

    --local xvel, yvel = player:getBox():getLinearVelocity()
    --player:getBox():setLinearVelocity(math.min(xvel, 20), math.min(yvel, 20))
end

function distanceBetweenEntities(entity1, entity2)
    return distanceFrom(entity1:getX(), entity1:getY(), entity2:getX(), entity2:getY())
end

function distanceFrom(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
