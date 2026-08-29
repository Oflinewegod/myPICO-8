pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--[[
cURRENT iSSUE:
fIGURING OUT THE BEST/MOST 
EFFICIENT WAY TO CHECK IF A 
MOVE IS VALID.
MUST CONSIDER THE FOLLOWING:
-CAN THE PIECE DO THAT MOVE?
-IS THERE A PIECE BETWEEN THE
CURRENT SPOT AND THE DESIRED ONE
(EXCLUDING KNIGHTS)?

]]

function _init()
	board={}
	boardtable()
	val = 200
	c={ --cursor
		x=1,
		y=1,
		sx=1,--selection x
		sy=1,
		a=0, --anim frame
		sel = false
	}
	piece = 0
	
	--valid moves
	moves = {
		--white
		--pawn
		[1] = {
			{-0, -1}
		},
		
		--rook
		[2] = {
			
		}
	}
	
	
end

function _update()
	updatecursor()
end

function _draw()
	cls()
	drawboard()
	drawpieces()
	drawcursor()
end

-->8
--board
function boardtable()
	for y=1,8 do
		board[y] = {} 
		for x=1,8 do
			--pieces
			--black back row
			if y==1 then
			if x==1 or x==8 then --rook
				setsquare(x,y,8)
			elseif x==2 or x==7 then --knight
				setsquare(x,y,9)
			elseif x==3 or x==6 then --bishop
				setsquare(x,y,10)
			elseif x==4 then --queen
				setsquare(x,y,11)
			elseif x==5 then --king
				setsquare(x,y,12)			
			end
			
			elseif y==2 then --black pawns
				setsquare(x,y,7)
				
			elseif y==7 then --white pawns
				setsquare(x,y,1)
			--white back row
			elseif y==8 then
			if x==1 or x==8 then --rook
				setsquare(x,y,2)
			elseif x==2 or x==7 then --knight
				setsquare(x,y,3)
			elseif x==3 or x==6 then --bishop
				setsquare(x,y,4)
			elseif x==4 then --queen
				setsquare(x,y,5)
			elseif x==5 then --king
				setsquare(x,y,6)			
			end
			else
				setsquare(x,y,0) --empty
			end			
		end
	end
end

function setsquare(x,y,val)
	board[y][x] = val
end


function drawboard()
	local brown = true

	for i=1,8 do 
		brown = not brown --flip to properly alternate rows
		for j=1,8 do
			if brown then
				spr(13, j*8, i*8)
			else
				pal(4,-9)
				spr(13, j*8, i*8)
				pal()
			end
			brown = not brown
		end
	end
end

function drawpieces()
	for i=1,8 do
		for j=1, 8 do
			if board[i][j] != 0 then
				spr(board[i][j],j*8,i*8)
			end
		end
	end
end


-->8
--ui
function drawcursor()
	c.a += 0.1
	if (c.a >= 2) c.a = 0
	
	--could've just recolored the
	--cursor but i'm lazy
	if c.sel then
		spr(20+c.a,c.x*8,c.y*8)
		spr(18+c.a,c.sx*8,c.sy*8)
	else
		spr(16+c.a,c.x*8,c.y*8)
	end
end

function updatecursor()
	if btnp(⬅️) then
		c.x -= 1
	elseif btnp(➡️) then
		c.x += 1
	elseif btnp(⬆️) then
		c.y -= 1
	elseif btnp(⬇️) then
		c.y += 1
	end
	
	--bounding
	if (c.x>8) c.x = 1
	if (c.x<1) c.x = 8
	if (c.y>8) c.y = 1
	if (c.y<1) c.y = 8
	
	if btnp(❎) then
		if c.sel then
			c.sel = false
			updatepiece()
		else
			c.sel = true
			c.sx = c.x
			c.sy = c.y
			piece = board[c.sy][c.sx]
		end
	end
end

function updatepiece()
	local dx = c.x - c.sx --difference in x
	local dy = c.y - c.sy --difference in y
	
	if (piece == 0) return
	
	for i=1,#moves[piece] do
		local move = moves[piece][i]
		
		if dx == move[1] and dy == move[2] then --x and y
			board[c.sy][c.sx] = 0
			board[c.y][c.x] = piece
			break
		end
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444440000000000000000
00000000000ff0000f0ff0f000000f0000ffff000000000000077000000110000101101000000100001111000000000000077000444444440000000000000000
00700700000ff0000ffffff0000ffff0000ff000070770700ffffff0000110000111111000011110000110000707707001111110444444440000000000000000
0007700000000000007777000fff7ff0000770000f0ff0f00ffffff0000000000077770001117110000770000101101001111110444444440000000000000000
00077000000ff00000ffff000fffff00000ff0000f7ff7f00ffffff0000110000011110001111100000110000171171001111110444444440000000000000000
0070070000ffff000077770000077700007777000ffffff000777700001111000077770000077700007777000111111000777700444444440000000000000000
000000000ffffff00ffffff00ffffff00ffffff00ffffff000ffff00011111100111111001111110011111100111111000111100444444440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444440000000000000000
cc0000ccc000000cbb0000bbb000000b880000888000000800000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000c00000000b000000b00000000800000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000c00000000b000000b00000000800000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc0000ccc000000cbb0000bbb000000b880000888000000800000000000000000000000000000000000000000000000000000000000000000000000000000000
