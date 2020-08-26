Class {
	#name : #TXTransactionHandler,
	#superclass : #Object,
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
