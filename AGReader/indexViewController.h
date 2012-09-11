//
//  indexViewController.h
//  AGReader
//
//  Created by Qiu Han on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookViewController.h"

@interface indexViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(retain, nonatomic) NSArray *bookIndex;

@property(retain, nonatomic) IBOutlet UITableView *tableView;

@property(retain, nonatomic) bookViewController *bookViewController;

@property(retain, nonatomic) MBProgressHUD* loadingSpinner;

@end
