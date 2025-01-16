component extends="coldbox.system.EventHandler" {

	property name="coldbox"      inject="coldbox";
	property name="github"       inject="apis.external.github";
	property name="emailService" inject="services.EmailService";

	this.allowedMethods = { index : "GET", check : "POST" };

	/**
	 * Default Action
	 */
	function index( event, rc, prc ){
		rc.settings = coldbox.getConfigSettings();
		rc.pucmm    = rc.settings[ "pucmm" ];

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
		settings = coldbox.getConfigSettings();
		rc.pucmm = settings[ "pucmm" ];

		local.githubUser = {
			"email"    : rc[ "email" ],
			"username" : rc[ "githubUser" ],
			"subject"  : rc[ "subject" ]
		};

		// If the subject is not valid
		try {
			local.subject = rc.pucmm.subjects[ local.githubUser[ "subject" ] ];
		} catch ( any ex ) {
			writeDump( var = ex, abort = true );
		}

		log.info( "Making post request into check..." );

		if (
			github.memberExists(
				settings.github.org,
				local.subject[ "github-team" ],
				local.githubUser[ "username" ]
			) eq true
		) {
			log.info( "Member #local.githubUser[ "username" ]# already exists in the team of #local.subject.name#..." );

			flash.put(
				name  = "response",
				value = {
					success : false,
					message : "Ya estás registrado/a en la materia #local.subject.name#. No tiene que hacer mas nada."
				}
			);

			relocate( uri = "/" );

			return;
		}

		log.info( "Github user #local.githubUser[ "username" ]# does not exists in the team #local.subject[ "github-team" ]#, proceeding to add it..." );

		github.addOrUpdateMember(
			settings.github.org,
			local.subject[ "github-team" ],
			local.githubUser[ "username" ]
		);

		flash.put(
			name  = "response",
			value = {
				success : true,
				message : "La invitacion ha sido enviada. Favor revisar el correo electrónico enviado."
			}
		);

		emailService.send(
			toEmail  = local.githubUser[ "email" ],
			subject  = "[PUCMM EICT GITHUB INVITATIONS] A new user has been added to the team #local.subject[ "github-team" ]# (#local.githubUser[ "username" ]#).",
			view     = "index",
			viewArgs = {
				githubOrg       : settings.github.org,
				githubTeam      : local.subject[ "github-team" ],
				studentFullName : "",
				subject         : local.subject.name,
				githubUsername  : local.githubUser[ "username" ],
				email           : local.githubUser[ "email" ]
			}
		);

		relocate( uri = "/" );
	}

	required string toEmail,
	required string subject,
	required string view,
	required any viewArgs

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
