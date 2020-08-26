Class {
	#name : #TXAutoCommitStrategy,
	#superclass : #TXTransactionStrategy,
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXAutoCommitStrategy >> abort: transaction error: error [
	transaction objects do: [ :each |
		each transactionalAbort ]
]

{ #category : #accessing }
TXAutoCommitStrategy >> commit: transaction [
	transaction objects do: [ :each |
		each transactionalCommit ]
]
