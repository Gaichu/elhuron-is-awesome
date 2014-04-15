-- objects.lua

local lg = love.graphics

-- elhuron ---------------------------------------

local vxVal = 20
local elhuronImg = lg.newImage("assets/earth.png") 
local elhuron = { w=elhuronImg:getWidth(), h=elhuronImg:getHeight(), rot=math.pi/4, scaleXY=.25  }

local hPosConst = 1.0575
local elx,ely = elhuron.scaleXY*elhuron.w, hPosConst*lg.getHeight()-(elhuron.scaleXY*elhuron.w)
function elhuron_draw()
  lg.draw(elhuronImg, elx, ely, elhuron.rot, elhuron.scaleXY, elhuron.scaleXY, elhuron.w/2, elhuron.h/2)
end

local delta = 0.0275
function elhuron_spin(dt)
  elhuron.rot = elhuron.rot + delta
end

local speedConst = 6
local vx = vxVal*speedConst
function elhuron_walk(dt)
  elx = elx + vx*dt 
  if elx >= lg.getWidth() then
    elx = 0 
  end
end
function elhuron_update(dt)
  elhuron_spin(dt)
  elhuron_walk(dt)
end

-- baby elhurons
local babby = { xPos = 0, yPos = lg.getHeight()/3, num = 10, posShift = -5, rot = 0, scaleChange = 0.375 }
local adjustYPosConst = 1.0275
function belhuron_draw()
  for i=1,babby.num do
    lg.draw(elhuronImg, babby.xPos*i/12, babby.yPos*adjustYPosConst, babby.rot, elhuron.scaleXY*babby.scaleChange, elhuron.scaleXY*babby.scaleChange) 
  end
end

local _vyVal, _vxVal, trigConst = -10, 35, 5
function belhuron_wave(dt)
  for i=1,babby.num do
    babby.xPos, babby.yPos = babby.xPos + _vxVal*dt, babby.yPos + math.sin(babby.xPos)*trigConst 
    if babby.xPos >= lg.getWidth() then _vxVal = -(_vxVal)  
    elseif babby.xPos <= 0 then _vxVal = -(_vxVal) end 
  end 
end
---------------------------------------------------------------------------------
-- bob.  

local walkright,maxImgs = {},5
for i=1,maxImgs do walkright[i] = lg.newImage("assets/player/animations/playeright" .. i .. ".png") end
local anim = walkright[1] -- start img for animation of walking bob
local animIndexBob, animBobTimerStart = 1,0
local bob = { xPos=250, yPos=500, rot=0, scaleXY = 1, w=walkright[1]:getWidth(), h=walkright[1]:getHeight()  }

local vxb = vxVal
function bob_walk(dt)
  bob.xPos = bob.xPos + vxb*dt
  if bob.xPos >= lg.getWidth() then bob.xPos = -bob.w end

  anim = walkright[animIndexBob] 

  local fwdBound = .15
  animBobTimerStart = animBobTimerStart + dt 
  if animBobTimerStart >= fwdBound then 
    animBobTimerStart = 0
    animIndexBob = animIndexBob + 1
    if animIndexBob >= maxImgs then -- start walking animation again
      animIndexBob = 1 
    end
  end
end

