#!/usr/bin/env python3
'''
XXX this is horrible and should not be used.
'''

import json
from socket import create_connection



class ThingStatus(object):
    _shapes = ["circle","barredCircle","triangle","square",
                            "roundedSquare","diamond","pentagon","star",
                            "hexagon","octogon","cross","strike"]
    def __init__(self,hostname='localhost',port=55000):
        self.hostname = hostname
        self.port = port
        self.address = (hostname,port)
        self.socket = create_connection(self.address)
        self._immediate = False

    def sendObjects(self,objects=None):
        if objects is None:
            objects = self.data
        else:
            objects = bytes(json.dumps(objects)+'\n','utf-8')
        self.socket.send(objects)

    def done(self):
        self.socket.close()

    def record(self):
        self._dict = {}
        self._immediate = False

    def send(self,objects=None):
        if objects:
            self.sendObjects(objects)
        else:
            self.sendObjects(self._dict)

    def setKeyVal(self,name,value,immediate=True):
        d = {name:value}
        if self._immediate:
            print(d)
            data = bytes(json.dumps(d),'utf-8')
            self.send(d)
        else:
            self._dict.update(d)

    def setShape(self,value):
        self.setKeyVal('shape',value)

    def setFillColor(self,value):
        self.setKeyVal('fillColor',value)

    def setForegroundColor(self,value):
        self.setKeyVal('foregroundColor',value)

    def setStrokecolor(self,value):
        self.setKeyVal('strokeColor',value)

    def setLineWidth(self,value):
        self.setKeyVal('outline.lineWidth',value)

    def setFont(self):
        self.setKeyVal('font',value)

    def setFontSize(self,value):
        self.setKeyVal('fontSize',value)

    def setSymbol(self,value):
        self.setKeyVal('text',value)

    def hidden(self,which='shape',value=1):
        self.setKeyVal(which+'.hidden',value)

    def hideShape(self):
        self.hidden('shape')
        
    def hideOutline(self):
        self.hidden('outline')
        
    def hideSymbol(self):
        self.hidden('symbol')

    def showShape(self):
        self.hidden('shape',0)
        
    def showOutline(self):
        self.hidden('outline',0)
        
    def showSymbol(self):
        self.hidden('symbol',0)

    @property
    def data(self):
        return bytes(self.dumps(),'utf-8')

    def dumps(self):
        return json.dumps(self._dict)

    

        

if __name__ == '__main__':
    ts = ThingStatus()

    ts.setShape('square')

    
                
