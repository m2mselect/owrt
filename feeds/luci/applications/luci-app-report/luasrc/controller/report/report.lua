module("luci.controller.report.report", package.seeall)

function index()
	entry({"admin", "status", "report"}, call("action_flashops"), _("Report"), 20)
end

function action_flashops()
	local sys = require "luci.sys"
	local fs  = require "nixio.fs"
	
	if luci.http.formvalue("report") then
		--
		-- Assemble file list, generate backup
		--
		
		if luci.http.formvalue("dmesg") then
			fork_exec("dmesg &> /tmp/report/dmesg.txt")
		end
		if luci.http.formvalue("sslog") then
			fork_exec("logread &> /tmp/report/logread.txt")
		end
		if luci.http.formvalue("network") then
			fork_exec("cat /etc/config/network &> /tmp/report/network.txt")
			fork_exec("cat /etc/config/firewall &> /tmp/report/firewall.txt")
			fork_exec("cat /etc/config/wireless &> /tmp/report/wireless.txt")
			fork_exec("route -n &> /tmp/report/route.txt")
			fork_exec("ifconfig &> /tmp/report/ifconfig.txt")
			fork_exec("iptables -S &> /tmp/report/iptables.txt")
		end
		if luci.http.formvalue("simman") then
			fork_exec("cat /etc/config/simman &> /tmp/report/simman.txt")
			fork_exec("simman_getinfo &> /tmp/report/simman_info.txt")
			os.execute("sleep 10")
		end
		if luci.http.formvalue("openvpn") then
			fork_exec("cat /etc/config/openvpn &> /tmp/report/openvpn.txt")
		end
		if luci.http.formvalue("mwan") then
			fork_exec("cat /etc/config/mwan3 &> /tmp/report/mwan.txt")
		end
		if luci.http.formvalue("pollmydevice") then
			fork_exec("cat /etc/config/pollmydevice &> /tmp/report/pollmydevice.txt")
		end
		if luci.http.formvalue("pollmydevice") then
			fork_exec("cat /etc/config/pollmydevice &> /tmp/report/pollmydevice.txt")
		end
		if luci.http.formvalue("ntp") then
			fork_exec("ntpq -p &> /tmp/report/ntpqp.txt")
			os.execute("sleep 10")
			fork_exec("cat /etc/ntp.conf &> /tmp/report/ntp.txt")
		end
		if luci.http.formvalue("sms") then
			fork_exec("cat /etc/config/smscontrol &> /tmp/report/smscontrol.txt")
			fork_exec("cat /etc/smsd.conf &> /tmp/report/smsd.txt")
			fork_exec("cat /var/log/smsd.log &> /tmp/report/smsdlog.txt")
		end
		if luci.http.formvalue("snmp") then
			fork_exec("cat /etc/config/snmpd &> /tmp/report/snmpd.txt")
		end

		local reader = ltn12_popen("cd /tmp/ && tar -czf - report 2>/dev/null")
		luci.http.header('Content-Disposition', 'attachment; filename="report-%s-%s.tar.gz"' % {
			luci.sys.hostname(), os.date("%Y-%m-%d")})
		luci.http.prepare_content("application/x-targz")
		luci.ltn12.pump.all(reader, luci.http.write)
		fork_exec("rm /tmp/report/*")
	else
		fork_exec("mkdir /tmp/report")
		--
		-- Overview
		--
		luci.template.render("report/report", {
			dmesg   = dmesg,
			sslog = sslog,
			network = network,
			simman = simman,
			openvpn = openvpn,
			mwan = mwan,
			pollmydevice = pollmydevice,
			ntp = ntp,
			sms = sms,
			snmp = snmp
		})
	end
end

function fork_exec(command)
	local pid = nixio.fork()
	if pid > 0 then
		return
	elseif pid == 0 then
		-- change to root dir
		nixio.chdir("/")

		-- patch stdin, out, err to /dev/null
		local null = nixio.open("/dev/null", "w+")
		if null then
			nixio.dup(null, nixio.stderr)
			nixio.dup(null, nixio.stdout)
			nixio.dup(null, nixio.stdin)
			if null:fileno() > 2 then
				null:close()
			end
		end

		-- replace with target command
		nixio.exec("/bin/sh", "-c", command)
	end
end

function ltn12_popen(command)

	local fdi, fdo = nixio.pipe()
	local pid = nixio.fork()

	if pid > 0 then
		fdo:close()
		local close
		return function()
			local buffer = fdi:read(2048)
			local wpid, stat = nixio.waitpid(pid, "nohang")
			if not close and wpid and stat == "exited" then
				close = true
			end

			if buffer and #buffer > 0 then
				return buffer
			elseif close then
				fdi:close()
				return nil
			end
		end
	elseif pid == 0 then
		nixio.dup(fdo, nixio.stdout)
		fdi:close()
		fdo:close()
		nixio.exec("/bin/sh", "-c", command)
	end
end
