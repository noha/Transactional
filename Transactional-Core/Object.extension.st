Extension { #name : #Object }

{ #category : #'*Transactional-Core' }
Object >> transactionalAbort [
	(self class slots select: [ :each | (each name beginsWith: '_') not ]) do: [ :slot|
		slot abort: self ]
]

{ #category : #'*Transactional-Core' }
Object >> transactionalCommit [
	(self class slots select: [ :each | (each name beginsWith: '_') not ]) do: [ :slot|
		slot commit: self ]
]
