local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'

require 'src.player'
require 'src.animatedplanet'
require 'src.rotatingplanet'
require 'src.background'

local entities = {}

function love.load()
    math.randomseed(os.time())
    local major, minor, revision, codename = love.getVersion()
    print("running with LÖVE version: " .. major .. "." .. minor .. "." .. revision .. " " .. codename)

    background = Background:new()

    player = Player:new(100, 100)
    table.insert(entities, player)

    planet1SpriteSheet = love.graphics.newImage("image/planets/Purple Planet.png")
    planet1 = AnimatedPlanet:new(500, 500, 5, planet1SpriteSheet)
    table.insert(entities, planet1)

    planet2SpriteSheet = love.graphics.newImage("image/planets/Green Planet.png")
    planet2 = AnimatedPlanet:new(300, 500, 4, planet2SpriteSheet)
    table.insert(entities, planet2)

    moonImage = love.graphics.newImage("image/planets/Baren.png")
    moon = RotatingPlanet:new(900, 100, 3, moonImage, .005)
    table.insert(entities, moon)
end

function love.draw()
    background:draw()
    for i in ipairs(entities) do
        love.graphics.setColor(1, 1, 1, 1)
        entities[i]:draw()
    end
end

--todo figure out how to get consistent framerate / tick rate
function love.update(dt)
    background:update(dt)
    for i in ipairs(entities) do
        entities[i]:update(dt)
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end
