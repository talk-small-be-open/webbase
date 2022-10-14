Extension { #name : #WEBTasks }

{ #category : #'*Webbase-Pharo' }
WEBTasks class >> garbageCollect [
	Smalltalk garbageCollect
]

{ #category : #'*Webbase-Pharo' }
WEBTasks class >> saveAndQuitPharo [
"	self saveBackup."

	"Delay, so that the image date will be really newer. Startup will not restore from backup then"
"	(Delay forSeconds: 2) wait."
	
	"Fork, damit dem Task von aussen nicht die Verbindung abgeschnitten wird via curl"
	Smalltalk snapshot: true andQuit: true
]

{ #category : #'*Webbase-Pharo' }
WEBTasks class >> saveSmalltalkImage [

	Smalltalk saveSession.

	"TODO: Make history copy of the image&sources file through file operations?"
]
