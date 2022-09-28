Extension { #name : #WEBComponent }

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> afterCaptchaDo: aBlock [
	^self requestCaptcha ifTrue: aBlock
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> chooseFrom: aCollection [
	^self chooseFrom: aCollection caption: 'Bitte wählen Sie einen Eintrag aus der Liste aus:' default: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> chooseFrom: aCollection caption: aText [
	^self chooseFrom: aCollection caption: aText default: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> chooseFrom: aCollection caption: aText default: anObject [
	^self chooseFrom: aCollection labels: nil caption: aText default: anObject
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> chooseFrom: aCollection labels: aLabelBlock caption: aText default: anObject [
	^self chooseFrom: aCollection labels: aLabelBlock caption: aText multi: false default: anObject
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> chooseFrom: aCollection labels: aLabelBlock caption: aText multi: aMultiBoolean default: anObject [
	| dialog |

	"Autochoose if no option"
	(aCollection isBlank) ifTrue: [
		^aMultiBoolean
			ifFalse: [nil]
			ifTrue: [aCollection copyEmpty]].

	"Autochoose if only one option"
	(aCollection size = 1) ifTrue: [
		^aMultiBoolean
			ifFalse: [aCollection anyOne]
			ifTrue: [aCollection copy]].

	dialog := (WEBChoiceDialog new
			messageText: aText;
			options: aCollection;
			selection: anObject;
			yourself).
	
	"TODO"
	aMultiBoolean ifTrue: [dialog beMultiselect].

	"Falls ein eigener Labeling-Block angegeben wurde, dann nehmen wir an, dass wir danach sortieren"
	aLabelBlock ifNotNil: [
		dialog 
			labelBlock: aLabelBlock;
			beLabelSorted].
			
	^self window: 'Auswahl' with: dialog
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> chooseMultipleFrom: aCollection caption: aText [
	^self chooseMultipleFrom: aCollection caption: aText default: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> chooseMultipleFrom: aCollection caption: aText default: aDefaultCollection [
	^self chooseFrom: aCollection labels: nil caption: aText multi: true default: aDefaultCollection

]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> confirm: aText [
	^self confirm: aText title: 'Bestätigung' buttonText: 'OK'
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> confirm: aText title: aTitleString buttonText: aButtonString [
	^self confirm: aText title: aTitleString buttonText: aButtonString cancelText: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> confirm: aText title: aTitleString buttonText: aButtonString cancelText: aCancelString [
	| answerValue |
	answerValue := self window: aTitleString with: (WEBConfirmationComponent new
			confirmationText: aButtonString;
			cancelText: aCancelString;
			message: aText;
			yourself).

	^answerValue = true
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> confirmYesNo: aText [
	^self confirm: aText title: 'Bestätigung' buttonText: 'Ja' cancelText: 'Nein'
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> confirmYesNo: aText ifNo: aBlock [
	^(self confirmYesNo: aText) ifFalse: aBlock
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> confirmYesNo: aText ifYes: aBlock [
	^(self confirmYesNo: aText) ifTrue: aBlock
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> confirmYesNo: aText ifYes: aBlock ifNo: aNoBlock [
	^(self confirmYesNo: aText) ifTrue: aBlock ifFalse: aNoBlock
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> inform: aText [
	^self inform: aText title: 'Information'
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> inform: aText title: aTitleString [
	^ self window: aTitleString with: (WEBInformationComponent new
			message: aText;
			yourself)
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> largeWindow: aText with: aComponent [
	^self lightbox: aComponent title: aText showClose: false large: true
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> lightbox: aComponent [
	self lightbox: aComponent title: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> lightbox: aComponent title: aTitleText [
	^self lightbox: aComponent title: aTitleText showClose: false
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> lightbox: aComponent title: aTitleText showClose: aBoolean [
	^self lightbox: aComponent title: aTitleText showClose: aBoolean large: false
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> lightbox: aComponent title: aTitleText showClose: aBoolean large: aBooleanLarge [
	"Display aComponent within a lightbox of the receiver. Note, that this does a full refresh displaying the lightbox. Also note, that this only works well, if you sent to the root component of your application."
	
	^ self wait: [ :cc | 
		self 
			show: aComponent
			onAnswer: cc
			delegation: (self pi defaultLightboxClass new
				delegate: aComponent;
				title: aTitleText;
				showCloseButton: aBoolean;
				isLarge: aBooleanLarge;
				yourself).
		WARenderNotification signal ]
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> offerDownload: aFilePath named: aFilename mime: aMimeString message: aMessageString [
	| downloader |

	downloader := WEBDownloadDocumentComponent named: aFilename action: [
		self sendFileToBrowser: aFilePath mime: aMimeString named: aFilename
	].

	downloader textMessage: aMessageString.
	
	self window: 'Download' with: downloader
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> offerDownloadFile: aWebLocalFileReference [
	^ self
		offerDownload: aWebLocalFileReference filePath
		named: aWebLocalFileReference title
		mime: aWebLocalFileReference contentType
		message: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> offloadDownloadWork: aBlock [
	"aBlock muss die Datei als WEBLocalFileReference liefern"
	| component jobId |
	
	jobId := self currentUser displayName, ' (', self currentUser uuidString, '): Download-Dokument erzeugen'.

	component := WEBBackgroundJobComponent
		jobTitle: jobId
		named: 'Ihre gewünschte Datei wird erzeugt.'
		block: aBlock.

	component beAutoClose.
	
	self show: component onAnswer: [:job |
		job ifSuccess: [
			| file |
			file := job executionResult. "WEBLocalFileReference"
			self offerDownloadFile: file]]
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> request: aText [
	^ self request: aText default: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> request: aQuestionText default: aDefaultText [
	^self request: aQuestionText title: 'Eingabe' default: aDefaultText

]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> request: aQuestionText default: aDefaultText validation: aBlock [
	| isValid newValue |
	newValue := aDefaultText.
	
	[
		newValue := self request: aQuestionText default: newValue.
		
		"Handle cancel"
		newValue ifNil: [^nil].
			
		isValid := aBlock isNil or: [(aBlock value: newValue) = true]. "Robustheit, es könnte non boolean kommen"
		isValid ifFalse: [
			self inform: 'Ungültige Eingabe, bitte erneut versuchen.'
		].
		
		] doWhileFalse: [isValid].
		
	^newValue
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> request: aQuestionText title: aTitleString [
	^self request: aQuestionText title: aTitleString default: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> request: aQuestionText title: aTitleString default: aDefaultText [
	^ self window: aTitleString with: (WEBInputDialog new
		default: aDefaultText;
		messageText: aQuestionText;
		yourself)
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> request: aQuestionText validation: aBlock [
	^self request: aQuestionText default: nil validation: aBlock
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> requestCaptcha [
	| answer |
	answer := self window: 'Captcha Code (Anti-Robot Sicherheitsabfrage)' with: WEBFigletCaptchaComponent new.

	^answer = true
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> requestMasked: aQuestionText [
	^ self window: 'Eingabe' with: (WEBInputDialog new
		beMasked;
		messageText: aQuestionText;
		yourself)
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> requestMultiline: aQuestionText [
	^self requestMultiline: aQuestionText default: nil
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> requestMultiline: aQuestionText default: aDefaultText [
	^ self window: 'Eingabe' with: (WEBInputDialog new
		beMultiline;
		default: aDefaultText;
		messageText: aQuestionText;
		yourself)
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> sendFileToBrowser: aFilePath mime: aMimeTypeString named: aString [
	"Sends the file to the browser"
	
	self requestContext respond: [ :response |
		response
			contentType: aMimeTypeString asString; "'application/pdf'"
			doNotCache;
			headerAt: 'X-Sendfile' put: aFilePath; "Apache"
			headerAt: 'X-Accel-Redirect' put: aFilePath; "nginx"
			attachmentWithFileName: aString ]
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> sendPdfToBrowser: aFilePath named: aString [
	self sendFileToBrowser: aFilePath mime: 'application/pdf' named: aString
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> warn: aText [
	^self warn: aText title: 'Wichtige Information'
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> warn: aText title: aTitleString [
	^ self window: aTitleString with: (WEBInformationComponent new
		beWarning;
		message: aText;
		yourself)
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> window: aComponent [
	^self window: nil with: aComponent
]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> window: aText with: aComponent [
	^self window: aText with: aComponent showClose: false

]

{ #category : #'*Webbase-View-Dialogs' }
WEBComponent >> window: aText with: aComponent showClose: showClose [
	^self lightbox: aComponent title: aText showClose: showClose

]
