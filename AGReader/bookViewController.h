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
#import "Toast+UIView.h"
#import "YouMiView.h"



@interface bookViewController : UIViewController

@property int initPageNum;

@property(retain, nonatomic) bookMarks *marks;

@property(retain, nonatomic) YouMiView *adView;

@property(retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property(retain, nonatomic) NSDictionary *book;

@property(retain, nonatomic) NSArray *views;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookInfo:(NSDictionary *)book pageNum:(int)pageNum marks:(bookMarks *)marks;

@end
