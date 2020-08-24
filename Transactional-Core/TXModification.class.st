Class {
	#name : #TXModification,
	#superclass : #Object,
	#instVars : [
		'object'
	],
	#category : #'Transactional-Core'
}

{ #category : #accessing }
TXModification >> object [
	^ object
]

{ #category : #accessing }
TXModification >> object: anObject [
	object := anObject
]
