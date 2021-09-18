-- ## raid controller mode
-- general
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
    event.log.sel_list_record_number = array_msg[1]
    event.log.date = array_msg[2]
    event.log.time = array_msg[3]
    event.log.sensor_type = array_msg[4]
    event.log.description = array_msg[5]
    event.log.event_direction = array_msg[6]
  end
  -- functions
  -- disk
  -- power
  emit(event)
end

-- ##########################
-- disk
if string.find(event.log.sensor_type, "Drive Slot") then
  event.log.metric = "1"
end
-- power
if string.find(event.log.sensor_type, "Power Supply") then
  event.log.metric = "1"
end

if string.find(event.log.sensor_type, "Power State") then
  event.log.metric = "1"
end
-- memory
if string.find(event.log.sensor_type, "Memory") and string.find(event.log.description, "Error") then
  event.log.metric = "1"
end



-- ########################### take disk out
-- 1,09/07/2021,12:12:35,Drive Slot / Bay #0x42,Drive Present,Deasserted
-- 2,09/07/2021,12:12:36,Drive Slot / Bay #0x42,In Failed Array,Asserted

########################### take 1 power cable out
7 | 09/08/2021 | 06:34:15 | Power Supply #0x3b | Failure detected | Asserted
8 | 09/08/2021 | 06:34:16 | Power Supply #0x3b | Power Supply AC lost | Asserted
9 | 09/08/2021 | 06:34:16 | Power Supply #0x3e | Redundancy Lost | Asserted

########################### take out 2 powers (when server starts up loging)
e |  Pre-Init  |0000000093| System ACPI Power State #0xd5 | S0/G0: working | Asserted

########################### press and hold power botton
11 | 09/08/2021 | 07:02:17 | System ACPI Power State #0xd5 | S4/S5: soft-off | Asserted
12 | 09/08/2021 | 07:02:42 | System ACPI Power State #0xd5 | S0/G0: working | Asserted

########################### press power 
14 | 09/08/2021 | 07:11:47 | System ACPI Power State #0xd5 | S4/S5: soft-off | Asserted
15 | 09/08/2021 | 07:12:00 | System ACPI Power State #0xd5 | S0/G0: working | Asserted

########################### ??? test memorys on lff 204
13 | 09/08/2021 | 07:05:48 | Memory #0x87 | Configuration Error | Asserted

########################### power source down
16 |  Pre-Init  |0000000094| System ACPI Power State #0xd5 | S0/G0: working | Asserted

############################ ping 8.8.8.8
############################ google.com
############################ date
vector exec date => مقایسه

############################ hex to decimal lua
print(tonumber("7DE",16))
print(0x7DE)

############################# after all going to metrics tag 