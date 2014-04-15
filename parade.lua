-- parade.lua because parades r awesome

require 'objects' 

local lg = love.graphics
local bg = lg.newImage("assets/stars.png")
local la = love.audio 
local src,vol = la.newSource("sfx/Loop_Chiptune_test.mp3"),0.5
src:setLooping(true)
src:setVolume(vol)

function parade_init()
  local color,constantOfEpicness = 185,42
  lg.setBackgroundColor(185,color+26,color+constantOfEpicness)
  src:play()
end

local rectWidth, rectHeight = lg.getWidth(), 50
local rectPosX, rectPosY = 0, lg.getHeight()-rectHeight
local xBg, yBg = 0,0
function parade_draw()
  lg.draw(bg,xBg,yBg)
  lg.rectangle('fill', rectPosX, rectPosY, rectWidth, rectHeight)
  objects_draw()
end
function parade_update(dt)
  objects_update(dt)
end
