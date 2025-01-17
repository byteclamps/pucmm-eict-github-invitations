component extends="coldbox.system.EventHandler" {

	property name="coldbox"      inject="coldbox";
	property name="github"       inject="apis.external.github";
	property name="jsonbin"      inject="apis.external.jsonbin";
	property name="emailService" inject="services.EmailService";

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
			rc.githubUser = "byteclamps";
			rc.email      = "20130216@ce.pucmm.edu.do";
		} else {
			rc.subject    = "";
			rc.githubUser = "";
			rc.email      = "";
		}

		event.setView( "main/index" );
	}

	function check( event, rc, prc ){
		settings    = coldbox.getConfigSettings();
		rc.subjects = variables.jsonbin.readBin( settings.jsonbin.studentBinId );

		local.githubUser = {
			"email"    : rc[ "email" ],
			"username" : rc[ "githubUser" ],
			"subject"  : rc[ "subject" ]
		};

		// If the subject is not valid
		try {
			local.subject = rc.subjects[ local.githubUser[ "subject" ] ];
		} catch ( any ex ) {
			returnFlashResponse(
				true,
				"Ha habido un problema a la de validar la petición. Si el problema persiste, comunicarse con el administrador del sistema."
			);
		}

		log.info( "Making post request into check..." );

		if ( arrayFind( local.subject.students, local.githubUser[ "email" ] ) eq 0 ) {
			log.info( "Student with email #local.githubUser[ "email" ]# is not valid." );

			returnFlashResponse(
				true,
				"El correo proporcionado no es valido o no esta registrado para la materia."
			);
		}

		if (
			github.memberExists(
				settings.github.org,
				local.subject[ "github-team" ],
				local.githubUser[ "username" ]
			) eq true
		) {
			log.info( "Member #local.githubUser[ "username" ]# already exists in the team of #local.subject.name#..." );

			returnFlashResponse(
				true,
				"Ya estás registrado/a en la materia #local.subject.name#. No tiene que hacer mas nada."
			);
		}

		log.info( "Github user #local.githubUser[ "username" ]# does not exists in the team #local.subject[ "github-team" ]#, proceeding to add it..." );

		github.addOrUpdateMember(
			settings.github.org,
			local.subject[ "github-team" ],
			local.githubUser[ "username" ]
		);

		emailService.send(
			toEmail  = local.githubUser[ "email" ],
			subject  = "[PUCMM EICT GITHUB INVITATIONS] A new user has been added to the team #local.subject[ "github-team" ]# (#local.githubUser[ "username" ]#).",
			view     = "index",
			viewArgs = {
				githubOrg       : settings.github.org,
				githubTeam      : local.subject[ "github-team" ],
				subject         : local.subject.name,
				githubUsername  : local.githubUser[ "username" ],
				email           : local.githubUser[ "email" ]
			}
		);

		returnFlashResponse( false, "La invitacion ha sido enviada. Favor revisar el correo electrónico enviado." );
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
