/**
 * Service that will send emails
 */
component scope="singleton" profile {

	// DI
	property name="log"         inject="logbox:logger:services.UserService";
	property name="wirebox"     inject="wirebox";
	property name="mailService" inject="MailService@cbmailservices";
	property name="cloudinary" inject="apis.external.cloudinary";

	/**
	 * Constructor
	 */
	EmailService function init(){
		return this;
	}

	/**
	 * Function to send an email with the required arguments (Basic ones)
	 *
	 * @toEmail Email to send to
	 * @subject Subject of the email
	 * @view View to use for the email, works like a template and will always be uneder views/email/** 
	 * @viewArgs View arguments to be used within the template itself
	 */
	void function send(
		required string toEmail,
		required string subject,
		required string view,
		required any viewArgs
	){
		var settings = wirebox.getInstance( "coldbox" ).getConfigSettings();

		log.info( () => "Attempting to send an email..." );
		log.debug( () => "toEmail:#toEmail#" );
		log.debug( () => "subject:#subject#" );
		log.debug( () => "viewArgs: ", viewArgs );

		var bodyTokens = {};

		for ( key in arguments.viewArgs ) {
			bodyTokens[ key ] = arguments.viewArgs[ key ];
		}

		if ( settings.features.sendEmail == false ) {
			log.warn(
				message   = "The feature to send email is not enabled, therefore emails will not be sent...",
				extraInfo = ""
			);
			return;
		}

		try {
			variables.mailService
				.newMail(
					debug   : settings.isDebug == true,
					priority: "highest",
					server  : settings.email.default.server,
					port    : settings.email.default.port,
					username: settings.email.default.username,
					password: settings.email.default.password,
					usessl  : "false",
					usetls  : "true",
					to      : toEmail,
					from    : settings.email.default.from,
					cc      : settings.email.default.cc,
					bcc     : settings.email.default.bcc,
					subject : subject,
					type    : "html"
				)
				.setBodyTokens( bodyTokens )
				.setView( view: "email/#arguments.view#", args: cloudinary )
				.send();
		} catch ( any ex ) {
			log.error( "There has been an error while sending the email...", ex );
		}
	}

}
