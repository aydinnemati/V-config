# **LOGS**
## log server
1. [install vector](https://vector.dev/docs/setup/installation/package-managers/)

2. configuration
```bash
---
sources:
  src_syslog:
    type: syslog
    address: 0.0.0.0:514
    mode: udp

  src_vector:
    type: vector
    address: 0.0.0.0:*<port>*
    version: "1"

# SSH and UFW
transforms:

  tran_syslog:
    type: lua
    inputs:
      - src_syslog
    version: '2'
    hooks:
      process: |-
        function (event, emit)
          if string.find(event.log.message, "Accepted password") then
            local userr = string.match(event.log.message, "Accepted password for ([^ ]*) from")
            local ipp = string.match(event.log.message, "from%s+(%S+)")
            local portt = string.match(event.log.message, "port ([^ ]*)")
            -- event.log.message = nil
            event.log.user = userr
            event.log.ssh_port = portt
            event.log.ip = ipp
            event.log.metric = "1"
          end
          if string.find(event.log.message, "Failed password") then
            local userr = string.match(event.log.message, "Failed password for ([^ ]*) from")
            local ipp = string.match(event.log.message, "from%s+(%S+)")
            local portt = string.match(event.log.message, "port ([^ ]*)")
            -- event.log.message = nil
            event.log.client_user = userr
            event.log.client_ip = ipp
            event.log.ssh_port = portt
            event.log.metric = "1"
          end
          if string.find(event.log.message, "[UFW BLOCK]") then
            local userr = string.match(event.log.message, "Accepted password for ([^ ]*) from")
            local interfacee = string.match(event.log.message, "IN=([^ ]*)")
            local macaddr = string.match(event.log.message, "MAC=([^ ]*)")
            local src_ip = string.match(event.log.message, "SRC=([^ ]*)")
            local dst_ip = string.match(event.log.message, "DST=([^ ]*)")
            local protcool = string.match(event.log.message, "PROTO=([^ ]*)")
            local src_port = string.match(event.log.message, "SPT=([^ ]*)")
            local dst_port = string.match(event.log.message, "DPT=([^ ]*)")
            event.log.interface = interfacee
            event.log.macaddress = macaddr
            event.log.source_ip = src_ip
            event.log.destination_ip = dst_ip
            event.log.protocol = protcool
            event.log.source_port = src_port
            event.log.destination_port = dst_port
            event.log.metric = "1"
          end
          emit(event)
        end

  tran_metrics:
    type: lua
    inputs:
      - src_syslog
      - src_vector
    version: '2'
    hooks:
      process: |-
        function (event, emit)
          if event.log.metric == "1" then
            event.log.metric = nil
          end
          emit(event)
        end

  tran_logs:
    type: lua
    inputs:
      - src_syslog
      - src_vector
    version: '2'
    hooks:
      process: |-
        function (event, emit)
          if event.log.metric ~= "1" then
          end
          emit(event)
        end

  tran_log_to_metric:
    type: log_to_metric
    inputs:
      - tran_metrics
    metrics:
      field: duration
      name: duration_total
      namespace: vector
      tags:
        host: ${HOSTNAME}
      type: counter

sinks:
  sink_promotheus:
    type: prometheus_exporter
    inputs:
      - tran_log_to_metric
    address: 0.0.0.0:9598

#  sink_clickhouse:
#    type: clickhouse
#    inputs:
#      - tran_log_to_metric
#    database: mydatabase
#    endpoint: http://localhost:8123
#    table: mytable
#    compression: gzip
#    encoding: null
#    healthcheck: null
#    skip_unknown_fields: null

#  sink_elastic_search:
#    type: elasticsearch
#    inputs:
#      - tran_log_to_metric
#    endpoint: http://10.24.32.122:9000
#    index: vector-%F
#    mode: normal
#    pipeline: pipeline-name
#    compression: none
#    encoding: null
#    healthcheck: null

  sink_console_testing:
    my_sink_id:
    type: console
    inputs:
      - my-source-or-transform-id
    target: stdout
    encoding: json # ndjson


```

- cmd test
```bash
$ sudo vector --config /path/to/config/file # in one of (TOML - YAML - JSON) formats
```

## target servers
1. config auth messages logging to syslog and rsyslog to send syslog to log server
```bash
# edit file /etc/rsyslog.d/*<50-default.conf>* with your loving editor and  add these lines
*.* @*<log-servers-IP-address>*:514
auth,authpriv.*			/var/log/syslog

# then restart rsyslog service
$ sudo systemctl restart rsyslog.service
# or
$ sudo service rsyslog restart
```

2. install ipmitool
```bash
$ sudo apt install ipmitool
```
3. [install vector](https://vector.dev/docs/setup/installation/package-managers/)

4. configuration
```bash
---
sources:
  src01:
    type: exec
    mode: scheduled
    command: ["ipmitool", "sel", "list", "-c"]

transforms:
  tran01:
    type: lua
    inputs:
      - src01
    version: '2'
    hooks:
      process: |-
              function (event, emit)
                function Split(s, delimiter)
                  result = {};
                  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
                    table.insert(result, match);
                  end
                  return result;
                end
                if event.log.command[2] == "sel" then
                  array_msg = Split(event.log.message, ",")
                  event.log.number_id = array_msg[1]
                  event.log.date = array_msg[2]
                  event.log.time = array_msg[3]
                  event.log.sensor_type = array_msg[4]
                  event.log.description = array_msg[5]
                  event.log.event_direction = array_msg[6]
                end
                if string.find(event.log.sensor_type, "Drive Slot") then
                  event.log.metric = "1"
                end
                if string.find(event.log.sensor_type, "Power Supply") then
                  event.log.metric = "1"
                end
                if string.find(event.log.sensor_type, "Power State") then
                  event.log.metric = "1"
                end
                if string.find(event.log.sensor_type, "Memory") and string.find(event.log.description, "Error") then
                   event.log.metric = "1"
                end
                emit(event)
              end

sinks:
  sink01:
    type: vector
    inputs:
      - tran01
    address: *<log-servers-IP-address>*:*<port>*
    version: "1"
```
- cmd test
```bash
$ sudo vector --config /path/to/config/file # in one of (TOML - YAML - JSON) formats
```