--
--

require 'luci.sys'

arg[1] = arg[1] or ""

m = Map("pollmydevice", translate("PollMyDevice"), translate("TCP to RS232/RS485 converter"))

s = m:section(NamedSection, arg[1], "pollmydevice", translate("Utility Settings"))
s.addremove = false

devicename = s:option(DummyValue, "devicename", translate("Port"))

mode = s:option(ListValue, "mode", translate("Mode"))
  mode.default = "disabled"
  mode:value("disabled")
  mode:value("server")
  mode:value("client")
  mode.optional = false

baudrate = s:option(ListValue, "baudrate",  translate("BaudRate"))
  baudrate.default = 9600
  baudrate:value(300)
  baudrate:value(600)
  baudrate:value(1200)
  baudrate:value(2400)
  baudrate:value(4800)
  baudrate:value(9600)
  baudrate:value(19200)
  baudrate:value(38400)
  baudrate:value(57600)
  baudrate:value(115200)
  baudrate:value(230400)
  baudrate:value(460800)
  baudrate:value(921600)
  baudrate.optional = false
  baudrate.datatype = "uinteger"
  baudrate:depends("mode","server")
  baudrate:depends("mode","client")

bytesize = s:option(ListValue, "bytesize", translate("ByteSize"))
  bytesize.default = 8
  bytesize:value(5)
  bytesize:value(6)
  bytesize:value(7)
  bytesize:value(8)
  bytesize.optional = false
  bytesize.datatype = "uinteger"
  bytesize:depends("mode","server")
  bytesize:depends("mode","client")

stopbits = s:option(ListValue, "stopbits", translate("StopBits"))
  stopbits.default = 1
  stopbits:value(1)
  stopbits:value(2)
  stopbits.optional = false
  stopbits.datatype = "uinteger"
  stopbits:depends("mode","server")
  stopbits:depends("mode","client")

parity = s:option(ListValue, "parity", translate("Parity"))
  parity.default = "none"
  parity:value("even")
  parity:value("odd")
  parity:value("none")
  parity.optional = false
  parity.datatype = "string"
  parity:depends("mode","server")
  parity:depends("mode","client")

flowcontrol = s:option(ListValue, "flowcontrol", translate("Flow Control"))
  flowcontrol.default = "none"
  flowcontrol:value("XON/XOFF")
  flowcontrol:value("RTS/CTS")
  flowcontrol:value("none")
  flowcontrol.optional = false
  flowcontrol.datatype = "string"
  flowcontrol:depends("mode","server")
  flowcontrol:depends("mode","client")

server_port = s:option(Value, "server_port",  translate("Server Port"))
  server_port.datatype = "and(uinteger, min(1025), max(65535))"
  --server_port.rmempty = false
  server_port:depends("mode","server")

conn_time = s:option(Value, "conn_time",  translate("Connection Hold Time (sec)"))
  conn_time.default = 60
  conn_time.datatype = "and(uinteger, min(0), max(100000))"
  --conn_time.rmempty = false
  conn_time:depends("mode","server")

modbus_gateway = s:option(ListValue, "modbus_gateway", translate("Modbus TCP/IP"))  -- create checkbox
  modbus_gateway.default = 0
  modbus_gateway:value(0,"disabled")
  modbus_gateway:value(1,"RTU")
  modbus_gateway:value(2,"ASCII")
  modbus_gateway:depends("mode","client")
  modbus_gateway:depends("mode","server")

client_host = s:option(Value, "client_host",  translate("Server Host or IP Address"))
  client_host.default = ""
  client_host.datatype = "string"
  client_host:depends("mode","client")

client_port = s:option(Value, "client_port",  translate("Server Port"))
  client_port.default = 6008
  client_port.datatype = "and(uinteger, min(1025), max(65535))"
  --client_port.rmempty = false
  client_port:depends("mode","client")

client_timeout = s:option(Value, "client_timeout",  translate("Client Reconnection Timeout (sec)"))
  client_timeout.default = 60
  client_timeout.datatype = "and(uinteger, min(0), max(100000))"
  --client_timeout.rmempty = false
  client_timeout:depends("mode","client")

client_auth = s:option(Flag, "client_auth", translate("Client Authentification"), translate("Use Authentification by ID"))  -- create enable checkbox
  client_auth.default = 1
  --client_auth.rmempty = false
  client_auth:depends("mode","client")

adtid = s:option(DummyValue, "adtid",  translate("Device ID"))
  --client_auth.rmempty = false
  adtid:depends("mode","client")

coff = s:option(Button, "coff", translate("Disable console port"), translate("Save the changes. The router will reboot"))  
  coff.title      = translate("Disable console port")
  coff.inputtitle = translate("Disable")
  coff.inputstyle = "apply"
  coff:depends("devicename","/dev/com0")
  function coff.write()
     luci.sys.call("/etc/pollmydevice/console disable")
  end

con = s:option(Button, "con", translate("Enable console port"), translate("Save the changes. The router will reboot"))  
  con.title      = translate("Enable console port")
  con.inputtitle = translate("Enable")
  con.inputstyle = "apply"
  con:depends("devicename","/dev/com0")
  function con.write()
     luci.sys.call("/etc/pollmydevice/console enable")
  end

return m
