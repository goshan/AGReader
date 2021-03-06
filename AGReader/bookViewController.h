//
//  bookViewController.h
//  AGReader
//
//  Created by Qiu Han on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "bookMarks.h"
#import "goshanLabel.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "YouMiView.h"



@interface bookViewController : UIViewController<UIScrollViewDelegate>

@property int totalPageNum;

@property int currentPageNum;

@property int showPageNum;

@property(retain, nonatomic) NSString *content;

@property(retain, nonatomic) bookMarks *marks;

@property(retain, nonatomic) Config *config;

@property(retain, nonatomic) YouMiView *adView;

@property(retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) UIView *funcView;

@property (retain, nonatomic) UIButton *viewModeButton;

@property (retain, nonatomic) UIButton *addMarkButton;

@property(retain, nonatomic) NSDictionary *book;

@property(retain, nonatomic) NSMutableArray *pageIndex;

@property(retain, nonatomic) NSMutableArray *views;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookInfo:(NSDictionary *)book pageNum:(int)pageNum textStart:(int)start marks:(bookMarks *)marks config:(Config *)config;

@end
