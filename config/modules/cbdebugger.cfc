component {

	function configure(){
		var isDebugEnabled = controller.getSetting( name = "ENVIRONMENT", defaultValue = "production" ) == "development";

		return {
			// This flag enables/disables the tracking of request data to our storage facilities
			// To disable all tracking, turn this master key off
			enabled          : isDebugEnabled,
			// This setting controls if you will activate the debugger for visualizations ONLY
			// The debugger will still track requests even in non debug mode.
			debugMode        : isDebugEnabled,
			// The URL password to use to activate it on demand
			debugPassword    : "cb:null",
			// This flag enables/disables the end of request debugger panel docked to the bottem of the page.
			// If you disable i, then the only way to visualize the debugger is via the `/cbdebugger` endpoint
			requestPanelDock : isDebugEnabled,
			// Request Tracker Options
			requestTracker   : {
				// Store the request profilers in heap memory or in cachebox, default is memory
				storage                      : "cachebox",
				// Which cache region to store the profilers in
				cacheName                    : "template",
				// Track all cbdebugger events, by default this is off, turn on, when actually profiling yourself :) How Meta!
				trackDebuggerEvents          : false,
				// Expand by default the tracker panel or not
				expanded                     : false,
				// Slow request threshold in milliseconds, if execution time is above it, we mark those transactions as red
				slowExecutionThreshold       : 1000,
				// How many tracking profilers to keep in stack
				maxProfilers                 : 75,
				// If enabled, the debugger will monitor the creation time of CFC objects via WireBox
				profileWireBoxObjectCreation : true,
				// Profile model objects annotated with the `profile` annotation
				profileObjects               : true,
				// If enabled, will trace the results of any methods that are being profiled
				traceObjectResults           : false,
				// Profile Custom or Core interception points
				profileInterceptions         : false,
				// By default all interception events are excluded, you must include what you want to profile
				includedInterceptions        : [],
				// Control the execution timers
				executionTimers              : {
					expanded           : true,
					// Slow transaction timers in milliseconds, if execution time of the timer is above it, we mark it
					slowTimerThreshold : 250
				},
				// Control the coldbox info reporting
				coldboxInfo : { expanded : true },
				// Control the http request reporting
				httpRequest : {
					expanded        : false,
					// If enabled, we will profile HTTP Body content, disabled by default as it contains lots of data
					profileHTTPBody : false
				}
			},
			// ColdBox Tracer Appender Messages
			tracers     : { enabled : true, expanded : false },
			// Request Collections Reporting
			collections : {
				// Enable tracking
				enabled      : true,
				// Expanded panel or not
				expanded     : false,
				// How many rows to dump for object collections
				maxQueryRows : 15,
				// How many levels to output on dumps for objects
				maxDumpTop   : 2
			},
			// CacheBox Reporting
			cachebox : { enabled : false, expanded : false },
			// Modules Reporting
			modules  : { enabled : true, expanded : false },
			// Quick and QB Reporting
			qb       : {
				enabled   : false,
				expanded  : false,
				// Log the binding parameters
				logParams : true
			},
			// Hyper configuration
			hyper : {
				enabled         : true,
				expanded        : false,
				logResponseData : true,
				logRequestBody  : true
			},
			// cborm Reporting
			cborm : {
				enabled   : false,
				expanded  : false,
				// Log the binding parameters
				logParams : true
			},
			// Adobe ColdFusion SQL Collector
			acfSql   : { enabled : false, expanded : false, logParams : true },
			// Lucee SQL Collector
			luceeSQL : { enabled : false, expanded : false, logParams : true },
			// Async Manager Reporting
			async    : { enabled : true, expanded : false }
		};
	}

}
