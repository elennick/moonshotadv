local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local Entity = require 'src.entity'

LaserGate = class('LaserGate', Entity)

function LaserGate:initialize(args)
    Entity.initialize(self, args.x, args.y)
    self.direction = args.direction
    self.gateIsOn = false
    self.timeSinceLastChange = 0

    --load graphics
    self.wall = love.graphics.newImage("image/wall.png")
    self.spriteSheet = love.graphics.newImage("image/lasers-spritesheet.png")
    self.frames = anim8.newGrid(13, 85, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), 0, 700)
    self.animation = anim8.newAnimation(self.frames('2-23', 1), .05)

    --create top block
    if self.direction == 'horizontal' then
        self.topBlockCollider = world:newRectangleCollider(self.x - 16, self.y, 16, 16)
    else
        self.topBlockCollider = world:newRectangleCollider(self.x, self.y, 16, 16)
    end
    self.topBlockCollider:setCollisionClass('Wall')
    self.topBlockCollider:setType('static')
    self.topBlockCollider:setFriction(0)

    --create bottom block
    if self.direction == 'horizontal' then
        self.bottomBlockCollider = world:newRectangleCollider(self.x - 116, self.y, 16, 16)
    else
        self.bottomBlockCollider = world:newRectangleCollider(self.x, self.y + 100, 16, 16)
    end
    self.bottomBlockCollider:setCollisionClass('Wall')
    self.bottomBlockCollider:setType('static')
    self.bottomBlockCollider:setFriction(0)

    --create laser
    if self.direction == 'horizontal' then
        self.laserCollider = world:newRectangleCollider(self.x - 100, self.y, 100, 16)
    else
        self.laserCollider = world:newRectangleCollider(self.x, self.y + 16, 16, 100)
    end
    self.laserCollider:setCollisionClass('Laser')
    self.laserCollider:setType('static')
    self.laserCollider:setFriction(0)
    self.laserCollider:setActive(false)

    --set rotation
    if self.direction == 'horizontal' then
        self.rotation = 1.58
    else
        self.rotation = 0
    end
end

function LaserGate:draw()
    love.graphics.push("all")
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)

    love.graphics.draw(self.wall, 0, 0, 0, .5, .5)
    if self.gateIsOn then
        self.animation:draw(self.spriteSheet, 1, 16)
    end
    love.graphics.draw(self.wall, 0, 100, 0, .5, .5)

    love.graphics.pop()
end

function LaserGate:update(dt)
    self.animation:update(dt)
    self.timeSinceLastChange = self.timeSinceLastChange + dt
    if self.timeSinceLastChange > 1 then
        self.gateIsOn = not self.gateIsOn
        self.timeSinceLastChange = 0
        if self.gateIsOn then
            self.laserCollider:setActive(true)
        else
            self.laserCollider:setActive(false)
        end
    end
end

return LaserGate
