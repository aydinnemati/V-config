 LOGS
- vector
- config
```bash

transforms:

  tran_microtik:
    type: lua
    inputs:
      - microtik
    version: '2'
    hooks:
      process: |-
        function (event, emit)
          if string.find(event.log.message, "firewall,info forward:") then
            local input = string.match(event.log.message, "in:([^ ]*)")
            local output = string.match(event.log.message, "out:([^ ]*),")
            local src_mac = string.match(event.log.message, "%w+:%w+:%w+:%w+:%w+:%w+")
            local port, security_flag = string.match(event.log.message, "proto ([^ ]*) ([^ ]*),")
            local private_ip, private_port = string.match(event.log.message, ", ([^ ]*):([^ ]*)->")
            local public_ip, public_port = string.match(event.log.message, "->([^ ]*):([^ ]*),")
            local lenght = string.match(event.log.message, ", len ([^ ]*)")
            event.log.lenght = lenght
            event.log.private_port = private_port
            event.log.public_port = public_port
            event.log.private_ip = private_ip
            event.log.public_ip = public_ip
            event.log.port = port
            event.log.security_flag = security_flag
            event.log.src_mac = src_mac
            event.log.input = input
            event.log.output = output
          end
          emit(event)
        end
```


sinks:
  sink_microtik_nat:
    type: clickhouse
    inputs:
      - tran_microtik
    database: logs
    endpoint: http://10.0.23.222:8123
    table: microtik_nat
    compression: gzip
    encoding: default
    healthcheck: false
    skip_unknown_fields: false





# Queries to build tables on clickhouse
## NAT logs
```sql
 CREATE TABLE IF NOT EXISTS microtik_nat (
    input  String,
    host  IPv4,
    lenght Int32,
    message   String,
    output  String,
    private_ip IPv4,
    private_port  Int32,
    port  Int32,
    public_ip  IPv4,
    public_port  String,
    security_flag  String,
    source_ip  IPv4,
    source_type String,
    src_mac  String,
    timestamp  Datetime
) ENGINE = MergeTree()
ORDER BY timestamp
```