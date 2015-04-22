//
//  StatusView.m
//  StatusThing
//
//  Created by Erik on 4/18/15.
//  Copyright (c) 2015 Symbolic Armageddon. All rights reserved.
//


#import "StatusView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSColor+NamedColorUtilities.h"
#import "Konstants.h"



@implementation StatusView

@synthesize shape = _shape;
@synthesize outline = _outline;
@synthesize symbol = _symbol;

#pragma mark -
#pragma mark Initialization Methods

- (instancetype)initWithFrame:(NSRect )rect
{
    self = [super initWithFrame:rect];
    if ( self ) {
        self.wantsLayer = YES;
        [self.layer addSublayer:self.shape];
        [self.layer addSublayer:self.outline];
        [self.layer addSublayer:self.symbol];
        
        [self.shape setVisibleShape:GeometricShapeCircle];
        self.shape.strokeColor = nil;
        
        [self.outline setVisibleShape:GeometricShapeCircle];
        self.outline.fillColor = nil;
        self.outline.lineWidth = 2.;
        
        [self setNeedsDisplay:YES];
    }
    return self;
}

- (instancetype)init
{
    CGFloat w = [[NSStatusBar systemStatusBar] thickness];
    
    return [self initWithFrame:NSMakeRect(0, 0, w, w)];
}

// missing: - (instancetype)initWithCoder:(NSCoder *)coder

#pragma mark -
#pragma mark Layer Drawing Methods

- (BOOL)opaque
{
    return NO;
}

- (BOOL)wantsUpdateLayer { return YES; }


- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [self.shape centerInRect:layer.bounds andInset:CGPointMake(4, 4)];
    [self.outline centerInRect:layer.bounds andInset:CGPointMake(4, 4)];
    [self.symbol centerInRect:layer.bounds andInset:CGPointMake(4, 4)];
}



#pragma mark -
#pragma mark Properties

- (PolyShapeLayer *)shape
{
    if (_shape == nil) {
        _shape = [PolyShapeLayer layer];
     }
    return _shape;
}

- (PolyShapeLayer *)outline
{
    if (_outline == nil) {
        _outline = [PolyShapeLayer layer];
    }
    return _outline;
}

- (SymbolShapeLayer *)symbol
{
    if (_symbol == nil) {
        _symbol = [SymbolShapeLayer layer];
    }
    return _symbol;
}



#pragma mark -
#pragma mark Methods

- (void)setShapeForObject:(NSString *)name
{
    GeometricShapeLayer *s = [self.shape setVisibleShape:name];
    GeometricShapeLayer *o = [self.outline setVisibleShape:name];
    
    NSLog(@"shape: %@ outline: %@",s.name,o.name);
    
    [self setNeedsDisplay:(s!=nil)||(o!=nil)];
}

- (void)setFillColorForObject:(id)object
{
    
    [self.shape setFillColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)setStrokeColorForObject:(id)object
{
    [self.shape setStrokeColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)setForegroundColorForObject:(id)object
{
    [self.symbol setForegroundColor:[[NSColor colorForObject:object] CGColor]];
}

- (void)setTextForObject:(id)object
{
    self.symbol.string = object;
}

- (void)setFontForObject:(id)object
{
    self.symbol.font = CFBridgingRetain(object);
}

- (void)setFontSizeForObject:(id)object
{
    self.symbol.fontSize = [object floatValue];
}

- (void)centerInRect:(CGRect)rect
{
    CGFloat dx = (CGRectGetWidth(rect) - CGRectGetWidth(self.frame)) / 2.;
    CGFloat dy = (CGRectGetHeight(rect) - CGRectGetHeight(self.frame)) / 2.;
    
    CGPoint newOrigin = CGPointMake(self.frame.origin.x + dx, self.frame.origin.y + dy);
    
    [self setFrameOrigin:newOrigin];
}

- (void)updateKeyPathsWithDictionary:(NSDictionary *)info
{
    
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        BOOL found = YES;
        // XXX weird bug here
        //     the found dance keeps it from happening
        @try {
            [self setValue:obj forKey:[key stringByAppendingString:@"ForObject"] ];
            NSLog(@"setValue %@ forKey %@",obj,key);
        }
        @catch (NSException *exception) {
            //NSLog(@"%@ForObject - updateWithDictionary: %@",key,exception);
            found = NO;
        }

        if ( !found ) {
            @try {
                [self setValue:obj forKeyPath:key];
                NSLog(@"setValue %@ forKeyPath %@",obj,key);
            }
            @catch (NSException *exception) {
                //NSLog(@"%@ - updateKeyPathsWithDictionary: %@",key,exception);
            }
        }
    }];
}



@end
