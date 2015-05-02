//
//  Konstants.h
//  StatusThing
//
//  Created by Erik on 4/16/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#ifndef StatusThing_Konstants_h
#define StatusThing_Konstants_h

#define StatusThingDefaultMessage @"<No Message>"
#define StatusThingWelcome        @"Connected to StatusThing\nFeed Me JSON\n> "
#define StatusThingGoodbye        @"\nBe seeing you space cowboy!\n"
#define StatusThingResponseOK     @"Ok\n> "
#define StatusThingResponseErrFmt @"Err: %@\n> "

#define StatusThingBonjourType    @"_statusthing._tcp."


#define kAppleInterfaceThemeChangedNotification @"AppleInterfaceThemeChangedNotification"
#define kAppleInterfaceStyle                    @"AppleInterfaceStyle"

#define StatusThingDefaultFontName @"Courier"

#define StatusThingDomain        @"com.symbolicarmageddon.StatusThing"

#define StatusThingHelpFile      @"HelpText"
#define StatusThingPrefKeyPort   @"port"


#define DegToRad(D) (((D)*(M_PI))/180.)
#define RadToDeg(R) (((R)*180.)/M_PI)

#define BlockWeakObject(o) __typeof(o) __weak
#define BlockWeakSelf BlockWeakObject(self)


#endif /* StatusThing_Konstants_h */
