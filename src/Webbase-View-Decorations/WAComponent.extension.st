Extension { #name : #WAComponent }

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> addBackButton [
	self addDecoration: WEBBackButtonDecoration new

]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> addBackButton: aLabelKey [
	self addDecoration: ((WEBBackButtonDecoration new)
		label: aLabelKey;
		yourself)

]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> addContainerDiv [
	| css classes |

	"Add a standard wrapping container div with the name of the component class"
	classes := OrderedCollection new
		add: self class;
		yourself.
		
	classes addAll: (self class allSuperclasses copyUpTo: WAComponent).
		
	css := (classes collect: [:each | each name asString]) joinUsing: ' '.

	^ self addContainerDiv: css

]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> addContainerDiv: aCssClassString [
	"Add a standard wrapping container div"
	^ self addDecoration: ((WEBDivDecoration cssClass: (aCssClassString))
		beLocal;
		yourself)
]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> addForm [
	self removeForm.
	^ self addDecoration: WEBFormDecoration new
]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> addForm: aButtonsCollection [
	^self addForm
		buttons: aButtonsCollection;
		beDirtyChecked;
		yourself
]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> beKeepaliveSession [
	self addDecoration: WEBKeepaliveSessionDecoration new

]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> beRestoringScrollPosition [
	self addDecoration: WEBRestoreScrollPositionDecoration new

]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> formDecoration [
	self shouldBeImplemented
]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> removeForm [
	self formDecoration ifNotNil: [
		self removeDecoration: self formDecoration.
	]
]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> renderFormButtonsOn: html [
	"Um die Buttons der Form-Decoration noch explizit an anderen Stellen platzieren zu können"
	self formDecoration renderButtonsOn: html
]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> restoreScrollPositionId [
	^self identityHash greaseString
]

{ #category : #'*Webbase-View-Decorations' }
WAComponent >> showWithBack: aComponent [
	self show: (aComponent addBackButton; yourself)
]
