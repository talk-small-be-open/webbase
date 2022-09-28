Class {
	#name : #WEBComponent,
	#superclass : #WAComponent,
	#instVars : [
		'formDecoration',
		'containerDecoration'
	],
	#category : #'Webbase-View-Main'
}

{ #category : #'helpers-ui' }
WEBComponent class >> requestPassword [
	^self window: 'Passwortabfrage' with: WEBPasswordComponent new
]

{ #category : #adding }
WEBComponent >> addContainerClass: aCssString [
	containerDecoration addClass: aCssString
]

{ #category : #'as yet unclassified' }
WEBComponent >> formDecoration [
	^ self decorations detect: [ :each | each isKindOf: WEBFormDecoration ] ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
WEBComponent >> formDecoration: anObject [
	formDecoration := anObject
]

{ #category : #initialization }
WEBComponent >> initialize [
	super initialize.
	containerDecoration := self addContainerDiv
]
