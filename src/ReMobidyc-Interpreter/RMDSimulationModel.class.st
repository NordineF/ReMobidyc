Class {
	#name : #RMDSimulationModel,
	#superclass : #Object,
	#instVars : [
		'simulationDefinition',
		'animatDefinitions',
		'cellDefinition',
		'worldDefinition',
		'actionDefinitions',
		'visualizer',
		'renderers',
		'taskDefinitions'
	],
	#category : #'ReMobidyc-Interpreter'
}

{ #category : #'instance creation' }
RMDSimulationModel class >> sugarScape [
	^ self new
		load: RMDWorldDefinitionNode empty;
		load: RMDCellDefinitionNode grassField;
		load: RMDAnimatDefinitionNode goat;
		load: RMDActionDefinitionNode respire;
		load: RMDActionDefinitionNode move;
		load: RMDActionDefinitionNode graze;
		load: (RMDTaskDefinitionNode goat_respire: '2000 [kcal/day]');
		load: RMDTaskDefinitionNode goat_walk_for_grass;
		load:
			(RMDTaskDefinitionNode
				goat_graze: '3000 [kcal/day]'
				upto: '10000[kcal]');
		load: RMDActionDefinitionNode grow_grass;
		load:
			(RMDTaskDefinitionNode
				cell_grow_grass: '2000[kcal/day]'
				upto: '1000000[kcal]');
		load:
			(RMDSimulationDefinitionNode
				timeDefinition: (RMDSimulationTimeDefinitionNode during: '360[day]' by: '0.5[day]')
				worldInitializer: RMDWorldInitializerNode empty
				cellInitializer:
					(RMDCellInitializerNode
						grassInitializer: 10
						by: 10
						of: '5[km]'
						grass: '0[kcal]'
						to: '1000000[kcal]')
				animatInitializers:
					{(RMDAnimatInitializerNode
						goatInitializer: 100
						bloodSugar: '500[kcal]'
						to: '1000[kcal]')});
		addRenderer: (RMDBackgroundColorRenderer color: Color brown);
		addRenderer:
			(RMDCellColorAlphaRenderer
				color: Color green
				alpha: 'here''s grass' asRMDExpression
				between: '0[kcal]' asRMDExpression
				and: '1000000[kcal]' asRMDExpression);
		addRenderer: (RMDAnimatDotRenderer on: 'Goat' diameter: 7 color: Color yellow);
		yourself
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> actionDefinitionAt: aString ifAbsent: errorBlock [
	^ actionDefinitions at: aString ifAbsent: errorBlock
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> actionNames [
	^ actionDefinitions keys asSortedCollection
]

{ #category : #adding }
RMDSimulationModel >> addActionDefinition: aRMDActionDefinitionNode [
	actionDefinitions
		at: aRMDActionDefinitionNode identifier
		put: aRMDActionDefinitionNode.
	taskDefinitions
		do: [ :task | 
			(task actionIdentifier isLocalActionIdentifierNode
				and: [ task actionIdentifier shortName
						= aRMDActionDefinitionNode identifier ])
				ifTrue: [ task resetAction ] ].
	^ aRMDActionDefinitionNode
]

{ #category : #adding }
RMDSimulationModel >> addAnimatDefinition: aRMDAnimatDefinitionNode [
	^ animatDefinitions
		at: aRMDAnimatDefinitionNode identifier
		put: aRMDAnimatDefinitionNode
]

{ #category : #adding }
RMDSimulationModel >> addRenderer: aRMDRenderer [
	renderers add: aRMDRenderer
]

{ #category : #adding }
RMDSimulationModel >> addTaskDefinition: aRMDTaskDefinitionNode [
	^ taskDefinitions add: aRMDTaskDefinitionNode
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> animatDefinitionAt: aString ifAbsent: errorBlock [
	^ animatDefinitions at: aString ifAbsent: errorBlock
]

{ #category : #enumerating }
RMDSimulationModel >> animatDefinitionsDo: aBlock [
	animatDefinitions valuesDo: aBlock
]

{ #category : #enumerating }
RMDSimulationModel >> animatInitializersDo: aBlock [
	simulationDefinition animatInitializers do: aBlock
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> animatNames [
	^ animatDefinitions keys asSortedCollection
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> cellDefinition [
	^ cellDefinition
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> cellDefinition: aRMDCellDefinitionNode [
	cellDefinition := aRMDCellDefinitionNode
]

{ #category : #'accessing - initializers' }
RMDSimulationModel >> cellInitializer [
	^ simulationDefinition cellInitializer
]

{ #category : #'accessing - cells' }
RMDSimulationModel >> cellLength [
	^ simulationDefinition cellInitializer length
]

{ #category : #'accessing - cells' }
RMDSimulationModel >> cellXDivisions [
	^ simulationDefinition cellInitializer xDivisions
]

{ #category : #'accessing - cells' }
RMDSimulationModel >> cellYDivisions [
	^ simulationDefinition cellInitializer yDivisions
]

{ #category : #'accessing - time' }
RMDSimulationModel >> deltaTime [
	^ simulationDefinition timeDefinition step numeric
]

{ #category : #'accessing - time' }
RMDSimulationModel >> duration [
	^ simulationDefinition timeDefinition duration numeric
]

{ #category : #'accessing - cells' }
RMDSimulationModel >> east [
	^ self cellLength * self cellXDivisions
]

{ #category : #initialization }
RMDSimulationModel >> initialize [
	super initialize.
	simulationDefinition := RMDSimulationDefinitionNode empty.
	cellDefinition := RMDCellDefinitionNode empty.
	worldDefinition := RMDWorldDefinitionNode empty.
	animatDefinitions := Dictionary new.
	actionDefinitions := Dictionary new.
	taskDefinitions := OrderedCollection new.
	renderers := OrderedCollection new.
]

{ #category : #accessing }
RMDSimulationModel >> load: aRMDSyntaxNode [
	aRMDSyntaxNode isWorldDefinitionNode
		ifTrue: [ ^ self worldDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isCellDefinitionNode
		ifTrue: [ ^ self cellDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isAnimatDefinitionNode
		ifTrue: [ ^ self addAnimatDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isActionDefinitionNode
		ifTrue: [ ^ self addActionDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isTaskDefinitionNode
		ifTrue: [ ^ self addTaskDefinition: aRMDSyntaxNode ].
	aRMDSyntaxNode isSimulationDefinitionNode
		ifTrue: [ ^self simulationDefinition: aRMDSyntaxNode ].
	^ self error: 'Unknown load'
]

{ #category : #'accessing - cells' }
RMDSimulationModel >> north [
	^ self cellLength * self cellYDivisions
]

{ #category : #adding }
RMDSimulationModel >> removeRenderer: aRMDRenderer ifAbsent: errorBlock [
	^ renderers remove: aRMDRenderer ifAbsent: errorBlock
]

{ #category : #adding }
RMDSimulationModel >> removeTaskDefinition: aRMDTaskDefinitionNode ifAbsent: errorBlock [
	^ taskDefinitions remove: aRMDTaskDefinitionNode ifAbsent: errorBlock
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> renderers [
	^ renderers
]

{ #category : #enumerating }
RMDSimulationModel >> renderersDo: aBlock [
	renderers do: aBlock
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> replaceTask: aRMDTaskDefinitionNode with: anotherRMDTaskDefinitionNode [
	| index |
	index := taskDefinitions indexOf: aRMDTaskDefinitionNode.
	index = 0
		ifTrue: [ taskDefinitions add: anotherRMDTaskDefinitionNode ]
		ifFalse:
			[ taskDefinitions at: index put: anotherRMDTaskDefinitionNode ].
	^ anotherRMDTaskDefinitionNode
]

{ #category : #accessing }
RMDSimulationModel >> repositoryName [
	^ 'model'
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> simulationDefinition [
	^ simulationDefinition
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> simulationDefinition: aRMDSimulationDefinition [
	simulationDefinition := aRMDSimulationDefinition
]

{ #category : #'accessing - cells' }
RMDSimulationModel >> south [
	^ 0.0
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> taskDefinitions [
	^ Array withAll: taskDefinitions
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> taskNames [
	^ (taskDefinitions collect: #name) asSortedCollection
]

{ #category : #enumerating }
RMDSimulationModel >> tasksDo: aBlock [
	taskDefinitions do: aBlock
]

{ #category : #'accessing - cells' }
RMDSimulationModel >> west [
	^ 0.0
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> worldDefinition [
	^ worldDefinition
]

{ #category : #'accessing - definitions' }
RMDSimulationModel >> worldDefinition: aRMDWorldDefinitionNode [
	worldDefinition := aRMDWorldDefinitionNode
]

{ #category : #'accessing - initializers' }
RMDSimulationModel >> worldInitializer [
	^ simulationDefinition worldInitializer
]
