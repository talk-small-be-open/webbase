Class {
	#name : #WEBTasks,
	#superclass : #WEBObject,
	#category : #'Webbase-Main-Core'
}

{ #category : #tasks }
WEBTasks class >> cleanupButler [
	self db butler cleanup
]

{ #category : #schedule }
WEBTasks class >> run5MinutelyTasks [
	self subclassResponsibility
]

{ #category : #schedule }
WEBTasks class >> runDailyTasks [
	self subclassResponsibility
]

{ #category : #schedule }
WEBTasks class >> runHourlyTasks [
	self subclassResponsibility
]

{ #category : #schedule }
WEBTasks class >> runNightlyTasks [
	self subclassResponsibility
]

{ #category : #tasks }
WEBTasks class >> wakeupButler [
	self db butler wakeup
]
