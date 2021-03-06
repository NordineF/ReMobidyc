Class {
	#name : #RMDCellDefinitionNode,
	#superclass : #RMDSpeciesDefinitionNode,
	#category : #'ReMobidyc-Language-AST'
}

{ #category : #accessing }
RMDCellDefinitionNode class >> createBuiltinProperties [
	^ {}
]

{ #category : #'typical instances' }
RMDCellDefinitionNode class >> grassField [
	<script: 'RMDCellDefinitionNode grassField inspect'>
	^ RMDGrammar new cellDefinition end parse: 'Cell with
	grass [kcal].'
]

{ #category : #testing }
RMDCellDefinitionNode >> isCellDefinitionNode [
	^ true
]

{ #category : #printing }
RMDCellDefinitionNode >> printOn: aStream [
	aStream nextPutAll: 'Cell'.
	propertyDeclarations
		ifNotEmpty: [ aStream
				nextPutAll: ' with';
				nextPut: Character cr.
			propertyDeclarations
				do: [ :def | 
					aStream nextPutAll: '    '.
					def printOn: aStream ]
				separatedBy: [ aStream nextPut: Character cr ] ].
	aStream nextPut: $.
]
