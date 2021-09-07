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
    event.log.Description = array_msg[5]
    event.log.event_direction = array_msg[6]
  end
  emit(event)
end

{
  "command": [
    "ipmitool",
    "sel",
    "list",
    "-c"
  ],
  "host": "sff-203",
  "message": [
    "6a",
    "09/07/2021",
    "08:23:57",
    "System ACPI Power State #0xd5",
    "S0/G0: working",
    "Asserted"
  ],
  "pid": 5874,
  "source_type": "exec",
  "stream": "stdout",
  "timestamp": "2021-09-07T11:20:02.090206985Z"
}

SEL Record ID          : 002d
 Record Type           : 02
 Timestamp             : 01/01/1970 00:01:35
 Generator ID          : 0020
 EvM Revision          : 04
 Sensor Type           : System ACPI Power State
 Sensor Number         : d5
 Event Type            : Sensor-specific Discrete
 Event Direction       : Assertion Event
 Event Data (RAW)      : 00ffff
 Event Interpretation  : Missing
 Description           : S0/G0: working

Sensor ID              : ACPI (0xd5)
Entity ID              : 7.1 (System Board)
Sensor Type            : System ACPI Power State (0x22)

 
6a | 09/07/2021 | 08:23:57 | System ACPI Power State #0xd5 | S0/G0: working | Asserted

{"command":["ipmitool","sel","list"],"host":"sff-203","message":"  65 | 09/07/2021 | 04:36:59 | System ACPI Power State #0xd5 | S4/S5: soft-off | Asserted","pid":4631,"source_type":"exec","stream":"stdout","timestamp":"2021-09-07T10:05:14.731577447Z"}
