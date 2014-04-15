-- main.lua

require 'parade'

function love.load()
  parade_init()
end
function love.draw()
  parade_draw()
end
function love.update(dt)
  parade_update(dt)
end

