//
//  bookMarks.h
//  AGReader
//
//  Created by Qiu Han on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bookIndex.h"

@interface bookMarks : NSObject

@property(retain, nonatomic) NSMutableArray *elems;

- (bookMarks *)initWithFile:(NSString *)filename andBookIndex:(bookIndex *)index;
- (NSDictionary *)markAtIndex:(int)index;
- (void)addMark:(NSDictionary *)mark;
- (void)removeMarkAtIndex:(int)index;
- (int)count;

@end
