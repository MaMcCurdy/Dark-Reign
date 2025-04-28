local StageManager = require "src.game.stages.StageManager"
local createTW = require "src.game.stages.createTW"
local createDW = require "src.game.stages.createDW"

local manager = StageManager()


manager.createStage[0] = createDW 
manager.createStage[1] = createTW

return manager