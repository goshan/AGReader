//
//  indexViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "indexViewController.h"


BOOL currentViewIsImage;

@implementation indexViewController

@synthesize bookView = _bookView;
@synthesize bookIndex = _bookIndex;
@synthesize bookMarks = _bookMarks;
@synthesize loadingSpinner = _loadingSpinner;
@synthesize contentView = _contentView;
@synthesize tableViewController = _tableViewController;
@synthesize imageViewController = _imageViewController;
@synthesize markViewController = _markViewController;


- (void)showSpinner {
    //display loading spinner when adding cell
    if(!_loadingSpinner) {
        _loadingSpinner = [[MBProgressHUD alloc] initWithView:self.view];
        _loadingSpinner.labelText = @"小说加载中...";
        
    }
    [self.view addSubview:_loadingSpinner];
    [_loadingSpinner show:YES];
}

- (void) showBookViewController{
    [_loadingSpinner hide:YES];
    [self.navigationController pushViewController:_bookView animated:YES];
}

- (void) showBookViewControllerByInitWith:(NSDictionary *)book{
    _bookView=[[bookViewController alloc] initWithNibName:@"bookViewController" bundle:nil bookInfo:book pageNum:0 marks:_bookMarks];
    [_loadingSpinner hide:YES];
    [self.navigationController pushViewController:_bookView animated:YES];
}

- (void) changeViewMode{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:_contentView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    if(currentViewIsImage) {
        currentViewIsImage = NO;
        [_imageViewController.view removeFromSuperview];
        [_contentView addSubview:_tableViewController.view];
        [_tableViewController.view setUserInteractionEnabled:YES];
        self.navigationItem.leftBarButtonItem.title = @"书架";
    }
    else {
        currentViewIsImage = YES;
        [_tableViewController.view removeFromSuperview];
        [_contentView addSubview:_imageViewController.view];
        [_imageViewController.view setUserInteractionEnabled:YES];
        self.navigationItem.leftBarButtonItem.title = @"列表";
    }
    
    [UIView commitAnimations]; 
}

- (void) showBookMark{
    _markViewController = [[bookMarkViewController alloc] initWithNibName:@"bookMarkViewController" bundle:nil bookMark:_bookMarks bookIndex:_bookIndex];
    [self.navigationController pushViewController:_markViewController animated:YES];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bookIndex = [[bookIndex alloc] initWithFile:@"bookIndex.txt"];
        _bookMarks = [[bookMarks alloc] initWithFile:@"bookMark.txt" andBookIndex:_bookIndex];
        _tableViewController = [[tableIndexViewController alloc] initWithNibName:@"tableIndexViewController" bundle:nil bookIndex:_bookIndex parentViewController:self];
        _imageViewController = [[imageIndexViewController alloc] initWithNibName:@"imageIndexViewController" bundle:nil bookIndex:_bookIndex parentViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Book Index";
    [_contentView addSubview:_imageViewController.view];
    currentViewIsImage = YES;
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleBordered target:self action:@selector(changeViewMode)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"书签" style:UIBarButtonItemStyleBordered target:self action:@selector(showBookMark)] autorelease];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_bookIndex release];
    [_bookView release];
    [_loadingSpinner release];
    [_tableViewController release];
    [_imageViewController release];
    [_contentView release];
    [super dealloc];
}

@end
