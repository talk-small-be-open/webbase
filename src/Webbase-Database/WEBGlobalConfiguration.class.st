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
	"do proactive stuff with the configuration values, if any"
]

{ #category : #accessing }
WEBGlobalConfiguration >> at: aKey [
	^ values at: aKey
]

{ #category : #accessing }
WEBGlobalConfiguration >> at: aKey ifAbsent: aBlock [
	^ values at: aKey ifAbsent: aBlock
]

{ #category : #accessing }
WEBGlobalConfiguration >> at: aKey put: aValue [
	values at: aKey put: aValue
]

{ #category : #'as yet unclassified' }
WEBGlobalConfiguration >> emailDomain [
	^ self at: #emailDomain ifAbsent: [ self webDomain ]
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
	^ self at: #webDomain ifAbsent: [ 'resres.ch' ]
]

{ #category : #'as yet unclassified' }
WEBGlobalConfiguration >> webUrl [
	^ ('https://', self webDomain, '/app') seasideUrl
]
