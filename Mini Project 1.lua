
--# Main
math.randomseed(os.time())
print("Start")
local player = {name = "Hero", hp = 100, maxHP = 100, attack = 10}
local enemy = {name = "Goblin", hp = 50, maxHP = 100, attack = 7}

function attack(attacker, defender)
    local critChance = 0.2
    local minDamage = attacker.attack - 5
    local maxDamage = attacker.attack + 5
    local damage = math.random(minDamage, maxDamage)
    
    local isCrit = math.random() < critChance
    
    if isCrit then
        damage = damage * 2
        print (attacker.name .. " lands a CRITICAL HIT on " .. defender.name .. " for " .. damage .. " damage.")
    else 
        print(attacker.name .. " attacks " .. defender.name .. " for " .. damage .. " damage.") defender.hp = defender.hp - damage
    end
end


for round = 1, 20 do
    print("Round" .. round)
    
    attack(player, enemy)
    
    if enemy.hp <= 0 then
        print(enemy.name .. " defeated! You win! ")
        break
    end
    
    attack(enemy, player)
    
    if player.hp <= 0 then
        print(player.name .. " defeated! GAME OVER! ")
        break 
        if player.hp > player.maxHP then
            player.hp = player.maxHP
        end
        if enemy.hp > enemy.maxHP then
            enemy.hp = enemy.maxHP
        end
    end
    
    print(player.name .. " HP: " .. player.hp)
    print(enemy.name .. " HP: " .. enemy.hp)
end
