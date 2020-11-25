local wf = require 'libs.windfield'
local json = require 'libs.json'

require 'src.player'
require 'src.rotatingplanet'
require 'src.turret'
require 'src.background'
require 'src.bullet'
require 'src.missile'
require 'src.explosion'
require 'src.wall'
require 'src.lasergate'

local lastJumped = 0
local jumpLimit = 0.5 --how often can the player jump... lower numbers are faster
local bulletLifetime = 10 --how long a bullet lives before being destroyed (if it doesnt collide with something first)
local missileLifetime = 20
local paused = false
local debug = false --make sure this is false for real deployment

local currentLevelName = nil
local currentLevel = 12
local levels = nil
local entities = {}
local planets = {}
bullets = {}
missiles = {}
explosions = {}
player = nil

function love.load()
    love.math.setRandomSeed(love.timer.getTime())
    local major, minor, revision, codename = love.getVersion()
    print("running with LÖVE version: " .. major .. "." .. minor .. "." .. revision .. " " .. codename)

    local levelsJson = readFile("./levels/levels.json")
    levels = json.decode(levelsJson)

    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 0)

    world:addCollisionClass('Missile', { ignores = { 'Missile' } })
    world:addCollisionClass('Bullet', { ignores = { 'Bullet', 'Missile' } })
    world:addCollisionClass('Planet')
    world:addCollisionClass('Player')
    world:addCollisionClass('Wall')
    world:addCollisionClass('Laser')

    mainFont = love.graphics.newFont("image/font/Amuro.otf", 12)
    love.graphics.setFont(mainFont)

    titleImage = love.graphics.newImage("image/title.png")
    woodenControlsImage = love.graphics.newImage("image/WoodenControls.png")
    rightArrowQuad = love.graphics.newQuad(137, 0, 12, 15, woodenControlsImage:getWidth(), woodenControlsImage:getHeight())
    leftArrowQuad = love.graphics.newQuad(120, 0, 12, 15, woodenControlsImage:getWidth(), woodenControlsImage:getHeight())
    upArrowQuad = love.graphics.newQuad(150, 0, 15, 15, woodenControlsImage:getWidth(), woodenControlsImage:getHeight())
    escQuad = love.graphics.newQuad(180, 60, 35, 16, woodenControlsImage:getWidth(), woodenControlsImage:getHeight())

    loadAudio()
    background = Background:new()
    loadLevel(currentLevel)
end

function love.draw()
    background:draw()

    love.graphics.setColor(1, 1, 1, 1)
    if currentLevel == 1 then
        love.graphics.draw(titleImage, 640, 150, 0, 1, 1, titleImage:getWidth() / 2, titleImage:getHeight() / 2)
        love.graphics.draw(woodenControlsImage, rightArrowQuad, 50, 569, 0, 2, 2)
        love.graphics.draw(woodenControlsImage, leftArrowQuad, 50, 599, 0, 2, 2)
        love.graphics.draw(woodenControlsImage, upArrowQuad, 50, 629, 0, 2, 2)
        love.graphics.draw(woodenControlsImage, escQuad, 45, 672, 0, 1, 1)
        --todo show control icons instead of just text
        love.graphics.print("     - Move clockwise", 50, 574, 0, 1.5)
        love.graphics.print("     - Move counterclockwise", 50, 604, 0, 1.5)
        love.graphics.print("     - Jump", 50, 637, 0, 1.5)
        love.graphics.print("     - Pause", 50, 667, 0, 1.5)
    else
        local levelText = "Level " .. currentLevel .. " - " .. currentLevelName
        love.graphics.print(levelText, love.graphics.getFont(), 25, 675, 0, 2, 2)
    end

    for i in ipairs(entities) do
        love.graphics.setColor(1, 1, 1, 1)
        entities[i]:draw()
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
    for i in ipairs(explosions) do
        love.graphics.setColor(1, 1, 1, 1)
        explosions[i]:draw()
    end

    player:draw()
    --world:draw()

    --if the game is paused, show the pause menu over everything
    if paused then
        drawPausePopup()
    end
end

