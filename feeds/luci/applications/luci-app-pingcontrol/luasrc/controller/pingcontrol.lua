module("luci.controller.pingcontrol", package.seeall)

function index()
	entry( {"admin", "services", "pingcontrol"}, arcombine(cbi("pingcontrol"),cbi("pingcontrol_edit")), _("PingControl"),5).leaf=true
end
