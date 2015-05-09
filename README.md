# StatusThing - Configurable Status Icon for OS X 

[![Build Status](https://travis-ci.org/JnyJny/StatusThing.svg?branch=master)](https://travis-ci.org/JnyJny/StatusThing)

Inspired by <a href="https://github.com/tonsky/AnyBar">AnyBar</a>, StatusThing is a network-addressable, JSON configurable icon that lives on your OS X status bar.

[![StatusThing Demo Video](https://raw.githubusercontent.com/JnyJny/StatusThing/3c651d63ab489cfa033c1eab795bbeae44c409e0/Screenshots/YTScreenshot.png)](https://youtu.be/4ASGU1lLHpI "StatusThing Demo Video")

## Features
- Listens for client TCP connections (port 21212 by default)
- Clients can send JSON dictionaries to change the appearance of the icon:
  - Shape of the foreground and background layers.
  - Colors
  - Arbitrary Unicode Text
  - Text color, font and font size.
  - Hide and show shape, outline and text
  - ANIMATIONS! Yes. Three layers of animation; foreground, background and text.
  - Short update messages (not yet).
  - <a href="http://www.rfc-editor.org/rfc/rfc7493.txt">RFC 7493</a> I-JSON messaging protocol compliant ( srsly )


### Shapes
Shapes are rendered on the fly, making StatusThing resolution independent.  Clients can also toggle the shape outline to get that extra level of customization.

Shapes include: circle, line, triangle, square, rounded square, diamond, pentagon, hexagon, septagon, octagon, nonagon, decagon, endecagon, *gasp* trigram, quadragram, pentagram, hexagram, septagram, octagram, nonagram, decagram, and endecagram.

The cool thing about the *-gram figures is they are star shaped, and they look totally bad-ass when animated!

### Text

Client supplied text displayed in center of status icon. Want to send a Unicode character? No problem! Want it drawn in Purple? No problem! What about throbbing, spinning and other stuf? Got you covered! Want to display a message? See the next section.


### Messages

Future Feature: Client supplied short messages to help give context to changes in status. 

# JSON

ThingStatus hopes you will send it well-formed JSON dictionaries. It will complain tersely if you care to read what it writes. It will ignore JSON dictionaries with unknown content (as per RFC1743).  Each line sent is expected to be a complete JSON dictionary, so no embedded newlines or carriage returns.  Multiple dictionaries can be sent, or you can send one big dictionary.  When you are done, shutdown your side of the socket and call it a day.

Don't worry, the server will give you a hand if you forget what all options can go into a dictionary.  The server responds to "help","reset" and "quit".  Later on the command "get" might be implemented to get the current state of StatusThing. 

Dictionaries control the attributes of three main elements in StatusThing: foreground layer, background layer and text.

### Shapes

```sh
{ "shape":"none|circle|line|square|diamond|roundedSquare|pentagon|hexagon|septagon|octogon|nonagon|decagon|endecagon|trigram|quadragram|pentagram|hexagram|septagram|octagram|nonagram|decagram|endecagram" }
```

Specifying a shape in the top level of a dictionary will set the shape for both the foreground and background layers. It may be possible in the future to specify seperate shapes for each layer.  But not right now.

### Layers

The StatusThing icon is composed of three layers: background, foreground and text in that order.  The three are composited together to make the final icon. 

#### Foreground and Background Layers

```sh
{ "stroke"    : color-specifier,
  "fill"      : color-specifier,
  "lineWidth" : float,
  "hidden"    : boolean }
```

#### Text Layer

```sh
{ "foreground" : color-specifier,
  "font"       : string,
  "fontSize"   : float,
  "string"     : string,
  "hidden"     : boolean }
```

The font for the text text is given by name, stuff like 'Courier', 'Helvetica Bold', 'Super Made-up Font Extra-Extra-Light Oblique'.

The fontSize is specified in points and frankly the text positioning code is really unsatisfactory and disappointing. My advice is to keep it between 12 and 12 for now.


#### Color Specifiers
```sh
"fill|stroke|foreground":"colorName"
"fill|stroke|foreground":{ "red":float,"green":float,"blue":float,"alpha" }
```

- fill       : color used to fill whichever shape you choose.
- stroke     : color used to outline the shape
- foreground : color used to fill the text

Colors can be specified as dictionaries of RGBA values, missing values are interpreted as 0. RGBA values should vary between 0.0 and 1.0.  If they are > 1, I will assume you are expressing the color using a range of numbers between 0 and 255 and scale the number to a float between 0 and 1.  I probably should default alpha to 1, so for now the color dictionary should have a minimum of two items in it: a color:number pair and a 'alpha':number pair.

Colors can also be specified by name.  The more common names are support, as are "banana" and "strawberry" and all the crayonbox color names.

Of course, if an element is hidden changing it's color won't be immediately apparent.

#### Animations

```sh
- { "spin[cw]":0|1,
    "spinccw":0|1,
    "throb":0|1,
    "bounce":0|1,
    "shake":0|1,
    "flip[y]":0|1,
    "flipX":0|1,
    "wobble":0|1,
    "blink":0|1
    "enbiggen":0|1,
    "stretch":0|1 }
}
```

All of these animations can be sent in the dictionaries for any layer and multiple animations may be specified in each dictionary.  Not all of them look good together, but you can do it.  Throbbing background, flipping foreground and an enbiggening, rotating text is pretty distracting. Which I guess is the point.

Send a value of 1 to active the animation and a zero to deactivate it.  All animations stop when the status bar icon is right clicked.



## Bindings

Planned client bindings are:
- python
- AppleScript
- Anything that can open a TCP connection and send JSON-formatted strings!

### Planned Features

See the <a href="https://github.com/JnyJny/StatusThing/blob/master/StatusThing/TODO">TODO</a> file for a more comprehensive list of planned features.

