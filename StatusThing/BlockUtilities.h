//
//  BlockUtilities.h
//  StatusThing
//
//  Created by Erik on 5/2/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//

#ifndef StatusThing_BlockUtilities_h
#define StatusThing_BlockUtilities_h

typedef void (^DictionaryEnumBlock) (NSString *key,id obj,BOOL *STOP);

// These macros provide a means of declaring a "weak" self of whatever
// type "self" is, automatically.  Weak references avoid capturing an
// object within a block and allow garbage collection to function
// correctly. 

#define BlockWeakObject(o) __typeof(o) __weak
#define BlockWeakSelf BlockWeakObject(self)

#endif
