Class {
	#name : #TXTransaction,
	#superclass : #Object,
	#instVars : [
		'handlers',
		'objects'
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
	self handlersDo: [ :handler |
		handler abort: self error: error ]
			
]

{ #category : #adding }
TXTransaction >> addAutoCommit [
	self addHandler: TXAutoCommitHandler new
]

{ #category : #adding }
TXTransaction >> addHandler: aHandler [
	handlers add: aHandler

]

{ #category : #accessing }
TXTransaction >> commit [
	self handlersDo: [ :handler |
		handler commit: self ]
					
]

{ #category : #'as yet unclassified' }
TXTransaction >> defaultHandler [
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
TXTransaction >> handlers [
	^ handlers
]

{ #category : #services }
TXTransaction >> handlersDo: aBlock [
	handlers
		ifNotEmpty: [ :h |
			h do: [ :handler |
				[ aBlock value: handler ]
					on: Error 
					do: [ :err | "ignore for now" ] ] ]
		ifEmpty: [ 
			aBlock value: self defaultHandlerClass new ]
		
]

{ #category : #initialization }
TXTransaction >> initialize [ 
	super initialize.
	objects := OrderedCollection new.
	handlers := OrderedCollection new
]

{ #category : #enumerating }
TXTransaction >> numberOfObjects [
	^ objects size
]

{ #category : #accessing }
TXTransaction >> objects [
	^ objects 
]

{ #category : #adding }
TXTransaction >> onCommit: successBlock fail: failBlock [
	self addHandler: (TXPluggableHandler new
		onCommitDo: successBlock;
		onAbortDo: failBlock)
]

{ #category : #accessing }
TXTransaction >> register: anObject [ 
	(objects includes: anObject) ifFalse: [ 
		objects add: anObject ]
]
