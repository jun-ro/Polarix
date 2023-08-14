-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

local EventHandler = {}

-- Constructor function for the EventHandler class.
-- Creates a new instance of the class with the provided configuration.
-- Parameters:
--   config: A table containing the configuration options for the EventHandler.

function EventHandler.new(config)
	local self = setmetatable({}, { __index = EventHandler })
	self.config = config
	self.eventQueue = {}
	return self
end

-- Sets the proxy (RemoteEvent) for the EventHandler.
-- Parameters:
--   proxy: The RemoteEvent that will be used for event communication.

function EventHandler:SetProxy(proxy: RemoteEvent)
	self.config.Proxy = proxy
end

-- Retrieves the configuration of the EventHandler.
-- Returns:
--   A table containing the current configuration options.

function EventHandler:GetConfig()
	return self.config
end

-- Creates a new event and returns an event object that can be used to fire the event.
-- Parameters:
--   functionName: The name of the function associated with the event on the server-side.
-- Returns:
--   An event object with the following methods:
--   - FireSignal(...): Fires the event on the server-side with optional arguments.
--   - CloseConnection(): Closes the connection to the event on the server-side.

function EventHandler:CreateEvent(functionName: string)
	local EndpointFolder = self.config.Parent:WaitForChild(self.config.Name)

	local function createUniqueEventId()
		local id
		repeat
			id = math.random(1, 10000)
		until not EndpointFolder:FindFirstChild(tostring(id))
		return tostring(id)
	end

	local eventId = createUniqueEventId()
	self.config.Proxy:FireServer(eventId, false, functionName)
	table.insert(self.eventQueue, eventId)

	local eventObject = {
		id = eventId,
		FireSignal = function(_: any, ...)
			self:EmitSignal(eventId, ...) -- Pass the parameters directly here
		end,
		CloseConnection = function(...)
			self:CloseConnection(eventId)
		end,
		FireAndCloseConnection = function(_: any, ...)
			self:EmitSignal(eventId, ...)
			self:CloseConnection(eventId)
		end,
		
	}

	setmetatable(eventObject, { __index = self })

	return eventObject
end

-- Fires an event on the server-side with the provided arguments.
-- This function waits for the event to exist before firing it.
-- Parameters:
--   id: The unique ID of the event to be fired.
--   ...: Optional arguments to be passed to the server-side function.

function EventHandler:EmitSignal(id, ...)
	local EndpointFolder = self.config.Parent:WaitForChild(self.config.Name)

	local ActivatedEvent
	while not ActivatedEvent do
		ActivatedEvent = EndpointFolder:FindFirstChild(tostring(id))
		wait(0.1) -- Adjust the wait time as needed (0.1 seconds here)
	end

	ActivatedEvent:FireServer(...)
end

-- Closes the connection to the event on the server-side and removes eventQueue ID from eventQueue list.
-- Parameters:
--   id: The unique ID of the event to be closed.

function EventHandler:CloseConnection(id)
	self.config['Proxy']:FireServer(id, true)
	
	
	for i, eventID in pairs(self.eventQueue) do
		if eventID == id then
			table.remove(self.eventQueue, i)
			break
		end
	end
	
	print("Connection Closed for", id)
end

-- Removes all events created using CreateEvent from the event queue and closes their connections.

function EventHandler:Purge()
	local queue = self.eventQueue 

	for _, ids in pairs(queue) do
		self:CloseConnection(ids)
	end
end

return EventHandler
