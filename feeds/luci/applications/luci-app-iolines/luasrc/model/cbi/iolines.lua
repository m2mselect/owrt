local fs  = require "nixio.fs"
local sys = require "luci.sys"

m = Map("iolines", "Universal I/O lines", translate("Mode 1 - voltage measurement; Mode 2 - resistive sensor connection; Mode 3 - load management"))

s = m:section(TypedSection, "io")
s.anonymous = true
s.addremove = false
s.template = "cbi/tblsection"

o = s:option(DummyValue, "name", translate("I/O name"))

mode = s:option(ListValue, "mode", translate("Mode"))
  mode.default = "mode1"
  mode:value("mode1", "Mode 1")
  mode:value("mode2", "Mode 2")
  mode:value("mode3", "Mode 3")
  mode.optional = false

enabled = s:option(Flag, "enabled", translate("Run on startup"))
  enabled.rmempty = false

voltage = s:option(DummyValue, "voltage", translate("Measured voltage on ADC, mV"))
    function voltage.cfgvalue(self, section)
        local dev = self.map:get(section, "dev")
        local test = io.popen("cat %s" %{dev})
        local result = test:read("*a")
        test:close()
        result = result * 4.365
        return tonumber(string.format("%.0f", result))
    end

resist = s:option(DummyValue, "resist", translate("Measured resistance by ADC, Ohm"))
    function resist.cfgvalue(self, section)
        local dev = self.map:get(section, "dev")
        local test = io.popen("cat %s" %{dev})
        local result = test:read("*a")
        test:close()
        result = result * 0.543
        return tonumber(string.format("%.0f", result))
    end
    resist:depends("mode","mode2")

refresher = s:option( Button, "refresher", translate("Refresh measuring") )  
  refresher.title      = translate("Refresh measuring")
  refresher.inputtitle = translate("Refresh")
  refresher.inputstyle = "apply"
  function refresher.write()
     
  end

return m
