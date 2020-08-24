Class {
	#name : #TXObjectCreated,
	#superclass : #TXModification,
	#category : #'Transactional-Core'
}

{ #category : #printing }
TXObjectCreated >> printOn: aStream [
	aStream << 'created : ' << object class name 
]
