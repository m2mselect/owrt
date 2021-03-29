-- Licensed to the public under the Apache License 2.0.

module("luci.controller.ttyd", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/ttyd") then
		return
	end

	entry({"admin", "system", "ttyd"}, alias("admin", "system", "ttyd", "ttyd"), _("Terminal"),49)
	entry({"admin", "system", "ttyd", "ttyd"}, call("overview"), _("Terminal"))
	entry({"admin", "system", "ttyd", "config"}, cbi("ttyd"), _("Config"))
end

function overview()
	local uci  = require "luci.model.uci".cursor()
	local enable = uci:get_first("ttyd", "ttyd", "enable") or "0"
	local ssl  = uci:get_first("ttyd", "ttyd", "ssl") or "0"
	local port = uci:get_first("ttyd", "ttyd", "port") or "7681"

	luci.template.render("ttyd/overview", {
		enable = tonumber(enable),
		ssl = tonumber(ssl),
		port = tonumber(port)
	})
end