function love.keypressed(key, scancode, isrepeat)
    --if the game is already paused and someone presses Q then quit
    --if paused and key == "q" then
    --    love.event.quit()
    --end

    --if escape is pressed, toggle the pause state
    if key == "escape" then
        paused = not paused
    end
end

function love.update(dt)
    --if game is paused then don't update anything's state
    if paused then
        return
    end

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
    lastJumped = lastJumped + dt
    if (love.keyboard.isDown("up") or love.keyboard.isDown("space")) and lastJumped > jumpLimit then
        --TODO make jump distance independent of planet size
        jumpSound:clone():play()
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

    for i in ipairs(entities) do
        entities[i]:update(dt)
    end

    for i in ipairs(planets) do
        planets[i]:update(dt)
    end

    for i, bullet in ipairs(bullets) do
        if bullet:getBox():enter('Planet') or bullet:getTimeAlive() > bulletLifetime then
            local explosion = Explosion:new(bullet:getX(), bullet:getY(), .5, 1, false)
            table.insert(explosions, explosion)
            bullet:destroy(i)
        else
            bullet:update(dt)
        end
    end
    for i, missile in ipairs(missiles) do
        if missile:getBox():enter('Planet')
                or missile:getBox():enter('Wall')
                or missile:getBox():enter('Bullet')
                or missile:getBox():enter('Laser')
                or missile:getTimeAlive() > missileLifetime then
            local explosion = Explosion:new(missile:getX(), missile:getY(), 1, 2.5, true)
            table.insert(explosions, explosion)
            missile:destroy(i)
        else
            missile:update(dt)
        end
    end
    for i, explosion in ipairs(explosions) do
        if explosion:getTimeAlive() > explosion:getLifetime() then
            table.remove(explosions, i)
        else
            explosion:update(dt)
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
    for i in ipairs(entities) do
        entities[i]:destroy()
    end
    for i in ipairs(planets) do
        planets[i]:getBox():destroy()
    end
    for i in ipairs(bullets) do
        bullets[i]:getBox():destroy()
    end
    for i in ipairs(missiles) do
        missiles[i]:getBox():destroy()
    end
    if player ~= nil then
        player:destroy()
    end

    entities = {}
    planets = {}
    bullets = {}
    missiles = {}
    explosions = {}
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
            table.insert(entities, Turret:new({ x = turretsToLoad[i].position.x,
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
            table.insert(entities, Wall:new({ x = wallsToLoad[i].position.x,
                                              y = wallsToLoad[i].position.y,
                                              w = wallsToLoad[i].size.w,
                                              h = wallsToLoad[i].size.h }))
        end
    end

    local laserGatesToLoad = levelToLoad.entities.laserGates
    if laserGatesToLoad ~= nil then
        for i in ipairs(laserGatesToLoad) do
            table.insert(entities, LaserGate:new({ x = laserGatesToLoad[i].position.x,
                                                   y = laserGatesToLoad[i].position.y,
                                                   direction = laserGatesToLoad[i].direction,
                                                   length = laserGatesToLoad[i].length,
                                                   switchRate = laserGatesToLoad[i].switchRate }))
        end
    end

    currentLevelName = levelToLoad.name
end

function drawPausePopup()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', 540, 270, 200, 100, 5, 5)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 545, 275, 190, 90, 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("** PAUSED **", 564, 305, 0, 1.5)
    --love.graphics.print("Q - Quit", 608, 335, 0, 1.5)
end

function loadAudio()
    jumpSound = love.audio.newSource("audio/jump.wav", "static")
    jumpSound:setVolume(0.25)

    explSound = love.audio.newSource("audio/explosion.mp3", "static")
    explSound:setVolume(0.3)

    laserSound = love.audio.newSource("audio/laserbuzz.wav", "static")
    laserSound:setVolume(0.5)

    missileSound = love.audio.newSource("audio/missile.wav", "static")
    missileSound:setVolume(0.2)

    gunSound = love.audio.newSource("audio/gunshot.wav", "static")
    gunSound:setVolume(0.1)

    local music = love.audio.newSource("audio/music/manystars.ogg", 'static')
    music:setLooping(true)
    music:play()

    if debug then
        love.audio.setVolume(0)
    end
end
