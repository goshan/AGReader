//
//  Utils.h
//  AGReader
//
//  Created by Qiu Han on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

//file extern
extern const NSString *BOOKFILEEXT;
extern const NSString *PAGEINDEXEXT;

//bookInfo key
extern const NSString *BOOKID;
extern const NSString *BOOKNAME;
extern const NSString *FILENAME;
extern const NSString *PAGEINDEX;
extern const NSString *IMAGEFILE;

//bookMark key
extern const NSString *MARKBOOKID;
extern const NSString *MARKPAGENUM;
extern const NSString *MARKCONTENT;

+ (const NSString *)BOOKFILEEXT;
+ (const NSString *)PAGEINDEXEXT;

+ (const NSString *)BOOKID;
+ (const NSString *)BOOKNAME;
+ (const NSString *)FILENAME;
+ (const NSString *)PAGEINDEX;
+ (const NSString *)IMAGEFILE;

+ (const NSString *)MARKBOOKID;
+ (const NSString *)MARKPAGENUM;
+ (const NSString *)MARKCONTENT;

@end
