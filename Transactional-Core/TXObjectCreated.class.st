Class {
	#name : #TXObjectCreated,
	#superclass : #Object,
	#instVars : [
		'object'
	],
	#category : #'Transactional-Core'
}

{ #category : #accessing }
TXObjectCreated >> object [
	^ object
]

{ #category : #accessing }
TXObjectCreated >> object: anObject [
	object := anObject
]
