//
//  goshanAppDelegate.m
//  AGReader
//
//  Created by Qiu Han on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "goshanAppDelegate.h"

#import "indexViewController.h"
#import "bookViewController.h"

@implementation goshanAppDelegate

@synthesize window = _window;
@synthesize navController = _navController;


- (NSArray *)loadBookIndexFrom:(NSString *)resource ofType:(NSString *)type{
    NSMutableArray *index = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSString *text  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    while (1){
        NSRange range = [text rangeOfString:@"\n"];
        if (range.location == NSNotFound){
            break;
        }
        NSString *line = [text substringToIndex:range.location];
        text = [text substringFromIndex:range.location+range.length];
        
        NSRange lineRange = [line rangeOfString:@"\t"];
        int id = [[line substringToIndex:lineRange.location] intValue];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *bookName = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *resource = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *pageIndex = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        NSString *bookImage = [NSString stringWithString:line];
        
        NSDictionary *book = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:id], @"id", bookName, @"bookName", resource, @"resource", pageIndex, @"pageIndex", bookImage, @"bookImage", nil];
        [index addObject:book];
    }
    return index;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //gen index
    //bookViewController *viewController = [[[bookViewController alloc] initWithNibName:@"bookViewController" bundle:nil resource:@"test_utf8" index:@"index"] autorelease];
    
    //normal user
    indexViewController *viewController = [[indexViewController alloc] initWithNibName:@"indexViewController" bundle:nil];
    _navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.window addSubview:_navController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
