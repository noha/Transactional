Class {
	#name : #TXProcessLocalVariable,
	#superclass : #ProcessLocalVariable,
	#category : #'Transactional-Core'
}

{ #category : #accessing }
TXProcessLocalVariable >> default [ 
	^ TXNoValue 
]

{ #category : #initialization }
TXProcessLocalVariable >> reset: anObject [
	^ Processor activeProcess resetPSValueAt: index 
]
