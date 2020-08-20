Class {
	#name : #TXPropertyChange,
	#superclass : #Object,
	#instVars : [
		'name',
		'oldValue',
		'newValue'
	],
	#category : #Transactional
}

{ #category : #accessing }
TXPropertyChange >> name [
	^ name
]

{ #category : #accessing }
TXPropertyChange >> name: anObject [
	name := anObject
]

{ #category : #accessing }
TXPropertyChange >> newValue [
	^ newValue
]

{ #category : #accessing }
TXPropertyChange >> newValue: anObject [
	newValue := anObject
]

{ #category : #accessing }
TXPropertyChange >> oldValue [
	^ oldValue
]

{ #category : #accessing }
TXPropertyChange >> oldValue: anObject [
	oldValue := anObject
]
