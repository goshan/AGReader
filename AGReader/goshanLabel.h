//
//  goshanLabel.h
//  AGReader
//
//  Created by Qiu Han on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goshanLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andLeftInsets:(float) insets;
-(id) initWithLeftInsets: (float) insets;


@end
