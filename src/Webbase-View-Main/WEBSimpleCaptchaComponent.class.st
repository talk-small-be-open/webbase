Class {
	#name : #WEBSimpleCaptchaComponent,
	#superclass : #WEBCaptchaComponent,
	#category : #'Webbase-View-Main'
}

{ #category : #rendering }
WEBSimpleCaptchaComponent >> renderCaptchaCodeOn: html [
	html div
		class: 'captcha';
		with: captchaCode
]
