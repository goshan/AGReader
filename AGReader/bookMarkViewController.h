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

@interface bookMarkViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(retain, nonatomic) MBProgressHUD *loadingSpinner;
@property(retain, nonatomic) bookViewController *bookView;

@property(retain, nonatomic) NSMutableArray *marks;
@property(retain, nonatomic) NSArray *index;
@property (retain, nonatomic) IBOutlet UITableView *tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookMark:(NSArray *)marks bookIndex:(NSArray *)index;

@end
