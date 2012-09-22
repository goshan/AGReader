//
//  Config.h
//  AGReader
//
//  Created by Qiu Han on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

@property int viewMode;     //0--day mode, 1--night mode

- (void)saveConfig;

- (Config *)initWithFile:(NSString *)filename;
@end
