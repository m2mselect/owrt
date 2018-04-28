module("luci.controller.smscontrol", package.seeall)

function index()
    local page
    page = entry({"admin", "services", "smscontrol"}, cbi("smscontrol"), _(translate("Remote SMS Control")))
    page.dependent = true
end