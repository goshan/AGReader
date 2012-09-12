//
//  indexViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "indexViewController.h"
#import "Utils.h"

BOOL currentViewIsImage;

@implementation indexViewController

@synthesize bookView = _bookView;
@synthesize bookIndex = _bookIndex;
@synthesize loadingSpinner = _loadingSpinner;
@synthesize contentView = _contentView;
@synthesize tableViewController = _tableViewController;
@synthesize imageViewController = _imageViewController;

- (NSArray *)loadBookIndexFrom:(NSString *)resource ofType:(NSString *)type{
    NSMutableArray *index = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSString *text  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    while (1){
        NSRange range = [text rangeOfString:@"\n"];
        if (range.location == NSNotFound){
            break;
        }
        NSString *line = [text substringToIndex:range.location];
        text = [text substringFromIndex:range.location+range.length];
        
        NSRange lineRange = [line rangeOfString:@"\t"];
        int bookId = [[line substringToIndex:lineRange.location] intValue];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *bookName = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *fileName = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *pageIndex = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        NSString *imageFile = [NSString stringWithString:line];
        
        NSDictionary *book = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:bookId], Utils.BOOKID, bookName, Utils.BOOKNAME, fileName, Utils.FILENAME, pageIndex, Utils.PAGEINDEX, imageFile, Utils.IMAGEFILE, nil];
        [index addObject:book];
    }
    return index;
}

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
    _bookView=[[bookViewController alloc] initWithNibName:@"bookViewController" bundle:nil bookInfo:book];
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
        self.navigationItem.rightBarButtonItem.title = @"书架";
    }
    else {
        currentViewIsImage = YES;
        [_tableViewController.view removeFromSuperview];
        [_contentView addSubview:_imageViewController.view];
        [_imageViewController.view setUserInteractionEnabled:YES];
        self.navigationItem.rightBarButtonItem.title = @"列表";
    }
    
    [UIView commitAnimations]; 
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bookIndex = [self loadBookIndexFrom:@"bookIndex" ofType:@"txt"];
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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleBordered target:self action:@selector(changeViewMode)] autorelease];
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
