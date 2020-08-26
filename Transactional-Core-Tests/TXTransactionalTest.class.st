Class {
	#name : #TXTransactionalTest,
	#superclass : #SlotSilentTest,
	#category : #'Transactional-Core-Tests'
}

{ #category : #tests }
TXTransactionalTest >> compileAccessorsNamed: aSymbol [
	self compileAccessorsFor: (aClass slotNamed: aSymbol)
]

{ #category : #running }
TXTransactionalTest >> createClass [
	self subclassResponsibility 

]

{ #category : #tests }
TXTransactionalTest >> forkWithTransaction: aBlock [
	[ 
		TXCurrentTransaction 
			value: TXTransaction new 
			during: aBlock ] fork
]

{ #category : #running }
TXTransactionalTest >> setUp [ 
	super setUp.
	self createClass.

]

{ #category : #running }
TXTransactionalTest >> tearDown [ 
	aClass := nil.
]
