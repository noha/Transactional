Class {
	#name : #TXJournalBuilderHandler,
	#superclass : #TXTransactionHandler,
	#instVars : [
		'builder',
		'journalBlock'
	],
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXJournalBuilderHandler >> abort: transaction error: error [
	
]

{ #category : #accessing }
TXJournalBuilderHandler >> builder [
	^ builder ifNil:[
		builder := self defaultBuilder ]
]

{ #category : #accessing }
TXJournalBuilderHandler >> builder: anObject [
	builder := anObject
]

{ #category : #accessing }
TXJournalBuilderHandler >> commit: transaction [
	journalBlock value: (TXJournalBuilder new 
		buildJournalFor: transaction)
]

{ #category : #accessing }
TXJournalBuilderHandler >> defaultBuilder [
	^ self defaultBuilderClass new
]

{ #category : #accessing }
TXJournalBuilderHandler >> defaultBuilderClass [
	^ TXJournalBuilder 
]

{ #category : #accessing }
TXJournalBuilderHandler >> journalBlock: anObject [
	journalBlock := anObject
]
