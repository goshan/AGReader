//
//  goshanLabel.m
//  AGReader
//
//  Created by Qiu Han on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "goshanLabel.h"

@implementation goshanLabel

@synthesize insets=_insets;



-(id) initWithFrame:(CGRect)frame andLeftInsets:(float)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = UIEdgeInsetsMake(0.0, insets, 0.0, 0.0);
    }
    return self;
}

-(id) initWithLeftInsets:(float)insets {
    self = [super init];
    if(self){
        self.insets = UIEdgeInsetsMake(0.0, insets, 0.0, 0.0);
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
