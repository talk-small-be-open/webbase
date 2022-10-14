"
I am the application control center from the ""outside"". I do stuff around the installation and operation of the application. Subclass myself to add your own control methods.
"
Class {
	#name : #WEBApplicationManager,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Core'
}

{ #category : #'pharo-integration' }
WEBApplicationManager class >> activateBetatesting [
	| app |

	#('app' 'app-admin') do: [ :each |
		app := WAAdmin defaultDispatcher handlerAt: each.
		app exceptionHandler: WEBBetatestErrorHandler.
	]
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> activateDebugging [
	| app |

	#('app' 'app-admin') do: [ :each |
		app := WAAdmin defaultDispatcher handlerAt: each.
		app exceptionHandler: WADebugErrorHandler.
	]
]

{ #category : #deployment }
WEBApplicationManager class >> afterDeployment [
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> beDevelopment [
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> beProduction [
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> installCommon [
	self pi defaultHtmlCanvasClass selectAsDefault
]

{ #category : #installation }
WEBApplicationManager class >> installDemo [
	self installProduction.
	WEBDatabase switchProductionToDemo
]

{ #category : #installation }
WEBApplicationManager class >> installDevelopment [
	self installCommon.
	self installDevelopmentSeasideComponents.
	self installSmtpConfig.
	self db ensureAdminExists.
	self loadDefaultData.

	"Webserver starten"
	ZnZincServerAdaptor startOn: self pi seasideWebserverPort.
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> installDevelopmentSeasideComponents [
	| apps app |

	apps := OrderedCollection new.

	self pi defaultFrontendMainTaskClasses do: [ :each |
		app := each registerAsApplication.
		app exceptionHandler: WADebugErrorHandler.
		app configuration
			at: #maximumRelativeAge put: (60 * 60 * 1); "1 Stunden"
			at: #maximumAbsoluteAge put: (60 * 60 * 24 * 1). "1 Tage"

		"last will be default. OPTIMIZE"
		WAAdmin defaultDispatcher defaultName: app name.

		apps add: app.
	].

	app := self pi defaultBackendMainTaskClass registerAsApplication.
	app exceptionHandler: WADebugErrorHandler.
	app configuration
		at: #maximumRelativeAge put: (60 * 60 * 1); "1 Stunden"
		at: #maximumAbsoluteAge put: (60 * 60 * 24 * 1). "1 Tage"

	apps add: app.

	"Registrieren von weiteren Hilfs-Handlers"
	apps add: WEBRunTaskRequestHandler register.
	apps add: WEBPingRequestHandler register.
	apps add: WEBSessionKeepaliveRequestHandler register.

"	config := self db globalConfiguration."

	"Email SMTP settings in Seaside settings übertragen"
	"DONT. We can use global seaside default WEBApplicationManager installSmtpConfig"
"	apps do: [ :each |
		each preferenceAt: #smtpServer put: config smtpServer.
		each preferenceAt: #smtpUsername put: config smtpUsername.
		each preferenceAt: #smtpPassword put: config smtpPassword.
	]"

	^ apps
]

{ #category : #installation }
WEBApplicationManager class >> installProductionGemStone [
	self installCommon.

	self installProductionSeasideComponents.

	"Bei korrektem Installieren sind die Seaside-Development Teile sowieso nicht existent,
	aber sicherheitshalber trotzdem:"
	self removeDevelopmentSeasideComponents.

	self installSmtpConfig.
	self db ensureAdminExists.
	self loadDefaultData.
]

{ #category : #installation }
WEBApplicationManager class >> installProductionPharo [
	self installCommon.

	self installProductionSeasideComponents.

	"Bei korrektem Installieren sind die Seaside-Development Teile sowieso nicht existent,
	aber sicherheitshalber trotzdem:"
	self removeDevelopmentSeasideComponents.

	self enableAutomation.
	self installSmtpConfig.
	self db ensureAdminExists.
	self loadDefaultData.
	
"	db := ALDatabase current.
	configurator := db schoolConfigurator."

	"Erste Tasks durchführen, damit gewisse Dinge initialisiert werden"
"	configurator tasksClass runMinutelyTasks.
	configurator tasksClass runAllFiveMinutesTasks.
	configurator tasksClass timetablesPublish."
		
	"Webserver starten"
	ZnZincServerAdaptor startOn: self pi seasideWebserverPort.
]

{ #category : #'pharo-integration' }
WEBApplicationManager class >> installProductionSeasideComponents [
	| apps app |

	apps := OrderedCollection new.

	self pi defaultFrontendMainTaskClasses do: [ :each |
		app := each registerAsApplication.
		app exceptionHandler: WEBEmailErrorHandler.
		app configuration
			at: #maximumRelativeAge put: (60 * 60 * 4); "4 Stunden"
			at: #maximumAbsoluteAge put: (60 * 60 * 24 * 3). "3 Tage"

		"last will be default. OPTIMIZE"
		WAAdmin defaultDispatcher defaultName: app name.

		apps add: app.
	].

	app := self pi defaultBackendMainTaskClass registerAsApplication.
	app exceptionHandler: WEBEmailErrorHandler.
	app configuration
		at: #maximumRelativeAge put: (60 * 60 * 4); "4 Stunden"
		at: #maximumAbsoluteAge put: (60 * 60 * 24 * 3). "3 Tage"

	apps add: app.

	"Registrieren von weiteren Hilfs-Handlers"
	apps add: WEBRunTaskRequestHandler register.
	apps add: WEBPingRequestHandler register.
	apps add: WEBSessionKeepaliveRequestHandler register.

"	config := self db globalConfiguration."

	"Email SMTP settings in Seaside settings übertragen"
	"DONT. We can use global seaside default WEBApplicationManager installSmtpConfig"
"	apps do: [ :each |
		each preferenceAt: #smtpServer put: config smtpServer.
		each preferenceAt: #smtpUsername put: config smtpUsername.
		each preferenceAt: #smtpPassword put: config smtpPassword.
	]"

	^ apps
]

{ #category : #installation }
WEBApplicationManager class >> installSmtpConfig [
	| server user password |

	server := self db globalConfiguration smtpServer.
	user := self db globalConfiguration smtpUsername.
	password := self db globalConfiguration smtpPassword.

	WAAdmin applicationDefaults	
		at: #smtpServer put: server;
		at: #smtpUsername put: user;
		at: #smtpPassword put: password.
]

{ #category : #'as yet unclassified' }
WEBApplicationManager class >> loadDefaultData [
	"subclasses"
]

{ #category : #removing }
WEBApplicationManager class >> removeDevelopmentSeasideComponents [

	"Unnötige Apps entfernen"
	WAAdmin
		unregister: 'config'; "Gefährliche App"
		unregister: 'browse';
		unregister: 'comet';
		unregister: 'examples';
		unregister: 'seaside';
		unregister: 'welcome';
		unregister: 'tools'.

]

{ #category : #installation }
WEBApplicationManager class >> update [
	self updateProduction
]

{ #category : #installation }
WEBApplicationManager class >> updateProduction [
	self pi defaultDataMigratorClass migrate
]
