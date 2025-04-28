local sounds = {} 

sounds["music_demo"] = love.audio.newSource("sounds/BATTLE BOSS 1.mp3","static")
sounds["music_demo"]:setVolume(0.3)

sounds["attack1"] = love.audio.newSource("sounds/leohpaz/Slash.wav","static")
sounds["attack2"] = love.audio.newSource("sounds/leohpaz/Claw.wav","static")
sounds["mob_hurt"] = love.audio.newSource("sounds/kronbits/Impact_Punch.wav","static")
sounds["player_hurt"] = love.audio.newSource("sounds/kronbits/Punch_Hurt.wav","static")
sounds["coin"] = love.audio.newSource("sounds/bfxr/Pickup_Coin.wav","static")
sounds["gem"] = love.audio.newSource("sounds/kronbits/Blop.wav","static")
sounds["jump"] = love.audio.newSource("sounds/kronbits/Jump_Classic.wav","static")
sounds["die"] = love.audio.newSource("sounds/kronbits/Negative_Short.wav","static")
sounds["game_over"] = love.audio.newSource("sounds/kronbits/Negative_Melody.wav","static")
return sounds