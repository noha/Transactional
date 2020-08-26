Class {
	#name : #TXPluggableTransactionStrategy,
	#superclass : #TXTransactionStrategy,
	#instVars : [
		'commitBlock',
		'abortBlock'
	],
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXPluggableTransactionStrategy >> abort: transaction error: error [
	abortBlock 
		ifNotNil: [ abortBlock value: error ]
		ifNil: [ error pass ]
	
]

{ #category : #accessing }
TXPluggableTransactionStrategy >> commit: transaction [
	commitBlock cull: transaction cull: self
]

{ #category : #enumerating }
TXPluggableTransactionStrategy >> onAbortDo: aBlock [ 
	abortBlock := aBlock
]

{ #category : #enumerating }
TXPluggableTransactionStrategy >> onCommitDo: aBlock [ 
	commitBlock := aBlock
]
