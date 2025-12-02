Class {
	#name : #WEBMaDateAndTimeComponent,
	#superclass : #MATextInputComponent,
	#traits : 'TWEBComponentHelpers',
	#classTraits : 'TWEBComponentHelpers classTrait',
	#category : #'Webbase-Magritte'
}

{ #category : #rendering }
WEBMaDateAndTimeComponent >> renderInputOn: html [
	html dateTimeLocalInput
"		on: #string of: self"
		value: (self value asString first: 16) ; "YYYY-MM-DDTHH:MM"
		callback: [ :value | self value: (DateAndTime fromString: value) ]
]
