local EventSystemFolder = script.Modules.EventSystem
local GlobalFunctions 	= script.Modules.GlobalFunctions
local Config 			= script.Config
local Seeker = {}
Seeker.__index = Seeker

function Seeker.new()
	local self = setmetatable({}, Seeker)
	self.EventHandler = require(EventSystemFolder.EventHandler)
	self.ServerHandler = require(EventSystemFolder.ServerHandler)
	self.defaultConfig = require(Config.EventData)
	return self
end

function Seeker:InitiateServer<T>(config: {}, Proxy: RemoteEvent, EventsList: {})
	
	-- Stupid Print Console thingy
	
	print("   ██████ ▓█████ ▓█████  ██ ▄█▀▓█████  ██▀███     ")
	print(" ▒██    ▒ ▓█   ▀ ▓█   ▀  ██▄█▒ ▓█   ▀ ▓██ ▒ ██▒   ")
	print(" ░ ▓██▄   ▒███   ▒███   ▓███▄░ ▒███   ▓██ ░▄█ ▒   ")
	print("   ▒   ██▒▒▓█  ▄ ▒▓█  ▄ ▓██ █▄ ▒▓█  ▄ ▒██▀▀█▄     ")
	print(" ▒██████▒▒░▒████▒░▒████▒▒██▒ █▄░▒████▒░██▓ ▒██▒   ")
	print(" ▒ ▒▓▒ ▒ ░░░ ▒░ ░░░ ▒░ ░▒ ▒▒ ▓▒░░ ▒░ ░░ ▒▓ ░▒▓░   ")
	print(" ░ ░▒  ░ ░ ░ ░  ░ ░ ░  ░░ ░▒ ▒░ ░ ░  ░  ░▒ ░ ▒░   ")
	print(" ░  ░  ░     ░      ░   ░ ░░ ░    ░     ░░   ░    ")
	print("       ░     ░  ░   ░  ░░  ░      ░  ░   ░        ")
	print("			 	  Server has started.		 	 	 ")
	
	
	local Server = self.ServerHandler.new(config)
	Server:SetProxy(Proxy)
	Server:SetEvents(EventsList)
	Server:Setup()
	Server:Hook()
end




return Seeker	
