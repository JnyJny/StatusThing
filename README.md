# StatusThing - Configurable Status Icon for OS X 

[![Build Status](https://travis-ci.org/JnyJny/StatusThing.svg?branch=master)](https://travis-ci.org/JnyJny/StatusThing)

![StatusThing Icon](https://raw.githubusercontent.com/JnyJny/StatusThing/master/StatusThing/Images.xcassets/AppIcon.appiconset/icon_32x32%402x.png) "Kazoos are awesome, kazoos all day are annoying."

Inspired by <a href="https://github.com/tonsky/AnyBar">AnyBar</a>, StatusThing is a network-addressable, JSON configurable icon that lives on your OS X status bar.  Use it to monitor the status of anything that can send JSON formatted text to a TCP port. 

[![StatusThing Demo Video](https://raw.githubusercontent.com/JnyJny/StatusThing/3c651d63ab489cfa033c1eab795bbeae44c409e0/Screenshots/YTScreenshot.png)](https://youtu.be/4ASGU1lLHpI "StatusThing Demo Video")

## Features
- Listens for client TCP/IP stream connections (port 21212 by default)
- Has three seperately configurable layers: background, foreground and text
- Clients send JSON dictionaries to change the appearance of the icon:
  - Shape and color of the fore and background.
  - Text color, font, font size and content.
  - Text content can be any string, including Unicode characters.
  - Layers can be hidden independently.
  - ANIMATIONS! All three layers can be independently animated.
  - Interactive help when connected via the network.
  - Configurable port number.
  - Configurable idle presentation.
  - Restrict remote access.
  - Restrict use of animations.
  - Short messages.
  - <a href="http://www.rfc-editor.org/rfc/rfc7493.txt">RFC 7493</a> I-JSON messaging protocol compliant (srsly).


### Shapes
Shapes are rendered on the fly, making StatusThing resolution independent.

Shapes include: circle, line, triangle, square, rounded square, diamond, n-gons where n = { 5, 11} and n-grams where n = {3, 11}.

The cool thing about the n-gram figures is they are star shaped, and they look totally bad-*ss when animated!

### Text

Client supplied text displayed in center of status icon. Want to send a Unicode character? No problem! Want it drawn in Purple? No problem! What about throbbing, spinning and other stuff? Got you covered! Want to display a message? Make sure you use the ticker animation to get it all displayed!  Need a longer message? Keep reading!

### Messages

Not enough to set an enbiggening poop-emoji on a throbbing red background to indicate that your root filesystem is full?  Send some text along to make it even more clear what your message is!  Think of it as more of a postcard than a registered letter; you provide a JSON message dictionary with a "from" element and a "body" element.  It can be "from" your filesystem or your user ID or whatever makes it easier to identify the source of the message for the intended receiver. The "body" is whatever text you want to send. Although you should probably keep it short, there is only room there for roughly half-a-tweet. Messages will show up in the "Messages" sub-menu and the body text will show up as a tool tip (hover your cursor over StatusThing for a second).


## JSON

ThingStatus hopes you will send it well-formed JSON dictionaries. It will complain tersely if you care to read what it writes. It will ignore JSON dictionaries with unknown content (as per RFC1743). Each line sent is expected to be a complete JSON dictionary, so no embedded newlines. Multiple dictionaries can be sent, or you can send one big dictionary. When you are done, shutdown your side of the socket and call it a day.

Dictionaries control the attributes of four main elements in StatusThing: shape, foreground, background and text.

The general shape of a StatusThing dictionary is:

```sh
{ "shape":string | {"name":string,"heading":float},
  "message":{"from":string,"body":string},
  "background":{},
  "foreground":{},
  "text":{},
}
```

You can use as much or as little as it takes to make you happy. 


### Shapes

```sh
{ "shape":"none|circle|line|square|diamond|roundedSquare|pentagon|hexagon|
           septagon|octogon|nonagon|decagon|endecagon|trigram|quadragram|
           pentagram|hexagram|septagram|octagram|nonagram|decagram|endecagram" }

{ "shape":{"name":"none|...|endecagram","heading":degrees}}
```

Specifying a shape in the top level of a dictionary will set the shape for both the foreground and background layers. The foreground and background shapes can be set independently by including a definition in their respective dictionaries.  Some combinations work better than others.  Especially when they are animated. If you include a top-level shape definiton and shape definitons in either the fore or background, the last one defined wins.


### Layers

The StatusThing icon is composed of three layers: background, foreground and text in that order back to front.  The three are composited together to make the final icon. 

#### Foreground and Background Layers

```sh
{ "stroke"    : color-specifier,
  "fill"      : color-specifier,
  "color"     : synonym for "stroke" or "fill", context sensitive
  "lineWidth" : float,
animation-name: boolean|string,
  "shape"     : shape-definition
  "hidden"    : boolean }
```

The foreground and background layers have the same attributes, but the initial configurations are slightly different.  The background layer has a lineWidth of zero and a "clear" stroke color and the "color" dictionary key is a synonym for "fill".  The foreground layer has a clear fill color and the "color" key is a synonym for "stroke".  The idea is that the background provides the fill color and the foreground provides the outline.  But if you want to do something else, you can.

#### Text Layer

```sh
{ "foreground" : color-specifier,
  "color"      : synonym for "foreground"
  "font"       : string,
  "fontSize"   : float,
  "string"     : string,
animation-name : boolean|string,
  "hidden"     : boolean }
```

The font for the text is given by name, stuff like 'Courier', 'Helvetica Bold', 'Super Made-up Font Extra-Extra-Light Oblique'.

The fontSize is specified in points.  Just be warned that the height of the status bar is 22 points and text will be clipped to the square icon.


#### Color Specifiers
```sh
"fill|stroke|foreground|color":"colorName"
"fill|stroke|foreground|color":{ "red":float,"green":float,"blue":float,"alpha" }
```

- fill       : color used to fill whichever shape you choose.
- stroke     : color used to outline the shape
- foreground : color used to fill the text
- color      : context sensitive synonym

Colors can be specified as dictionaries of RGBA values, missing values are interpreted as 0. RGBA values should vary between 0.0 and 1.0. If they are > 1, I will assume you are expressing the color using a range of numbers between 0 and 255 and scale the number to a float between 0 and 1. I probably should default alpha to 1, so for now the color dictionary should have a minimum of two items in it: a color:number pair and a 'alpha':number pair.

Colors can also be specified by name.  The more common names are supported, as are "banana" and "strawberry" and all the crayonbox color names.  See the capabilities JSON dictionary for a complete list of supported color name strings. 

Of course, if an element is hidden changing it's color won't be immediately apparent.

The string "color" means different things depending on whether the parent key is "foreground", "background" or "text". With foreground, color is a synonym for 'stroke'. With background, color is a synonym for 'fill'.  And for text, color is a synonym for 'foreground'. 

#### Animations

```sh
{ "spin[cw|ccw]"  :[0|1]|speed-string,
   "throb"        :[0|1]|speed-string,
   "bounce"       :[0|1]|speed-string,
   "shake"        :[0|1]|speed-string,
   "flip[xy]"     :[0|1]|speed-string,
   "wobble"       :[0|1]|speed-string,
   "blink"        :[0|1]|speed-string,
   "enbiggen"     :[0|1]|speed-string,
   "stretch[xy]"  :[0|1]|speed-string,
   "ticker"       :[0|1]|speed-string,
   "reverseticker":[0|1]|speed-string
}
```

All of these animations can be sent in the dictionaries for any layer and multiple animations may be specified in each dictionary. Not all of them look good together, but you can do it.  Throbbing background, flipping foreground and an enbiggening, rotating text is pretty distracting. Which I guess is the point. Kazoo time.

Send a value of 1 to activate the animation and a zero to deactivate it.  A string speed value is also accepted, it can be one of; slowest, slower, slow, normal, fast, faster, fastest. The default speed for most animations is "normal" ( the ticker and reverseticker animations default to slowest ).  If you hate the speeds I picked, feel free to change them.

### Messages

Clients can send short postcard-like messages to StatusThing:

```sh
"message":{
    "from":"",
    "body":""
}
```
The from and body keys are optional, however without those populated it's sort of a boring message.

Messages show up in the "Messages" submenu, newest at the top. If there is body text, it will be used as the tooltip. Hover over StatusThing after receiving a message and all will become clear.  Speaking of clear, use the "Clear Messages" menu item to get rid of all the messages you've received.  Frankly, this feature needs some more work. 

## Interactive Commands

StatusThing isn't picky about how you talk to it; netcat, telnet or any other program which has the ability to open a TCP socket. When connected, there are a variety of commands you can issue in addition to JSON dictionaries.  Here is an excerpt from the online help:

```sh
Commands:
q|Q   - quit         : ask the server to terminate this connection
c     - capabilities : ask the server for it's capabilties
C     - capabilities : ask the server for it's capabilties, pretty printed
g     - get          : ask the server for it's current configuration
G     - get          : ask the server for it's current configuration, pretty printed
r|R   - reset        : reset to idle values set in preferences, stops animations
h|H|? - help         : this help
```
The [g]et and [c]apabilities command return JSON dictionaries.  The [g]et dictionary is the current configuration of StatusThing. The [c]apabilities dictionary is a list of all the animations, speeds, colors and shapes that are supported by StatusThing.  This should make writing and maintaining various bindings less brittle.

## Bindings

Planned client bindings are:
- python
- AppleScript
- Anything that can open a TCP connection and send JSON-formatted strings!

### Planned Features

See the <a href="https://github.com/JnyJny/StatusThing/blob/master/StatusThing/TODO">TODO</a> file for the most up-to-date status of on-going work.

## License

This software is licensed with the MIT license. 
