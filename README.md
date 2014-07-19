#websocket-pipe

Pipe IO to a websocket, broadcast to clients

websocket-pipe allows you to pipe Ruby IO streams (files, stdin/stdout, sockets, etc) to a websocket server. The server will broadcast your message to all connected clients.

##API

`WebsocketPipe.`**`new(reader[,host_info])`**

Creates a new WebsocketPipe reading from the supplied `IO` object `reader`. Optional `host_info` will be passed to `[EM::WebSocket](https://github.com/igrigorik/em-websocket).run`.

`WebsocketPipe.`**`fork!`**

Forks your websocket server off in a new process. Return value is a tuple of the process pid and a `writer` stream. The associated `reader` is used by the websocket process to broadcast data from `writer` to connected clients.

`#`**`start!`**

Starts the server.

##Example
### Tailing `system.log`
In the example below we'll pipe the output of a `tail` call to our browser, which will display the output as an unordered list.

#### Pipe STDIN to clients (`stdin-to-ws.rb`)

```ruby
require 'websocket-pipe'

WebsocketPipe.new(STDIN).start!
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

#### Output:
> <ul>
>     <li>Jul 19 12:56:27 --- last message repeated 2 times ---<br></li>
>     <li>Jul 19 12:56:36 YourMachine.local login[30604]: USER_PROCESS: > 30604 ttys001<br></li>
>     <li>Jul 19 12:56:38 YourMachine.local login[30604]: DEAD_PROCESS: 30604 > ttys001<br></li>
>     <li>Jul 19 12:57:18 YourMachine.local login[30758]: USER_PROCESS: > 30758 ttys001<br></li>
>     <li>Jul 19 12:58:02 YourMachine kernel[0]: The USB device Apple Internal > Keyboard / Trackpad (Port 5 of Hub at 0x14000000) may have caused a > wake by issuing a remote wakeup (2)<br></li>
>     <li>Jul 19 12:58:38 --- last message repeated 1 time ---<br></li>
> </ul>
