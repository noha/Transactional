Class {
	#name : #TXTransactionHandler,
	#superclass : #Object,
	#instVars : [
		'next'
	],
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXTransactionHandler >> abort: transaction error: error [
	self subclassResponsibility 
]

{ #category : #accessing }
TXTransactionHandler >> commit: transaction [
	self subclassResponsibility 
]

{ #category : #accessing }
TXTransactionHandler >> last [
	next ifNil: [ ^ self ].
	^ next last
]

{ #category : #accessing }
TXTransactionHandler >> next [
	^ next
]

{ #category : #accessing }
TXTransactionHandler >> next: anObject [
	next := anObject
]
