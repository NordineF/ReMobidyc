"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestReMobidycStorage,
	#superclass : #PackageManifest,
	#category : #'ReMobidyc-Storage-Manifest'
}

{ #category : #'code-critics' }
ManifestReMobidycStorage class >> ruleRBAtIfAbsentRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#RMDMemory #at:ifAbsentPut: #false)) #'2019-12-27T13:38:37.83963+09:00') )
]

{ #category : #'code-critics' }
ManifestReMobidycStorage class >> ruleRBCollectionMessagesToExternalObjectRuleV1FalsePositive [
	^ #(#(#(#RGPackage #(#'ReMobidyc-Storage')) #'2020-01-15T12:40:11.223963+09:00') )
]
