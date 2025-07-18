function setup()
    player = {
        name = "You",
        hp = 100,
        maxhp = 100,
        atk = 20,
        def = 8
    }
    
    enemy = {
        name = "Enemy",
        hp = 100,
        maxhp = 100,
        atk = 20,
        def = 8
    }
    
    currentState = "waiting" 
    messages = {"Battle Start!"}
end

function draw()
    background(40, 40, 50)
    fill(255)
    fontSize(20)
    text("Player HP: "..player.hp.."/"..player.maxhp, WIDTH/2, HEIGHT - 50)
    text("Enemy HP: "..enemy.hp.."/"..enemy.maxhp, WIDTH/2, HEIGHT - 80)
    
    for i = 1, #messages do
        text(messages[i], WIDTH/2, HEIGHT - 100 - i*20)
    end
    
    if currentState == "waiting" then
        drawButton("Attack", WIDTH/4 - 75, 100, function() playerTurn("attack") end)
        drawButton("Defend", WIDTH*3/4 - 75, 100, function() playerTurn("defend") end)
    end
end

function drawButton(label, x, y, action)
    fill(100, 200, 250)
    rect(x, y, 150, 60, 10)
    fill(0)
    fontSize(20)
    text(label, x + 75, y + 30)
    
    if CurrentTouch.state == BEGAN and CurrentTouch.x > x and CurrentTouch.x < x + 150 and
    CurrentTouch.y > y and CurrentTouch.y < y + 60 then
        if currentState == "waiting" then
            currentState = "busy"
            action()
        end
    end
end

function playerTurn(action)
    if action == "attack" then
        local isCrit = math.random() < 0.2
        local base = player.atk - math.random(0, enemy.def)
        local damage = math.max(1, base)
        if isCrit then
            damage = damage * 2
        end
        enemy.hp = math.max(0, enemy.hp - damage)
        table.insert(messages, 1, player.name .. " attacks " .. enemy.name .. " for " .. damage .. (isCrit and " (CRIT!)" or "") .. " damage!")
    elseif action == "defend" then
        local incoming = enemy.atk
        local reduced = math.max(1, incoming - player.def * 2)
        player.hp = math.max(0, player.hp - reduced)
        table.insert(messages, 1, player.name .. " defends and takes " .. reduced .. " reduced damage!")
    end
    
    checkPotion(player)
    checkWin()
    
    if enemy.hp > 0 and currentState ~= "gameover" then
        tween.delay(1, function() enemyTurn() end)
    end
end

function enemyTurn()
    local base = enemy.atk - math.random(0, player.def)
    local damage = math.max(1, base)
    local isCrit = math.random() < 0.2
    if isCrit then damage = damage * 2 end
    player.hp = math.max(0, player.hp - damage)
    table.insert(messages, 1, enemy.name .. " attacks " .. player.name .. " for " .. damage .. (isCrit and " (CRIT!)" or "") .. " damage!")
    
    checkPotion(enemy)
    checkWin()
    
    if player.hp > 0 then
        tween.delay(1, function() currentState = "waiting" end)
    end
end

function checkPotion(entity)
    if math.random() < 0.1 then
        if math.random() < 0.5 then
            entity.hp = math.min(entity.hp + 10, entity.maxhp)
            table.insert(messages, 1, entity.name .. " found and drank a potion! +10 HP")
        else
            entity.hp = math.max(entity.hp - 10, 0)
            table.insert(messages, 1, entity.name .. " found and drank a potion! -10 HP")
        end
    end
end

function checkWin()
    if enemy.hp <= 0 then
        table.insert(messages, 1, "You defeated the enemy!")
        currentState = "gameover"
    elseif player.hp <= 0 then
        table.insert(messages, 1, "You were defeated!")
        currentState = "gameover"
    end
end