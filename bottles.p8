pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--built in 

function _init()
	d=0 --debug
	f=false
	
	bot={
		sel=false, --is a bottle selected?
		num=0, --which bottle? #1
		pic=0 --bottle 2
	}
	
 lst={ --bottles
 	"2013",
 	"433",
 	"0002",
 	"113",
 	"221",
 	"465",
 	"456",
 	"66",
 	"554"
 }
 
 curs={
 	x=12,
 	y=39,
 	s=0, --selection
 	f=0, --frame for anim
 }
end

function _update()
	selectbottle()
	win()
end

function _draw()
	cls()
	updatecursor()
	drawbottles()
	ds()
	--drawbs()
end
-->8
--bottles

function drawbottles()
	--set coords ⬇️
	x=0
	y=0
	for i=1,#lst do
		if i>12 then
			x=i-12
			y=3
	 elseif i>6 then
	 	x=i-6
	 	y=2
	 else
	 	x=i
	 	y=1
	 end
	 x*=16
	 y*=32
	 --draw glass ⬇️
	 if i==bot.num then
	 	y-=4
	 end
		spr(1, x,y)
		if complete(i) then
			spr(3, x,y-8)
		else
			spr(2, x,y-8)
		end
		
		drawcolor(x,y,i)
	end
end

function drawcolor(x,y,i)
	
	for j=1,#lst[i] do
		clr = tonum(lst[i][j])+4
			pal(1,clr)
		if j>2 then
			spr(3+j,x,y-8)
		else
			spr(3+j,x,y)
		end
	end
end

function complete(n)
	if #lst[n]==4 then
		c=lst[n][1]
		for j=2,4 do
			if lst[n][j]!=c then
				return false
			end
		end
		return true
	else
		return false
	end
end
-->8
--ui 
function increment(cord,val)
	--increment
	if abs(val)==16 then --if x
		curs.x+=val
		curs.s+=abs(val)/val
	else --if y
		if #lst<=6 then
			curs.x+=16*#lst*abs(val)/val
			if val>0 then
				curs.s=#lst-1
			else
				curs.s=0
			end
		else
			curs.y+=val
			curs.s+=abs(val)/val*6
		end
	end
	
	--bound increment
	if curs.s<0 then 
		curs.s=0 
		curs.x=0
		curs.y=0
	elseif curs.s>=#lst then
		curs.s=#lst-1
		curs.s=flr(curs.s)
		curs.x=128
		curs.y=128
	else
		if curs.y==39 then
			if (curs.s>5) curs.s = 5
		else
			if (curs.s<6) curs.s = 6
		end
	end
	
end

