Class {
	#name : #TXMementoSlot,
	#superclass : #IndexedSlot,
	#instVars : [
		'memento'
	],
	#category : #'Transactional-Core-Transactional-Core'
}

{ #category : #testing }
TXMementoSlot >> hasChanged: anObject [
	^ ((self read: anObject) = (self readOriginal: anObject)) not
]

{ #category : #'class building' }
TXMementoSlot >> installingIn: aClass [
	| slotName |
	super installingIn: aClass.
	
	slotName := ('_mementoSlot_', self name) asSymbol.
	aClass classLayout 
		resolveSlot: slotName   
		ifFound:  [: slot |  memento := slot ]
		ifNone: [aClass addSlot: (memento := slotName => ProcessLocalSlot)]
	
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> read: anObject [
	| slotValue |
	^ TXTransaction current 
		ifNotNil: [ :transaction |
			slotValue := memento read: anObject.
			slotValue 
				ifNotNil: [ slotValue ]
				ifNil: [ | value |
					value := self readOriginal: anObject.
					value isCollection 
						ifTrue: [ 
							value := value copy.
							memento write: value to: anObject ].
					value ] ]
		ifNil: [ self readOriginal: anObject ]
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> readOriginal: anObject [

	^ anObject instVarAt: (anObject class instVarNames indexOf: self name)
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> write: aValue to: anObject [
	TXTransaction current
		ifNotNil: [ :transaction | | oldValue |
			oldValue := memento read: anObject.
			memento write: aValue to: anObject.
			oldValue ifNil: [
				transaction register: anObject ]]
		ifNil: [ 
			anObject 
				instVarAt: (anObject class instVarNames indexOf: self name)
				put: aValue ]
]
