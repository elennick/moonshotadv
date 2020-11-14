local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local wf = require 'libs.windfield'

require 'src.player'
require 'src.rotatingplanet'
require 'src.turret'
require 'src.background'
require 'src.bullet'

local turrets = {}
local planets = {}
local lastJumped = 0
local jumpLimit = 0.5 --how often can the player jump... lower numbers are faster
local bulletLifetime = 10 --how long a bullet lives before being destroyed (if it doesnt collide with something first)
bullets = {}

function love.load()
    math.randomseed(os.time())
    local major, minor, revision, codename = love.getVersion()
    print("running with LÖVE version: " .. major .. "." .. minor .. "." .. revision .. " " .. codename)

    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 0)

    world:addCollisionClass('Planet')
    world:addCollisionClass('Bullet')
    world:addCollisionClass('Player')

    background = Background:new()
    player = Player:new(700, 0, 0)

    table.insert(planets, RotatingPlanet:new({ x = 700, y = 375, size = 4, image = love.graphics.newImage("image/planets/Baren.png"), rotationSpeed = .1 }))
    table.insert(planets, RotatingPlanet:new({ x = 550, y = 600, size = 3, image = love.graphics.newImage("image/planets/Ice.png"), rotationSpeed = .2 }))
    table.insert(planets, RotatingPlanet:new({ x = 300, y = 425, size = 4, image = love.graphics.newImage("image/planets/Lava.png"), rotationSpeed = -.1 }))
    table.insert(planets, RotatingPlanet:new({ x = 450, y = 200, size = 3, image = love.graphics.newImage("image/planets/Terran.png"), rotationSpeed = -.15 }))
    table.insert(planets, RotatingPlanet:new({ x = 850, y = 150, size = 4, image = love.graphics.newImage("image/planets/CO-MechPlanet.png"), rotationSpeed = .15 }))

    table.insert(turrets, Turret:new({ x = 50, y = 50, firingSpeed = 2, bulletSpeed = 5 }))
    table.insert(turrets, Turret:new({ x = 1200, y = 650, firingSpeed = 3, bulletSpeed = 8 }))
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
    player:draw()
    --world:draw()
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
    end

    --handle input
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

    --update all entities in the world
    world:update(dt)
    background:update(dt)

    for i in ipairs(turrets) do
        turrets[i]:update(dt)
    end

    for i in ipairs(planets) do
        planets[i]:update(dt)
    end

    for i in ipairs(bullets) do
        bullets[i]:update(dt)
        if bullets[i]:getBox():enter('Planet') then
            print 'collision'
            bullets[i]:destroy(i)
            break
        end
        if bullets[i]:getTimeAlive() > bulletLifetime then
            print 'bullet deleted'
            bullets[i]:destroy(i)
            break
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
