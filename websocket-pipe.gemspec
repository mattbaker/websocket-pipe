Gem::Specification.new do |s|
  s.name        = 'websocket-pipe'
  s.version     = '0.0.1'
  s.date        = '2014-07-19'
  s.summary     = "Pipe data to a Websocket!"
  s.description = "Pipe data from a Ruby IO stream to a Websocket server, broadcasting to all clients."
  s.authors     = ["Matt Baker"]
  s.email       = 'mbaker.pdx+websocketpipe@gmail.com'
  s.files       = ["lib/websocket-pipe.rb"]
  s.add_runtime_dependency "em-websocket", ['>= 0.5.1', '< 0.6.0']
  s.homepage    =
    'https://github.com/mattbaker/websocket-pipe'
  s.license       = 'Apache License, Version 2.0'
end