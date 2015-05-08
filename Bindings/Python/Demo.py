#!/usr/bin/env python3

from time import sleep
from statusthing import StatusThing, ColorRGBA
from collections import OrderedDict
import colorama
import curses

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

    def start(self,pause=1.75):
        self.shape = 'circle'
        self.foreground.color = 'black'
        self.foreground.lineWidth = 3
        self.hidden(fg=False,bg=True,txt=True)
        sleep(pause)
        print(colorize("https://github.com/jnyjny/StatusThing",fg='white',bg='blue'))
        sleep(pause)
        self.foreground.blink = True
        self.commit()
        print("Hey, here I am. Up on the status bar.")
        sleep(pause*3)
        self.foreground.blink = False
        self.foreground.hidden = True
        self.text.hidden = False
        self.text.font = 'Courier Bold'
        self.text.foreground = "black"
        self.text.string = "Hi"
        print("I am stupid excited to see you!")
        self.commit()
        sleep(pause)
        self.text.enbiggen = True
        self.text.spin = True
        self.commit()
        sleep(pause)
        self.text.enbiggen = False
        self.text.spin = False
        self.text.hidden = True
        self.foreground.hidden = False
        self.commit()
        print("I am StatusThing and I know lots of tricks.")
        sleep(pause)
        print("For instance, I can change",colorize("shape,",'green'),len(self.shapes),'and counting.')

        n = 0
        for shape in self.shapes:
            n += 1
            end = '\n' if n % 7 == 0 else ''
            comma = ', ' if self.shapes[-1] != shape else ''
            print(shape.capitalize()+comma,end=end,flush=True)
            self.shape = shape
            self.commit()
            sleep(pause/2)
        print("\nAs you can see, I am quite flexible.")
        self.shape = 'circle'
        self.commit()
        print("I have",colorize("emotional",'cyan','red'),"intelligence too!")
        sleep(pause)
        self.foreground.hidden = True
        self.background.hidden = False
        self.background.fill = 'clear'
        self.commit()
        for (name,color) in self.roygbiv:
            last = self.roygbiv[-1] == (name,color)
            comma = '' if last else ', '
            print(colorize(name.capitalize(),name)+comma,end='\n' if last else '',flush=True)
            self.background.fill = color
            self.commit()
            sleep(pause/2)
            
        self.foreground.fill = 'clear'
        self.foreground.hidden = False
        self.background.hidden = True
        self.commit()
        print("I know plenty of other colors, but I'm sure you are getting the idea.")
        sleep(pause)
        print("Something else I can do...")
        sleep(pause)
        self.hidden(bg=True,fg=True,txt=False)
        self.text.foreground = 'black'
        self.text.fontSize = 18
        self.text.string = '?'
        self.commit()
        sleep(pause)
        print("Display text!")
        self.text.string = '!'
        self.commit()
        sleep(pause)
        print("Unfortuantely I only have room for one or two characters.")
        sleep(pause)
        self.text.font = 'Apple Color Emoji'
        self.text.fontSize = 22
        print("So use unicode characters and make them",colorize("count!",'green'))
        for emoji in ['😍','👻','🎵','🚀','🎥','📫','💣','➡️','⬇️','⬅️','⬆️',
                      '💯','🔜','♨️','♻️','🌀','⎋','⌘','⌫','☎︎','℗','Ω','⨁','⨂','∳','✅' ]:
            self.text.string = emoji
            self.commit()
            sleep(pause/4)
        self.text.spin = True
        self.commit()
        self.text.string = '\u018f'
        self.text.font = 'Courier Bold'
        self.commit()
        sleep(pause/4)
        self.text.spin = False
        self.commit()
        print("Whoever thought up Unicode and emoji was",colorize('wicked smart!','blue','white'))
        sleep(pause)
        print('I have a couple more tricks to show you..')
        sleep(pause)
        print('I can be very',colorize('animated','red','yellow'),'...')
        self.hidden(fg=False,bg=True,txt=True)
        self.shape = 'rounded square'
        n = 0
        for animation in self.foreground.animations:
            n += 1
            last = self.foreground.animations[-1] == animation
            comma = '' if last else ', '
            end = '\n' if last or (n % 7 == 0) else ''
            setattr(self.foreground,animation,True)
            self.commit()
            print(animation+comma,end=end,flush=True)
            sleep(pause*1.25)
            setattr(self.foreground,animation,False)
            self.commit()

        print("To be honest",colorize('Jefe,','yellow'),"I have a plethora of options.")

        self.hidden(bg=False,fg=False,txt=True)
        self.background.throb = True
        self.background.fill = ColorRGBA(1,0,0,1)
        self.foreground.lineWidth = 2
        self.foreground.flipy = True
        self.commit()
        sleep(pause*2)
        self.foreground.spinccw = True
        self.commit()
        sleep(pause*2)
        self.foreground.spinccw = False
        self.foreground.spincw = True
        self.background.fill = 'green'
        self.commit()
        self.shape = 'pentagram'
        self.background.enbiggen = True
        self.commit()
        sleep(pause*2)
        print("Ok, things are getting out of hand!")
        self.shape = "circle"
        self.foreground.spincw = False
        self.background.throb = False
        self.foreground.flipy = False
        self.background.enbiggen = False
        self.background.stretch = False
        self.foreground.lineWidth = 3
        self.commit()
        sleep(pause*2)
        print("Thanks for watching my demo! It was lots of fun.")
        sleep(pause/2)
        print("I am StatusThing, and I am...")
        sleep(pause/2)
        print(' - JSON configurable')
        sleep(pause/2)
        print(' - Network addressable')
        sleep(pause/2)
        print(' - Bonjour enabled')
        sleep(pause/2)
        print(' - Animated')
        sleep(pause/2)
        print(' -',colorize('Tons of Fun!!','green'))
        sleep(pause)
        print('Come visit my github page and download me today!')
        sleep(pause)
        print('Thanks for watching!')
        sleep(pause)
        print(colorize("https://github.com/jnyjny/StatusThing",fg='white',bg='blue'))
        sleep(pause*3)
        print("PS. This demo was written using brand new python bindings.")
        sleep(pause)
        print("    I think they worked out nicely!")
        sleep(pause)
        print("See you later space cowboy!")
        print("EOF")
        self.hidden(bg=True,fg=False,txt=True)
        self.commit()

if __name__ == '__main__':
    demo = StatusThingDemo()
    demo.start()
    demo.deactivate()

