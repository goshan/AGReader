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
#import "MBProgressHUD.h"

@interface indexViewController : UIViewController
{
    NSArray *bookIndex;
    bookViewController *bookView;
    MBProgressHUD* loadingSpinner;
}

@property(retain, nonatomic) NSArray *bookIndex;

@property(retain, nonatomic) bookViewController *bookView;

@property(retain, nonatomic) MBProgressHUD *loadingSpinner;

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property(retain, nonatomic) tableIndexViewController *tableViewController;

@property(retain, nonatomic) imageIndexViewController *imageViewController;


- (void)showSpinner;
- (void) showBookViewController;
- (void) showBookViewControllerByInitWith:(NSDictionary *)book;



@end
