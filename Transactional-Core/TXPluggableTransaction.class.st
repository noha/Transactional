Class {
	#name : #TXPluggableTransaction,
	#superclass : #TXTransaction,
	#instVars : [
		'commitBlock',
		'abortBlock'
	],
	#category : #'Transactional-Core-Transactional-Core'
}

{ #category : #accessing }
TXPluggableTransaction >> abort: error [
	super abort: error.
	abortBlock 
		ifNotNil: [ abortBlock value: error ]
		ifNil: [ error pass ]
	
]

{ #category : #accessing }
TXPluggableTransaction >> commit [ 
	super commit.
	commitBlock cull: dirty cull: self
]

{ #category : #'as yet unclassified' }
TXPluggableTransaction >> journal [
	^ dirty 
		flatCollect: [ :each | self journalFor: each ]
		as: OrderedCollection 
]

{ #category : #'as yet unclassified' }
TXPluggableTransaction >> journalFor: anObject [
	| list |
	list := OrderedCollection new.
	anObject isNew ifTrue: [ 
		list add: (TXObjectCreated new 
			object: anObject)].
	(anObject class slots reject: [ :each | each name beginsWith: '_' ]) do: [ :slot |
		(slot hasChanged: anObject) ifTrue: [ 
			list add: (TXPropertyChange new
				name: slot name;
				oldValue: (slot readOriginal: anObject);
				newValue: (slot read: anObject) )] ].
	^ list
]

{ #category : #enumerating }
TXPluggableTransaction >> onAbortDo: aBlock [ 
	abortBlock := aBlock
]

{ #category : #enumerating }
TXPluggableTransaction >> onCommitDo: aBlock [ 
	commitBlock := aBlock
]