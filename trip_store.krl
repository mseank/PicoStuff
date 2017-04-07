ruleset trip_store {
	meta {
    name "Trip Store"
    description <<
Store trips
>>
    author "Sean Miller"
    provides trips, long_trips, short_trips
    shares trips, long_trips, short_trips
	}

	global {
		clear_trips = { "_0": { "trip": { "mileage": ""} } }
		clear_long = { "_0": { "trip": { "mileage": ""} } }

		trips = function() {
			ent:trips
		}

		long_trips = function() {
			ent:long_trips
		}

		short_trips = function() {
			ent:trips.difference(ent:long_trips)
		}
	}

	rule collect_trips is active {
		select when explicit trip_processed
		pre {
				mileage = event:attr("mileage").klog("our passed in mileage: ")
				timestamp = event:attr("timestamp").klog("our passed in timestamp: ")
		} 
		always{
    		ent:trips{[timestamp,"trips","mileage"]} := mileage

		}
	}

	rule collect_long_trips is active {
		select when explicit found_long_trip
		pre{
				mileage = event:attr("mileage").klog("our passed in mileage: ")
		}
		always{
			ent:long_trips{[timestamp,"trips","mileage"]} := mileage
		}
	}

	rule clear_trips is active {
		select when car trip_reset
		always {
			ent:trips := clear_trips;
			ent:long_trips := clear_long
		}
	}	
}