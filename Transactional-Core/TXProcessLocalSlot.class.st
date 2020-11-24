Class {
	#name : #TXProcessLocalSlot,
	#superclass : #ProcessLocalSlot,
	#category : #'Transactional-Core'
}

{ #category : #initialization }
TXProcessLocalSlot >> initialize: anObject [
	thisContext object: anObject instVarAt: index put: TXProcessLocalVariable new
]

{ #category : #testing }
TXProcessLocalSlot >> isVisible [ 
	^ false
]

{ #category : #accessing }
TXProcessLocalSlot >> reset: anObject [
	(thisContext object: anObject instVarAt: index) reset: anObject
]
