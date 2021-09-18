function (event, emit)
    function Split(s, delimiter)
      result = {};
      for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
      end
      return result;
    end
    if event.log.command[2] == "sel" then
      event.log.aaaaaaaaaaaaasghar = "asdasd"
    end
    emit(event)
  end