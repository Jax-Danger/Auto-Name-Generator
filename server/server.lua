-- This function is called when a player connects to the server. 
--It uses oxmysql exports to add the player to the players table in the database and generates a random first and last name for the player if they are not already in the table.
function randomName(source)
    -- get player identifier
    if source ~= nil then
        -- add player to the players table in the database and generate a random name if they are not already in the table
        exports.oxmysql:execute('SELECT * FROM players WHERE identifier = @identifier', {
            ['@identifier'] = GetPlayerIdentifiers(source)[1]
        }, function(result)
            if result[1] == nil then
                exports.oxmysql:execute('INSERT INTO players (identifier, firstname, lastname) VALUES (@identifier, @firstname, @lastname)', {
                    ['@identifier'] = GetPlayerIdentifiers(source)[1],
                    ['@firstname'] = Config.FirstNames[math.random(1, #Config.FirstNames)],
                    ['@lastname'] = Config.LastNames[math.random(1, #Config.LastNames)]
                })
            end
        end)
    end
end

-- create a command that executes the randomName function
RegisterCommand('name', function(source, args, rawCommand)
    -- if the player has a name in the players table in the database, then return a message saying they already have a name. If they do not have a name, then generate a random name for them.
        exports.oxmysql:execute('SELECT * FROM players WHERE identifier = @identifier', {
            ['@identifier'] = GetPlayerIdentifiers(source)[1],
            ['@firstname'] = Config.FirstNames[math.random(1, #Config.FirstNames)],
            ['@lastname'] = Config.LastNames[math.random(1, #Config.LastNames)]
        }, function(result)
            if result[1] ~= nil then
                local firstName = result[1].firstname
                local lastName = result[1].lastname
                TriggerClientEvent('names:notify:NameDisplay', source, firstName, lastName)
            else
                randomName(source)
                -- notify the player what their name is.
                TriggerClientEvent('names:notify:NameDisplay', source, firstName, lastName)
            end
        end)
end, false)



-- register a player connect event
AddEventHandler('playerConnecting', function()
    if Config.AutoGenerate then
        randomName(source)
    end
end)

-- register a server event that clears the player's name in the database and adds a new name from the dialog input
RegisterNetEvent('names:newName')
AddEventHandler('names:newName', function(firstname, lastname)
    -- clear the player's name in the database
    local source = source
    local identifier = GetPlayerIdentifiers(source)[1]
    exports.oxmysql:execute('UPDATE players SET firstname = "", lastname = "" WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        -- add player back to the players table in the database with the new name
        exports.oxmysql:execute('UPDATE players SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier', {
            ['@identifier'] = identifier,
            ['@firstname'] = firstname,
            ['@lastname'] = lastname
        })
    end)
    -- notify the player that they have a new name
    TriggerClientEvent('names:notify:NameChanged', source, firstname, lastname)
end)
