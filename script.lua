-- resolution is 480 x 272
local green = color.new(57,191,106)
local purple = color.new(204,97,208)
scWidth = 480
scHeight = 272
Game = {}
Physics = {}
Hero = {}
Platform = { platforms = {}}
Hero.__index = Hero
Platform.__index = Platform

function Physics:gravity(item)
	item.vel.y = item.vel.y + 20
end

function Physics:update()
	Physics:gravity(hero)
	hero:move(.01, Platform.platforms)
end

function Platform:new(pos, size, color)
	local p = setmetatable(
	{
		color = color,
		pos = pos,
		size = size
	}, Platform)
	table.insert(self.platforms, p)
	return p
end

function Platform:render()
	draw.fillrect(self.pos.x, self.pos.y, self.size.x, self.size.y, purple)
end

function Hero:new(pos,size,color)
	return setmetatable(
	{	
		pos = pos,
		size = size,
		color = color,
		canJump = false,
		vel = {x=0,y=0}
	}, Hero)
end

function Hero:collidesWith(arr)
	for index,item in ipairs(arr) do 
		if (self.pos.x < item.pos.x + item.size.x and
			self.pos.x + self.size.x> item.pos.x and
			self.pos.y < item.pos.y + item.size.y and
			self.pos.y+ self.size.y > item.pos.y) then
				return true
		end
	end
	return false
end

function Hero:move(dTime, platforms)
	local move = {x = self.pos.x+(dTime*self.vel.x), y = self.pos.y+(dTime*self.vel.y)}
	self.pos.x, self.pos.y = move.x, move.y
	if(self:collidesWith(platforms)) then
		self.pos.y = self.pos.y - 1
		self.vel.y = 0
		self.canJump = true
	end
	if (self.pos.x + self.size.x) > 480 or self.pos.x < 1 then
		self.pos.x = self.pos.x - move.x
	end
	if (self.pos.y + self.size.y) > 272 or self.pos.y < 1 then
		self.pos.y = self.pos.y - move.y
	end
end

function Hero:render()
	draw.fillrect(self.pos.x, self.pos.y, self.size.x, self.size.y, self.color)
end

function Game:init()
	os.setcpu(333)
	hero = Hero:new({x = 140, y =235}, {x = 10, y = 20}, green) --green colored
	Platform:new({x=0,y=scHeight-20},{x=scWidth,y=20}, purple)
	Platform:new({x=200,y=scHeight-50},{x=scWidth/2,y=5}, purple)
	Platform:new({x=100,y=scHeight-100},{x=scWidth/4,y=5}, purple)
end

function Game:renderAll()
	hero:render()
	for index,item in ipairs(Platform.platforms) do 
		item:render()
	end
	screen:flip()
end

function Game:controls()
	buttons:read()
	if buttons.held.cross and hero.canJump then
		hero.vel.y = -500
		hero.canJump = false
	end
	if buttons.held.right then
		hero.vel.x = 80
	elseif buttons.held.left then 
		hero.vel.x = -80
	else
		hero.vel.x = 0
	end
end

function Game:run()
	self:init()
	while true do	
		Game:controls()
		Physics:update()
		self:renderAll()
	end
end

Game:run()
