pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- actors
ball={x=15,y=15,dx=40,dy=40,r=2}

pad={x=62,y=122,w=28,h=4,sp=50}

-- game
game={
	sts={home=1,play=2,gameover=3},
	cst=nil,
}

function game:upd(dt)	
 if game.cst==game.sts.home then
  game:title()
 end

 if game.cst==game.sts.play then
  ball:move(dt)
  pad:move(dt)

  ball:collision()
 end

 if game.cst==game.sts.gameover then
  game:gameover()
 end
end

function game:draw()
	if(game.cst!=game.sts.play) return
 
 cls()
 circfill(ball.x,ball.y,
  ball.r,10)
 rectfill(pad.x,pad.y,pad.x+pad.w,
  pad.y+pad.h,12)
end

function game:title()
 cls(3)
 print("hello",52,60)
 print("press ❎ to start",40,70)
 if btn(❎) then
 	game.cst=game.sts.play
 end
end

function game:gameover()
 print("gameover")
 stop()
end


function _init()
 -- running time
 rt=t()
 
 game.cst=game.sts.home
end

function _update60()
 local dt = t() - rt
 rt += dt

 game:upd(dt)
end

function _draw()
 game:draw()
end

--##############################
--ball
function ball:move(dt)
	self.x += self.dx * dt
	self.y += self.dy * dt
end

function ball:collision()
	--margin
	local marg = 6
	
	-- right/left side
	if self.x > 128-marg or
			self.x < 0+marg then
		self.dx *= -1
	end

	-- up
	if self.y < 0+marg then
		self.dy *= -1
	end

	-- paddle
 -- is colliding only with paddle's top side
 if pget(self.x,self.y+self.r+1)
   == 12 then
  if (self.dy>0) self.dy *= -1
 end
end

--paddle
function pad:move(dt)
	--left
	if (btn(0)) self.x -=self.sp*dt
	--right
	if (btn(1)) self.x +=self.sp*dt
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100002e0502a0502705025050220501f0501d0501c050190501605013050100500e0500b050080500605005050040500305001050000500005000040000300002000000000000000000000000000000000000
