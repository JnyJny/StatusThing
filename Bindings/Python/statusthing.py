#!/usr/bin/env python3

'''python bindings to talk to a Mac OSX StatusThing

http://github.com/jnyjny/StatusThing

'''

from json import dumps,loads
from socket import create_connection


class Layer(object):
    '''
    Models a StatusThing layer: foreground, background or text
    depending on the properties supplied to __init__.
    '''

    def __init__(self,name,properties,animations,filters=None):
        self.name = name
        self.properties = properties

        if 'hidden' not in self.properties:
            self.properties.append('hidden')

        if 'color' not in self.properties:
            self.properties.append('color')
        
        self.animations = animations
        
        self.filters = filters

        self._categories = [self.properties,self.animations,self.filters]
        
        self.clear()

    def clear(self):
        '''
        Walks the lists of layer properties, animations and filters
        and sets them all to None.  The value of None signifies that
        the property, animation or filter should be ignored by the
        model method.
        '''
        for category in self._categories:
            for propertyName in category:
                setattr(self,propertyName,None)

    def deactivate(self):
        '''
        Use this method to change any Boolean valued item from True
        to False. Good for turning off a bunch of animations.
        '''
        for category in self._categories:
            for name in category:
                v = getattr(self,name)
                if v is True:
                    setattr(self,name,False)
            
    def model(self):
        '''
        This method returns a dictionary of all properties, animations
        and filters whose values are not None.
        '''
        r = {}
        for category in [self.properties,self.animations,self.filters]:
            for propertyName in category:
                value = getattr(self,propertyName)
                if value is None:
                    continue
                r.setdefault(propertyName,value)
        return r

class Message(object):
    '''
    
    '''
    def __init__(self,sender=None,body=None):
        self.name = 'message'
        self.sender = sender
        self.body = body

    def clear(self):
        self.sender = None
        self.body = None

    def deactivate(self):
        pass

    def model(self):
        r = {}

        if self.sender is not None:
            r.setdefault('sender',self.sender)
            
        if self.body is not None:
            r.setdefault('body',self.body)
            
        return r

class ColorRGBA(dict):
    '''
    Convenience class for creating color dictionaries.

    The values for color components are expected to be
    floating point values between 0 and 1.  If a component
    is larger than 1, it's scaled to a value between 0 and 1
    using the altScale argument.  The default altScale is
    255,
    
    With no arguments, returns a dictionary that describes
    the color black with full alpha.
    '''

    @classmethod
    def colorForHexstring(cls,hexstring):

        if len(hexstring) < 3:
            raise ValueError('hexstring too short < 3 .')
        
        if len(hexstring) == 6:
            components = bytes.fromhex(hexstring)
            
        if hexstring.startswith('#'):
            components = bytes.fromhex(hexstring[1:])
            
        if hexstring.startswith('0x'):
            components = bytes.fromhex(hexstring[2:])

        if len(components) != 3:
            raise ValueError('unable to parse hexstring into three components')

        return cls(components[0],components[1],components[2])
            
    
    def __init__(self,red=0,green=0,blue=0,alpha=1.0,altScale=255):
        self.setdefault('red',  self.scaled(red,  altScale))
        self.setdefault('green',self.scaled(green,altScale))
        self.setdefault('blue', self.scaled(blue, altScale))
        self.setdefault('alpha',self.scaled(alpha,altScale))

    def scaled(self,value,scale):
        if value > 1:
            value /= scale
        return value
    

