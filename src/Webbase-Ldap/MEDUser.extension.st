Extension { #name : #MEDUser }

{ #category : #'*Webbase-Ldap' }
MEDUser >> isAuthenticateAtLdap [
	^ ldapUid notBlank
]
