Extension { #name : #WEBObject }

{ #category : #'*Webbase-Database' }
WEBObject >> db [
	^ WEBDatabase current
]

{ #category : #'*Webbase-Database' }
WEBObject class >> db [
	^ WEBDatabase current
]