class StatusThing(object):
    '''
    This class drives the appearance of a StatusThing application
    running on a local or a remote host.

    Example:

    st = StatusThing('host.example.com',21212)
    st.shape = 'pentagram'
    st.background.fill = 'red'
    st.background.spin = True
    st.text.string = '!'
    st.text.foreground = ColorRGBA.forHexstring('#ff00ff')
    st.text.enbiggen = True
    st.foreground.stroke = ColorRGBA(0,0,0,0.2)
    st.commit()

    st.deactivate()
    st.commit()

    st.clear()
    st.foreground.stroke = 'black'
    st.text.hidden = True
    st.commit()
    st.done()
    
    '''
    
    _text_properties = ['foreground','string','font','fontSize']
    
    _shape_properties = ['fill','stroke','lineWidth']

    
    
    def __init__(self,hostname='localhost',port=21212,recvsz=8192):
        '''
        hostname : string address, either dotted decimal or name
        port     : integer port that StatusThing is listening on

        The object is not connected to the remote host until
        the first commit.
        '''
        
        self.address    = (hostname,port)
        self.shape      = None
        self.recvsz     = recvsz
        self.responses  = []
        self.background = Layer('background',
                                self._shape_properties,
                                self.animations,
                                self.filters)
        self.foreground = Layer('foreground',
                                self._shape_properties,
                                self.animations,
                                self.filters)
        self.text       = Layer('text',
                                self._text_properties,
                                self.animations,
                                self.filters)
        self.message    = Message()

    def __str__(self):
        '''
        JSON formatted representation of a StatusThing 
        '''
        return dumps(self.model())

    @property
    def entities(self):
        try:
            return self._entities
        except AttributeError:
            self._entities = [self.background,
                              self.foreground,
                              self.text,
                              self.message]
        return self._entities

    @property
    def socket(self):
        '''
        TCP v4 socket connected to the host and port specified in
        the StatusThing.address tuple. If you want to connect to
        another host:

        statusthing.done()
        statusthing.address = (hostname,port)
        ...
        statusthing.commit()

        '''
        try:
            return self._socket
        except AttributeError:
            self._socket = create_connection(self.address)
            data = self._socket.recv(self.recvsz)
            self.responses.append(data)
        return self._socket

    def sendCommand(self,cmd):
        self.socket.send(bytes(cmd,'utf-8'))
        data = self.socket.recv(self.recvsz)
        reply,sep,prompt = str(data,'utf-8').partition('\n')
        return reply
        
    @property
    def currentState(self):
        '''
        A dictionary describing the remote state.
        '''
        return loads(self.sendCommand('g'))

    @property
    def helpText(self):
        try:
            return self._helpText
        except AttributeError:
            self._helpText = self.sendCommannd('h')
        return self._helpText

    @property
    def capabilities(self):
        try:
            return self._capabilities
        except AttributeError:
            self._capabilities = loads(self.sendCommand('c'))
            # shapes in the right order, don't mess it up
            self._capabilities['animations'].sort()
            self._capabilities['filters'].sort()
        return self._capabilities

    @property
    def shapes(self):
        return self.capabilities['shapes']

    @property
    def filters(self):
        return self.capabilities['filters']

    @property
    def animations(self):
        return self.capabilities['animations']

    @property
    def colors(self):
        return self.capabilities['colors']

    def reset(self):
        self.sendCommand('r')
    
    def model(self):
        '''
        StatusThing consumes JSON dictionaries which describe the
        desired state for StatusThing's shape, background, foreground,
        text and message entities.  

        This method steps through those entities and creates the
        dictionary from the entity templates.  If a property is
        anything other than None, it is included in the model dictionary.

        Items are removed from the model by invoking the clear() method.
        
        '''
        r = {}
        
        if self.shape is not None:
            r.setdefault('shape',self.shape)

        # message quacks-like-a-duck or in this case quacks like a layer
            
        for entity in self.entities:
            model = entity.model()
            if len(model) == 0:
                continue
            r.setdefault(entity.name,model)
        return r
    
    
    def clear(self):
        '''
        This method clears the all of the templates. Afterwards, model()
        will return an empty dictionary.
        '''
        self.shape = None
        for entity in self.entities:
            entity.clear()

    def deactivate(self):
        '''
        '''
        for entity in self.entities:
            entity.deactivate()

    def commit(self,json=None):
        '''
        This method commits changes to the local StatusThing
        representation to the remote host.  Response text is
        appended to the responses property.
        '''

        if json is None:
            json = str(self) + '\n'
        data = bytes(json,'utf-8')
        self.socket.send(data)
        data = self.socket.recv(self.recvsz)
        self.responses.append(data)

    def done(self):
        '''
        Use this method to shutdown communication with the remote
        StatusThing application. 
        '''
        data = bytes.fromhex('04') # sending ctrl-d is cooler than a q
        self.socket.send(data)
        self.responses.append(self.socket.recv(self.recvsz))
        self.socket.close()
        del(self._socket)

        
if __name__ == '__main__':
    
    # XXX this is debugging stuff.  should replace with a command-line
    #     parsing interface.
    
    s = StatusThing()
    s.background.fill = ColorRGBA(0,1,0,0.5)
    print(s)
    s.commit()
    s.done()
    print('\n'.join(map(str,s.responses)))
