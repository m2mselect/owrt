-- Copyright 2016 David Thornley <david.thornley@touchstargroup.com>
-- Licensed to the public under the Apache License 2.0.

local map, section, net = ...

local device, apn, pincode, username, password, modes
local auth, ipv6


device = section:taboption("general", Value, "device", translate("Modem device"))
device.rmempty = false

local device_suggestions = nixio.fs.glob("/dev/cdc-wdm*")

if device_suggestions then
	local node
	for node in device_suggestions do
		device:value(node)
	end
end

modes = section:taboption("general", Value, "modes", translate("Service Type"))
modes:value("", translate("-- Please choose --"))
modes:value("all", "All")
modes:value("lte", "LTE only")
modes:value("umts", "UMTS only")
modes:value("gsm", "GPRS only")

local simman = map.uci:get("simman", "core", "enabled") or "0"
if simman == "0" then
	apn = section:taboption("general", Value, "apn", translate("APN"))
	pincode = section:taboption("general", Value, "pincode", translate("PIN"))
	username = section:taboption("general", Value, "username", translate("PAP/CHAP username"))
	password = section:taboption("general", Value, "password", translate("PAP/CHAP password"))
	password.password = true
else
	apn = section:taboption("general", DummyValue, "apn", translate("APN"), translate("You can configure this value in the SIM manager, or after disabling it"))
	pincode = section:taboption("general", DummyValue, "pincode", translate("PIN"), translate("You can configure this value in the SIM manager, or after disabling it"))
	username = section:taboption("general", DummyValue, "username", translate("PAP/CHAP username"), translate("You can configure this value in the SIM manager, or after disabling it"))
	password = section:taboption("general", DummyValue, "password", translate("PAP/CHAP password"), translate("You can configure this value in the SIM manager, or after disabling it"))
end

auth = section:taboption("general", Value, "auth", translate("Authentication Type"))
auth:value("", translate("-- Please choose --"))
auth:value("both", "PAP/CHAP (both)")
auth:value("pap", "PAP")
auth:value("chap", "CHAP")
auth:value("none", "NONE")

if luci.model.network:has_ipv6() then
    ipv6 = section:taboption("advanced", Flag, "ipv6", translate("Enable IPv6 negotiation"))
    ipv6.default = ipv6.disabled
end
