ESX = exports["es_extended"]:getSharedObject()


ESX.RegisterServerCallback('dms_flyjob:get', function(source, cb)
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM dms_flyjob WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
    cb(result)
end)

RegisterServerEvent('dms_flyjob:jobexp')
AddEventHandler('dms_flyjob:jobexp',function()
    local _source = source
	local steamt = GetPlayerIdentifier(_source, 0)
	local namePlayer = GetPlayerName(_source)
    local addexp = Config.addexp.givexp
	MySQL.Async.fetchAll('SELECT * FROM dms_flyjob WHERE identifier = @identifier', { 
		['@identifier'] = steamt,
	}, function(result2)
		if result2[1] == nil then
			MySQL.Async.execute('INSERT INTO dms_flyjob (`identifier`, `name`, `exp`) VALUES (@identifier, @name, @exp)', {['@identifier'] = steamt, ['@name'] = namePlayer, ['@exp'] = 1})
		else
            if result2[1].exp < Config.addexp.expmax then
                rChoice({
                    {Config.addexp.random, function(val)
                        MySQL.Async.execute('UPDATE dms_flyjob SET `exp` = @exp, `name` = @name WHERE identifier = @identifier', {
                            ['@exp'] = result2[1].exp + addexp,
                            ['@name'] = namePlayer,
                            ['@identifier'] = steamt
                        })
                        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = Config.locales[20]..addexp.. Config.locales[24] })
                    end},
                    {Config.addexp.random2, function(val)
                        MySQL.Async.execute('UPDATE dms_flyjob SET `exp` = @exp, `name` = @name WHERE identifier = @identifier', {
                            ['@exp'] = result2[1].exp,
                            ['@name'] = namePlayer,
                            ['@identifier'] = steamt
                        })
                        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = Config.locales[22] })
                    end}
                })
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = Config.locales[21]..Config.addexp.expmax })
            end
		end
	end)
end)

RegisterServerEvent('dms_flyjob:money')
AddEventHandler('dms_flyjob:money',function()
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM dms_flyjob WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
    local name = result[1].name
    local ep = result[1].exp
    for k,v in pairs(Config.exp) do
        if ep >= v.xp and ep <= v.xp1 then
            xPlayer.addMoney(v.money)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = Config.locales[23]..v.money.. Config.locales[25] })
        end
    end
end)

function rChoice(data)
    local min, max, total = 1, 0, 0
    for _, d in ipairs(data) do
        total = total + d[1]
    end

    local val = math.random(1, total)
    for _, d in ipairs(data) do
        max = max + d[1]
        if val >= min and val <= max then
            d[2](val)
        end
        min = min + d[1]
    end
end