Class {
	#name : #TXJournalBuilder,
	#superclass : #Object,
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXJournalBuilder >> buildJournalFor: aTransaction [
	^ TXJournal new
		addAll: (aTransaction objects 
			flatCollect: [ :each | self modificationsOf: each ]
			as: OrderedCollection);
		yourself
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> isNew: anObject [
	"How can we decide in the image if an object has been newly created?"
	^ false
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> modificationForSlot: slot in: anObject [
	^ self propertyChangedClass new
		object: anObject;
		property: slot name;
		oldValue: (slot basicRead: anObject);
		newValue: (slot read: anObject) 
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> modificationsOf: anObject [
	| list |
	list := OrderedCollection new.
	(self isNew: anObject) ifTrue: [ 
		list add: (self objectCreated: anObject)].
	(self modifiedSlots: anObject) do: [ :slot |
		list add: (self modificationForSlot: slot in: anObject)] .
	^ list
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> modifiedSlots: anObject [
	^ (self slotsOf: anObject) select: [ :slot |
		slot hasChanged: anObject ]
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> objectCreated: anObject [
	^ self objectCreatedClass new
			object: anObject
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> objectCreatedClass [
	^ TXObjectCreated
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> propertyChangedClass [ 
	^ TXPropertyChange
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> slotsOf: anObject [
	^ anObject class slots 
		reject: [ :each | each name beginsWith: '_' ]
]
