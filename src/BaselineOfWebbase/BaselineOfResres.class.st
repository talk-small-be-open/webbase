Class {
	#name : #BaselineOfResres,
	#superclass : #BaselineOf,
	#category : #BaselineOfWebbase
}

{ #category : #baselines }
BaselineOfResres >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
"		spec preLoadDoIt: #'preload:package:'."
		spec 
			baseline: 'OSSubprocess' with: [
				spec
					repository: 'github://pharo-contributions/OSSubprocess:master/repository' ];

			baseline: 'Seaside3' with: [
				spec
					repository: self seasideRepository;
					loads: #('Core' 'JSON' 'Email' 'Javascript' 'JQuery' 'JQueryUI' 'REST' 'Zinc' ) ];

			project: 'Seaside3-Dev'
			copyFrom: 'Seaside3'
			with: [ spec loads: #('Core' 'JSON' 'Email' 'Javascript' 'JQuery' 'JQueryUI' 'REST' 'Zinc' 'Development') ]

	].

	spec for: #pharo do: [
		spec package: #'ResRes-Core' with: [
			spec
				requires: #('Seaside3' 'OSSubprocess' 'MockGemStone' )
			].
		spec package: 'MockGemStone' with: [
			spec
				requires: #('Seaside3');
				repository: 'github://talk-small-be-open/utils:master/src' ].

		spec group: 'default' with: #(#'ResRes-Core').
		spec group: 'devtools' with: #(#'Seaside3-Dev').
	].

	spec for: #gemstone do: [
		
	]

]

{ #category : #actions }
BaselineOfResres >> preload: loader package: packageSpec [
	
	"OBSOLETE?"
	
	"Warum nötig? Weil es sonst irgendwie eine falsche Seasideversion indirekt von einem anderen Projekt geladen hätte. Deshalb hier vordefinieren."
	Metacello new
		baseline: 'Seaside3';
		repository: self seasideRepository;
		lock.

]

{ #category : #'as yet unclassified' }
BaselineOfResres >> seasideRepository [
	^'github://SeasideSt/Seaside:v3.4.8/repository'
]
