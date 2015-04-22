# StatusThing - Configurable Status Icon for OS X

Inspired by <a href="https://github.com/tonsky/AnyBar">AnyBar</a>, StatusThing is a network-addressable, JSON configurable icon that lives on your OS X status bar.

<img src="Screenshots/ScreenShot0.png"/>

```sh
$ telnet localhost 55000
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Connected to ThingStatus
Feed Me JSON
{ "shape":"circle","color":"white","symbol":"\u018F","symbolColor":"black" }
^]
telnet> q
```

<img src="Screenshots/ScreenShot1.png"/>

```sh
$ telnet localhost 55000
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Connected to ThingStatus
Feed Me JSON
{ "color":"red","symbolColor":"yellow" } }
^]
telnet> q
```
<img src="Screenshots/ScreenShot2.png"/>

## Features
- Listens for client TCP connections (port 55000 by default)
- Clients can send JSON dictionaries to change the appearance of the icon:
  - shape
  - color
  - symbol
  - symbol color, font and font size
  - short update messages
  - hide and show shape, outline and symbol


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

# JSON

ThingStatus hopes you will send it well-formed JSON dictionaries. It will complain silently to itself and ignore ill-formed JSON dictionaries until I teach it better manners.  Each line sent is expected to be a complete JSON dictionary, so no embedded newlines or carriage returns.  Multiple dictionaries can be sent, or you can send one big dictionary.  When you are done, shutdown your side of the socket and call it a day.

### Shapes

```sh
{ "shape":"circle|barredCircle|square|roundedSquare|diamond|pentagon|hexagon|octogon" }
```

Broken or debugging shapes include; star, cross, strike.

### Colors
```sh
{"fillColor|strokeColor|foregroundColor":"colorName"}
{"fillColor|strokeColor|foregroundColor":{ "red":float,"green":float,"blue":float,"alpha" }}
```

fillColor: the color used to fill whichever shape you choose. Can also be "none"
### Toggling Element Visibility
```sh
{"shape.hidden":0|1}
{"outline.hidden":0|1}
{"symbol.hidden":0|1}
```

### Symbol Text and Attributes
```sh
{"text":"Your text here but only the first two characters will likely show"}
{"font":"fontName"}
{"fontSize":float}
```




## Bindings

Planned client bindings are:
- python
- AppleScript
- Anything that can open a TCP connection and send JSON-formatted strings!

### Planned Features

See the <a href="https://github.com/JnyJny/StatusThing/blob/master/StatusThing/TODO">TODO</a> file for a more comprehensive list of planned features.

