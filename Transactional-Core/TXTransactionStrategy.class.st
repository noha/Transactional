Class {
	#name : #TXTransactionStrategy,
	#superclass : #Object,
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXTransactionStrategy >> abort: transaction error: error [
	self subclassResponsibility 
]

{ #category : #accessing }
TXTransactionStrategy >> commit: transaction [
	self subclassResponsibility 
]
