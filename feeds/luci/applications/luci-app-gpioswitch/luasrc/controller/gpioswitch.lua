module("luci.controller.gpioswitch", package.seeall)

function index()
    local page
    page = entry({"admin", "services", "gpioswitch"}, cbi("gpioswitch"), _(translate("GPIO")))
    page.dependent = true
end