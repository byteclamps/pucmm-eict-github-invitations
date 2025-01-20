/**
 * Base model component class that maps from the request collection (RC)
 */
component accessors="true" presistent="true" {

	// Log property
	property name="log" inject="logbox";


	// Rc properties
	this.rcStruct = {}

	/**
	 * Handles the mapping from the rc structure
	 *
	 * @rc The request collection structure from the client
	 */
	public function mapFromRc( any rc ){
		if ( isNull( this.rcStruct ) || structCount( this.rcStruct ) == 0 ) {
			return;
		}

		for ( key in rc ) {
			if ( ( key != "event" and key != "fieldnames" ) && structKeyExists( this.rcStruct, key ) == false ) {
				throw(
					type         = "ValidationException",
					message      = "El formulario provisionado no contiene las informaciones correcta. Favor refrescar la página e intentar de nuevo.",
					extendedinfo = serializeJSON( [
						{
							"missing_field" : key,
							"message"       : "The field '#key#' is not valid."
						}
					] ),
					errorcode = 400
				);
			} else if ( key == "event" or key == "fieldnames" ) {
				continue;
			} else {
				invoke(
					this,
					"set#this.rcStruct[ key ]#",
					[ rc[ key ] ]
				);
			}
		}
	}

	/**
	 * Attempts the validation process using "cbvalidation" library
	 *
	 * @obj The structure to validate against
	 */
	public function validate( any obj ){
		try {
			application.wirebox.getInstance( "validationManager@cbvalidation" ).validateOrFail( obj );
		} catch ( ValidationException ex ) {
			throw(
				type         = "ValidationException",
				extendedinfo = ex.extendedInfo,
				errorcode    = 400
			);
		}
	}

}
