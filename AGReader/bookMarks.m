//
//  bookMarks.m
//  AGReader
//
//  Created by Qiu Han on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "bookMarks.h"


@implementation bookMarks

@synthesize elems = _elems;


- (NSMutableArray *)loadBookMarkFrom:(NSString *)filename withBookIndex:(bookIndex *)index{
    NSMutableArray *marks = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//获得需要的路径    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filePath]){
        return marks;
    }
    NSString *content  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    while (1){
        NSRange range = [content rangeOfString:@"\n"];
        if (range.location == NSNotFound){
            break;
        }
        NSString *line = [content substringToIndex:range.location];
        content = [content substringFromIndex:range.location+range.length];
        
        NSRange lineRange = [line rangeOfString:@"\t"];
        NSString *bookId = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *pageNum = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *startPos = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        NSString *content = line;
        
        NSDictionary *mark = [[NSDictionary alloc] initWithObjectsAndKeys:bookId, MARKBOOKID, pageNum, MARKPAGENUM, startPos, MARKSTARTPOS, content, MARKCONTENT, nil];
        [marks addObject:mark];
    }
    return marks;
}

- (bookMarks *)initWithFile:(NSString *)filename andBookIndex:(bookIndex *)index{
    self = [super init];
    if (self){
        _elems = [self loadBookMarkFrom:filename withBookIndex:index];
    }
    return self;
}

- (NSDictionary *)markAtIndex:(int)index{
    return [_elems objectAtIndex:index];
}

- (void)saveMarks{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//获得需要的路径    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"bookMark.txt"];
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i=0; i<_elems.count; i++){
        NSDictionary *mark = [_elems objectAtIndex:i];
        [str appendFormat:@"%@\t%@\t%@\t%@\n", [mark objectForKey:MARKBOOKID], [mark objectForKey:MARKPAGENUM], [mark objectForKey:MARKSTARTPOS], [mark objectForKey:MARKCONTENT]];
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:NO];
}

- (void)addMark:(NSDictionary *)mark{
    [_elems addObject:mark];
    [self saveMarks];
}

- (void)removeMarkAtIndex:(int)index{
    [_elems removeObjectAtIndex:index];
    [self saveMarks];
}

- (int)count{
    return _elems.count;
}

@end
