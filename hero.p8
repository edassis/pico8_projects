pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- game
game={
	sts={home=1,play=2,gameover=3},
	cst=nil,
}

ball={x=62,y=62,dx=50,dy=50,r=2}

pad={x=62,y=122,w=28,h=4,sp=55}

function game:upd(dt)	
 if game.cst==game.sts.home then
  game:title()
 end

 if game.cst==game.sts.play then
  ball:move(dt)
  pad:move(dt)

  ball:collision()
  local block_coll=
  		blocks:collision()
  
  if count(block_coll) then
   local dx=block_coll[1].dx
   local dy=block_coll[1].dy
  	-- increment pontuation
  	-- reflect ball
  	ball:reflect(dx,dy)
  end
 end

 if game.cst==game.sts.gameover then
  game:gameover()
 end
end

function game:title()
 cls(3)
 print("hero",56,60)
 print("press ❎ to start",30,70)
 if btn(❎) then
	 game:start()
 end
end

function game:start()
	cls()
	blocks:start()
	game.cst=game.sts.play
end

function game:draw()
	if(game.cst!=game.sts.play) return
 
 cls()
 circfill(ball.x,ball.y,
  ball.r,10)
 rectfill(pad.x,pad.y,pad.x+pad.w,
  pad.y+pad.h,12)
 
 blocks:draw()
end

function game:gameover()
	cls()
 print("gameover")
 stop()
end

-- #############################

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

function ball:reflect(coll_dx,coll_dy)
	-- how to do this?
end

function ball:collision()
	--margin
	local marg=6
	
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
 
 -- bottom
 -- gameover
 if self.y > 128+self.r then
 	game.cst=game.sts.gameover
 end
end

--paddle
function pad:move(dt)
	--left
	if (btn(⬅️)) self.x -=self.sp*dt
	--right
	if (btn(➡️)) self.x +=self.sp*dt
end

-- blocks
blocks={
	w=11,
	h=4,
	marg=2,
	edge=12,
	
	pos={},
}

function blocks:start()
	local w=self.w
	local h=self.h
	local marg=self.marg
	local edge=self.edge
	
	for y=1,4 do
		for x=1,8 do
			local x0=(x-1)*(w+marg)+edge
			local y0=(y-1)*(h+marg)+edge
			
			add(self.pos, {x0=x0,y0=y0})
		end
	end
end

function blocks:draw()
	for e in all(self.pos) do
		
		local x0=e.x0
		local x1=x0+self.w
		
		local y0=e.y0
		local y1=y0+self.h
		
		rectfill(x0,y0,x1,y1,10)
	end
end

---- returns blocks collided with
---- the ball
--function blocks:collision()
---- not have info about coll
---- direction and pos
--	local coll={}
--	
--	-- for each block
--	-- check if ball is colliding
--	for e in all(blocks.pos) do
--		local x=e.x0
--		local y=e.y0
--		
--		-- check rect area of block
--		-- isn't outside
--		if not (ball.y+ball.r < y or
--				ball.x-ball.r > x+blocks.w or
--				ball.y-ball.r > y+blocks.h or
--				ball.x+ball.r < x) then
--			local str="collided with "
----			str=str..x.." "..y	
----			printh(str)
--			-- increment pontuation
--			-- reflect ball
--			add(coll, e)
--		end
--	end
--	
--	return coll
--end

-- returns reflections dirs
-- of collisions
function blocks:collision()
	local ans={}
	-- for each block
	-- check if ball is colliding
	for e in all(blocks.pos) do
		local x=e.x0
		local y=e.y0
		local coll={}
		-- check either ball is
		-- touching one of the
		-- blocks edges
		if ball.y+ball.r >= y then
			coll.dx=-1*sgn(ball.dx)
			coll.dy=-1
			add(ans, coll)
			del(blocks.pos, e)
			break
		
		elseif ball.y-ball.r <= y then
			coll.dx=-1*sgn(ball.dx)
			coll.dy=1
			add(ans, coll)
			del(blocks.pos,e)
			break
		
		-- left
		elseif ball.x+ball.r >= x then
			coll.dx=-1
			coll.dy=-1*sgn(ball.dy)
			add(ans, coll)
			del(blocks.pos,e)
			break
		
		-- right
		elseif ball.x-ball.r <= x then
			coll.dx=1
			coll.dy=-1*sgn(ball.dy)
			add(ans, coll)
			del(blocks.pos,e)
			break
		end
	end
	
	return ans
end
-->8
-- 
-->8
-- support functions
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100002e0502a0502705025050220501f0501d0501c050190501605013050100500e0500b050080500605005050040500305001050000500005000040000300002000000000000000000000000000000000000
