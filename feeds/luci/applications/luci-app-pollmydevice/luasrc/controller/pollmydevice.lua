module("luci.controller.pollmydevice", package.seeall)

function index()

    if not nixio.fs.access("/etc/config/pollmydevice") then
        return
    end

    local uci = require("luci.model.uci").cursor()
    local page 
    local nameifc = '0'
    page = node("admin", "services")

    page = entry({"admin", "services", "pollmydevice"}, cbi("pollmydevice"), _(translate("PollMyDevice")))
    page.leaf   = true
    page.subindex = true

    uci:foreach("pollmydevice", "interface",
        function (section)
            local ifc = section[".name"]
            if ifc == '0' then
                nameifc = 'RS485'
            elseif ifc == '1' then
                nameifc = 'RS232'
            end
            entry({"admin", "services", "pollmydevice", ifc}, true, nameifc:upper())
        end)

end