local stand = {}
for i=1,maxImgs do stand[i] = lg.newImage("assets/player/animations/playerstand" .. i .. ".png") end
local aliceMsg, aliceMsg1 = lg.newImage("assets/ALICE.png"), lg.newImage("assets/aliceMsg.png") -- when reaching w/2 of screen he's looking for alice and alice responds with a msg 
local msgTimerMax, msgTimerStart = 5,0 
local inMsgState,msg,aliceMsgPrint = true,false,false
function bob_searchAliceActivate(dt)
  if bob.xPos >= lg.getWidth()/2 and inMsgState then -- when bob at screen.w/2 turn left and stand still  
  -- use timer to say how long shoud wait (wait for alice blob)
    vxb = vxVal*0
    anim = stand[animIndexBob]
   
    local fwdBound = .15
    if animBobTimerStart >= fwdBound then 
      animBobTimerStart = 0
      animIndexBob = animIndexBob + 1
      if animIndexBob >= maxImgs then 
        animIndexBob = 1 
      end
    end
    
    msg = true -- triggers img drawing in printMsgToAlice() function
   
    msgTimerStart = msgTimerStart + dt 
    local timerConst = 1.25
    if ((msgTimerStart > msgTimerMax/2) and not (msgTimerStart >= msgTimerMax)) then 
      aliceMsgPrint = true 
    elseif msgTimerStart >= msgTimerMax then -- manage drawing of alice's msg and bob's msg
      aliceMsgPrint = false
      if msgTimerStart >= timerConst*msgTimerMax then 
        msg = false
        inMsgState = false -- bob is able to walk again  
        vxb = vxVal -- start walking again
      end
    end
  end
end
function bob_update(dt)
  bob_walk(dt)
  bob_searchAliceActivate(dt)
end

local wConst, hConst,aliceMsg1PosX = 1.75, 1.5,-17
function printMsgToAlice()
  if msg then lg.draw(aliceMsg, bob.xPos-bob.w*wConst, bob.yPos-bob.h*hConst) end
  if aliceMsgPrint then lg.draw(aliceMsg1, aliceMsg1PosX, lg.getHeight()-bob.h*hConst*1.75) end 
end
function bob_draw() 
  lg.draw(anim, bob.xPos, bob.yPos)
  printMsgToAlice()
end

---------------------------------------------------------------------------------------
-- the rest. unfortunately without walking animation, but they're cool either way.
-- mini boss
local mbImg = lg.newImage("assets/miniBoss_laserRight.png")
local mbw,mbh = mbImg:getWidth(),mbImg:getHeight()
local mb = { xPos=-mbw*2, yPos=lg.getHeight()-mbh, rot=0, scaleXY=1 }

function mb_draw()
  lg.draw(mbImg, mb.xPos, mb.yPos, mb.rot, mb.scaleXY, mb.scaleXY) 
end

local vxBoss = vxVal
function mb_walk(dt)
  mb.xPos = mb.xPos + vxBoss*dt
  if mb.xPos >= lg.getWidth() then mb.xPos = -mbw end 
end
---

-- simple enemy
local eImg = lg.newImage("assets/tutEnem.png")
local ew,eh = eImg:getWidth(), eImg:getHeight()
local en = { xPos=0, yPos=lg.getHeight()-eh, rot = 0, scaleXY = 1 }

function en_draw()
  lg.draw(eImg, en.xPos, en.yPos, en.rot, en.scaleXY, en.scaleXY)
end

local vxEn = vxVal
function en_walk(dt)
  en.xPos = en.xPos + vxEn*dt
  if en.xPos >= lg.getWidth() then en.xPos = -ew end 
end
---

-- turret .. on wheels? :)
local tuImg = lg.newImage("assets/turret.png")
local tuw,tuh = eImg:getWidth(), eImg:getHeight()
local tu = { xPos=-tuw*2.5, yPos=lg.getHeight()-tuh, rot = 0, scaleXY = 1 }

function tu_draw()
  lg.draw(tuImg, tu.xPos, tu.yPos, tu.rot, tu.scaleXY, tu.scaleXY)
end

local vxTu = vxVal
function tu_walk(dt)
  tu.xPos = tu.xPos + vxTu*dt 
  if tu.xPos >= lg.getWidth() then tu.xPos = -tuw end 
end

function objects_draw()
  elhuron_draw()
  bob_draw()
  mb_draw()
  en_draw()
  tu_draw()
  belhuron_draw()
end
function objects_update(dt)
  elhuron_update(dt)
  bob_update(dt)
  mb_walk(dt)
  en_walk(dt)
  tu_walk(dt)
  belhuron_wave(dt)
end
