component extends="coldbox.system.EventHandler" {

	property name="coldbox"      inject="coldbox";
	property name="github"       inject="apis.external.github";
	property name="jsonbin"      inject="apis.external.jsonbin";
	property name="emailService" inject="services.EmailService";
	property name="githubUser"       inject="GithubUser";

	this.allowedMethods = { index : "GET", check : "POST" };

	/**
	 * Default Action
	 */
	function index( event, rc, prc ){
		rc.settings = coldbox.getConfigSettings();
		rc.subjects = variables.jsonbin.readBin( rc.settings.jsonbin.studentBinId );

		log.info( "Loading index (Main view)..." );

		if ( rc.settings.isLocal eq true ) {
			rc.subject    = "st-icc-354";
			rc.username = "byteclamps";
			rc.email      = "20130216@ce.pucmm.edu.do";
		} else {
			rc.subject    = "";
			rc.username = "";
			rc.email      = "";
		}

		event.setView( "main/index" );
	}

	function check( event, rc, prc ){
		settings    = coldbox.getConfigSettings();

		try {
			var user  = githubUser.init( rc ).fromClient();
			rc.subjects = variables.jsonbin.readBin( settings.jsonbin.studentBinId );

			// If the subject is not valid
			try {
				local.subject = rc.subjects[ user.getSubject() ];
			} catch ( any ex ) {
				returnFlashResponse(
					true,
					"Ha habido un problema a la de validar la petición. Si el problema persiste, comunicarse con el administrador del sistema."
				);
			}

			log.info( "Making post request into check..." );

			if ( arrayFind( local.subject.students, user.getEmail() ) eq 0 ) {
				log.info( "Student with email #user.getEmail()# is not valid." );

				returnFlashResponse(
					true,
					"El correo proporcionado no es valido o no esta registrado para la materia."
				);
			}

			if (
				github.memberExists(
					settings.github.org,
					local.subject[ "github-team" ],
					user.getUsername()
				) eq true
			) {
				log.info( "Member #user.getUsername()# already exists in the team of #local.subject.name#..." );

				returnFlashResponse(
					true,
					"Ya estás registrado/a en la materia #local.subject.name#. No tiene que hacer mas nada."
				);
			}

			log.info( "Github user #user.getUsername()# does not exists in the team #local.subject[ "github-team" ]#, proceeding to add it..." );

			github.addOrUpdateMember(
				settings.github.org,
				local.subject[ "github-team" ],
				user.getUsername()
			);

			emailService.send(
				toEmail  = user.getEmail(),
				subject  = "[PUCMM EICT GITHUB INVITATIONS] A new user has been added to the team #local.subject[ "github-team" ]# (#user.getUsername()#).",
				view     = "index",
				viewArgs = {
					githubOrg       : settings.github.org,
					githubTeam      : local.subject[ "github-team" ],
					subject         : local.subject.name,
					username  : user.getUsername(),
					email           : user.getEmail()
				}
			);

			returnFlashResponse( false, "La invitacion ha sido enviada. Favor revisar el correo electrónico enviado." );
		} catch (ValidationException ex) {
			var errors = deserializeJSON(ex.extendedInfo);
			var message = "";

			for (key in errors) {
				message = message & arrayToList(arrayMap(errors[key], (item) => item.message & "<br>"));
			}

			returnFlashResponse( true, message );
		}
	}

	private void function returnFlashResponse( required boolean isError, required string message ){
		flash.put(
			name  = "response",
			value = {
				success : arguments.isError eq false,
				message : arguments.message
			}
		);

		relocate( uri = "/" );

		abort;
	}

	/**
	 * --------------------------------------------------------------------------
	 * Implicit Actions
	 * --------------------------------------------------------------------------
	 * All the implicit actions below MUST be declared in the config/Coldbox.cfc in order to fire.
	 * https://coldbox.ortusbooks.com/getting-started/configuration/coldbox.cfc/configuration-directives/coldbox#implicit-event-settings
	 */

	function onAppInit( event, rc, prc ){
	}

	function onRequestStart( event, rc, prc ){
	}

	function onRequestEnd( event, rc, prc ){
	}

	function onSessionStart( event, rc, prc ){
	}

	function onSessionEnd( event, rc, prc ){
		var sessionScope     = event.getValue( "sessionReference" );
		var applicationScope = event.getValue( "applicationReference" );
	}

	function onException( event, rc, prc ){
		event.setHTTPHeader( statusCode = 500 );
		// Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		// Place exception handler below:
	}

}
