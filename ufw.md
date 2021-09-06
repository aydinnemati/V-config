# UFW
## ufw block
- log
```
{"appname":"kernel","facility":"kern","host":"syslog-sender","hostname":"syslog-sender","message":"[UFW BLOCK] IN=enp0s3 OUT= MAC=08:00:27:55:1d:36:2c:6f:c9:09:9a:cd:08:00 SRC=10.0.11.72 DST=10.0.10.212 LEN=40 TOS=0x00 PREC=0x00 TTL=126 ID=3845 DF PROTO=TCP SPT=9090 DPT=34930 WINDOW=0 RES=0x00 ACK RST URGP=0","severity":"warning","source_ip":"10.0.10.212","source_type":"syslog","timestamp":"2021-09-06T08:00:26Z"}
```
```bash
transforms:
  tran:
    type: lua
    inputs:
      - src
    version: '2'
    hooks:
      process: |-
        function (event, emit)
          if string.find(event.log.message, "[UFW BLOCK]") then
            local userr = string.match(event.log.message, "Accepted password for ([^ ]*) from")
            local interfacee = string.match(event.log.message, "IN=([^ ]*)")
            local macaddr = string.match(event.log.message, "MAC=([^ ]*)")
            local src_ip = string.match(event.log.message, "SRC=([^ ]*)")
            local dst_ip = string.match(event.log.message, "DST=([^ ]*)")
            local protcool = string.match(event.log.message, "PROTO=([^ ]*)")
            local src_port = string.match(event.log.message, "SPT=([^ ]*)")
            local dst_port = string.match(event.log.message, "DPT=([^ ]*)")
            
            -- event.log.message = nil

            event.log.interface = interfacee
            event.log.macaddress = macaddr
            event.log.source_ip = src_ip
            event.log.destination_ip = dst_ip
            event.log.protocol = protcool
            event.log.source_port = src_port
            event.log.destination_port = dst_port
          end
          emit(event)
        end
```

##
- log
```
```
```bash
```
