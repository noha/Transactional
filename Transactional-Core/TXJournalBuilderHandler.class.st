Class {
	#name : #TXJournalBuilderHandler,
	#superclass : #TXTransactionHandler,
	#instVars : [
		'journalBlock'
	],
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXJournalBuilderHandler >> abort: transaction error: error [
	
]

{ #category : #accessing }
TXJournalBuilderHandler >> commit: transaction [
	journalBlock value: (TXJournalBuilder new 
		buildJournalFor: transaction)
]

{ #category : #accessing }
TXJournalBuilderHandler >> journalBlock: anObject [
	journalBlock := anObject
]
