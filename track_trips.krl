ruleset track_trips {
	meta {
	    name "Trip Tracker"
	    description <<Tracks trips>>
	    author "Sean Miller"
	    logging on
	}

	global {

	}

	rule process_trip is active{
	  select when echo message input re#(.*)# setting(mileage);
	  send_directive("trip") with
	    trip_length = mileage
	}
}