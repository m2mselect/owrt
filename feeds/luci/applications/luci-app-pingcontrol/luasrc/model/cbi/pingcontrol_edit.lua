local sys = require "luci.sys"
local utl = require "luci.util"
local a = require"luci.dispatcher"


local m = Map("pingcontrol",translatef("PingControl Instance: %s",arg[1]),"")
	m.redirect=a.build_url("admin/services/pingcontrol/")

section_gen = m:section(NamedSection, arg[1], "pingcontrol", translate("General settings"))  -- create general section

enabled = section_gen:option(Flag, "enabled", translate("Enabled"), translate("Enabled"))  -- create enable checkbox
  enabled.rmempty = false

check_period = section_gen:option(Value, "check_period",  translate("Period of check, sec"))
  check_period.default = 60
  check_period.datatype = "and(uinteger, min(20))"
  check_period.rmempty = false
  check_period.optional = false

iface = section_gen:option(Value, "iface",  translate("Ping interface"))
  iface.default = internet
  local _, object
  for _, object in ipairs(utl.ubus()) do
    local net = object:match("^network%.interface%.(.+)")
    if net and net ~= "loopback" then iface:value(net) end
  end


testip = section_gen:option(DynamicList, "testip",  translate("IP address of remote server"))
  testip.datatype = "ipaddr"
  testip.cast = "string"
  testip.rmempty = false
  testip.optional = false

sw_before_modres = section_gen:option(Value, "sw_before_modres",  translate("Failed attempts before iface up/down"),  translate("0 - not used"))
  sw_before_modres.default = 0
  sw_before_modres.datatype = "and(uinteger, min(0), max(100))"
  sw_before_modres.rmempty = false
  sw_before_modres.optional = false

sw_before_sysres = section_gen:option(Value, "sw_before_sysres",  translate("Failed attempts before reboot"),  translate("0 - not used"))
  sw_before_sysres.default = 0
  sw_before_sysres.datatype = "and(uinteger, min(0), max(100))"
  sw_before_sysres.rmempty = false
  sw_before_sysres.optional = false

return m
