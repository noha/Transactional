Class {
	#name : #TXTransactionTest,
	#superclass : #TXTransactionalTest,
	#category : #'Transactional-Core-Tests'
}

{ #category : #tests }
TXTransactionTest >> createClass [
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
]

{ #category : #tests }
TXTransactionTest >> testAutoCommitHandlerAbort [
	| transaction object  |
	self createClass.
	
	transaction := TXTransaction new
		addAutoCommit.
		
	object := aClass new.
	transaction do: [ 
		object 
			number: 3;
			string: 'foo';
			dict: { #foo -> #bar } asDictionary.
			Error signal ].
		
	self assert: object number equals: nil.
	self assert: object string equals: nil.
	self assert: object dict equals: nil.
]

{ #category : #tests }
TXTransactionTest >> testAutoCommitHandlerCommit [
	| transaction object  |
	self createClass.
	
	transaction := TXTransaction new
		addAutoCommit.
		
	object := aClass new.
	transaction do: [ 
		object 
			number: 3;
			string: 'foo';
			dict: { #foo -> #bar } asDictionary  ].
		
	self assert: object number equals: 3.
	self assert: object string equals: 'foo'.
	self assert: object dict equals: { #foo -> #bar } asDictionary.
]

{ #category : #tests }
TXTransactionTest >> testJournalBuilderAbort [
	| transaction object journal |
	self createClass.
	transaction := TXTransaction new
		addHandler: (TXJournalBuilderHandler new
			journalBlock: [:j | journal := j ]).
		
	object := aClass new.
	transaction do: [ 
		object 
			number: 3;
			string: 'foo';
			dict: { #foo -> #bar } asDictionary.
		Error signal  ].
		
	self assert: journal isNil.

]

{ #category : #tests }
TXTransactionTest >> testJournalBuilderCommit [
	| transaction object journal |
	self createClass.
	transaction := TXTransaction new
		addHandler: (TXJournalBuilderHandler new
			journalBlock: [:j | journal := j ]).
		
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

{ #category : #tests }
TXTransactionTest >> testNoHandlerAbort [
	| transaction object  |
	self createClass.
	
	transaction := TXTransaction new.
		
	object := aClass new.
	transaction do: [ 
		object 
			number: 3;
			string: 'foo';
			dict: { #foo -> #bar } asDictionary.
		Error signal  ].
		
	self assert: object number equals: nil.
	self assert: object string equals: nil.
	self assert: object dict equals: nil.
]

{ #category : #tests }
TXTransactionTest >> testNoHandlerCommit [
	| transaction object  |
	self createClass.
	
	transaction := TXTransaction new.
		
	object := aClass new.
	transaction do: [ 
		object 
			number: 3;
			string: 'foo';
			dict: { #foo -> #bar } asDictionary  ].
		
	self assert: object number equals: 3.
	self assert: object string equals: 'foo'.
	self assert: object dict equals: { #foo -> #bar } asDictionary.
]

{ #category : #tests }
TXTransactionTest >> testPluggableHanclerCommit [
	| transaction object objects |
	self createClass.
	
	transaction := TXTransaction new
		onCommit: [ :tx | objects := tx objects ]
		fail:  [:error | error pass ].
		
	object := aClass new.
	transaction do: [ 
		object 
			number: 3;
			string: 'foo';
			dict: { #foo -> #bar } asDictionary  ].
		
	self assert: objects size equals: 1.

]