function boundcursor() --?
--[[
	how do i save my tokens here?!
	i cannot figure out how to
	make it like
	f=curs.f
	or something to cut my token
	count in half.
	this whole thing is 
	horrendous.
	
	:(
	]]
	
	--anim ⬇️
	if curs.f<16 or curs.f>38 then
		curs.f=16
	end
	
	--update location ⬇️
 --if (btnp(➡️)) curs.x+=16
 if (btnp(➡️)) increment(curs.x,16)
 if (btnp(⬅️)) increment(curs.x,-16)
 if (btnp(⬇️)) increment(curs.y,32)
 if (btnp(⬆️)) increment(curs.y,-32)
	
	--"dynamic" bounds ⬇️
	--x bounding
	if (curs.x<12) curs.x=12
	if #lst<6 then
		if (curs.x>12+#lst*16-1) curs.x=12+(#lst-1)*16	
	else -- greater than 6 bottles
		if curs.y>39 then 
			if (curs.x>12+(#lst-6)*16-1) curs.x=12+(#lst-7)*16
		else
			if (curs.x>12+6*16-1) curs.x=12+5*16
		end
	end
	
	--y bounding
	if (curs.y<39) curs.y=39
	if curs.y>39 then
		if #lst<7 then
			curs.y=39
		else
			if (curs.y>71) curs.y=71
		end
	end
end

function updatecursor()
	boundcursor()
	spr(curs.f,curs.x,curs.y,2,1)
	curs.f+=2
end
-->8
--game?

function selectbottle()
	if btnp(❎) then
	if not complete(curs.s+1) then
		if not bot.sel then --no bottle

			bot.sel = true
			bot.num = curs.s+1
		else --trying to pour
			bot.sel=false
			if valid() then
				pour()
			else
				
			end
			bot.num=0
			--if so, pour
			--else, do not pour.
		end
	end
	end
end

function valid()
	bot1=lst[bot.num]
	bot2=lst[curs.s+1]
	--replace things
	
	if bot.num!=curs.s+1 then --not self
		if (bot2[#bot2] == bot1[#bot1]) or bot2=="" then
		--check color valid
			l=1
			n=lst[bot.num][-1]
			while bot1[-l-1]==n do
				l+=1
			end
			if l+#lst[curs.s+1] <= 4 then
				f=true
				return true
			end
			f = false
			return false
		elseif bot2== "" then
			return true
		end
		f=false
		return false
	end
	f=false
	return false --self
end

function pour()
	nb=sub(bot1,1,#bot1-l)
	repeat
		--add to new bottle (bot2)
		lst[curs.s+1]=lst[curs.s+1]..bot1[#bot1]
		--take from old bottle (bot1)
		l-=1
	until l==0
	lst[bot.num]=nb
end

function wincheck()
	for i=1,#lst do
		if not (complete(i) or lst[i]=="") then
			return false
		end
	end	
	return true
end

function win()
	if wincheck() then
		sfx(0,0)
	end
end
-->8
--debug

--[[
	current issue:
	curs.s is 1 more than it 
	should be when you go to the 
	next line and it gets rounded
	down.
]]

function ds()
	print(f,112,112)
end
__gfx__
00000000700000070000000000444400000000000111111000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000070077770000744700000000000111111000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700700000070070070000700700000000000111111000000000000110000000000000000000000000000000000000000000000000000000000000000000
00077000700000070070070000700700011111100000000000000000000110000000000000000000000000000000000000000000000000000000000000000000
00077000700000070700007007000070011111100000000000000000001111000000000000000000000000000000000000000000000000000000000000000000
00700700700000070700007007000070011111100000000000111100000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000077000000770000007011111100000000001111110000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777777000000770000007000000000000000001111110000000000000000000000000000000000000000000000000000000000000000000000000
00ff00000000ff0000ff00000000ff0000ff00000000ff0000ff00000000ff0000ff00000000ff0000ff00000000ee0000ff00000000ff0000ee00000000ff00
0ffffffeeffffff00ffffffeeffffff00fffffeeeffffff00fffffeeeffffff00ffffeeeeffffff00fffeeeeeeeefff00eeeeeeeeeeeeee00fffeeeeeeeefff0
00fffffeefffff0000ffffeeefffff0000fffeeeffffff0000ffeeefffffff0000feeeffffffff0000eeffffffffff0000ffffffffffff0000ffffffffffee00
00000ffeeff0000000000feefff0000000000eeffff0000000000efffff0000000000ffffff0000000000ffffff0000000000ffffff0000000000ffffff00000
0000000ee00000000000000ef00000000000000ff00000000000000ff00000000000000ff00000000000000ff00000000000000ff00000000000000ff0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ff00000000ff0000ff00000000ff0000ff00000000ff0000ff00000000ff000000000000000000000000000000000000000000000000000000000000000000
0ffffffeeeeffff00ffffffeeefffff00ffffffeeefffff00ffffffeeffffff00000000000000000000000000000000000000000000000000000000000000000
00ffffffffeeef0000fffffffeeeff0000ffffffeeefff0000fffffeeeffff000000000000000000000000000000000000000000000000000000000000000000
00000ffffff0000000000fffffe0000000000ffffee0000000000fffeef000000000000000000000000000000000000000000000000000000000000000000000
0000000ff00000000000000ff00000000000000ff00000000000000fe00000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000c00003505035000350500000029050290002905000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
