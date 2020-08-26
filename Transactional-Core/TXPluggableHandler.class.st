Class {
	#name : #TXPluggableHandler,
	#superclass : #TXTransactionHandler,
	#instVars : [
		'commitBlock',
		'abortBlock'
	],
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXPluggableHandler >> abort: transaction error: error [
	abortBlock 
		ifNotNil: [ abortBlock value: error ]
		ifNil: [ error pass ]
	
]

{ #category : #accessing }
TXPluggableHandler >> commit: transaction [
	commitBlock cull: transaction cull: self
]

{ #category : #enumerating }
TXPluggableHandler >> onAbortDo: aBlock [ 
	abortBlock := aBlock
]

{ #category : #enumerating }
TXPluggableHandler >> onCommitDo: aBlock [ 
	commitBlock := aBlock
]
