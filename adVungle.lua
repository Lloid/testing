local _M = {
	callback = {}
}
local ads = require "ads"
local timeslimit = 1
local appId = "5591042321ebd6dd5f000138"
adLog = {}

--

local function defaultHandler()
end

--
function _M:addListener(newlistener, name)
	if ( newlistener and type(newlistener) == "function" ) then
    	_M.callback[tostring(name)] = newlistener
    else
    	print('no callback function input')
    end
end
--
function _M:init(adButtonHandler)

	if ( adButtonHandler and type(adButtonHandler) == "function" ) then
    	_M.callback["buttonHandler"] = adButtonHandler
    else
    	_M.callback["buttonHandler"] = defaultHandler
    end

	local function adListener(event)
        if ( event.type == "adStart" and event.isError ) then
            print('ads is caching')
            for k,v in pairs(_M.callback) do v(event) end
        end
        if ( event.type == "adStart" and not event.isError ) then
            print('ad is playing')
            for k,v in pairs(_M.callback) do v(event) end
        end
        if ( event.type == "cachedAdAvailable" ) then
        	print('ad is ready.')
            for k,v in pairs(_M.callback) do v(event) end
        end
        if ( event.type == "adView" ) then
        	print('ad is viewed.')
            for k,v in pairs(_M.callback) do v(event) end
        end
        if ( event.type == "adEnd" ) then
        	print('returned to the apps.')
            for k,v in pairs(_M.callback) do v(event) end
        end
    end
	ads.init("vungle", appId, adListener)
end
--
function _M.showAd()
    -- local alert = native.showAlert("Congrats!", "fire!", { "OK" })
	ads.show("incentivized")
end
--
function _M:isReady()
    return ads.isAdAvailable()
end
--
return _M