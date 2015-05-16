# Status Thing Travis CI makefile
# https://travis-ci.org/JnyJny/StatusThing

TARGET=StatusThing
RELEASE_ROOT=build/Release

BUILD := $(shell agvtool vers -terse)
MVERSION := $(shell agvtool mvers -terse1 | sed -e "s/ /-/")

BUILD_TARGET=$(RELEASE_ROOT)/$(TARGET).app

PKG_TARGET=$(TARGET)-$(MVERSION)-buildv$(BUILD).app.gz

all: pkg

build: clean
	agvtool bump
	xcodebuild build

pkg: build
	tar zcf $(PKG_TARGET) $(BUILD_TARGET)

clean:
	@xcodebuild clean
	@rm -f $(TARGET)*.app.gz
