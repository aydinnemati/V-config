# cisco switch logs
- vector
- config
```bash
transforms:

  tran_cisco_all:
    type: lua
    inputs:
      - cisco
    version: '2'
    hooks:
      process: |-
        function (event, emit)
            function pri_parser_severity(pri_severity)
                if pri_severity == 0 then
                    pri_severity_state = "emergency"
                    pri_severity_detail = "system is unusable"

                elseif pri_severity == 1 then
                    pri_severity_state =  "alert"
                    pri_severity_detail = "action must be taken immediately"

                elseif pri_severity == 2 then
                    pri_severity_state =  "critical"
                    pri_severity_detail = "critical conditions"

                elseif pri_severity == 3 then
                    pri_severity_state =  "error"
                    pri_severity_detail = "error conditions"

                elseif pri_severity == 4 then
                    pri_severity_state =  "warning"
                    pri_severity_detail = "warning conditions"

                elseif pri_severity == 5 then
                    pri_severity_state =  "notice"
                    pri_severity_detail = "normal but significant condition"

                elseif pri_severity == 6 then
                    pri_severity_state =  "informational"
                    pri_severity_detail = "informational messages"

                elseif pri_severity == 7 then
                    pri_severity_state =  "debug"
                    pri_severity_detail = "debug-level messages"
                else
                    pri_severity_state =  "undefined"
                    pri_severity_detail = "undefined"
                end
                return pri_severity_detail, pri_severity_state, pri_severity
            end
            function pri_parser_facility(pri_facility)
                if pri_facility == 0 then
                    pri_facility_detail = "kernel messages"
                elseif pri_facility == 1 then
                    pri_facility_detail = "user-level messages"
                elseif pri_facility == 2 then
                    pri_facility_detail = "mail system"
                elseif pri_facility == 3 then
                    pri_facility_detail = "system daemons"
                elseif pri_facility == 4 then
                    pri_facility_detail = "security/authorization messages"
                elseif pri_facility == 5 then
                    pri_facility_detail = "messages generated internally by syslogd"
                elseif pri_facility == 6 then
                    pri_facility_detail = "line printer subsystem"
                elseif pri_facility == 7 then
                    pri_facility_detail = "network news subsystem"
                elseif pri_facility == 8 then
                    pri_facility_detail = "UUCP subsystem"
                elseif pri_facility == 9 then
                    pri_facility_detail = "clock daemon"
                elseif pri_facility == 10 then
                    pri_facility_detail = "security/authorization messages"
                elseif pri_facility == 11 then
                    pri_facility_detail = "FTP daemon"
                elseif pri_facility == 12 then
                    pri_facility_detail = "NTP subsystem"
                elseif pri_facility == 13 then
                    pri_facility_detail = "log audit"
                elseif pri_facility == 14 then
                    pri_facility_detail = "log alert"
                elseif pri_facility == 15 then
                    pri_facility_detail = "clock daemon"
                elseif pri_facility == 16 then
                    pri_facility_detail = "local use 0  (local0)"
                elseif pri_facility == 17 then
                    pri_facility_detail = "local use 1  (local1)"
                elseif pri_facility == 18 then
                    pri_facility_detail = "local use 2  (local2)"
                elseif pri_facility == 19 then
                    pri_facility_detail = "local use 3  (local3)"
                elseif pri_facility == 20 then
                    pri_facility_detail = "local use 4  (local4)"
                elseif pri_facility == 21 then
                    pri_facility_detail = "local use 5  (local5)"
                elseif pri_facility == 22 then
                    pri_facility_detail = "local use 6  (local6)"
                elseif pri_facility == 23 then
                    pri_facility_detail = "local use 7  (local7)"
                else
                    pri_facility_detail = "undefined"
                end
                return pri_facility_detail, pri_facility
            end
            function Split(s, delimiter)
                result = {};
                for match in (s..delimiter):gmatch("(.-)"..delimiter) do
                    table.insert(result, match);
                end
                return result;
            end
            if string.find(event.log.message, "%LINK%-3%-UPDOWN:") 
            or string.find(event.log.message, "%LINEPROTO%-5%-UPDOWN")
            or string.find(event.log.message, "%LINK%-5%-CHANGED")
            or string.find(event.log.message, "%SYS%-5%-CONFIG_I") then 
                local pri, record_id  = string.match(event.log.message,"^<(%d+)>(%d+):")
                local pri_facility_number = pri//8
                local pri_severity_number = pri%8
                local pri_facility = pri_parser_facility(pri_facility_number)
                local pri_severity = pri_parser_severity(pri_severity_number)
                local description = string.match(event.log.message, ", (%U*)")
                event.log.record_id = record_id
                event.log.pri_severity = pri_severity_number
                event.log.pri_facility_detail = pri_facility_detail
                event.log.pri_facility = pri_facility_number
                event.log.pri_severity_detail = pri_severity_detail
                event.log.pri_severity_state = pri_severity_state
                event.log.timestamp = os.date('%Y-%m-%d %H:%M:%S', os.time(event.log.timestamp))
            end
            emit(event)
        end
  tran_cisco_link:
    type: lua
    inputs:
      - tran_cisco_all
    version: '2'
    hooks:
      process: |-
        function (event, emit)      
            if string.find(event.log.message, "%LINK%-3%-UPDOWN:") then
                local interface = string.match(event.log.message, "Interface ([^ ]*),")
                event.log.mnemonic = "%LINK%-3%-UPDOWN"
                event.log.interface = interface
            end
            if string.find(event.log.message, "%LINEPROTO%-5%-UPDOWN") then
                local interface = string.match(event.log.message, "Interface ([^ ]*),")
                event.log.mnemonic = "%LINEPROTO%-5%-UPDOWN"
                event.log.interface = interface
            end
            if string.find(event.log.message, "%LINK%-5%-CHANGED") then
                local interface = string.match(event.log.message, "Interface ([^ ]*),")
                event.log.mnemonic = "%LINK%-5%-CHANGED"
                event.log.interface = interface
            end
            emit(event)
        end
  tran_cisco_config:
    type: lua
    inputs:
      - tran_cisco_all
    version: '2'
    hooks:
      process: |-
        function (event, emit)      
            if string.find(event.log.message, "%SYS%-5%-CONFIG_I") then
                local user = string.match(event.log.message, "Configured from console by (%w+)")
                local shell, user_ip = string.match(event.log.message, "on (%w+) %(([^ ]*)%)")
                local description = string.match(event.log.message, "Configured from console by %w+")
                event.log.mnemonic = "%SYS%-5%-CONFIG_I"
                event.log.description = description
                event.log.user_ip = user_ip
                event.log.user = user
                event.log.shell = shell
            end
            emit(event)
        end

-- sink links to table links
sinks:
  sink_cisco_link:
    type: clickhouse
    inputs:
      - tran_cisco_link
    database: test
    endpoint: http://10.0.23.222:8123
    table: cisco_link
    compression: gzip
    encoding: default
    healthcheck: false
    skip_unknown_fields: false

    -- sink config to table cofig
  sink_cisco_config:
    type: clickhouse
    inputs:
      - tran_cisco_config
    database: test
    endpoint: http://10.0.23.222:8123
    table: cisco_config
    compression: gzip
    encoding: default
    healthcheck: false
    skip_unknown_fields: false

```
# Queries to build tables on clickhouse
## link logs

```sql
 CREATE TABLE IF NOT EXISTS cisco_link (
    description  String,
    host  IPv4,
    interface  String,
    message   String,
    mnemonic  String,
    pri_facility Int32,
    pri_facility_detail  String,
    pri_severity  Int32,
    pri_severity_detail  String,
    pri_severity_state  String,
    record_id  Int32,
    source_ip  IPv4,
    source_type String,
    timestamp  Datetime
) ENGINE = MergeTree()
ORDER BY timestamp
```
## config logs

```sql
 CREATE TABLE IF NOT EXISTS cisco_config (
    description  String,
    host  IPv4,
    shell  String,
    message   String,
    mnemonic  String,
    pri_facility Int32,
    pri_facility_detail  String,
    pri_severity  Int32,
    pri_severity_detail  String,
    pri_severity_state  String,
    record_id  Int32,
    source_ip  IPv4,
    source_type String,
    user  String,
    user_ip IPv4,
    timestamp  Datetime
) ENGINE = MergeTree()
ORDER BY timestamp
```