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
            if string.find(event.log.message, "%LINK%-3%-UPDOWN:") then
                local pri, record_id  = string.match(event.log.message,"^<(%d+)>(%d+):")
                local pri_facility_number = pri//8
                local pri_severity_number = pri%8
                local pri_facility = pri_parser_facility(pri_facility_number)
                local pri_severity = pri_parser_severity(pri_severity_number)
                local date = string.match(event.log.message,".(%w+ %d+ %d+:%d+:%d+%.%d+)")
                local interface = string.match(event.log.message, "Interface ([^ ]*),")
                local description = string.match(event.log.message, ", (%U*)")
                event.log.pri_severity_detail = pri_severity_detail
                event.log.pri_severity_state = pri_severity_state
                event.log.mnemonic = "%LINK%-3%-UPDOWN"
                event.log.description = description
                event.log.interface = interface
                event.log.pri_severity = pri_severity_number
                event.log.pri_facility_detail = pri_facility_detail
                event.log.pri_facility = pri_facility_number
                event.log.record_id = record_id
                event.log.date = date
            end
            emit(event)
        end
            emit(event)
        end
        
        
        https://www.cisco.com/c/en/us/td/docs/voice_ip_comm/cust_contact/contact_center/ipcc_enterprise/ippcenterprise10_0_1/configuration/UCCE_BK_SCB58691_00_serviceability-best-practices-guide/UCCE_BK_SCB58691_00_serviceability-best-practices-guide_chapter_0100.pdf