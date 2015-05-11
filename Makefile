# Status Thing Travis CI makefile
# https://travis-ci.org/JnyJny/StatusThing

TARGET=StatusThing
RELEASE_ROOT=build/Release

VERSION := $(shell agvtool vers -terse)
MVERSION := $(shell agvtool mvers -terse1 | sed -e "s/ /-/")

BUILD_TARGET=$(RELEASE_ROOT)/$(TARGET).app

PKG_TARGET=$(TARGET)-$(MVERSION)-v$(VERSION).app.gz

GIT_TAG= V$(VERSION)-$(MVERSION)

all: 

build: clean 
	xcodebuild build


release: build
	echo git tag -a $(GIT_TAG)

pkg: release
	tar zcf $(PKG_TARGET) $(BUILD_TARGET)

clean:
	@xcodebuild clean
	@rm -f $(TARGET)*.app.gz
