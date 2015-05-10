release:
	xcodebuild

archive:
	xcodebuild -scheme StatusThing archive -archivePath archive/StatusThing
