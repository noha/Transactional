Class {
	#name : #TXMementoSlot,
	#superclass : #IndexedSlot,
	#instVars : [
		'memento'
	],
	#category : #'Transactional-Core'
}

{ #category : #'as yet unclassified' }
TXMementoSlot >> abort: anObject [
	memento write: TXNoValue to: anObject
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> basicRead: anObject [
	^ anObject instVarAt: (self instVarIndexIn: anObject)
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> basicWrite: aValue to: anObject [
	anObject 
		instVarAt: (self instVarIndexIn: anObject)
		put: aValue
]

{ #category : #'as yet unclassified' }
TXMementoSlot >> commit: anObject [
	self 
		basicWrite: (self read: anObject)  
		to: anObject 
		
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> doWithTransaction: aTransactionBlock ifNone: aBlock [
	^ TXTransaction current
		ifNotNil: aTransactionBlock 
		ifNil: aBlock
]

{ #category : #testing }
TXMementoSlot >> hasChanged: anObject [
	| old new |
	old := self read: anObject.
	new := self basicRead: anObject.

	^ (new = old) not
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> instVarIndexIn: anObject [
	^ anObject class instVarNames indexOf: self name
]

{ #category : #'class building' }
TXMementoSlot >> installingIn: aClass [
	| slotName |
	super installingIn: aClass.
	
	slotName := ('_mementoSlot_', self name) asSymbol.
	aClass classLayout 
		resolveSlot: slotName   
		ifFound:  [: slot | memento := slot ]
		ifNone: [aClass addSlot: (memento := slotName => TXProcessLocalSlot)]
	
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> read: anObject [
	
	^ self 
		doWithTransaction: [ :transaction | | mementoValue |
			mementoValue := memento read: anObject.
			Transcript show: self name asString, ': '.
			Transcript show: 'read proc: ', Processor activeProcess identityHash asString; show: ', '.
			Transcript show: 'object: ', anObject asString; show: ', '.
			Transcript show: 'value: ', mementoValue asString; cr.
			(mementoValue == TXNoValue) 
				ifTrue: [ | value |
					value := self basicRead: anObject.
					value isCollection 
						ifTrue: [ 
							value := value copy.
							memento write: value to: anObject.
							transaction register: anObject].
					value ]
				ifFalse: [ mementoValue ] ]
		ifNone:  [ 
			Transcript show: self name asString, ': '.
			Transcript show: 'read proc: ', Processor activeProcess identityHash asString; show: ', '.
			Transcript show: 'object: ', anObject asString; show: ', '.
			Transcript show: 'basic read'; cr.
			self basicRead: anObject ]
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> wantsInitialization [ 
	^ true
]

{ #category : #'meta-object-protocol' }
TXMementoSlot >> write: aValue to: anObject [
	self 
		doWithTransaction: [ :transaction |
			Transcript show: self name asString, ': '.
			Transcript show: 'write proc: ', Processor activeProcess identityHash asString; show: ', '.
			Transcript show: 'object: ', anObject asString; show: ', '.
			Transcript show: 'current: ', (memento read: anObject) asString; show: ', '.
			Transcript show: 'value: ', aValue asString; cr.

			((memento read: anObject) = TXNoValue) 
				ifTrue: [ transaction register: anObject ] .
			memento write: aValue to: anObject ]
		ifNone: [ 
			Transcript show: self name asString, ': '.
			Transcript show: 'write proc: ', Processor activeProcess identityHash asString; show: ', '.
			Transcript show: 'object: ', anObject asString; show: ', '.
			Transcript show: 'value: ', aValue asString; cr.
			self basicWrite: aValue to: anObject   ]
]
