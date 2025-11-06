Class {
	#name : #WEBBackgroundJobComponent,
	#superclass : #WEBBackgroundJobComponentBase,
	#instVars : [
		'isFirstDisplay'
	],
	#category : #'Webbase-Main-Offloading'
}

{ #category : #initialization }
WEBBackgroundJobComponent >> initialize [
	super initialize.
	
	isFirstDisplay := true
]

{ #category : #'as yet unclassified' }
WEBBackgroundJobComponent >> poll [
	"Polling"
	isFirstDisplay := false.
	self checkIfFinished.
]

{ #category : #rendering }
WEBBackgroundJobComponent >> renderContentOn: html [
	| refreshMs |
	
	refreshMs := self ifDevelopment: [ 1000 ] else: [ 5000 ].
	
	self shouldDisplayWaitScreen
		ifTrue: [
			html alertWarning
				with: [
					html h4: [
						html spinner; space; space.
						html text: 'Einen Moment bitte'
					].
					html paragraph: [
						html span: self jobTitle.
						self ifDevelopment: [
							html break.
							html anchor
								callback: [self abort];
								with: 'Abbrechen']]].
			html script: ((html javascript
				callback: [ self poll ]) setTimeout: refreshMs).
		]
		ifFalse: [
			job isSuccess ifTrue: [html alertSuccess: 'OK'].
			job isError ifTrue: [html alertDanger: 'FEHLER ', job errorDescription].
			html anchorButton
				callback: [self close];
				with: 'Vorgang fertig. Schliessen.'
		].

]

{ #category : #asserting }
WEBBackgroundJobComponent >> shouldDisplayWaitScreen [
	^ self isGenerating or: [ isFirstDisplay ]
]
