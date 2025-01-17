component {

	function configure(){
		return {
			// The default token Marker Symbol
			tokenMarker     : "@",
			// Default protocol to use, it must be defined in the mailers configuration
			defaultProtocol : "default",
			// Here you can register one or many mailers by name
			mailers         : {
				"default"  : { class : "CFMail", properties : {} },
				"files"    : { class : "File", properties : { filePath : "/logs" } },
				"postmark" : { class : "PostMark", properties : { apiKey : "" } },
				"mailgun"  : {
					class      : "Mailgun",
					properties : { apiKey : "", domain : "" }
				}
			},
			// The defaults for all mail config payloads and protocols
			defaults : {
				from : getSystemSetting( "SMTP_FROM_EMAIL" ),
				cc   : getSystemSetting( "SMTP_CC_EMAIL" )
			},
			// Whether the scheduled task is running or not
			runQueueTask : true
		}
	}

}
