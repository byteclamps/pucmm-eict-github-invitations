/**
 * I am a new Model Object
 */
component accessors="true" extends="BaseModel" {

	// Properties
	property name="subject" type="string";
	property name="username" type="string";
	property name="email" type="string";	

	// Rc properties
	this.rcStruct = {
		"subject"          : "subject",
		"username"     : "username",
		"email"         : "email",
		"g-recaptcha-response" : "gcaptchaResponse"
	};

	// Validation Constraints
	this.constraints = {
		subject : {
			required        : true,
			requiredMessage : "La materia es requerida"
		},
		username : {
			required        : true,
			requiredMessage : "El usuario es requerido",
			size            : "4..64",
			sizeMessage     : "El usuario debe de contener entre {min} y {max} caracteres"
		},
		email : {
			required        : true,
			requiredMessage : "El correo electrónico es requerido",
			size            : "4..64",
			sizeMessage     : "El correo electrónico debe de contener entre {min} y {max} caracteres",
			type            : "email"
		},
	};

	// Constraint Profiles
	this.constraintProfiles = {
		"update" : {}
	};

	// Population Control
	this.population = {
		include : [],
		exclude : []
	};

	// Mementifier
	this.memento = {
		// An array of the properties/relationships to include by default
		defaultIncludes = [ "*" ],
		// An array of properties/relationships to exclude by default
		defaultExcludes = [],
		// An array of properties/relationships to NEVER include
		neverInclude = [],
		// A struct of defaults for properties/relationships if they are null
		defaults = {},
		// A struct of mapping functions for properties/relationships that can transform them
		mappers = {}
	};

	/**
	 * Constructor
	 */
	GithubUser function init(any rc){
		if ( isNull( arguments.rc ) == false ) {
			mapFromRc( arguments.rc );
		}

		return this;
	}

	/**
	 * Verify if the model has been loaded from the database
	 */
	function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

	public GithubUser function fromClient(){
		validate( this );

		return this;
	}

}