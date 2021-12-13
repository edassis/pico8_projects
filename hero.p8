pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- game
game={
	sts={home=1,play=2,gameover=3},
	cst=nil,
}

ball={x=62,y=62,dx=40,dy=40,r=2}

pad={x=92,y=122,w=28,h=4,sp=55}

function game:upd(dt)	
 if game.cst==game.sts.home then
  game:title()
 end

 if game.cst==game.sts.play then
  ball:move(dt)
  pad:move(dt)

  ball:collision()
  local n_coll=
  		blocks:collision()
  
  if count(n_coll) then
  	-- normal collision
   local x=n_coll[1]
   local y=n_coll[2]
  	-- increment pontuation
  	ball:reflect({x=x, y=y})
  end
  
  -- gameover
  if ball.y > 128+ball.r then
			game.cst=game.sts.gameover
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
	if not (self.mv_x or self.mv_y)
	then
		self.mv_x=0
		self.mv_y=0
	end
	
	self.mv_x+=self.dx*dt
	self.x+=self.mv_x\1
	self.mv_x-=self.mv_x\1
	
	self.mv_y+=self.dy*dt
	self.y+=self.mv_y\1
	self.mv_y-=self.mv_y\1
	
	local str=self.x.." "..self.y
	printh(str)
end

function ball:reflect(n)
	-- how to do this?
	-- r=d-2(d*n)n
	-- where (d*n) is the dot prod
	local dot=mat:dot(
			{x=ball.dx, y=ball.dy},
			{x=n.x, y=n.y})
	
	ball.dx=ball.dx-2*dot*n.x
	ball.dy=ball.dy-2*dot*n.y
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

-- returns collision normal
function blocks:collision()
	-- for each block
	-- check if ball is colliding
	for e in all(blocks.pos) do
		local x=e.x0
		local y=e.y0
		-- check either ball is
		-- touching one of the
		-- blocks edges
		
		if ball.x >= x and
				ball.x <= x+blocks.w then	
			-- up
			if ball.y+ball.r >= y and
					ball.y-ball.r < y then
				del(blocks.pos, e)
				return pack(0,-1)
			-- down
			elseif ball.y-ball.r <=
					y+blocks.h and
					ball.y+ball.r > y+blocks.h
					then
				del(blocks.pos, e)
				return pack(0,1)
			end
		end
		
		if ball.y >= y and
				ball.y <= y+blocks.h then
			-- left
			if ball.x+ball.r >= x 
					and ball.x-ball.r < x then
				del(blocks.pos, e)
				return pack(-1,0)
			-- right
			elseif ball.x-ball.r <=
					x+blocks.w and
					ball.x+ball.r > x+blocks.w
					then
				del(blocks.pos, e)
				return pack(1,0)
			end
		end
	end
	
	return nil
end
-->8
-- 
-->8
-- support functions

mat={}

function mat:dot(va,vb)
	return va.x*vb.x + va.y*vb.y
end

function mat:len(v)
	return sqrt(v.x*v.x +
			v.y*v.y)
end

function mat:angle_to(va,vb)
	local aux={
			x=vb.x-va.x,
			y=vb.y-va.y}
	return atan2(aux.x,aux.y)
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
