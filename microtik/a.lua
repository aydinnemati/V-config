a = "firewall,info forward: in:ether5-LAN out:ether1-work-Irancell, src-mac 00:19:e7:90:d4:45, proto TCP (SYN), 10.0.10.76:61127->40.127.110.237:443, NAT (10.0.10.76:61127->10.0.100.254:61127)->40.127.110.237:443, len 52"
b = "src 00:19:e7:90:d4:45"

p, pp = string.match(a, "proto ([^ ]*) ([^ ]*),")
print(p)
print(pp)