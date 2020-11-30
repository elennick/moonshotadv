local wf = require 'libs.windfield'
local json = require 'libs.json'
local cpml = require 'libs.cpml'

require 'src.player'
require 'src.rotatingplanet'
require 'src.turret'
require 'src.background'
require 'src.bullet'
require 'src.missile'
require 'src.explosion'
require 'src.wall'
require 'src.lasergate'
require 'src.key'
require 'src.lockedgate'

local lastJumped = 0
local jumpLimit = 0.5 --how often can the player jump... lower numbers are faster
local bulletLifetime = 10 --how long a bullet lives before being destroyed (if it doesnt collide with something first)
local missileLifetime = 20
local gravityMultiplier = 30
local jumpMultiplier = 6
local walkMultiplier = 1.8

local paused = false
local debug = true --make sure this is false for real deployment
local music = true --make sure this is true for real deployment

local currentLevelName = nil
local currentLevel = 1
local levels = nil
local planets = {}
local levelStartTime = nil
local timeSinceLevelStart = 0
local lastPlanetTouched = nil
local jumpState = 'jumped'
entities = {}
bullets = {}
missiles = {}
explosions = {}
keys = {}
lockedGates = {}
player = nil

function love.load()
    love.math.setRandomSeed(love.timer.getTime())
    local major, minor, revision, codename = love.getVersion()
    print("running with LÖVE version: " .. major .. "." .. minor .. "." .. revision .. " " .. codename)

    levels = json.decode(readFile("./levels/levels.json"))

    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 0)

    world:addCollisionClass('Missile', { ignores = { 'Missile' } })
    world:addCollisionClass('Bullet', { ignores = { 'Bullet', 'Missile' } })
    world:addCollisionClass('Planet')
    world:addCollisionClass('Player')
    world:addCollisionClass('Wall')
    world:addCollisionClass('Laser')
    world:addCollisionClass('LockedGate')
    world:addCollisionClass('Meteor', { ignores = { 'All' } })
    world:addCollisionClass('Key', { ignores = { 'Bullet', 'Missile' } })

    mainFont = love.graphics.newFont("image/font/Amuro.otf", 12)
    love.graphics.setFont(mainFont)

    titleImage = love.graphics.newImage("image/title.png")
    woodenControlsImage = love.graphics.newImage("image/WoodenControls.png")
    rightArrowQuad = love.graphics.newQuad(137, 0, 12, 15, woodenControlsImage:getWidth(), woodenControlsImage:getHeight())
    leftArrowQuad = love.graphics.newQuad(120, 0, 12, 15, woodenControlsImage:getWidth(), woodenControlsImage:getHeight())
    upArrowQuad = love.graphics.newQuad(150, 0, 15, 15, woodenControlsImage:getWidth(), woodenControlsImage:getHeight())
    escQuad = love.graphics.newQuad(180, 60, 35, 16, woodenControlsImage:getWidth(), woodenControlsImage:getHeight())

    initAudio()
    background = Background:new()
    loadLevel(currentLevel)
end

