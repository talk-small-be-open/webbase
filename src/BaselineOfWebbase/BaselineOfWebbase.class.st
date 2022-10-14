Class {
	#name : #BaselineOfWebbase,
	#superclass : #BaselineOf,
	#category : #BaselineOfWebbase
}

{ #category : #baselines }
BaselineOfWebbase >> baseline: spec [
	<baseline>

	self baselineCommon: spec.

	self baselinePharo: spec.

	self baselineGemStone: spec
]

{ #category : #baselines }
BaselineOfWebbase >> baselineCommon: spec [

	spec for: #'common' do: [
		spec preLoadDoIt: #'preload:package:'.
		spec 
			baseline: 'Seaside3' with: [
				spec
					repository: self seasideRepository;
	"TODO: Development nur bei Group=devtools reinnehmen, aber wie geht das?"
					loads: #('Core' 'JSON' 'Email' 'Javascript' 'JQuery' 'JQueryUI' 'REST' 'Zinc' ) ];

			project: 'Seaside3-Dev'
			copyFrom: 'Seaside3'
			with: [ spec loads: #('Core' 'JSON' 'Email' 'Javascript' 'JQuery' 'JQueryUI' 'REST' 'Zinc' 'Development') ].



		spec package: #'Webbase-Main' with: [
			spec
				requires: #('OrderPreservingDictionary' 'Seaside3' )].


		spec group: 'devtools' with: #(#'Seaside3-Dev').

	].

]

{ #category : #baselines }
BaselineOfWebbase >> baselineGemStone: spec [

	spec for: #gemstone do: [

		spec baseline: 'Seaside3' with: [
			"GemStone specific seaside packages"
			spec
				loads: #('Base' 'Core' 'JSON' 'Email' 'Javascript' 'JQuery' 'Production' 'Zinc Project' 'Seaside-GemStone-Adaptors-Zinc')
		].

		spec package: #'Webbase-GemStone' with: [
			spec
				requires: #('MockGemStone' 'Webbase-Main');
				repository: 'github://talk-small-be-open/webbase'].

		spec group: 'default' with: #(#'Webbase-Main' #'Webbase-GemStone').
		
	]

]

{ #category : #baselines }
BaselineOfWebbase >> baselinePharo: spec [

	spec for: #pharo do: [

		spec
			baseline: 'OSSubprocess' with: [
				spec
					repository: 'github://pharo-contributions/OSSubprocess:master/repository' ];
			baseline: 'Magritte' with: [
				spec
					repository: 'github://magritte-metamodel/magritte:v3.6'; 
					loads: #(default Seaside) ];

			baseline: 'Voyage' with: [
				spec
					repository: 'github://pharo-nosql/voyage/mc';
					loads: #(mongo) ];

			baseline: 'OrderPreservingDictionary' with: [
				spec
					repository: 'github://pharo-contributions/OrderPreservingDictionary';
					loads: #(default) ];

			project: 'LDAP' with: [
				spec
					className: #ConfigurationOfLDAP;
					versionString: #'stable';
					repository: 'github://pharo-contributions/LDAP/src' ].

		spec package: #'Webbase-Main' with: [
			spec
				includes: #('Webbase-Pharo');
				requires: #('OSSubprocess' )].
		spec package: #'Webbase-VoyageMongo' with: [
			spec
				requires: #('Voyage' 'Webbase-Main')].
		spec package: #'Webbase-Magritte' with: [
			spec
				requires: #('Magritte' 'Webbase-Main')].
		spec package: #'Webbase-Pharo' with: [
			spec
				requires: #('Webbase-Main')].
		spec package: #'Webbase-Ldap' with: [
			spec
				requires: #('LDAP' 'Webbase-Main');
				repository: 'github://talk-small-be-open/webbase'].
		spec package: 'MockGemStone' with: [
			spec
				requires: #('Seaside3');
				repository: 'github://talk-small-be-open/utils:master/src' ].


		spec group: 'default' with: #(#'Webbase-Main').
		spec group: 'mongo' with: #(#default #'Webbase-VoyageMongo').
		spec group: 'gemstone' with: #(#default #'MockGemStone').
		spec group: 'magritte' with: #(#default #'Webbase-Magritte').
		spec group: 'ldap' with: #(#default #'Webbase-Ldap').
	].

]

{ #category : #actions }
BaselineOfWebbase >> preload: loader package: packageSpec [
	"Warum nötig? Weil es sonst irgendwie eine falsche Seasideversion indirekt von einem anderen Projekt geladen hätte. Deshalb hier vordefinieren."
	Metacello new
		baseline: 'Seaside3';
		repository: self seasideRepository;
		lock.

]

{ #category : #'as yet unclassified' }
BaselineOfWebbase >> seasideRepository [
	^'github://SeasideSt/Seaside:v3.4.8/repository'
]
