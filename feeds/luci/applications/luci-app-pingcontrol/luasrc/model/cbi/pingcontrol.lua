local sys = require "luci.sys"
local utl = require "luci.util"
local uci = require "luci.model.uci".cursor()

m = Map("pingcontrol", "PingControl", translate("Server availability check"))

section_gen = m:section(TypedSection, "pingcontrol")
section_gen.anonymous = true
section_gen.addremove = true
section_gen.template = "cbi/tblsection"
section_gen.template_addremove = "pingcontrol/add_rem"
section_gen.extedit = luci.dispatcher.build_url("admin", "services", "pingcontrol", "%s")

local name = section_gen:option( DummyValue, "name", translate("Configuration name"))

function name.cfgvalue(self, section)
  return section or "Unknown"
end

enabled = section_gen:option(Flag, "enabled", translate("Enabled"))
 enabled.rmempty = false
iface = section_gen:option(DummyValue, "iface",  translate("Interface"))
testip = section_gen:option(DummyValue, "testip",  translate("IP address"))
sw_before_sysres = section_gen:option(DummyValue, "sw_before_sysres",  translate("Reboot"))
function sw_before_sysres.cfgvalue(self, section)
  value = self.map:get(section, self.option)
  if value == "0" or value == nil then
    return translate("no")
  else
    return translate("yes")
  end
end

function section_gen.parse(self, section)
  local cfgname = luci.http.formvalue("cbid." .. self.config .. "." .. self.sectiontype .. ".name") or ""
  local configName
  local existname = false
  uci:foreach("pingcontrol", "pingcontrol", function(x)
    configName = x[".name"] or ""
    if configName == cfgname then
      existname = true
    end
  end)
  if cfgname and cfgname ~= '' then
    new_instance(self, cfgname, existname)
  end
  TypedSection.parse(self, section)
  uci.commit("pingcontrol")
end

function new_instance(self,name, exist)
  local t = {}
  if exist then
    m.message = translatef("ERROR: Name %s already exists", name)
  elseif name and #name > 0 then
    if not (string.find(name, "[%c?%p?%s?]+") == nil) then
      m.message = translate("ERROR: Only alphanumeric characters are allowed")
    else
    t["enabled"]= "0"
    t["check_period"]= "30"
    t["iface"] = "internet"
    t["testip"] = "8.8.8.8"
    t["sw_before_modres"] = "3"
    uci:section("pingcontrol", "pingcontrol",name,t)
    uci:save("pingcontrol")
    uci.commit("pingcontrol")
    m.message = translate("SUCCES: New instance was created. Configure it now")
    end
  else
    m.message = translate("ERROR: To create a new Gre-tunnel instance it's name has to be entered")
  end
end

return m
