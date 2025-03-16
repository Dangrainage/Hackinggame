
local r, g, b = love.math.colorFromBytes(132, 193, 238)
love.graphics.setBackgroundColor(r, g, b)


function love.load()
    --Other random stuff
    love.window.setTitle("Hacking game?")
    love.keyboard.setKeyRepeat(true)

	--lib loading
	anim8 = require 'libs/anim8'


	--player stuff
	player = {x = 0, y = 0, width = 62, height = 62, animations = {}, spritesheet = love.graphics.newImage('sprites/spritesheet.png')}
    player.grid = anim8.newGrid(66, 66, player.spritesheet:getWidth(), player.spritesheet:getHeight())
	player.animations.right = anim8.newAnimation( player.grid('1-3', 1),0.15)
    player.animations.left = anim8.newAnimation( player.grid('1-3', 2),0.15)
    player.anim = player.animations.right
    -- other game objects 
    computer = { x = 200, y = 0, width = 32, height = 32}
    computer.sprite = love.graphics.newImage('sprites/computer.png')

    -- Variable, bools and other data types MK II

    bwa = false
end

-- update function
function love.update(dt)
    -- Variables, bools and other data types

    -- movement
	local isMoving = false
	

    if love.keyboard.isDown("right") then
        player.anim = player.animations.right
        player.x = player.x + 2
        isMoving = true
    end

    if love.keyboard.isDown("left") then
        isMoving = true
        player.x = player.x - 2
        player.anim = player.animations.left
    end

    if isMoving == false then
    	player.anim:gotoFrame(1)
    end

    -- Things that need regular updating
    player.anim:update(dt)

    -- Collisions and touches
end

-- drawing
function love.draw()
    love.graphics.draw(computer.sprite, computer.x, computer.y, nil, 0.5)
    player.anim:draw(player.spritesheet, player.x, player.y, nil, 1)
    if bwa == true then
        love.graphics.print("Hacking!!!")
    end
end

-- Other functions


function checkCollision(obj1, obj2)
    return obj1.x < obj2.x + obj2.width and
           obj1.x + obj1.width > obj2.x and
           obj1.y < obj2.y + obj2.height and
           obj1.y + obj1.height > obj2.y
end


function touch(obj1, obj2)
    local overlapX = math.min(obj1.x + obj1.width, obj2.x + obj2.width) - math.max(obj1.x, obj2.x)
    local overlapY = math.min(obj1.y + obj1.height, obj2.y + obj2.height) - math.max(obj1.y, obj2.y)

    if overlapX < overlapY then
        if obj1.x < obj2.x then
            obj1.x = obj2.x - obj1.width
        else
            obj1.x = obj2.x + obj2.width
        end
        obj1.vx = 0
    else
        if obj1.y < obj2.y then
            obj1.y = obj2.y - obj1.height
        else
            obj1.y = obj2.y + obj2.height
        end
        obj1.vy = 0
    end
end


-- hacking 

function love.keypressed(key, scancode, isrepeat)
    if key == "up" and checkCollision(player, computer) then
        bwa = true
    else 
        bwa = false
    end
end
