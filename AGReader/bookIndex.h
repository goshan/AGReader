//
//  bookIndex.h
//  AGReader
//
//  Created by Qiu Han on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bookIndex : NSObject

@property(retain, nonatomic) NSArray *elems;

- (bookIndex *)initWithFile:(NSString *)filename;
- (int)count;
- (NSDictionary *)bookInfoAtIndex:(int)index;
@end
