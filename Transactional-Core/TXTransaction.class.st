Class {
	#name : #TXTransaction,
	#superclass : #Object,
	#instVars : [
		'dirtyObjects'
	],
	#category : #'Transactional-Core-Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXTransaction class >> current [
	^ TXCurrentTransaction value
]

{ #category : #accessing }
TXTransaction >> abort: error [
	dirtyObjects do: [ :each |
		each transactionalAbort ]
]

{ #category : #accessing }
TXTransaction >> commit [ 
	dirtyObjects do: [ :each |
		each transactionalCommit ]
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
TXTransaction >> register: anObject [ 
	(dirtyObjects includes: anObject) ifFalse: [ 
		dirtyObjects add: anObject ]
]
