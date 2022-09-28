Class {
	#name : #WEBComponent,
	#superclass : #WAComponent,
	#category : #'Webbase-View-Main'
}

{ #category : #'helpers-ui' }
WEBComponent class >> requestPassword [
	^self window: 'Passwortabfrage' with: WEBPasswordComponent new
]

{ #category : #'as yet unclassified' }
WEBComponent >> formDecoration [
	^ self decorations detect: [ :each | each isKindOf: WEBFormDecoration ] ifNone: [ nil ]
]

{ #category : #initialization }
WEBComponent >> initialize [
	super initialize.

]
