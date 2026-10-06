-- Pong для LÖVE2D
local W,H=1280,720
local pw,ph=18,130
local speed,ballSpeed,radius=520,520,10
local left,right,ball
local p1,p2=0,0
local running,paused,gameOver=false,false,false
local fontBig,fontSmall,fontControls
local sounds={}

local function makeSound(freq,duration)
 local rate=44100
 local n=math.floor(rate*duration)
 local data=love.sound.newSoundData(n,rate,16,1)

 for i=0,n-1 do
  local t=i/rate
  local fade=1-i/n
  data:setSample(i,math.sin(2*math.pi*freq*t)*.18*fade)
 end

 return love.audio.newSource(data,"static")
end

local function sound(n)
 if sounds[n] then
  sounds[n]:stop()
  sounds[n]:play()
 end
end

local function resetBall(dir)
 ball.x,ball.y=W/2,H/2
 ball.vx=ballSpeed*dir
 ball.vy=(love.math.random()-.5)*ballSpeed*1.2
end

local function resetGame()
 p1,p2=0,0

 left={
  x=40,
  y=H/2-ph/2
 }

 right={
  x=W-40-pw,
  y=H/2-ph/2
 }

 ball={
  x=W/2,
  y=H/2
 }

 resetBall(love.math.random()<.5 and 1 or -1)

 running=false
 paused=false
 gameOver=false
end

local function hit(p)
 return ball.x-radius<p.x+pw
    and ball.x+radius>p.x
    and ball.y-radius<p.y+ph
    and ball.y+radius>p.y
end

function love.load()
 love.window.setMode(W,H,{
  fullscreen=false,
  resizable=false,
  vsync=true
 })

 love.window.setTitle("Pong")

 love.graphics.setBackgroundColor(.067,.067,.067)

 fontBig=love.graphics.newFont(52)
 fontSmall=love.graphics.newFont(20)
 fontControls=love.graphics.newFont(18)

 sounds.bounce=makeSound(520,.06)
 sounds.paddle=makeSound(700,.06)
 sounds.score=makeSound(260,.12)
 sounds.start=makeSound(880,.08)

 resetGame()
end

function love.update(dt)

 if not running or paused or gameOver then
  return
 end

 -- Гравець 1: W / S
 if love.keyboard.isDown("w") then
  left.y=left.y-speed*dt
 end

 if love.keyboard.isDown("s") then
  left.y=left.y+speed*dt
 end

 -- Гравець 2: стрілки ↑ / ↓
 if love.keyboard.isDown("up") then
  right.y=right.y-speed*dt
 end

 if love.keyboard.isDown("down") then
  right.y=right.y+speed*dt
 end

 left.y=math.max(0,math.min(H-ph,left.y))
 right.y=math.max(0,math.min(H-ph,right.y))

 ball.x=ball.x+ball.vx*dt
 ball.y=ball.y+ball.vy*dt

 if ball.y-radius<=0 then
  ball.y=radius
  ball.vy=math.abs(ball.vy)
  sound("bounce")

 elseif ball.y+radius>=H then
  ball.y=H-radius
  ball.vy=-math.abs(ball.vy)
  sound("bounce")
 end

 if ball.vx<0 and hit(left) then
  ball.x=left.x+pw+radius
  ball.vx=math.abs(ball.vx)*1.04
  ball.vy=((ball.y-(left.y+ph/2))/(ph/2))*ballSpeed
  sound("paddle")
 end

 if ball.vx>0 and hit(right) then
  ball.x=right.x-radius
  ball.vx=-math.abs(ball.vx)*1.04
  ball.vy=((ball.y-(right.y+ph/2))/(ph/2))*ballSpeed
  sound("paddle")
 end

 if ball.x<-radius then
  p2=p2+1
  sound("score")
  resetBall(1)

 elseif ball.x>W+radius then
  p1=p1+1
  sound("score")
  resetBall(-1)
 end

 if p1>=10 or p2>=10 then
  running=false
  gameOver=true
 end
end

function love.keypressed(key)

 -- ПРОБІЛ — старт / пауза
 if key=="space" then

  if not gameOver then

   if not running then
    running=true
    paused=false
   else
    paused=not paused
   end

   sound("start")
  end

 -- R — перезапуск
 elseif key=="r" then
  resetGame()

 -- ESC — вихід
 elseif key=="escape" then
  love.event.quit()
 end
end

function love.draw()

 -- Рахунок
 love.graphics.setFont(fontBig)

 love.graphics.printf(
  tostring(p1),
  0,
  35,
  W/2-40,
  "right"
 )

 love.graphics.printf(
  tostring(p2),
  W/2+40,
  35,
  W/2-40,
  "left"
 )

 -- Центральна лінія
 love.graphics.setLineWidth(3)

 for y=0,H,30 do
  love.graphics.line(
   W/2,
   y,
   W/2,
   y+15
  )
 end

 -- Платформи
 love.graphics.rectangle(
  "fill",
  left.x,
  left.y,
  pw,
  ph
 )

 love.graphics.rectangle(
  "fill",
  right.x,
  right.y,
  pw,
  ph
 )

 -- М'яч
 love.graphics.circle(
  "fill",
  ball.x,
  ball.y,
  radius
 )

 -- Повідомлення
 love.graphics.setFont(fontSmall)

 local msg

 if gameOver then

  msg=(p1>=10 and
   "Гравець 1 переміг!"
   or
   "Гравець 2 переміг!")
   .." Натисни R для нової гри"

 elseif not running then

  msg="Натисни ПРОБІЛ, щоб почати"

 elseif paused then

  msg="ПАУЗА — натисни ПРОБІЛ"

 else

  msg="Гра триває"

 end

 love.graphics.printf(
  msg,
  0,
  H-105,
  W,
  "center"
 )

 -- ==================================================
 -- ПОЯСНЕННЯ КЕРУВАННЯ ВНИЗУ
 -- ==================================================

 love.graphics.setFont(fontControls)

 love.graphics.printf(
  "Гравець 1: W / S — рух платформи     |     Гравець 2: ↑ / ↓ — рух платформи",
  0,
  H-65,
  W,
  "center"
 )

 love.graphics.printf(
  "ПРОБІЛ — старт / пауза     |     R — перезапуск",
  0,
  H-38,
  W,
  "center"
 )

end
