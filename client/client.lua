local isNear = false

local point = lib.points.new({
	coords = Config.ChangeNameLoc.coords,
	distance = 2.0,
})



function point:onEnter()
	isNear = true
	lib.showTextUI('[E] - Change your name', {
		position = "top-center",
		icon = 'user',
		style = {
			borderRadius = 0,
			backgroundColor = '#48BB78',
			color = 'white'
		}
	})
	TriggerEvent('names:changeName')
end
function point:onExit()
	lib.hideTextUI()
	isNear = false
end
RegisterNetEvent('names:changeName')
AddEventHandler('names:changeName', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
				
			if isNear then                
				if IsControlJustReleased(0, 38) then
					local input = lib.inputDialog('City Hall: Change your name.', {
						{type = 'input', label = 'First Name', description = 'Change your First Name', required = true, min = 3, max = 10, allowCancel = true},
						{type = 'input', label = 'Last Name', description = 'Change your Last Name', required = true, min = 3, max = 10, allowCancel = true},
					})
					if input then
						local firstname = input[1]
						local lastname = input[2]
						if lib.alertDialog({
							header = 'City Hall',
							content = 'Confirm your name change to ' .. input[1] .. ' ' .. input[2] .. '.',
							centered = true,
							cancel = true
						}) then
							TriggerServerEvent('names:newName', firstname, lastname)
						else    
							lib.notify({
								title = 'City Hall',
								description = 'You have cancelled your name change.',
								type = 'error'
							})
						end
					end
				end
			end
		end
	end)
end)


-- register a client event that notifies the player they have a new name
RegisterNetEvent('names:notify:NameChanged')
AddEventHandler('names:notify:NameChanged', function(firstname, lastname)
	-- notify the player that they have a new name
	lib.notify({
		title = 'City Hall',
		description = 'You\'re new name is ' .. firstname .. ' ' .. lastname .. '.',
		type = 'success',
		position = 'center-right'
	})
end)

RegisterNetEvent('names:notify:NameDisplay')
AddEventHandler('names:notify:NameDisplay', function(firstName, lastName)
	-- notify the player that they have a new name
	local firstName = firstName
	local lastName = lastName
	lib.notify({
		id = 'identification',
		title = 'Identification',
		description = 'Your name is ' .. firstName .. ' ' .. lastName .. '.',
		position = 'center-right',
		style = {
			backgroundColor = '#313131',
			color = '#ffffff',
			['.description'] = {
			  color = '#ffffff'
			}
		},
		icon = 'check',
		iconColor = '#03c5ac'
	})
end)



-- create a blip on the map for the City Hall location
Citizen.CreateThread(function()
	for _, info in pairs(Config.CityHallBlip) do
		local blip = AddBlipForCoord(info.coords)
		SetBlipSprite(blip, info.id)
		SetBlipDisplay(blip, info.display)
		SetBlipScale(blip, info.scale)
		SetBlipColour(blip, info.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.name)
		EndTextCommandSetBlipName(blip)
	end
end)
