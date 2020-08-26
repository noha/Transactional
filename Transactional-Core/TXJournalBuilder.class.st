Class {
	#name : #TXJournalBuilder,
	#superclass : #Object,
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXJournalBuilder >> buildJournalFor: aTransaction [
	| journal |
	journal := TXJournal new.
	journal addAll: (aTransaction objects 
		flatCollect: [ :each | self journalFor: each ]
		as: OrderedCollection) 
]

{ #category : #'as yet unclassified' }
TXJournalBuilder >> journalFor: anObject [
	| list |
	list := OrderedCollection new.
	"anObject isNew ifTrue: [ 
		list add: (TXObjectCreated new 
			object: anObject)]."
	(anObject class slots reject: [ :each | each name beginsWith: '_' ]) do: [ :slot |
		(slot hasChanged: anObject) ifTrue: [ 
			list add: (TXPropertyChange new
				object: anObject;
				property: slot name;
				oldValue: (slot basicRead: anObject);
				newValue: (slot read: anObject) )] ].
	^ list
]
