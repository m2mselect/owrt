
m = Map("ttyd", translate("Configuration"))
s = m:section(TypedSection, "ttyd")
s.addremove = false
s.anonymous = true

o = s:option(Flag, "enable", translate("Enable"));
o.default = true;

o = s:option(Value, "port", translate("Port"), translate("Port to listen (default: 7681, use `0` for random port)"));
o.datatype    = "port";
o.placeholder = 7681;

o = s:option(Value, "interface", translate("Interface"), translate("Network interface to bind (eg: eth0), or UNIX domain socket path (eg: /var/run/ttyd.sock)"));
o.nocreate    = true;
o.unspecified = true;

o = s:option(Value, "credential", translate("Credential"), translate("Credential for Basic Authentication"));
o.placeholder = "username:password";

o = s:option(Value, "uid", translate("User ID"), translate("User id to run with"));
o.datatype = "uinteger";

o = s:option(Value, "gid", translate("Group ID"), translate("Group id to run with"));
o.datatype = "uinteger";

o = s:option(Value, "signal", translate("Signal"), translate("Signal to send to the command when exit it (default: 1, SIGHUP)"));
o.datatype = "uinteger";

s:option(Flag, "url_arg", translate("Allow URL args"), translate("Allow client to send command line arguments in URL (eg: http://localhost:7681?arg=foo&arg=bar)"));

s:option(Flag, "readonly", translate("Read-only"), translate("Do not allow clients to write to the TTY"));

o = s:option(DynamicList, "client_option", translate("Client option"), translate("Send option to client"));
o.placeholder = "key=value";

o = s:option(Value, "terminal_type", translate("Terminal type"), translate("Terminal type to report (default: xterm-256color)"));
o.placeholder = "xterm-256color";

s:option(Flag, "check_origin", translate("Check origin"), translate("Do not allow websocket connection from different origin"));

o = s:option(Value, "max_clients", translate("Max clients"), translate("Maximum clients to support (default: 0, no limit)"));
o.datatype = "uinteger";
o.placeholder = "0";

s:option(Flag, "once", translate("Once"), translate("Accept only one client and exit on disconnection"));

o = s:option(Value, "index", translate("Index"), translate("Custom index.html path"));

s:option(Flag, "ipv6", translate("IPv6"), translate("Enable IPv6 support"));

s:option(Flag, "ssl", translate("SSL"), translate("Enable SSL"));

o = s:option(FileUpload, "ssl_cert", translate("SSL cert"), translate("SSL certificate file path"));
o:depends("ssl", "1");

o = s:option(FileUpload, "ssl_key", translate("SSL key"), translate("SSL key file path"));
o:depends("ssl", "1");

o = s:option(FileUpload, "ssl_ca", translate("SSL ca"), translate("SSL CA file path for client certificate verification"));
o:depends("ssl", "1");

o = s:option(Value, "debug", translate("Debug"), translate("Set log level (default: 7)"));
o.placeholder = "7";

s:option(Value, "command", translate("Command"));

return m
