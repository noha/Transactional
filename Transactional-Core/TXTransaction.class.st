Class {
	#name : #TXTransaction,
	#superclass : #Object,
	#instVars : [
		'dirtyObjects',
		'commitStrategy'
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
		commitStrategy: TXPluggableTransactionStrategy new;
		yourself
]

{ #category : #services }
TXTransaction >> abort: error [
	self commitStrategy 
		abort: self error: error
]

{ #category : #adding }
TXTransaction >> addPluggableDo: successBlock fail: failBlock [
	| pluggable |
	pluggable := TXPluggableTransactionStrategy new
		onCommitDo: successBlock;
		onAbortDo: failBlock.
	commitStrategy 
		ifNotNil: [ commitStrategy last add: pluggable ]
		ifNil: [ commitStrategy := pluggable ]
]

{ #category : #accessing }
TXTransaction >> commit [
	^ self commitStrategy commit: self
]

{ #category : #accessing }
TXTransaction >> commitStrategy [
	^ commitStrategy ifNil: [ 
		commitStrategy := self defaultCommitStrategy ]
]

{ #category : #accessing }
TXTransaction >> commitStrategy: anObject [
	commitStrategy := anObject
]

{ #category : #accessing }
TXTransaction >> defaultCommitStrategy [
	^ TXAutoCommitStrategy 
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

{ #category : #initialization }
TXTransaction >> initialize [ 
	super initialize.
	dirtyObjects := OrderedCollection new
]

{ #category : #accessing }
TXTransaction >> objects [
	^ dirtyObjects 
]

{ #category : #accessing }
TXTransaction >> register: anObject [ 
	(dirtyObjects includes: anObject) ifFalse: [ 
		dirtyObjects add: anObject ]
]
