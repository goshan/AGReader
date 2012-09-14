//
//  bookMarkViewController.h
//  AGReader
//
//  Created by Qiu Han on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "bookViewController.h"
#import "bookMarks.h"
#import "bookIndex.h"

@interface bookMarkViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(retain, nonatomic) MBProgressHUD *loadingSpinner;
@property(retain, nonatomic) bookViewController *bookView;

@property(retain, nonatomic) bookMarks *marks;
@property(retain, nonatomic) bookIndex *index;
@property (retain, nonatomic) IBOutlet UITableView *tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookMark:(bookMarks *)marks bookIndex:(bookIndex *)index;

@end
