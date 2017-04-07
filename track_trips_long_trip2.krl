ruleset track_trips_long_trip {
		meta {
	    name "Trip Tracker"
	    description <<Tracks trips>>
	    author "Sean Miller"
	    logging on
	    use module trip_store
	    shares __testing
	}

	global {
	__testing = { "events": [{ "domain": "car", "type": "new_trip",
                              "attrs": [ "mileage" ] } ] }

    long_trip = 2500
    current_trip = 0
	}

	rule process_trip is active{
	  select when longcar new_trip input re#(.*)# setting(mileage);
	  pre{
	  	event:attr("timestamp") = time:now()
	  }
	  send_directive("trip") with
	    trip_length = mileage
	  always{
	      ent:trips := ent:trips.defaultsTo([]).union([mileage]).union([timestamp]);
		  raise explicit event "trip_processed"
		  	attributes event:attrs()
	  }
	}

	rule find_long_trips is active{
		select when explicit trip_processed;
		pre{
			mileage = event:attr("mileage").klog("our passed in mileage: ")
			timestamp = event:attr("timestamp").klog("our passed in timestamp: ")
			lessMileage = mileage.as("Number") < long_trip
		}
		if lessMileage then
			send_directive("trip")
				with trip_length = mileage
		fired{
		} else {
			raise explicit event "found_long_trip"
		}

	}
}