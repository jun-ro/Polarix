local Polarix = require(game:GetService("ReplicatedStorage").Polarix).new()
local Proxy = game:GetService("ReplicatedStorage").Polarix.Events.Proxy

Polarix:InitiateServer(Polarix.defaultConfig, Proxy, require(script.EventsList))
