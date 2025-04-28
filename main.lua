local Globals = require "src.Globals"
local Push = require "libs.push"
local Sounds = require "src.game.Sounds"
local Player = require "src.game.Player"
local Camera = require "libs.sxcamera"
local HUD = require "src.game.HUDimproved"

function love.load()
    love.window.setTitle("Dark Reign Demo")
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true})
    math.randomseed(os.time()) 

    player = Player(0,0)
    hud = HUD(player)

    camera = Camera(gameWidth/2,gameHeight/2,
        gameWidth,gameHeight)
    camera:setFollowStyle('PLATFORMER')

    stagemanager:setPlayer(player)
    stagemanager:setCamera(camera)

    titleFont = love.graphics.newFont("fonts/Abaddon Bold.ttf",50)
    stagemanager:setStage(0)

end

function love.resize(w,h)
    Push:resize(w,h)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "F2" or key == "tab" then
        debugFlag = not debugFlag  
    elseif gameState == "over" then
        gameState = "start"
        player:reset()
        stagemanager:setStage(0)
    elseif key == "return" and gameState=="start" then
        gameState = "play"
        stagemanager:setStage(0)

    elseif key == "return" and gameState == "map" then
        gameState = "play"
        player:reset()
        stagemanager:setStage(0)
    elseif key == "backspace" and gameState == "map" then
        gameState = "play"
        player:reset()
        stagemanager:setStage(1)
    else
        player:keypressed(key, stagemanager:currentStage()) 
    end
end
function love.mousepressed(x, y, button, istouch)
    gx, gy = Push:toGame(x,y)

end

function love.update(dt)
    if player.lives <= 0 and gameState ~= "over" then 
        gameState = "over"
        stagemanager:currentStage():stopMusic()
        Sounds["game_over"]:play()
    end

    if gameState == "play" then
        stagemanager:currentStage():update(dt)
        player:update(dt, stagemanager:currentStage())
        hud:update(dt)

        camera:update(dt)
        camera:follow(math.floor(player.x+48), math.floor(player.y))
        if player.x < 29*16 then
            gameState = "map"
        end

    elseif gameState == "start" then

    elseif gameState == "over" then


        
    elseif gameState == "map" then
    end
end

function love.draw()
    Push:start() 

    if gameState == "play" then
        drawPlayState()
    elseif gameState == "start" then
        drawStartState()
    elseif gameState == "over" then
        drawGameOverState()
    elseif gameState == "map" then
        drawMapState()
    else 
        love.graphics.setColor(1,1,0)
        love.graphics.printf("Error", 0,20,gameWidth,"center")
    end

    Push:finish()
end

function drawPlayState()

    stagemanager:currentStage():drawBg()

    camera:attach()

    stagemanager:currentStage():draw()
    player:draw(stagemanager:currentStage())
    
    camera:detach()

    hud:draw()
end

function drawStartState()
    love.graphics.setColor(0.3,0.3,0.3) 
    stagemanager:currentStage():drawBg()
    stagemanager:currentStage():draw()
    player:draw(stagemanager:currentStage()) 
    love.graphics.setColor(1,0,0.25) 
    love.graphics.printf("Dark Reign", titleFont,0,20,gameWidth,"center")
    love.graphics.printf("Press Enter to Start",0,100,gameWidth,"center")
        
end

function drawGameOverState()
    love.graphics.setColor(0.3,0.3,0.3)
    stagemanager:currentStage():drawBg()
    camera:attach() 
    stagemanager:currentStage():draw()
    
    camera:detach() 

    love.graphics.setColor(1,0,0,1)
    love.graphics.printf("Game Over", titleFont,0,80,gameWidth,"center")

    love.graphics.printf("Press any key for Start Screen", 0,150,gameWidth,"center")
end

function drawMapState()
    love.graphics.setColor(0.3,0.3,0.3)
    stagemanager:currentStage():drawBg()
    camera:attach()
    camera:detach()

    love.graphics.setColor(1,0,0.7)
    love.graphics.printf("Select A Stage", titleFont,0,80,gameWidth,"center")

    love.graphics.printf("Press enter for main stage\nPress backspace for new stage", 0,150,gameWidth,"center")
end