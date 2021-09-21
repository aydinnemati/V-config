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
            local protocol, security_flag = string.match(event.log.message, "proto ([^ ]*) ([^ ]*),")
            local private_ip, private_port = string.match(event.log.message, ", ([^ ]*):([^ ]*)->")
            local public_ip, public_port = string.match(event.log.message, "->([^ ]*):([^ ]*),")
            local lenght = string.match(event.log.message, ", len ([^ ]*)")
            event.log.lenght = lenght
            event.log.private_port = private_port
            event.log.public_port = public_port
            event.log.private_ip = private_ip
            event.log.public_ip = public_ip
            event.log.protocol = protocol
            event.log.security_flag = security_flag
            event.log.src_mac = src_mac
            event.log.input = input
            event.log.output = output
          end
          emit(event)
        end



vector_1  | {"host":"<IP>","message":

"firewall,info forward: in:ether5-LAN out:Shatel-Misc-2017117232, src-mac <MAC>, proto TCP (SYN), <IP>:<PORT>-><IP>:<PORT>, NAT (<IP>:<PORT>-><IP>:<PORT>)-><IP>:<PORT>, len 60","source_ip":"<IP>","source_type":"syslog","timestamp":"2021-09-18T10:04:57.133065498Z"}


vector_1  | {"host":"<IP>","message":

"firewall,info forward: in:ether5-LAN out:Shatel-Misc-2017117232, src-mac <MAC>, proto TCP (SYN), <IP>:<PORT>-><IP>:<PORT>, len 60","source_ip":"<IP>","source_type":"syslog","timestamp":"2021-09-18T10:04:57.952976631Z"}