Extension { #name : #WAPresenter }

{ #category : #'*Webbase-View-Main' }
WAPresenter >> currentUser [
	^self session user
]

{ #category : #'*Webbase-View-Main' }
WAPresenter >> flashErrorMessage: aMessageString [
	^self session addFlashErrorMessage: aMessageString
]

{ #category : #'*Webbase-View-Main' }
WAPresenter >> flashMessage: aMessageString [
	^self session addFlashMessage: aMessageString
]

{ #category : #'*Webbase-View-Main' }
WAPresenter >> isLoggedIn [
	^self session isLoggedIn
]
