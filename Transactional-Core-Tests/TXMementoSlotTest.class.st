Class {
	#name : #TXMementoSlotTest,
	#superclass : #SlotSilentTest,
	#category : #'Transactional-Core-Tests'
}

{ #category : #running }
TXMementoSlotTest >> createClass [
	| mementoSlot |
	Transcript show: '// create class'; cr.
	mementoSlot := #memento2 => TXMementoSlot.
	Transcript show: '- after slot'; cr.
	aClass := self make: [ :builder | 
		builder 
			slots: { mementoSlot } ].
	Transcript show: '\\ create class'; cr.
]

{ #category : #tests }
TXMementoSlotTest >> forkWithTransaction: aBlock [
	[ 
		TXCurrentTransaction 
			value: TXTransaction new 
			during: aBlock ] fork
]

{ #category : #running }
TXMementoSlotTest >> setUp [ 
	Transcript show: '// setUp'; cr.
	super setUp.
	self createClass.
	Transcript show: '\\ setUp'; cr.
]

{ #category : #running }
TXMementoSlotTest >> tearDown [ 
	aClass := nil.
]

{ #category : #tests }
TXMementoSlotTest >> testConcurrentWriteCollection [
	| object semaphore1 semaphore2 mementoSlot |
	object transactionalAbort .
	mementoSlot := aClass slotNamed: #memento2.
	object := aClass new.
	object transactionalAbort .
	Transcript show: '-- UI --'; cr.
	Transcript show: 'UI before process: ', Processor activeProcess identityHash asString; cr.
	mementoSlot write: #(1 2 3 4 5 6) asOrderedCollection to: object.	
	self assert: (mementoSlot read: object) equals: #(1 2 3 4 5 6) asOrderedCollection.
	Transcript show: '// UI --'; cr.
	semaphore1 := Semaphore new.
	semaphore2 := Semaphore new.
	
	

	self forkWithTransaction: [  
		Transcript show: '-- #1 --'; cr.
		Transcript show: '#1 before process: ', Processor activeProcess identityHash asString; cr.
		self assert: (mementoSlot read: object) equals: #(1 2 3 4 5 6) asOrderedCollection.
		(mementoSlot read: object) removeAt: 3.
		Transcript show: '// #1 --'; cr.
		semaphore1 wait.
		Transcript show: '-- #1 --'; cr.
		Transcript show: '#1 after process: ', Processor activeProcess identityHash asString; cr.
		self assert: (mementoSlot read: object) equals: #(1 2 4 5 6) asOrderedCollection.
		Transcript show: '// #1 --'; cr. ].
		

	self forkWithTransaction: [  
		Transcript show: '-- #2 --'; cr.
		self assert: (mementoSlot read: object) equals: #(1 2 3 4 5 6) asOrderedCollection.
		Transcript show: '#2 before process: ', Processor activeProcess identityHash asString; cr.
		(mementoSlot read: object) add: 7.
		Transcript show: '// #2 --'; cr.
		semaphore2 wait.
		Transcript show: '-- #2 --'; cr.
		Transcript show: '#2 after process: ', Processor activeProcess identityHash asString; cr.
		self assert: (mementoSlot read: object) equals: #(1 2 3 4 5 6 7) asOrderedCollection.
		Transcript show: '// #2 --'; cr.
 ].
	
	Transcript show: 'UI after process: ', Processor activeProcess identityHash asString; cr.
	self assert: (mementoSlot read: object) equals: #(1 2 3 4 5 6) asOrderedCollection.
	semaphore2 signal.
	100 milliSeconds wait.
	semaphore1 signal. 
]

{ #category : #tests }
TXMementoSlotTest >> testConcurrentWriteObject [	
	| object semaphore1 semaphore2 mementoSlot |
	
	mementoSlot := aClass slotNamed: #memento2.
	object := aClass new. 
	semaphore1 := Semaphore new.
	semaphore2 := Semaphore new.
	
	self forkWithTransaction: [  
		self assert: (mementoSlot read: object) equals: nil.
		mementoSlot write: #process1 to: object.
		semaphore1 wait.
		self assert: (mementoSlot read: object) equals: #process1 ].
	
	self forkWithTransaction: [  
		self assert: (mementoSlot read: object) equals: nil.
		mementoSlot write: #process2 to: object.
		semaphore2 wait.
		self assert: (mementoSlot read: object) equals: #process2 ].
	
	self assert: (mementoSlot read: object) equals: nil.
	semaphore2 signal.
	100 milliSeconds wait.
	semaphore1 signal. 
]

{ #category : #tests }
TXMementoSlotTest >> testCreateClassWithMementoSlot [
	| mementoSlot |
	
	mementoSlot := aClass slotNamed: #memento2.

	self assert: (aClass hasSlot: mementoSlot).
	self assert: (aClass classLayout hasSlot: (mementoSlot instVarNamed: 'memento'))
	

]

{ #category : #tests }
TXMementoSlotTest >> testCreateClassWithNilMemento [
	| value mementoSlot |
	
	mementoSlot := aClass slotNamed: #memento2.
	
	value := mementoSlot read: aClass new.
	self assert: value equals: nil 

]

{ #category : #tests }
TXMementoSlotTest >> testCreateClassWithValueWrite [
	| object mementoSlot |

	mementoSlot := aClass slotNamed: #memento2.
	
	object := aClass new.
	mementoSlot write: #foo to: object.
	self assert: (mementoSlot read: object) equals: #foo

]

{ #category : #tests }
TXMementoSlotTest >> testCreateClassWithValueWriteInProcess [
	| object semaphore mementoSlot |
	
	mementoSlot := aClass slotNamed: #memento2.
	
	object := aClass new.
	semaphore := Semaphore new.
	[ 
		mementoSlot write: #foo to: object.
		self assert: (mementoSlot read: object) equals: #foo.
		semaphore signal.
	] fork.
	semaphore wait.
]

{ #category : #tests }
TXMementoSlotTest >> testSetTransaction [
	
	TXCurrentTransaction 
		value: TXTransaction new 
		during: [  self assert: TXTransaction current notNil ]
]
