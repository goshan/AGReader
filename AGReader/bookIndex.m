//
//  bookIndex.m
//  AGReader
//
//  Created by Qiu Han on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "bookIndex.h"
#import "Utils.h"

@implementation bookIndex

@synthesize elems = _elems;



- (NSArray *)loadBookIndexFrom:(NSString *)filename ofType:(NSString *)type{
    NSMutableArray *index = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    NSString *text  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    while (1){
        NSRange range = [text rangeOfString:@"\n"];
        if (range.location == NSNotFound){
            break;
        }
        NSString *line = [text substringToIndex:range.location];
        text = [text substringFromIndex:range.location+range.length];
        
        NSRange lineRange = [line rangeOfString:@"\t"];
        int bookId = [[line substringToIndex:lineRange.location] intValue];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *bookName = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *fileName = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *pageIndex = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        NSString *imageFile = [NSString stringWithString:line];
        
        NSDictionary *book = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:bookId], Utils.BOOKID, bookName, Utils.BOOKNAME, fileName, Utils.FILENAME, pageIndex, Utils.PAGEINDEX, imageFile, Utils.IMAGEFILE, nil];
        [index addObject:book];
    }
    return index;
}

- (bookIndex *)initWithFile:(NSString *)filename{
    self = [super init];
    if (self){
        NSRange range = [filename rangeOfString:@"."];
        NSString *resource = [filename substringToIndex:range.location];
        NSString *ext = [filename substringFromIndex:range.location+range.length];
        _elems = [self loadBookIndexFrom:resource ofType:ext];
    }
    return self;
}

- (int)count{
    return _elems.count;
}

- (NSDictionary *)bookInfoAtIndex:(int)index{
    return [_elems objectAtIndex:index];
}

@end
