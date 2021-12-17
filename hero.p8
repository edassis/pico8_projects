pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- game
game={
	sts={
  home=1,
  play=2,
  gameover=3,
 },
	cst=nil,
}

ball={
 x=62,
 y=62,
 -- movement remainder
 rem={x=0,y=0},
 -- direction
 dx=1.5,dy=1.5,
 r=2,
}

pad={x=92,y=106,w=24,h=3,
 vel_max=1.8,ac=0.26,deac=0.32,
 vel=0,
}

map={
 marg={l=6,r=6,t=6,b=11},
}

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
  if ball.y > 128-map.marg.b-ball.r then
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

 map:limits_draw()
 
 blocks:draw()
end

function map:limits_draw()
 -- area border tickness
	local tckn=3
 -- blank space
	local marg={}
 marg.sides=map.marg.l-tckn
 marg.bot=map.marg.b-tckn

 -- top
	rectfill(marg.sides,marg.sides,128-marg.sides-1,marg.sides+tckn-1,7)
 -- bottom
	rectfill(marg.sides,128-tckn-marg.bot,128-marg.sides-1,128-marg.bot-1,7)
	-- left
	rectfill(marg.sides,marg.sides+tckn,marg.sides+tckn-1,128-tckn-marg.bot-1,7)
	-- right
 rectfill(128-marg.sides-tckn,marg.sides+tckn,128-marg.sides-1,128-tckn-marg.bot-1,7)
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
 local amount={}
 amount.x=self.dx
 amount.y=self.dy
 
 -- decimals values for
 -- drawing are bad
 if amount.x*amount.y!=0 then
  -- moving diagonally
  -- around 70% of x/y mov
  amount.x*=0.707
  amount.y*=0.707
 end

 self.rem.x+=amount.x
 self.rem.y+=amount.y
	
	-- if > 0.5 bump the value
 -- rounds to the closest
	amount.x=flr(self.rem.x+0.5)
	amount.y=flr(self.rem.y+0.5)
	
	self.rem.x-=amount.x
	self.rem.y-=amount.y
	
 self.x+=amount.x
 self.y+=amount.y
 
-- printh("rem x "..self.rem.x..
-- 		" rem y "..self.rem.y)
-- printh("amount "..amount.x
-- 		.." "..amount.y)
-- printh("x "..self.x.." y "..
-- 		self.y)
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
	
	-- right/left side
	if self.x > 128-map.marg.r-self.r or
			self.x < 0+map.marg.l+self.r then
		self.dx *= -1
	end

	-- up
	if self.y < 0+map.marg.t+self.r then
		self.dy *= -1
	end

	-- paddle
 -- is colliding only with
 -- paddle's top side
 -- use sprite instead of color
 if pget(self.x,self.y+self.r+1)
   == 12 then
  if (self.dy>0) self.dy *= -1
 end
end

--paddle
function pad:move(dt)
 local input=false
	--left
	if (btn(⬅️)) then
  self.vel-=self.ac
  input=true
 end
	--right
	if (btn(➡️)) then
  self.vel+=self.ac
  input=true
 end

 if not input then
  self.vel=
    abs(self.vel) > self.deac
    and self.vel-self.deac*sgn(self.vel)
    or 0
 end

 --clamp velocity
 self.vel=min(abs(self.vel),
 self.vel_max) * sgn(self.vel)

 self.x+=self.vel
 -- map limits
 self.x=mid(map.marg.l,self.x,128-self.w-map.marg.r)
end

-- blocks
blocks={
	w=11,
	h=4,
	marg=2,
	
	pos={},
}

function blocks:start()
	local w=self.w
	local h=self.h
	local marg=self.marg
	
	for y=1,4 do
		for x=1,8 do
			local x0=(x-1)*(w+marg)
     +map.marg.l+6
			local y0=(y-1)*(h+marg)
     +map.marg.t+2
			
			add(self.pos,{x0=x0,y0=y0})
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
-- *
-->8
-- support functions

mat={}

function mat:dot(va,vb)
	return va.x*vb.x+va.y*vb.y
end

function mat:len(v)
	return sqrt(v.x*v.x +
			v.y*v.y)
end

function mat:angle_to(va,vb)
 -- need test
	local aux={
			x=vb.x-va.x,
			y=vb.y-va.y}
	return atan2(aux.x,aux.y)
end

function mat:appr(init,target,step)
	return init < target and
			min(init+step,target) or
			max(init-step,target)
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