function love.draw()
    background:draw()

    love.graphics.setColor(1, 1, 1, 1)
    for i in ipairs(entities) do
        entities[i]:draw()
    end
    for i in ipairs(planets) do
        planets[i]:draw()
    end
    for i in ipairs(bullets) do
        bullets[i]:draw()
    end
    for i in ipairs(missiles) do
        missiles[i]:draw()
    end
    for i in ipairs(explosions) do
        explosions[i]:draw()
    end
    for i in ipairs(keys) do
        keys[i]:draw()
    end
    for i in ipairs(lockedGates) do
        lockedGates[i]:draw()
    end

    player:draw()
    if debug then
        world:draw()
    end

    love.graphics.setColor(1, 1, 1, 1)
    if currentLevel == 1 and not debug then
        love.graphics.draw(titleImage, 640, 150, 0, 1, 1, titleImage:getWidth() / 2, titleImage:getHeight() / 2)
        drawControls(50, 569)
    elseif isLastLevel() then
        love.graphics.draw(titleImage, 640, 150, 0, 1, 1, titleImage:getWidth() / 2, titleImage:getHeight() / 2)
        love.graphics.print("YOU GOT TO THE MOON!!!", love.graphics.getFont(), 25, 675, 0, 2, 2)
        love.graphics.print("Thanks for playing!", love.graphics.getFont(), 975, 675, 0, 2, 2)
    else
        local levelText = "Level " .. currentLevel .. " - " .. currentLevelName
        love.graphics.print(levelText, love.graphics.getFont(), 25, 675, 0, 2, 2)
        local timeString = string.format("Time: %.2f", timeSinceLevelStart)
        love.graphics.print(timeString, 25, 25, 0, 2, 2)
    end

    if player:getNumOfKeysInInventory() > 0 then
        love.graphics.print("Keys: " .. player:getNumOfKeysInInventory(), 1150, 30, 0, 2, 2)
    end

    if paused then
        drawPausePopup()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "r" and paused and debug then
        restartLevel()
    end

    if key == "q" and paused and debug then
        love.event.quit()
    end

    if key == "v" and paused and debug then
        love.audio.setVolume(0)
    end

    if key == "n" and paused and debug then
        loadNextLevel()
    end

    if key == "l" and paused and debug then
        if pcall(function()
            local textFromClipoboard = tostring(love.system.getClipboardText())
            local jsonFromClipboard = json.decode(textFromClipoboard)
            levels = jsonFromClipboard
            clearLevel()
            loadLevel(1)
        end) then
            print("loaded level from clipboard")
        else
            print("error loading level from clipboard")
        end
    end

    if (key == "up" or key == "space") and lastJumped > jumpLimit and timeSinceLevelStart > .2 then
        local closestPlanet = getClosestPlanet()
        local normalizedVectorTowardsClosestPlanet = getNormalizedVectorTowardsPlanet(closestPlanet)
        player:getBox():setLinearVelocity(
                -normalizedVectorTowardsClosestPlanet.x * jumpMultiplier,
                -normalizedVectorTowardsClosestPlanet.y * jumpMultiplier)

        jumpSound:clone():play()
        lastJumped = 0
        jumpState = 'jumped'
    end

    if key == "escape" then
        paused = not paused
    end
end

function love.update(dt)
    timeSinceLevelStart = love.timer.getTime() - levelStartTime
    lastJumped = lastJumped + dt

    --if game is paused then don't update anything's state
    if paused then
        return
    end

    local closestPlanet = getClosestPlanet()
    local normalizedVectorTowardsClosestPlanet = getNormalizedVectorTowardsPlanet(closestPlanet)

    --apply gravity towards the closest planet
    if not player:getBox():enter('Planet') then
        player:getBox():applyForce(
                normalizedVectorTowardsClosestPlanet.x * gravityMultiplier,
                normalizedVectorTowardsClosestPlanet.y * gravityMultiplier)
    else
        if lastJumped > .1 and lastPlanetTouched ~= closestPlanet then
            player:getBox():setLinearVelocity(0, 0)
            player:getBox():setAngularVelocity(0)
        end
        if closestPlanet:getType() == 'moon' and not isLastLevel() then
            successSound:clone():play()
            loadNextLevel()
            return
        end
        lastPlanetTouched = closestPlanet
        jumpState = 'landed'
    end

    if player:getBox():enter('Bullet') or player:getBox():enter('Missile') then
        deathSound:clone():play()
        restartLevel()
    end

    --handle left/right input
    isMovingLeft = false
    isMovingRight = false
    if love.keyboard.isDown("right") and lastJumped > jumpLimit and jumpState == 'landed' then
        --clockwise
        isMovingRight = true
        player:getBox():setLinearVelocity(
                normalizedVectorTowardsClosestPlanet.y * walkMultiplier,
                -normalizedVectorTowardsClosestPlanet.x * walkMultiplier)
    end
    if love.keyboard.isDown("left") and lastJumped > jumpLimit and jumpState == 'landed' then
        --counterclockwise
        isMovingLeft = true
        --local velx, vely = player:getBox():getLinearVelocity()
        --player:getBox():setLinearVelocity(math.min(velx, 80), math.min(vely, 80))
        player:getBox():setLinearVelocity(
                -normalizedVectorTowardsClosestPlanet.y * walkMultiplier,
                normalizedVectorTowardsClosestPlanet.x * walkMultiplier)
    end

    --update all entities in the world
    world:update(dt)
    background:update(dt)

    for i in ipairs(entities) do
        entities[i]:update(dt)
    end

    for i in ipairs(keys) do
        keys[i]:update(dt)
    end

    for i in ipairs(lockedGates) do
        lockedGates[i]:update(dt)
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
    local angleTo = math.atan2(normalizedVectorTowardsClosestPlanet.y, normalizedVectorTowardsClosestPlanet.x)
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
    for i in ipairs(keys) do
        keys[i]:getBox():destroy()
    end
    for i in ipairs(lockedGates) do
        lockedGates[i]:getBox():destroy()
    end
    if player ~= nil then
        player:destroy()
    end

    entities = {}
    planets = {}
    bullets = {}
    missiles = {}
    explosions = {}
    keys = {}
    lockedGates = {}
    player = nil
