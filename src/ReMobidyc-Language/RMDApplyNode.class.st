Class {
	#name : #RMDApplyNode,
	#superclass : #RMDExpressionNode,
	#instVars : [
		'function',
		'arguments'
	],
	#category : #'ReMobidyc-Language-AST'
}

{ #category : #'instance creation' }
RMDApplyNode class >> function: aString expressions: anArrayOfRMDExpression [
	^ self new
		function: aString;
		arguments: anArrayOfRMDExpression;
		yourself
]

{ #category : #comparing }
RMDApplyNode >> = anObject [
	^ self class = anObject class
		and:
			[ function = anObject function and: [ arguments = anObject arguments ] ]
]

{ #category : #accessing }
RMDApplyNode >> arguments [
	^ arguments
]

{ #category : #accessing }
RMDApplyNode >> arguments: anArrayOfRMDExpressionNode [
	arguments := anArrayOfRMDExpressionNode
]

{ #category : #enumerating }
RMDApplyNode >> childrenDo: aBlock [
	arguments do: aBlock
]

{ #category : #accessing }
RMDApplyNode >> function [
	^ function
]

{ #category : #accessing }
RMDApplyNode >> function: aString [
	function := aString
]

{ #category : #comparing }
RMDApplyNode >> hash [
	^ function hash bitXor: arguments hash
]

{ #category : #testing }
RMDApplyNode >> isApplyNode [
	^ true
]

{ #category : #copying }
RMDApplyNode >> postCopy [
	arguments := arguments collect: #copy
]

{ #category : #accessing }
RMDApplyNode >> precedence [
	^ 1
]

{ #category : #printing }
RMDApplyNode >> printOn: aStream [
	aStream nextPutAll: function.
	aStream nextPut: $(.
	arguments
		do: [ :expression | expression printOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $)
]

{ #category : #rewriting }
RMDApplyNode >> replaceChildren: aDictionary [
	aDictionary at: function ifPresent: [ :node | function := node copy ].
	arguments := arguments
		collect: [ :node | node copyReplace: aDictionary ]
]
