/**
 * Component that configures and handles date and time for the application
 */
component singleton {
	// ZoneId java object
	property name="zoneId"        inject="java:java.time.ZoneId";

	// DateTimeFormatter java object
	property name="dtf"           inject="java:java.time.format.DateTimeFormatter";

	// ZonedDateTime java object
	property name="zonedDateTime" inject="java:java.time.ZonedDateTime";

	/**
	 * Returns the current time in UTC
	 *
	 * @id The id of the format to return the current date and time, by default
	 * meaning, no arguments provided, goes like "dd-MMM-yyyy' 'hh:mm:ss a"
	 */
	function now( id = 0 ){
		local.result = variables.zonedDateTime.now( variables.zoneId.of( "UTC" ) );

		return format( local.result.toString(), arguments.id );
	}

	/**
	 * Returns the provided date and time with a specific format
	 *
	 * @value 
	 * @id The id of the format to return the current date and time
	 * 1 -> "ISO_INSTANT"
	 * 2 -> "dd-MM-yyyy"
	 * 3 -> "HH:mm:ss"
	 * 4 -> A struct of 2 parts: { date : "dd-MM-yyyy", time : "hh:mm:ss a" }
	 * 5 -> "dd-MM-yyyy' a las 'hh:mm:ss a"
	 * 6 -> "dd-MM-yyyy' 'HH:mm:ss.SSS"
	 * 7 -> "ddMMyyyyHH"
	 * default -> "dd-MMM-yyyy' 'hh:mm:ss a"
	 */
	function format( required string value, numeric id = 0 ){
		local.result = variables.zonedDateTime.parse( arguments.value );

		switch ( arguments.id ) {
			case "1":
				return local.result.format( variables.dtf.ISO_INSTANT );
			case "2":
				return local.result.format( variables.dtf.ofPattern( "dd-MM-yyyy" ) );
			case "3":
				return local.result.format( variables.dtf.ofPattern( "HH:mm:ss" ) );
			case "4":
				return {
					date : local.result.format( variables.dtf.ofPattern( "dd-MM-yyyy" ) ),
					time : local.result.format( variables.dtf.ofPattern( "hh:mm:ss a" ) )
				};
			case "5":
				return local.result.format( variables.dtf.ofPattern( "dd-MM-yyyy' a las 'hh:mm:ss a" ) );
			case "6":
				return local.result.format( variables.dtf.ofPattern( "dd-MM-yyyy' 'HH:mm:ss.SSS" ) );
			case "7":
				return local.result.format( variables.dtf.ofPattern( "ddMMyyyyHH" ) );
			default:
				return local.result.format( variables.dtf.ofPattern( "dd-MMM-yyyy' 'hh:mm:ss a" ) );
		}
	}

}