end

function restartLevel()
    loadLevel(currentLevel)
    if paused then
        paused = false
    end
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

    local keysToLoad = levelToLoad.entities.keys
    if keysToLoad ~= nil then
        for i in ipairs(keysToLoad) do
            table.insert(keys, Key:new({ x = keysToLoad[i].position.x,
                                         y = keysToLoad[i].position.y }))
        end
    end

    local lockedGatesToLoad = levelToLoad.entities.lockedGates
    if lockedGatesToLoad ~= nil then
        for i in ipairs(lockedGatesToLoad) do
            table.insert(lockedGates, LockedGate:new({ x = lockedGatesToLoad[i].position.x,
                                                       y = lockedGatesToLoad[i].position.y,
                                                       direction = lockedGatesToLoad[i].direction }))
        end
    end

    currentLevelName = levelToLoad.name
    levelStartTime = love.timer.getTime()
    if isLastLevel() then
        background:setMeteorsEnabled(true)
    end
end

function initAudio()
    jumpSound = love.audio.newSource("audio/jump.wav", "static")
    jumpSound:setVolume(0.25)

    explSound = love.audio.newSource("audio/explosion.mp3", "static")
    explSound:setVolume(0.3)

    laserSound = love.audio.newSource("audio/laserbuzz.wav", "static")
    laserSound:setVolume(0.3)

    missileSound = love.audio.newSource("audio/missile.wav", "static")
    missileSound:setVolume(0.2)

    gunSound = love.audio.newSource("audio/gunshot.wav", "static")
    gunSound:setVolume(0.1)

    keyPickupSound = love.audio.newSource("audio/keypickup.ogg", "static")
    keyPickupSound:setVolume(1.0)

    unlockSound = love.audio.newSource("audio/unlock.wav", "static")
    unlockSound:setVolume(1.0)

    successSound = love.audio.newSource("audio/success.wav", "static")
    successSound:setVolume(1.0)

    deathSound = love.audio.newSource("audio/death.wav", "static")
    deathSound:setVolume(1.0)

    local musicSound = love.audio.newSource("audio/music/manystars.ogg", 'static')
    musicSound:setLooping(true)
    musicSound:setVolume(1.3)

    if music then
        musicSound:play()
    end
end

function drawControls(x, y)
    love.graphics.draw(woodenControlsImage, rightArrowQuad, x, y, 0, 2, 2)
    love.graphics.draw(woodenControlsImage, leftArrowQuad, x, y + 30, 0, 2, 2)
    love.graphics.draw(woodenControlsImage, upArrowQuad, x, y + 60, 0, 2, 2)
    love.graphics.draw(woodenControlsImage, escQuad, x - 5, y + 103, 0, 1, 1)
    love.graphics.print("     - Move clockwise", x, y + 5, 0, 1.5)
    love.graphics.print("     - Move counterclockwise", x, y + 35, 0, 1.5)
    love.graphics.print("     - Jump", x, y + 68, 0, 1.5)
    love.graphics.print("     - Pause", x, y + 98, 0, 1.5)
end

function drawPausePopup()
    local topLeftX = 440
    local topLeftY = 260
    local width = 375
    local height = 240
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', topLeftX, topLeftY, width, height, 5, 5)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', topLeftX + 5, topLeftY + 5, width - 10, height - 10, 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("PAUSED", topLeftX + 142, topLeftY + 30, 0, 1.5)
    drawControls(topLeftX + 30, topLeftY + 80)
end

function isLastLevel()
    return table.getn(levels) == currentLevel
end

function loadNextLevel()
    currentLevel = currentLevel + 1
    loadLevel(currentLevel)
end

function getClosestPlanet()
    local closestPlanet = nil

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

    return closestPlanet
end

function getNormalizedVectorTowardsPlanet(planet)
    local vectorXTowardPlanet = planet:getX() - player:getX();
    local vectorYTowardPlanet = planet:getY() - player:getY();
    return cpml.vec2(vectorXTowardPlanet, vectorYTowardPlanet)
end

function clampVector(v, d)
    local x, y = v.x, v.y
    local d2 = math.sqrt(x * x + y * y)
    if d2 > d then
        v.x = x / d2 * d
        v.y = y / d2 * d
    end
    return d2
end
