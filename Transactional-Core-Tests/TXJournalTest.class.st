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

{ #category : #running }
TXJournalTest >> tearDown [ 
	super tearDown.
	aClass := nil
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
	transaction := TXTransaction new
		addAutoCommit;
		onCommit:  
		[ :tx :ctx | | builder |
			self assert: tx numberOfObjects equals: 1.
			builder := TXJournalBuilder new.
			journal := builder buildJournalFor: tx.
			self assert: journal numberOfChanges equals: 3 ]
		fail:  [:error | error pass ].
		
	object := aClass new.
	transaction do: [ 
		object 
			number: 3;
			string: 'foo';
			dict: { #foo -> #bar } asDictionary  ].
		
	self assert: journal changes first newValue equals: 3.
	self assert: journal changes second newValue equals: 'foo'.
	self assert: journal changes third newValue equals: { #foo -> #bar } asDictionary.
]
