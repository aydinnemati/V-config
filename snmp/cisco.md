# cisco nexus 300 snmp parser with vector to prometheus
- See [OIDs](https://ixnfo.com/en/snmp-oid-and-mib-for-interfaces.html)
> vector config
```lua
-- on some server that has access to switch
sources:
  src_cisco_snmp:
    type: exec
    mode: scheduled
    command: ["snmpwalk", "-c", "aasaamSNMP", "-v", "2c", "10.0.0.254"]

transforms:

  tran_cisco_snmp:
    type: lua
    inputs:
      - src_cisco_snmp
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
            if string.match(event.log.command[1], "snmpwalk") then
              event.log.community = event.log.command[3]
              event.log.snmp_version = event.log.command[4]
              event.log.host = event.log.command[6]
              event.log.timestamp = os.date('%Y-%m-%d %H:%M:%S', os.time(event.log.timestamp))
              local oid  = string.match(event.log.message,"([^ ]*) =")
              event.log.oid = oid
              -- local oid_list = Split(oid, "%.")
              -- oid_list[#oid_list] = nil
              -- event.log.oid_list = oid_list
              -- event.log.oid = oid
              event.log.command = nil
              if string.match(oid, "iso.3.6.1.2.1.1.1") then
                local list_system_description = Split(string.match(event.log.message, '\"(.+)\"'), ",")
                event.log.device_model = list_system_description[1]
                event.log.device_software = list_system_description[2]
                event.log.device_software_version = list_system_description[3]
                event.log.device_release = list_system_description[4]
                event.log.device_compiled = list_system_description[5]
              end
              if string.match(oid, "iso.3.6.1.2.1.1.5") then
                local device_name = string.match(event.log.message, '\"(.+)\"')
              end
            end
            emit(event)
        end

sinks:
  sink_cisco_snmp:
    type: console
    inputs:
      - tran_cisco_snmp
    target: stdout
    encoding: json
```