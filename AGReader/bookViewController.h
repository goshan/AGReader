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
#import "Toast+UIView.h"
#import "YouMiView.h"



@interface bookViewController : UIViewController<UIScrollViewDelegate>

@property int totalPageNum;

@property int currentPageNum;

@property int showPageNum;

@property(retain, nonatomic) NSString *content;

@property(retain, nonatomic) bookMarks *marks;

@property(retain, nonatomic) YouMiView *adView;

@property(retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIView *funcView;

@property(retain, nonatomic) NSDictionary *book;

@property(retain, nonatomic) NSDictionary *pageIndex;

@property(retain, nonatomic) NSArray *views;


- (IBAction)addMark:(id)sender;

- (IBAction)changeMode:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookInfo:(NSDictionary *)book pageNum:(int)pageNum marks:(bookMarks *)marks;

@end
