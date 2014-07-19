#websocket-pipe

Pipe IO to a websocket, broadcast to clients

websocket-pipe allows you to pipe Ruby IO streams (files, stdin/stdout, sockets, etc) to a websocket server. The server will broadcast your message to all connected clients.

##Example
### Tailing `system.log`
In the example below we'll pipe the output of a `tail` call to our browser, which will display the output as an unordered list.

#### Pipe STDIN to clients (`stdin-to-ws.rb`)

```ruby
require 'websocket-pipe'

WebSocketPipe.new(STDIN).start!
```


#### Pipe tail output to clients (`tail-syslog`)

```bash
#!/usr/bin/env bash

tail -f /private/var/log/system.log | ruby stdin-to-ws.rb
```

#### Display received data from `tail` as UL (`tail.html`)

```html
<html>
  <head>
    <title>Pipe</title>
    <style>
      #log { font-family: Anonymous Pro, monospace}
    </style>
  </head>
  <body>
    <ul id="log">
    </ul>
  </body>

  <script>
    var socket = new WebSocket('ws://localhost:8080');

    socket.onmessage = function(event) {
      var msg = document
        .createElement("li")
      msg.innerText = event.data
      document
        .getElementById("log")
        .appendChild(msg);
    };
    socket.onopen = function(event) {
      console.log('Connected:', event.target.url)
    };
    socket.onerror = function(error) {
      console.warn('WebSocket Error:' , error);
    };
  </script>
</html>

```

