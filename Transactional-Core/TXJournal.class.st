Class {
	#name : #TXJournal,
	#superclass : #Object,
	#instVars : [
		'changes'
	],
	#category : #'Transactional-Core'
}

{ #category : #adding }
TXJournal >> add: aModification [
	changes add: aModification 
]

{ #category : #adding }
TXJournal >> addAll: aCollection [
	aCollection do: [ :each | self add: each ]
]

{ #category : #initialization }
TXJournal >> initialize [ 
	super initialize.
	changes := OrderedCollection new
]
