
local fs  = require "nixio.fs"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local utl = require ("luci.util")
local CFG_MAP = "gre_tunnel"
local CFG_SEC = "gre_tunnel"

local m, s, o

m = Map(CFG_MAP, translate("Generic Routing Encapsulation Tunnel"))
m.spec_dir = nil

s = m:section( TypedSection, CFG_SEC, translate(""), translate("") )
s.addremove = true
s.anonymous = true
s.template = "cbi/tblsection"
s.template_addremove = "gre-tunnel/gre_add_rem"
s.addremoveAdd = true
s.novaluetext = translate("There are no GRE Tunnel configurations yet")

uci:foreach(CFG_MAP, CFG_SEC, function(sec)
	s.addremoveAdd = false
end)

s.extedit = luci.dispatcher.build_url("admin", "services", "gre-tunnel", "%s")

local name = s:option( DummyValue, "name", translate("Tunnel name"))

function name.cfgvalue(self, section)
	return section:gsub("^%l", string.upper) or "Unknown"
end

status = s:option(Flag, "enabled", translate("Enable"))

wan_ifname = s:option( DummyValue, "wan_ifname", translate("WAN interface name"))

	function wan_ifname.cfgvalue(self, section)
		return self.map:get(section, self.option) or "Unknown"
	end

remote_ip = s:option( DummyValue, "remote_ip", translate("Remote VPN endpoint"))

	function remote_ip.cfgvalue(self, section)
		return self.map:get(section, self.option) or "Unknown"
	end

tunnel_ip = s:option( DummyValue, "tunnel_ip", translate("Local tunnel IP"))

	function tunnel_ip.cfgvalue(self, section)
		return self.map:get(section, self.option) or "Unknown"
	end

mode = s:option( DummyValue, "mode", translate("Tunnel mode"))

	function mode.cfgvalue(self, section)
		return self.map:get(section, self.option) or "Unknown"
	end

function s.parse(self, section)
	local cfgname = luci.http.formvalue("cbid." .. self.config .. "." .. self.sectiontype .. ".name") or ""
	local delButtonFormString = "cbi.rts." .. self.config .. "."
	local delButtonPress = false
	local configName
	local uFound
	local existname = false
	uci:foreach("gre_tunnel", "gre_tunnel", function(x)
		if not delButtonPress then
			configName = x[".name"] or ""
			if luci.http.formvalue(delButtonFormString .. configName) then
				delButtonPress = true
			end
		end
		newname= "gre_"..cfgname
		if configName == newname then
			existname = true
		end
	end)
	if delButtonPress then
		luci.sys.call("ip tunnel del "..configName.." 2> /dev/null ")
		luci.sys.call("logger [GRE-TUN] "..configName.." Cleaning up...")
		uci.delete("gre_tunnel", configName)
		uci.save("gre_tunnel")
		luci.sys.call("/etc/init.d/gre-tunnel restart >/dev/null")
		cfgname = false
		uci.commit("gre_tunnel")
	end
	if cfgname and cfgname ~= '' then
		openvpn_new(self, cfgname, existname)
	end
	TypedSection.parse( self, section )
	uci.commit("gre_tunnel")
end

function openvpn_new(self,name, exist)

	local t = {}

	if exist then
		name = ("gre_"..name)
		m.message = translatef("err: Name %s already exists.", name)
	elseif name and #name > 0 then

		if not (string.find(name, "[%c?%p?%s?]+") == nil) then
			m.message = translate("err: Only alphanumeric characters are allowed.")
		else
		namew = name
		name = ("gre_"..name)
		t["enabled"]= "0"
		t["ifname"]= name
		t["mtu"] = "1476"
		t["ttl"] = "255"
		t["tunnel_ip"] = ""
		t["mode"] = "gre"
		t["tunnel_netmask"] = ""
		t["remote_ip"] = ""
		t["remote_network"] = ""
		t["remote_netmask"] = ""
		uci:section("gre_tunnel", "gre_tunnel", name,t)
		uci:save("gre_tunnel")
		uci.commit("gre_tunnel")
		m.message = translate("scs:New Gre-tunnel instance was created successfully. Configure it now")
		end
	else
		m.message = translate("err: To create a new Gre-tunnel instance it's name has to be entered!")
	end
end

local save = m:formvalue("cbi.apply")
if save then
	m.uci:foreach("gre_tunnel", "gre_tunnel", function(s)
		gre_inst = s[".name"] or ""
		greEnable = m:formvalue("cbid.gre_tunnel." .. gre_inst .. ".enabled") or "0"
		gre_vpn_enable = s.enabled or "0"
		if greEnable ~= gre_vpn_enable then
			m.uci:foreach("gre_tunnel", "gre_tunnel", function(a)
				gre_inst2 = a[".name"] or ""
				local usr_enable = a.usr_enable or ""
				if usr_enable == "1" then
					m.uci:delete("gre_tunnel", gre_inst2, "usr_enable")
				end
			end)
		end
	end)
	m.uci:save("gre_tunnel")
	m.uci.commit("gre_tunnel")
end

return m
