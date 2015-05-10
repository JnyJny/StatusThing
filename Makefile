
TARGET=StatusThing
BUILD_RELEASE=build/Release

# need to get the version out of xcode 

BUILD_TARGET=$(BUILD_RELEASE)/$(TARGET).app
PKG_TARGET=$(TARGET).app.gz

all: pkg

build: clean
	xcodebuild build

pkg: build
	tar zcf $(PKG_TARGET) $(BUILD_TARGET)

clean:
	xcodebuild clean
	rm -f $(PKG_TARGET)
