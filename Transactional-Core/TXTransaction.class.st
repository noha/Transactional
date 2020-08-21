Class {
	#name : #TXTransaction,
	#superclass : #Object,
	#instVars : [
		'dirty'
	],
	#category : #'Transactional-Core-Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXTransaction class >> current [
	^ TXCurrentTransaction value
]

{ #category : #accessing }
TXTransaction >> abort: error [
	Transcript show: '---abort: ', error messageText, '---'; cr.
	dirty do: [ :each |
		Transcript show: each asString; cr ]
]

{ #category : #accessing }
TXTransaction >> commit [ 
	Transcript show: '---commit---'; cr.
	dirty do: [ :each |
		Transcript show: each asString; cr ]
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
	dirty := Set new
]

{ #category : #accessing }
TXTransaction >> register: anObject [ 
	dirty add: anObject
]
