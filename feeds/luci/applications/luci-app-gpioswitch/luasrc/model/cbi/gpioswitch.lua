--
--
local fs  = require "nixio.fs"
local sys = require "luci.sys"

local gpios = { }

gpios[1] = {name =  "i1",
			mode10 = "echo 51 > /sys/class/gpio/export",
			mode11 = "echo in > /sys/class/gpio/gpio51/direction",
			mode12 = "echo 50 > /sys/class/gpio/export", 
            mode13 = "echo out > /sys/class/gpio/gpio50/direction", 
            mode14 = "echo 0 > /sys/class/gpio/gpio50/value",

            mode20 = "echo 51 > /sys/class/gpio/export",
            mode21 = "echo out > /sys/class/gpio/gpio51/direction",
            mode22 = "echo 0 > /sys/class/gpio/gpio51/value",
            mode23 = "echo 50 > /sys/class/gpio/export",
            mode24 = "echo out > /sys/class/gpio/gpio50/direction",
            mode25 = "echo 0 > /sys/class/gpio/gpio50/value",

            mode30 = "echo 51 > /sys/class/gpio/export",
            mode31 = "echo out > /sys/class/gpio/gpio51/direction",
            mode32 = "echo 1 > /sys/class/gpio/gpio51/value",
            mode33 = "echo 50 > /sys/class/gpio/export",
            mode34 = "echo out > /sys/class/gpio/gpio50/direction",
            mode35 = "echo 1 > /sys/class/gpio/gpio50/value" }

gpios[2] = {name = "i2",
            mode10 = "echo 54 > /sys/class/gpio/export",
			mode11 = "echo in > /sys/class/gpio/gpio54/direction",
			mode12 = "echo 53 > /sys/class/gpio/export", 
            mode13 = "echo out > /sys/class/gpio/gpio53/direction", 
            mode14 = "echo 0 > /sys/class/gpio/gpio53/value",

            mode20 = "echo 54 > /sys/class/gpio/export",
            mode21 = "echo out > /sys/class/gpio/gpio54/direction",
            mode22 = "echo 0 > /sys/class/gpio/gpio54/value",
            mode23 = "echo 53 > /sys/class/gpio/export",
            mode24 = "echo out > /sys/class/gpio/gpio53/direction",
            mode25 = "echo 0 > /sys/class/gpio/gpio53/value",

            mode30 = "echo 54 > /sys/class/gpio/export",
            mode31 = "echo out > /sys/class/gpio/gpio54/direction",
            mode32 = "echo 1 > /sys/class/gpio/gpio54/value",
            mode33 = "echo 53 > /sys/class/gpio/export",
            mode34 = "echo out > /sys/class/gpio/gpio53/direction",
            mode35 = "echo 1 > /sys/class/gpio/gpio53/value" }

gpios[3] = {name = "i3",
            mode10 = "echo 57 > /sys/class/gpio/export",
			mode11 = "echo in > /sys/class/gpio/gpio57/direction",
			mode12 = "echo 64 > /sys/class/gpio/export", 
            mode13 = "echo out > /sys/class/gpio/gpio64/direction", 
            mode14 = "echo 0 > /sys/class/gpio/gpio64/value",

            mode20 = "echo 57 > /sys/class/gpio/export",
            mode21 = "echo out > /sys/class/gpio/gpio57/direction",
            mode22 = "echo 0 > /sys/class/gpio/gpio57/value",
            mode23 = "echo 64 > /sys/class/gpio/export",
            mode24 = "echo out > /sys/class/gpio/gpio64/direction",
            mode25 = "echo 0 > /sys/class/gpio/gpio64/value",

            mode30 = "echo 57 > /sys/class/gpio/export",
            mode31 = "echo out > /sys/class/gpio/gpio57/direction",
            mode32 = "echo 1 > /sys/class/gpio/gpio57/value",
            mode33 = "echo 64 > /sys/class/gpio/export",
            mode34 = "echo out > /sys/class/gpio/gpio64/direction",
            mode35 = "echo 1 > /sys/class/gpio/gpio64/value" }

gpios[4] = {name = "i4",
            mode10 = "echo 66 > /sys/class/gpio/export",
			mode11 = "echo in > /sys/class/gpio/gpio66/direction",
			mode12 = "echo 65 > /sys/class/gpio/export", 
            mode13 = "echo out > /sys/class/gpio/gpio65/direction", 
            mode14 = "echo 0 > /sys/class/gpio/gpio65/value",

            mode20 = "echo 66 > /sys/class/gpio/export",
            mode21 = "echo out > /sys/class/gpio/gpio66/direction",
            mode22 = "echo 0 > /sys/class/gpio/gpio66/value",
            mode23 = "echo 65 > /sys/class/gpio/export",
            mode24 = "echo out > /sys/class/gpio/gpio65/direction",
            mode25 = "echo 0 > /sys/class/gpio/gpio65/value",

            mode30 = "echo 66 > /sys/class/gpio/export",
            mode31 = "echo out > /sys/class/gpio/gpio66/direction",
            mode32 = "echo 1 > /sys/class/gpio/gpio66/value",
            mode33 = "echo 65 > /sys/class/gpio/export",
            mode34 = "echo out > /sys/class/gpio/gpio65/direction",
            mode35 = "echo 1 > /sys/class/gpio/gpio65/value" }

m = SimpleForm("Gpioswitch", "GPIO management", translate("Mode 1 - voltage measurement; Mode 2 - connection of resistance sensors; Mode 3 - load management"))
m.submit = false
m.reset = false

s = m:section(Table, gpios)
-----
o = s:option(DummyValue, "name", translate("GPIO name"))
--
mode1 = s:option(Button, "mode1on", translate("Mode 1"))
mode1.write = function(self, section)
    sys.call("%s" %{gpios[section].mode10})
    sys.call("%s" %{gpios[section].mode11})
    sys.call("%s" %{gpios[section].mode12})
    sys.call("%s" %{gpios[section].mode13})
    sys.call("%s" %{gpios[section].mode14})
end
--
mode2 = s:option(Button, "mode2on", translate("Mode 2"))
mode2.write = function(self, section)
    sys.call("%s" %{gpios[section].mode20})
    sys.call("%s" %{gpios[section].mode21})
    sys.call("%s" %{gpios[section].mode22})
    sys.call("%s" %{gpios[section].mode23})
    sys.call("%s" %{gpios[section].mode24})
    sys.call("%s" %{gpios[section].mode25})
end
--
mode3 = s:option(Button, "mode3on", translate("Mode 3"))
mode3.write = function(self, section)
    sys.call("%s" %{gpios[section].mode30})
    sys.call("%s" %{gpios[section].mode31})
    sys.call("%s" %{gpios[section].mode32})
    sys.call("%s" %{gpios[section].mode33})
    sys.call("%s" %{gpios[section].mode34})
    sys.call("%s" %{gpios[section].mode35})
end
-----

return m
