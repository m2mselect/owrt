local s = require("luci.sys")
local a = require"luci.dispatcher"
local d = require("luci.util")

local i

if arg[1] then
	i = arg[1]
else
	return nil
end

local o,u

local o = Map("gre_tunnel",translatef("GRE Tunnel Instance: %s",i:gsub("^%l",string.upper)),"")
	o.redirect=a.build_url("admin/services/gre-tunnel/")

local a = o:section(NamedSection,i,"gre_tunnel",translate("Main Settings"),"")

e = a:option(Flag,"enabled",translate("Enabled"),translate("Enable GRE (Generic Routing Encapsulation) tunnel."))
	e.rmempty=false

wan_ifname = a:option(Value, "wan_ifname", translate("WAN interface name"))
	wan_ifname:value("", translate("-- Please choose --"))
	wan_ifname:value("3g-internet", "3g-internet")
	wan_ifname:value("wwan0", "wwan0")

mode = a:option(ListValue, "mode", translate("Tunnel mode"))
	mode:value("gre", "GRE")
	mode:value("ipip", "IP-in-IP")

remote_ip = a:option(Value,"remote_ip",translate("Remote endpoint IP address"),translate("IP address of the remote GRE tunnel device."))
	remote_ip.datatype="ip4addr"

remote_network=a:option(Value,"remote_network",translate("Remote network"),translate("IP address of LAN network on the remote device."))
	remote_network.datatype="ipaddr"

remote_netmask=a:option(Value,"remote_netmask",translate("Remote network netmask"),translate("Netmask of LAN network on the remote device. Range [0 - 32]."))
	remote_netmask.datatype="range(0,32)"

function remote_netmask:validate(n)
	local a=tostring(o:formvalue("cbid.gre_tunnel."..i..".remote_network"))
	local e=tostring(luci.util.exec("ipcalc.sh "..a.." "..n.." |grep NETWORK= | cut -d'=' -f2 | tr -d ''"))
	e=e:match("[%w%.]+")
	if a==e then
		return n
	else
		o.message=translatef("err: To match specified netmask, Remote network IP address should be %s",e);
		return nil
	end
	return n
end

t=a:option(Value,"tunnel_ip",translate("Local tunnel IP"),translate("Local virtual IP address. Can not be in the same subnet as LAN network."))
	t.datatype="ipaddr"

l=a:option(Value,"tunnel_netmask",translate("Local tunnel netmask"),translate("Netmask of local virtual IP address. Range [0 - 32]."))
	l.datatype="range(0,32)"

n=a:option(Value,"mtu",translate("MTU"),translate("MTU (Maximum Transmission Unit) for tunnel connection. Range [0 - 1500]."))
	n.datatype="range(0,1500)"

v=a:option(Value,"ttl",translate("TTL"),translate("TTL (Time To Live) for tunnel connection. Range [0 - 255]."))
	v.datatype="range(0,255)"

u=a:option(Flag,"pmtud",translate("PMTUD"),translate("Enable PMTUD (Path Maximum Transmission Unit Discovery) technique for this tunnel."))

return o

