function randomName(source)
	if source ~= nil then
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

RegisterCommand('name', function(source)
	exports.oxmysql:execute('SELECT * FROM players WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1],
		['@firstname'] = Config.FirstNames[math.random(1, #Config.FirstNames)],
		['@lastname'] = Config.LastNames[math.random(1, #Config.LastNames)]
	}, function(result)
		if result[1] ~= nil then
			local firstname = result[1].firstname
			local lastname = result[1].lastname
			TriggerClientEvent('names:notify:NameDisplay', source, firstname, lastname)
		else
			randomName(source)
			TriggerClientEvent('names:notify:NameDisplay', source, firstname, lastname)
		end
	end)
end, false)

AddEventHandler('playerConnecting', function(source)
	randomName(source)
end)



RegisterNetEvent('names:newName')
AddEventHandler('names:newName', function(firstname, lastname)
	local source = source -- player id server side
	local identifier = GetPlayerIdentifiers(source)[1] -- steam id

	exports.oxmysql:execute('UPDATE players SET firstname = "", lastname = "" WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		exports.oxmysql:execute('UPDATE players SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier', {
			['@identifier'] = identifier,
			['@firstname'] = firstname,
			['@lastname'] = lastname 
		})
	end)
	TriggerClientEvent('names:notify:NameChanged', source, firstname, lastname)
end)