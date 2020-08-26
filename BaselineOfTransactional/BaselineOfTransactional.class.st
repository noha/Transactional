Class {
	#name : #BaselineOfTransactional,
	#superclass : #BaselineOf,
	#category : #BaselineOfTransactional
}

{ #category : #baselines }
BaselineOfTransactional >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			package: 'Transactional-Core';
			package: 'Transactional-Core-Tests' with: [ 
				spec requires: #('Transactional-Core') ].
			
		spec 
			group: 'Core' with: #('ActiveGrid-Core');
			group: 'Tests' with: #('ActiveGrid-Core-Tests' );
			group: 'default' with: #('Core' 'Tests') ]
]
