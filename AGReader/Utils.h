//
//  Utils.h
//  AGReader
//
//  Created by Qiu Han on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

extern const NSString *BOOKID;
extern const NSString *BOOKNAME;
extern const NSString *FILENAME;
extern const NSString *PAGEINDEX;
extern const NSString *IMAGEFILE;


+ (const NSString *)BOOKID;
+ (const NSString *)BOOKNAME;
+ (const NSString *)FILENAME;
+ (const NSString *)PAGEINDEX;
+ (const NSString *)IMAGEFILE;

@end
