Class {
	#name : #WEBSystemCommand,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Misc'
}

{ #category : #convenience }
WEBSystemCommand class >> cp: aSource to: aTarget [
	self run: 'cp "', aSource, '" "', aTarget, '"'
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> ensureNonBullshitShellCommand: aShellCommandString [

	aShellCommandString isByteString ifFalse: [
		WEBError signal: 'Cant execute non-8bit shell commands' ].
		
	"TODO: Check more than that?"
]

{ #category : #command }
WEBSystemCommand class >> fetch: aCommandString [
	| shellOutput exitCode shell output cmd |
	self logCommand: aCommandString.

	cmd := aCommandString.
	
	self ensureNonBullshitShellCommand: cmd.

	OSSUnixSubprocess new
		shellCommand: cmd;
		redirectStdout;
		runAndWaitOnExitDo: [ :process :outString |
			shellOutput := WEBHelper fromUtf8: outString.
		].

	self logOutput: shellOutput.

	^shellOutput
]

{ #category : #convenience }
WEBSystemCommand class >> lns: aSource to: aTarget [
	self run: 'ln -fs "', aSource, '" "', aTarget, '"'
]

{ #category : #convenience }
WEBSystemCommand class >> lns: aSource to: aTarget inFolder: aFolderString [
	self run: 'cd "', aFolderString, '" && ln -fs "', aSource, '" "', aTarget, '"'
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> logCommand: aString [
	Transcript
		show: ('System-Call: ', aString);
		cr.
]

{ #category : #'as yet unclassified' }
WEBSystemCommand class >> logOutput: aString [
	Transcript show: ('System-Call output: ', aString)
]

{ #category : #convenience }
WEBSystemCommand class >> mv: aSource to: aTarget [
	self run: 'mv "', aSource, '" "', aTarget, '"'
]

{ #category : #convenience }
WEBSystemCommand class >> rm: aSource [
	self run: 'rm -f "', aSource, '"'
]

{ #category : #command }
WEBSystemCommand class >> run: aCommandString [
	| cmd |

	self logCommand: aCommandString.

	cmd := aCommandString.
	
	self ensureNonBullshitShellCommand: cmd.

	^ OSSUnixSubprocess new
		shellCommand: cmd;
		runAndWait;
		isSuccess
]

{ #category : #command }
WEBSystemCommand class >> runAsync: aCommandString [
	| cmd |

	self logCommand: aCommandString.
	
	cmd := aCommandString.

	self ensureNonBullshitShellCommand: cmd.
	
	OSSUnixSubprocess new
		shellCommand: cmd;
		run
]
