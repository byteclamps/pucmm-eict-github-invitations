/**
 * This component is to be able to make http request
 */
component {
    // Log property
	property name="log"     inject="logbox:logger:components.http";

    // Wirebox property
	property name="wirebox" inject="wirebox";

    // Hyper (The library being used for easy configuration)
	property name="hyper"   inject="HyperBuilder@hyper";

    /**
     * Makes the http request with all the required configuration
     *
     * @method Http method (GET,POST,PUT,DELETE)
     * @baseUrl Base url to make the request
     * @path Path to for the resource
     * @headers Headers to be sent. By default is empty
     * @params Params to sent in the url as query parameters (Defaults to empty).
     * @body Request body to sent in the request. Normally in PUT and POST requests
     */
	struct function request(
		required string method,
		required string baseUrl,
		required string path,
		struct headers = {},
		struct params  = {},
		struct body    = {}
	)
		returnformat="JSON"
		returntype  ="struct"
		output      ="true"
	{
		local.settings = wirebox.getInstance( "coldbox" ).getConfigSettings();

		log.info( "Sending http request to #arguments.baseUrl##arguments.path#..." );

		log.debug( "method: #arguments.method#" );
		log.debug( "path: #arguments.path#" );

		local.request = hyper
			.new()
			.setMethod( arguments.method )
			.setBaseUrl( arguments.baseUrl )
			.setUrl( arguments.path )
			.withHeaders( arguments.headers )
			.withQueryParams( arguments.params )
			.setEncodeUrl( "true" );

		local.result = local.request.send();

		if (log.canDebug() eq true) {
			log.debug("Response: #serializeJSON(local.result.getMemento())#");
		}

		if ( local.result.getStatusCode() >= 200 && local.result.getStatusCode() <= 299 ) {
			local.data = local.result.getData();

			if ( isJSON( local.data ) ) {
				local.data = deserializeJSON( local.data );
			}

			return {
				data        : local.data,
				headers     : local.result.getHeaders(),
				cookies     : local.result.getCookies(),
				timestamp   : local.result.getTimestamp(),
				status_code : local.result.getStatusCode(),
				status_text : local.result.getStatus()
			};
		}

		throw(
			message   = "Ha habido un error en el servidor a la hora de procesar su solicitud. Código de error 7000.",
			type      = "Custom",
			errorcode = "#local.result.getStatusCode()#",
            object = local.result.getData()
		);
	}

}
