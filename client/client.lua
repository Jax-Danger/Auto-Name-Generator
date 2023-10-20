local isNear = false

local point = lib.points.new({ 
	coords = Config.ChangeNameLoc.coords,
	distance = 2.0
})

function point:onEnter()
	isNear = true
	lib.showTextUI('Press [E] to change your name.', {
		position = "right-center",
		icon = 'user',
		style = {
			borderRadius = 0,
			backgroundColor = '#48BB78',
			color = '#white',
		}
	})
	TriggerEvent('names:changeName')
end
function point:onExit()
	isNear = false
	lib.hideTextUI()
end


RegisterNetEvent('names:notify:NameChanged')
AddEventHandler('names:notify:NameChanged', function(firstname, lastname)
	-- notify the player they have a new name
	lib.notify({
		title = 'City Hall',
		description = 'You\'re new name is ' .. firstname .. ' ' .. lastname,
		type = 'success',
		position = 'center-right'
	})
end)

RegisterNetEvent('names:notify:NameDisplay')
AddEventHandler('names:notify:NameDisplay', function(firstName, lastName)
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
				color = '#ffffff',
			}
		},
		icon = 'check',
		iconColor = '#03C5AC'
	})
end)

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

RegisterNetEvent('names:changeName')
AddEventHandler('names:changeName', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0) -- wait 0 milliseconds
			if isNear then
				if IsControlJustReleased(0, 38) then -- If 'E' is pressed
					local input = lib.inputDialog('City Hall: Change your name.', {
						{type = 'input', labe = 'First Name', description = 'Change your First Name.', required = true, min = 3, max = 10},
						{type = 'input', labe = 'Last Name', description = 'Change your Last Name.', required = true, min = 3, max = 10},
					})
					if input then
						local firstname = input[1]
						local lastname = input[2]
						if lib.alertDialog({
							header = 'City Hall',
							content = 'Confirm  your name change to ' .. input[1] .. ' ' .. input[2] .. '.',
							centered = true,
							cancel = true,
						}) then
							TriggerServerEvent('names:newName', firstname, lastname)
						else
							lib.notify({
								title = 'City Hall',
								description = 'You have canceled your name change.',
								type = 'error',
								position = 'center-right'
							})
						end
					end
				end
			end
		end
	end)
end)