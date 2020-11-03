local class = require 'libs.middleclass'

Player = class('Player')

function Player:initialize(x, y)
    self.x = x
    self.y = y
end

function Player:draw()

end

return Player
