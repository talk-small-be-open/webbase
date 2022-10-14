Extension { #name : #WEBApplicationManager }

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> cleanUpForDevelopment [
	"Entschlacken des Images für Server. Hm, ging nicht ohne Exceptions:"
	
	self isDevelopment ifTrue: [

		self cleanUpPharo.

		"Nicht-aggressives Cleanup in diversen Klassen."
		Smalltalk cleanUp: false.

		Smalltalk fixObsoleteReferences.

		"weiteres cleanup klassenseitig, undeclared etc."
		SmalltalkImage cleanUp.

		3 timesRepeat: [Smalltalk garbageCollect].

		Transcript cr; show: 'DEV Cleanup finished.'
	].
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> cleanUpForProduction [
	"Entschlacken des Images für Server. Hm, ging nicht ohne Exceptions:"
	
	self isProduction ifTrue: [
		
		self cleanUpPharo.
		
		"Einzelne Teile entnommen von ImageCleaner>>cleanUpForProduction"

		"trim MC ancestory information"
"old fashion. New ist Iceberg.		MCVersionInfo allInstances do: [ :each | each instVarNamed: 'ancestors' put: nil ]."

		3 timesRepeat: [Smalltalk garbageCollect].
		
		"delete logo"	
		PolymorphSystemSettings showDesktopLogo: false.
		
		"Aggressives Cleanup in diversen Klassen. Entfernt z.B. ChangeSets etc."
		Smalltalk cleanUp: true except: #() confirming: false.

		Smalltalk fixObsoleteReferences.
				
		"weiteres cleanup klassenseitig, undeclared etc."
		SmalltalkImage cleanUp.
		
		3 timesRepeat: [Smalltalk garbageCollect].
		
		Transcript cr; show: 'Cleanup finished.'
		
	].
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> cleanUpPharo [
	FreeTypeCache cleanUp.
	Clipboard startUp: true.
	RubEditingState allInstances do: [ :each | each instVarNamed: #undoManager put:nil].
"	GTPlayBook reset."
	EditorFindReplaceDialogWindow cleanUp.
"	ActiveHand resetClickState; releaseAllFocus."
	UITheme current focusIndicator: nil.
	CairoBackendCache soleInstance flush.
	40 timesRepeat: [
		1 second wait.
		World doOneCycle.
	]. 

"	Smalltalk garbageCollect."
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> enableAutomation [
	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> ensureExternalProcessWarmup [
	"Manchmal gab es Zombie-Prozesse und dies half dagegen"
	Smalltalk at: #OSProcessAccessor ifPresent: [ :ospa |
		ospa initialize ]
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> ensureFixedTimeZone [
	"OPTIMIZE: evt. direkt LocalTimeZone new nehmen, ohne fixed...,
	das braucht aber stets für den Offset ein primitives Aufruf, aber
	dadurch wären Sommerzeit/Winterzeit Übergänge ruckelfrei"
	DateAndTime localTimeZone: LocalTimeZone new asFixedTimeZone.

]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> ensureStartUpConditions [
	self ensureExternalProcessWarmup.

	self isProduction ifTrue: [
"		self installPharoUiManager."
		self setMaxExternalSemaphores.
		
	].

	self isDevelopment ifTrue: [
		self setDevelopmentProcessEnvironment].
	
"	self ensureFixedTimeZone."
"	self ensureSwissStartOfWeek."

	self ensureTranscriptVisible.
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> ensureSwissStartOfWeek [
	(Week dayNames includes: #Monday) ifTrue: [
		Week startDay: #Monday ].
	
	(Week dayNames includes: #Montag) ifTrue: [
		Week startDay: #Montag ].
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> ensureTranscriptVisible [
	| label transcriptWindows |

	Smalltalk isHeadless ifTrue: [ ^self ].

	label := 'Log transcript'.
	transcriptWindows := UIManager default currentWorld windowsSatisfying: [ :each | each label = label ].
	transcriptWindows ifEmpty: [
		"OPTIMIZE: Hier gab es komische Effekte beim Aufstarten war das ein NonInteractiveTranscript"
		[ Smalltalk tools transcript openLabel: label ] ifError: [ "just continue, hmhm" ]
	]
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> installGermanConstants [
	ChronologyConstants installGermanNames
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> setDevelopmentProcessEnvironment [
	Smalltalk platform environment
		at: 'PATH'
		put: '/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/mysql/bin'
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> setMaxExternalSemaphores [
	"Normal ist 4096 und es muss 2-Potenz sein"
	Smalltalk vm maxExternalSemaphoresSilently: 8192
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> shutDown: isQuitting [
"	lastImageSavedAt := DateAndTime now."
	isQuitting ifTrue: [
"		Transcript show: 'Called Shutdown-Handler'."
		]
]

{ #category : #'*Webbase-Pharo' }
WEBApplicationManager class >> startUp: isComingUp [
	isComingUp ifTrue: [
		self db logInfo: 'Called Startup-Handler'.
		self ensureStartUpConditions.
		
"		self isProduction ifTrue: [
			self restoreLastBackupIfNewer]]"
	]
]
