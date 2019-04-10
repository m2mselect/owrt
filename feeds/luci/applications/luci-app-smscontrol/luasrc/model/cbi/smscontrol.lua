local fs  = require "nixio.fs"
local sys = require "luci.sys"

m = Map("smscontrol", "Remote SMS control", translate("Here you can send commands to router via a call or SMS"))

n = m:section(NamedSection, "common", "smscontrol")

enabled = n:option(Flag, "enabled", translate("Enabled"), translate(""))
  enabled.rmempty = false

pass = n:option(Value, "pass",  translate("Password"))
  function pass.cfgvalue(self, section)
    value = self.map:get(section, self.option)
    if value == nil then
      local test = io.popen("getserialnum")
      local value = test:read("*a")
      test:close()
      return value
    else
      return value
    end
  end
  pass.rmempty = false
  pass.optional = false
  pass.datatype = "and(uciname,maxlength(15))"

whitelist = n:option(DynamicList, "whitelist",  translate("Allowed phone numbers"))
  whitelist.datatype = "phonedigit"
  whitelist.cast = "string"
  whitelist.rmempty =true

s = m:section(TypedSection, "remote", translate("Command over SMS"), translate("For example, if you enter '1234' as a password and send an SMS command '1234;reboot' to the router, the router will reboot"))
s.rmempty = true
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

enabled = s:option(Flag, "enabled", translate("Enable"))
  enabled.rmempty = false

ack = s:option(Flag, "ack", translate("Reply via SMS"))
  ack.rmempty = true

received = s:option(Value, "received", translate("Message text"))
  received.rmempty =false
  received.optional = false

command = s:option(Value, "command", translate("Linux command"))
  command.rmempty =false
  command.optional = false

l = m:section(TypedSection, "cli", translate("Universal command over SMS"), translate("For example, if you enter '1234' as a password and send an SMS command '1234;CLI$ifconfig br-lan down' to the router, the router will execute CLI-command ifconfig br-lan down"))
l.rmempty = true
l.anonymous = true
l.addremove = false
l.template = "cbi/tblsection"

enabled = l:option(Flag, "enabled", translate("Enable"))
  enabled.rmempty = false

ack = l:option(Flag, "ack", translate("Reply via SMS"))
  ack.rmempty = true

received = l:option(DummyValue, "received", translate("Message text"))
  received.rmempty =false
  received.optional = false
  received.value = "CLI$any_cli_command_here"

command = l:option(DummyValue, "command", translate("Linux command"))
  command.rmempty =false
  command.optional = false
  command.value = "any_cli_command_here"

c = m:section(TypedSection, "call", translate("Command over call"), translate("You can make a call from the allowed phone number and then the router will execute the command"))
c.rmempty = true
c.anonymous = true
c.addremove = false
c.template = "cbi/tblsection"

enabled = c:option(Flag, "enabled", translate("Enable"))
  enabled.rmempty = false

ack = c:option(Flag, "ack", translate("Reply via SMS"))
  ack.rmempty = true

command = c:option(Value, "command", translate("Linux command"))
  command.rmempty =false
  command.optional = false

k = m:section(NamedSection, "send", "smscontrol", translate("Send SMS"))
k.rmempty = true

to = k:option(Value, "to",  translate("To phone number"))
  to.datatype = "phonedigit"
  to.cast = "string"
  to.rmempty =true
  to.optional =false

msgtxt = k:option(Value, "msgtxt", translate("Message text"))
  msgtxt.rmempty =true
  msgtxt.optional =false

sendsms = k:option(Button, "sendsms", translate("Send") )  
  sendsms.title      = translate(" ")
  sendsms.inputtitle = translate("Send")
  sendsms.inputstyle = "apply"
  function sendsms.write(self, section)
    local to = self.map:get(section, "to")
    local msgtxt = self.map:get(section, "msgtxt")
    local err = self.map:get(section, "err")
    if msgtxt == nil then
      luci.sys.call("/etc/smscontrol/sendsms error error &" %{msgtxt})
      return self.map:set(section, "err", "Empty message")
    else
      if to == nil then
        luci.sys.call("/etc/smscontrol/sendsms error '%s' &" %{msgtxt})
        return self.map:set(section, "err", "You must specify a phone number")
      else
        luci.sys.call("/etc/smscontrol/sendsms %s '%s' &" %{to, msgtxt})
        self.map:set(section, "to", "")
        self.map:set(section, "msgtxt", "")
        return self.map:set(section, "err", "")
      end
    end
  end

err = k:option(DummyValue, "err", translate(" "))
  err.rmempty =true
  err.optional =false

return m
