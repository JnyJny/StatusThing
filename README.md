# StatusThing - Configurable Status Icon for OS X

Inspired by <a href="https://github.com/tonsky/AnyBar">AnyBar</a>, StatusThing is a network-addressable, JSON configurable icon that lives on your OS X status bar.

<img src="Screenshots/ScreenShot0.png"/>

```sh
{ "shape":"circle","color":"white","symbol":"\u018F","symbolColor":"black" }
```

<img src="Screenshots/ScreenShot1.png"/>

```sh
{ "color":"red","symbolColor":"yellow" }
```
<img src="Screenshots/ScreenShot2.png"/>

## Features
- Listens for client TCP connections (port 55000 by default)
- Clients can send JSON dictionaries to change the appearance of the icon:
  - shape
  - color
  - symbol
  - symbol color
  - short update messages


### Shapes
Shapes are rendered on the fly, making ThingStatus resolution independent.  Clients can also toggle the shape outline to get that extra level of customization.

  - circle
  - triangle
  - square
  - roundedsquare
  - diamond
  - pentagon
  - hexagon
  - octogon
  - ...

Future Feature: Animation

### Symbols

Client supplied symbol displayed in center of status icon. Want to send a Unicode character? No problem! Want it drawn in Purple? No problem!

### Messages

Future Feature: Client supplied short messages to help give context to changes in status.


## Bindings

Planned client bindings are:
- python
- AppleScript
- Anything that can open a TCP connection and send JSON-formatted strings!

### Planned Features

See the <a href="https://github.com/JnyJny/StatusThing/blob/master/StatusThing/TODO">TODO</a> file for a more comprehensive list of planned features.

