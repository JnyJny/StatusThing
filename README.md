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
Connected to StatusThing
Feed Me JSON
{"shape":"circle"}
{"background":{"fill":"white"}}
{"foreground":{"stroke":"black","lineWidth":2}}
{"symbol":{"string":"\U018F","foreground":"black"}}
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
Connected to StatusThing
Feed Me JSON
{"symbol":{"foreground":"banana"}}
{"background":{"fill":{"red":1,"alpha"=1.}}}
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
  - hide and show shape, outline and symbol
  - short update messages (not yet)


### Shapes
Shapes are rendered on the fly, making StatusThing resolution independent.  Clients can also toggle the shape outline to get that extra level of customization.

Shapes include: circle, line, triangle, square, rounded square, diamond, pentagon, hexagon, septagon, octagon, nonagon, decagon, endecagon, *gasp* trigram, quadragram, pentagram, hexagram, septagram, octagram, nonagram, decagram, and endecagram.

Future Feature: Animations like bounce, shimmy, throb, wink, shine. Oh and rotate.

### Symbols

Client supplied symbol displayed in center of status icon. Want to send a Unicode character? No problem! Want it drawn in Purple? No problem!  Want to display a message?   See the next section.


### Messages

Future Feature: Client supplied short messages to help give context to changes in status. 

# JSON

ThingStatus hopes you will send it well-formed JSON dictionaries. It will complain silently to itself and ignore ill-formed JSON dictionaries until I teach it better manners.  Each line sent is expected to be a complete JSON dictionary, so no embedded newlines or carriage returns.  Multiple dictionaries can be sent, or you can send one big dictionary.  When you are done, shutdown your side of the socket and call it a day.

Dictionaries control the attributes of three main elements in StatusThing: foreground layer, background layer and symbol.

### Shapes

```sh
{ "shape":"none|circle|line|square|diamond|roundedSquare|pentagon|hexagon|septagon|octogon|nonagon|decagon|endecagon|trigram|quadragram|pentagram|hexagram|septagram|octagram|nonagram|decagram|endecagram" }
```

Specifying a shape in the top level of a dictionary will set the shape for both the foreground and background layers. It may be possible in the future to specify seperate shapes for each layer.  But not right now.

### Foreground and Background Layers

```sh
{ "stroke"    : color-specifier,
  "fill"      : color-specifier,
  "lineWidth" : float,
  "hidden"    : boolean }
```

### Symbol Layer

```sh
{ "foreground" : color-specifier,
  "font"       : string,
  "fontSize"   : float,
  "string"     : string,
  "hidden"     : boolean }
```

The font for the symbol text is given by name, stuff like 'Courier', 'Helvetica Bold', 'Super Made-up Font Extra-Extra-Light Oblique'.

The fontSize is specified in points and frankly the symbol positioning code is really unsatisfactory and disappointing. My advice is to keep it between 12 and 12 for now.


### Color Specifiers
```sh
"fill|stroke|foreground":"colorName"
"fill|stroke|foreground":{ "red":float,"green":float,"blue":float,"alpha" }
```

- fill       : color used to fill whichever shape you choose.
- stroke     : color used to outline the shape
- foreground : color used to fill the symbol

Colors can be specified as dictionaries of RGBA values, missing values are interpreted as 0. RGBA values should vary between 0.0 and 1.0.  If they are > 1, I will assume you are expressing the color using a range of numbers between 0 and 255 and scale the number to a float between 0 and 1.  I probably should default alpha to 1, so for now the color dictionary should have a minimum of two items in it: a color:number pair and a 'alpha':number pair.

Colors can also be specified by name.  The more common names are support, as are "banana" and "strawberry" and all the crayonbox color names.

Of course, if an element is hidden changing it's color won't be immediately apparent.





## Bindings

Planned client bindings are:
- python
- AppleScript
- Anything that can open a TCP connection and send JSON-formatted strings!

### Planned Features

See the <a href="https://github.com/JnyJny/StatusThing/blob/master/StatusThing/TODO">TODO</a> file for a more comprehensive list of planned features.

