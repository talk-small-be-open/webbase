Class {
	#name : #WEBGlobalConfiguration,
	#superclass : #WEBObject,
	#instVars : [
		'values'
	],
	#category : #'Webbase-Database'
}

{ #category : #actions }
WEBGlobalConfiguration >> apply [
]

{ #category : #'as yet unclassified' }
WEBGlobalConfiguration >> emailDomain [
]

{ #category : #initialization }
WEBGlobalConfiguration >> initialize [
	super initialize.
	values := Dictionary new
]

{ #category : #accessing }
WEBGlobalConfiguration >> keys [
	^ values keys
]

{ #category : #'as yet unclassified' }
WEBGlobalConfiguration >> webDomain [
]

{ #category : #'as yet unclassified' }
WEBGlobalConfiguration >> webUrl [
]
