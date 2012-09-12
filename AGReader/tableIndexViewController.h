//
//  tableIndexViewController.h
//  AGReader
//
//  Created by Qiu Han on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class indexViewController;

@interface tableIndexViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(retain, nonatomic) NSArray *bookIndex;

@property(retain, nonatomic) indexViewController *parent;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookIndex:(NSArray *)index parentViewController:(indexViewController *)parent;



@end
