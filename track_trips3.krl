ruleset track_trips3 {
	meta {
	    name "Trip Tracker"
	    description <<Tracks trips>>
	    author "Sean Miller"
	    logging on
	    shares __testing
	}

	global {
	__testing = { "events": [{ "domain": "car", "type": "new_trip",
                              "attrs": [ "mileage" ] } ] }
	}

	rule process_trip is active{
	  select when car2 new_trip input re#(.*)# setting(mileage);
	  send_directive("trip") with
	    trip_length = mileage
	  always{
	      ent:trips := ent:trips.defaultsTo([]).union([mileage]);
		  raise explicit event "trip_processed"
		  	attributes event:attrs()
	  }
	}
}