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


rule hello is active {
  select when echo hello
  send_directive("say") with
    something = "Hello World"
}
   
rule message is active {
  select when echo message input re#(.*)# setting(input);
  send_directive("say") with
    something = input
}
  
}