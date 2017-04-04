ruleset echo {
  meta {
    name "Echo Server"
    description <<Echo Server>>
    author "Sean Miller"
    logging on
    shares hello, __testing
  }

  global {

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