Extension { #name : #RMDBuiltinActionIdentifierNode }

{ #category : #'*ReMobidyc-Interpreter' }
RMDBuiltinActionIdentifierNode >> evalIn: aRMDInterpreter [
	^ RMDBuiltinRepository
		actionNamed: shortName
		ifAbsent: [ KeyNotFound signal: shortName ]
]

{ #category : #'*ReMobidyc-Interpreter' }
RMDBuiltinActionIdentifierNode >> resolveWith: aRMDSimulationModel [
	^ RMDBuiltinRepository
		actionNamed: shortName
		ifAbsent: [ KeyNotFound signal: shortName ]
]
