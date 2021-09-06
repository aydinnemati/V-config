# SSH 
## Accepted password
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
            event.log.message = nil
            event.log.user = userr
            event.log.ip = ipp
          end
          emit(event)
        end
```
