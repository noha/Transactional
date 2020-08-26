Class {
	#name : #TXAutoCommitHandler,
	#superclass : #TXTransactionHandler,
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXAutoCommitHandler >> abort: transaction error: error [
	transaction objects do: [ :each |
		each transactionalAbort ]
]

{ #category : #accessing }
TXAutoCommitHandler >> commit: transaction [
	transaction objects do: [ :each |
		each transactionalCommit ]
]
