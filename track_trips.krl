ruleset track_trips {
	meta {
	    name "Trip Tracker"
	    description <<Tracks trips>>
	    author "Sean Miller"
	    logging on
	    shares __testing
	}

	global {
	__testing = { "events": [{ "domain": "track_trips", "type": "message",
                              "attrs": [ "mileage" ] } ] }
	}

	rule process_trip is active{
	  select when echo message mileage re#(.*)# setting(mileage);
	  send_directive("trip") with
	    trip_length = mileage
	}
}