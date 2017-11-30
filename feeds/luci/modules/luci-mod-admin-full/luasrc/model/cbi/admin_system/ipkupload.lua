-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008-2011 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local fs = require "nixio.fs"
local ipkg = require "luci.model.ipkg"

f = SimpleForm("ipkupload", translate("Upload package"), nil)
f.reset = false
f.submit = false

sul = f:section(SimpleSection, "", nil)
fu = sul:option(FileUpload, "")
fu.template = "cbi/other_upload"
um = sul:option(DummyValue, "", nil)

local dir, filename, fd
dir = "/tmp/ipkupload/"
filename = "/tmp/ipkupload/tmp.ipk"
luci.http.setfilehandler(
    function(meta, chunk, eof)
        if not fd then
        	if meta and meta.name == "ulfile" then
        		nixio.fs.mkdir(dir)
				fd = io.open(filename, "w")
			end
        end
        if chunk and fd then
            fd:write(chunk)
        end
        if eof and fd then
            fd:close()
            fd = nil
        end
    end
)


if luci.http.formvalue("upload") then
    local file = luci.http.formvalue("ulfile")
	local succ = ipkg.install(filename)
    if succ == 0 then
        um.value = translate("Package installed")
    else
        um.value = translate("Error")
	end
    nixio.fs.remove(filename)
	nixio.fs.rmdir(dir)
    nixio.fs.unlink("/tmp/luci-indexcache")
end

return f
