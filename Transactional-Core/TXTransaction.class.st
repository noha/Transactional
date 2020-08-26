Class {
	#name : #TXTransaction,
	#superclass : #Object,
	#instVars : [
		'dirtyObjects',
		'handler'
	],
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXTransaction class >> current [
	^ TXCurrentTransaction value
]

{ #category : #'as yet unclassified' }
TXTransaction class >> pluggable [
	^ self new 
		commitStrategy: TXPluggableHandler new;
		yourself
]

{ #category : #services }
TXTransaction >> abort: error [
	self handler 
		abort: self error: error
]

{ #category : #adding }
TXTransaction >> addAutoCommit [
	self addHandler: TXAutoCommitHandler new
]

{ #category : #adding }
TXTransaction >> addHandler: aHandler [
	handler 
		ifNotNil: [ handler last add: aHandler ]
		ifNil: [ handler := aHandler ]
]

{ #category : #accessing }
TXTransaction >> commit [
	^ self handler commit: self
]

{ #category : #accessing }
TXTransaction >> defaultHandler [
	^ TXAutoCommitHandler 
]

{ #category : #enumerating }
TXTransaction >> do: aBlock [ 
	TXCurrentTransaction 
		value: self
		during: [
			[  aBlock value.
				self commit  ]
					on: Error do: [:error | 
						self abort: error ] ]
]

{ #category : #accessing }
TXTransaction >> handler [
	^ handler ifNil: [ 
		handler := self defaultHandler ]
]

{ #category : #initialization }
TXTransaction >> initialize [ 
	super initialize.
	dirtyObjects := OrderedCollection new
]

{ #category : #enumerating }
TXTransaction >> numberOfObjects [
	^ dirtyObjects size
]

{ #category : #accessing }
TXTransaction >> objects [
	^ dirtyObjects 
]

{ #category : #adding }
TXTransaction >> onCommit: successBlock fail: failBlock [
	self addHandler: (TXPluggableHandler new
		onCommitDo: successBlock;
		onAbortDo: failBlock)
]

{ #category : #accessing }
TXTransaction >> register: anObject [ 
	(dirtyObjects includes: anObject) ifFalse: [ 
		dirtyObjects add: anObject ]
]
