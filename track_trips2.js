var args = require("minimist")(process.argv.slice(2));
 
var event_type = args.e || "new_trip";
var message = args.m || "3300miles";
 
var request = require("request");
// must be an eci to a pico with the echo_server ruleset or similar installed
var eci = "cj12uyjrb0000ug7bjaogafn8";
var eid = "my-event-id";
var pico_engine = "localhost:8080";
 
var url = "http://"+pico_engine+"/sky/event/"+eci+"/"+eid+"/car2/"+event_type;
request.post(url,{form:{input:message}},function(err,response,body){
  JSON.parse(body).directives.forEach(function(d){
    if (d.name === "trip"){
      console.log(d.options.trip_length);
    }
  });
});