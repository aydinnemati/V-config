# SSH - Linux
## Accepted password
- log
```
Accepted password for a from 10.0.10.187 port 34042 ssh2
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
          if string.find(event.log.message, "Accepted password") then
            local userr = string.match(event.log.message, "Accepted password for ([^ ]*) from")
            local ipp = string.match(event.log.message, "from%s+(%S+)")
            local portt = string.match(event.log.message, "port ([^ ]*)")
            -- event.log.message = nil
            event.log.user = userr
            event.log.ssh_port = portt
            event.log.ip = ipp
          end
          emit(event)
        end
```
## Failed password
- log
```
Failed password for a from 10.0.10.187 port 34028 ssh2
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
          if string.find(event.log.message, "Failed password") then
            local userr = string.match(event.log.message, "Failed password for ([^ ]*) from")
            local ipp = string.match(event.log.message, "from%s+(%S+)")
            local portt = string.match(event.log.message, "port ([^ ]*)")
            -- event.log.message = nil
            event.log.client_user = userr
            event.log.client_ip = ipp
            event.log.ssh_port = portt
          end
          emit(event)
        end
```
