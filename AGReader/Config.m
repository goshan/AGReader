//
//  Config.m
//  AGReader
//
//  Created by Qiu Han on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Config.h"

@implementation Config

@synthesize viewMode = _viewMode;

- (void) saveConfig{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//获得需要的路径    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"config.txt"];
    NSString *str = [NSString stringWithFormat:@"viewMode=%d\n", _viewMode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:NO];
}

- (Config *)initWithFile:(NSString *)filename{
    self = [super init];
    if (self){
        _viewMode = 0;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];//获得需要的路径    
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:filePath]){
            return self;
        }
        NSString *content  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        while (1){
            NSRange range = [content rangeOfString:@"\n"];
            if (range.location == NSNotFound){
                break;
            }
            NSString *line = [content substringToIndex:range.location];
            content = [content substringFromIndex:range.location+range.length];
            
            NSRange lineRange = [line rangeOfString:@"="];
            NSString *configID = [line substringToIndex:lineRange.location];
            NSString *configCon = [line substringFromIndex:lineRange.location+lineRange.length];
            if ([configID isEqual:@"viewMode"]){
                _viewMode = [configCon intValue];
            }
        }
    }
    return self;
}

@end
