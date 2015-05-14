#!/usr/bin/env python3

from time import sleep
from statusthing Import StatusThing, ColorRGBA
import colorama




class StatusThingDemo(StatusThing):
    def __fini__(self):
        self.done()
        print("Be seeing you space cowboy!")
        print("EOF")

    def hidden(self,fg=None,bg=None,txt=None):
        self.foreground.hidden = fg
        self.background.hidden = bg
        self.text.hidden = txt
        self.commit()

    def start(aBeat=1.75):
        pass
