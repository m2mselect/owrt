module("luci.controller.iolines", package.seeall)

function index()
    local page
    page = entry({"admin", "services", "iolines"}, cbi("iolines"), _(translate("I/O lines")))
    page.dependent = true
end