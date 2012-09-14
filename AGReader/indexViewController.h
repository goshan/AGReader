//
//  indexViewController.h
//  AGReader
//
//  Created by Qiu Han on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tableIndexViewController.h"
#import "imageIndexViewController.h"
#import "bookViewController.h"
#import "bookMarkViewController.h"
#import "MBProgressHUD.h"
#import "bookMarks.h"

@interface indexViewController : UIViewController

@property(retain, nonatomic) NSArray *bookIndex;

@property(retain, nonatomic) bookMarks *bookMarks;

@property(retain, nonatomic) bookViewController *bookView;

@property(retain, nonatomic) MBProgressHUD *loadingSpinner;

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property(retain, nonatomic) tableIndexViewController *tableViewController;

@property(retain, nonatomic) imageIndexViewController *imageViewController;

@property(retain, nonatomic) bookMarkViewController *markViewController;


- (void)showSpinner;
- (void) showBookViewController;
- (void) showBookViewControllerByInitWith:(NSDictionary *)book;



@end
