Extension { #name : #WAComponent }

{ #category : #'*Webbase-View-Main' }
WAComponent >> cancel [
	"Standard implementation for the form decoration FormDecoration to work out of the box"
	self answer: nil
]

{ #category : #'*Webbase-View-Main' }
WAComponent >> close [
	"Standard implementation for the form decoration DAZFormDecoration to work out of the box"
	self answer
]

{ #category : #'*Webbase-View-Main' }
WAComponent >> ok [
	"Standard implementation for the form decoration PPLFormDecoration to work out of the box"
	self answer
]
