#!/usr/bin/env python3

from time import sleep
from statusthing import StatusThing, ColorRGBA
from collections import OrderedDict
import colorama

st = StatusThing()

def colorize(text,fg=None,bg=None):
    try:
        cfg = colorama.ansi.Fore.__dict__[fg.upper()] if fg is not None else ''
        rfg = colorama.ansi.Fore.__dict__['RESET'] if fg is not None else ''
    except:
        cfg = ''
        rfg = ''

    try:
        cbg = colorama.ansi.Back.__dict__[bg.upper()] if bg is not None else ''
        rbg = colorama.ansi.Back.__dict__['RESET'] if bg is not None else ''
    except:
        cbg = ''
        rft = ''
        
    return cfg+cbg+text+rfg+rbg
    

class StatusThingDemo(StatusThing):

    def __fini__(self):
        self.done()
        print("Be seeing you space cowboy!")
        print("EOF")

    @property
    def roygbiv(self):
        try:
            return self._roygbiv
        except AttributeError:
            self._roygbiv = [('red','red'),
                             ('orange','orange'),
                             ('yellow','yellow'),
                             ('green','green'),
                             ('blue','blue'),
                             ('indigo',ColorRGBA.colorForHexstring('#4B0082')),
                             ('violet',ColorRGBA.colorForHexstring('#EE82EE'))]
        return self._roygbiv

    def hidden(self,fg=None,bg=None,txt=None):
        self.foreground.hidden = fg
        self.background.hidden = bg
        self.text.hidden = txt
        self.commit()
        self.clear()

    # rework in to an array of sections
    #
    # encapsulate sections into DemoSection objects
    # call in sequence
    #

    def start(self,aBeat=1.75,sections=None):
        self.reset()
        # for section in sections
        #    section.play(aBeat)
        self.shape = 'circle'
        self.foreground.color = 'black'
        self.foreground.lineWidth = 2
        self.hidden(fg=False,bg=True,txt=True)
        sleep(aBeat)
        print(colorize("https://github.com/JnyJny/StatusThing",fg='white',bg='blue'))
        sleep(aBeat)
        self.foreground.blink = True
        self.commit()
        print("Hey, here I am. Up on the status bar.")
        sleep(aBeat*3)
        self.foreground.blink = False
        self.foreground.hidden = True
        self.text.hidden = False
        self.text.font = 'Courier Bold'
        self.text.fontSize = 14
        self.text.foreground = "black"
        self.text.string = "Hi"
        print("I am stupid excited to see you!")
        self.commit()
        sleep(aBeat)
        self.text.enbiggen = True
        self.text.spin = 'fast'
        self.commit()
        sleep(aBeat)
        self.text.enbiggen = False
        self.text.spin = False
        self.text.hidden = True
        self.foreground.hidden = False
        self.commit()
        print("I am StatusThing and I know lots of tricks.")
        sleep(aBeat)
        print("For instance, I can change",colorize("shape,",'green'),len(self.shapes),'and counting.')

        shapes = list(self.shapes)
        try:
            shapes.remove('None')
        except:
            pass

        shapes.sort()
        
        for idx,shape in enumerate(shapes):
            end = '\n' if idx and idx % 7 == 0 else ''
            comma = ', ' if self.shapes[-1] != shape else ''
            print(shape.capitalize()+comma,end=end,flush=not end)
            self.shape = shape
            self.commit()
            pause = aBeat/2. if idx < 7 else (aBeat * (1./(idx)))
            sleep(pause)
        sleep(aBeat)
        print("\nAs you can see, I am quite flexible.")
        self.shape = 'circle'
        self.commit()
        sleep(aBeat*2)
        print("I also have",colorize("emotional",'cyan','red'),"intelligence!")
        sleep(aBeat)
        self.foreground.hidden = True
        self.background.hidden = False
        self.background.fill = 'clear'
        self.commit()
        for (name,color) in self.roygbiv:
            last = self.roygbiv[-1] == (name,color)
            comma = '' if last else ', '
            print(name.capitalize()+comma,
                  end='\n' if last else '',
                  flush=not last)
            self.background.fill = color
            self.commit()
            sleep(aBeat/2)
            
        self.foreground.fill = 'clear'
        self.foreground.hidden = False
        self.background.hidden = True
        self.commit()
        print("I know plenty of other colors, but I'm sure you are getting the idea.")
        sleep(aBeat)
        print("Here's another fun thing I can do...")
        sleep(aBeat)
        self.hidden(bg=True,fg=True,txt=False)
        self.text.foreground = 'black'
        self.text.fontSize = 18
        self.text.string = '?'
        self.commit()
        sleep(aBeat)
        print("Display text!")
        self.text.string = '!'
        self.commit()
        sleep(aBeat)
        print("Unfortunately I only have room for one or two characters...")
        sleep(aBeat)
        self.text.font = 'Apple Color Emoji'
        self.text.fontSize = 22
        print("So use unicode characters and make them",colorize("count!",'green'))
        for idx,emoji in enumerate(['😍','👻','🎵','🎥','📫','💣','➡️','⬇️','⬅️','⬆️',
                                    '💯','🔜','♨️','♻️','🌀','⎋','⌘','⌫','☎︎','℗',
                                    'Ω','⨁','⨂','∳','✅','🚀' ]):
            self.text.string = emoji
            self.commit()
            sleep(aBeat/(idx+1))
        self.text.spin = True
        self.commit()
        self.text.string = '\u018f'
        self.text.font = 'Courier Bold'
        self.commit()
        sleep(aBeat/4)
        self.text.spin = False
        self.commit()
        print("Whoever thought up Unicode and emoji was",colorize('wicked smart!','blue','white'))
        sleep(aBeat*3)
        print('I saved my best trick for last.')
        sleep(aBeat)
        print('I can be very',colorize('animated','red','yellow'),'...')
        sleep(aBeat/2)
        self.hidden(fg=False,bg=True,txt=True)
        self.shape = 'rounded square'
        animations = self.foreground.animations
        animations.remove('spincw')
        animations.remove('flipx')
        for idx,animation in enumerate(animations):
            last = self.foreground.animations[-1] == animation
            comma = '' if last else ', '
            end = '\n' if last or (idx and (idx % 7 == 0)) else ''
            setattr(self.foreground,animation,True)
            self.commit()
            print(animation+comma,end=end,flush=True)
            sleep(aBeat*1.50)
            setattr(self.foreground,animation,False)
            self.commit()
        print("Each of my three layers are individually animatiable.")
        sleep(aBeat)
        print("To be honest",colorize('Jefe,','yellow'),"I have a plethora of options.")
        self.hidden(bg=False,fg=False,txt=True)
        self.background.throb = True
        self.background.fill = ColorRGBA(1,0,0,1)
        self.foreground.lineWidth = 2
        self.foreground.flipy = True
        self.commit()
        sleep(aBeat*2)
        self.foreground.spinccw = True
        self.commit()
        sleep(aBeat*2)
        self.foreground.spinccw = False
        self.foreground.spincw = True
        self.background.fill = 'green'
        self.commit()
        self.shape = 'pentagram'
        self.background.enbiggen = True
        self.commit()
        sleep(aBeat*2)
        print("That was fun, but I'll dial it back a notch or two.")
        self.shape = "circle"
        self.foreground.spincw = False
        self.background.throb = False
        self.foreground.flipy = False
        self.background.enbiggen = False
        self.background.stretch = False
        self.foreground.lineWidth = 2
        self.commit()
        sleep(aBeat)
        print("I am StatusThing, and I am...")
        sleep(aBeat/2)
        print(' - JSON configurable')
        sleep(aBeat/2)
        print(' - Network addressable')
        sleep(aBeat/2)
        print(' - Bonjour enabled')
        sleep(aBeat/2)
        print(' - Animated')
        sleep(aBeat/2)
        print(' -',colorize('Tons of Fun!!','green'))
        sleep(aBeat)
        print('Visit my github page and download me today!')
        sleep(aBeat)
        print('Give a visual voice to anything you can think of.')
        sleep(aBeat)
        print('Thanks for watching!')
        sleep(aBeat)
        print(colorize("https://github.com/JnyJny/StatusThing",fg='white',bg='blue'))
        sleep(aBeat*3)
        print("PS. This demo was written using python bindings that build the")
        sleep(aBeat/2)
        print("    JSON dictionaries that describe the changes you saw in the video.")
        sleep(aBeat/2)
        print("    The demo and the bindings are also available on github.")
        sleep(aBeat)

        self.hidden(bg=True,fg=False,txt=True)
        self.commit()

if __name__ == '__main__':
    demo = StatusThingDemo()
    demo.start()
    demo.deactivate()

