Class {
	#name : #TXJournalTest,
	#superclass : #SlotSilentTest,
	#category : #'Transactional-Core-Tests'
}

{ #category : #tests }
TXJournalTest >> compileAccessorsNamed: aSymbol [
	self compileAccessorsFor: (aClass slotNamed: aSymbol)
]

{ #category : #tests }
TXJournalTest >> forkWithTransaction: aBlock [
	[ 
		TXCurrentTransaction 
			value: TXTransaction new 
			during: aBlock ] fork
]

{ #category : #tests }
TXJournalTest >> testBuildJournal [
	"Add instance variables using the builder interface"
	
	| transaction object journal |
	aClass := self make: [ :builder |
		builder 
			slots: {
				#number => TXMementoSlot.
				#string => TXMementoSlot.
				#dict => TXMementoSlot}
		].
	
	self compileAccessorsNamed: #number.
	self compileAccessorsNamed: #string.
	self compileAccessorsNamed: #dict.
	
	transaction := TXPluggableTransaction new
		onCommitDo: [ :list :tx | 
			self assert: list size = 1.
			journal := tx journalFor: list anyOne.
			self assert: journal size equals: 3 ];
		onAbortDo: [:error | error pass ].
		
	object := aClass new.
	transaction do: [ 
		object 
			number: 3;
			string: 'foo';
			dict: { #foo -> #bar } asDictionary  ].
		
	self assert: journal first newValue equals: 3.
	self assert: journal second newValue equals: 'foo'.
	self assert: journal third newValue equals: { #foo -> #bar } asDictionary.
]
