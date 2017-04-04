ruleset echo {
  meta {
    name "Echo Server"
    description <<Echo Server>>
    author "Sean Miller"
    logging on
    shares __testing
  }

  global {
  __testing = { "events": [ { "domain": "echo", "type": "hello" },
                            { "domain": "echo", "type": "message",
                              "attrs": [ "input" ] } ] }
  }


rule hello_world is active {
  select when echo hello
  send_directive("say") with
    something = "Hello World"
}
   
rule echo is active {
  select when echo message input re#(.*)# setting(m);
  send_directive("say") with
    something = m
}
  
}