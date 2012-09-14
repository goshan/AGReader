//
//  imageIndexViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "imageIndexViewController.h"
#import "indexViewController.h"


int colPerRow = 2;
int imageHeight = 70;
int imageWidth = 70;
int rowStart = 11;
int colStart = 60;
int rowSpace = 14;
int colSpace = 60;

@implementation imageIndexViewController

@synthesize bookIndex = _bookIndex;
@synthesize parent = _parent;
@synthesize imageView = _imageView;




- (NSArray *)getRowAndColByIndex:(int) index{
    int col = index%colPerRow;
    int row = index/colPerRow;
    NSArray *rowAndCol = [NSArray arrayWithObjects:[NSNumber numberWithInt:row], [NSNumber numberWithInt:col], nil];
    return rowAndCol;
}

- (void)openBook:(id)sender{
    UIButton *image = sender;
    NSDictionary *book = [_bookIndex bookInfoAtIndex:image.tag];
    [_parent showSpinner];
    if(_parent.bookView && [_parent.bookView.book objectForKey:Utils.BOOKID] == [book objectForKey:Utils.BOOKID]){
        [_parent showBookViewController];
    }
    else {
        [_parent performSelector:@selector(showBookViewControllerByInitWith:) withObject:book afterDelay:0.0];
    }
}

- (void)addImageViewTo:(UIView *)view{
    for (int i=0; i<_bookIndex.count; i++){
        NSArray *rowAndCol = [self getRowAndColByIndex:i];
        UIButton *image = [[UIButton alloc] initWithFrame:CGRectMake(colStart+[[rowAndCol objectAtIndex:1] intValue]*(colSpace+imageWidth), rowStart+[[rowAndCol objectAtIndex:0] intValue]*(rowSpace+imageHeight), imageWidth, imageHeight)];
        [image setBackgroundImage:[UIImage imageNamed:[[_bookIndex bookInfoAtIndex:i] objectForKey:Utils.IMAGEFILE]] forState:UIControlStateNormal];
        image.tag = i;
        
        //make image round
        CALayer *layer = image.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 5.0;
        
        //add touch action
        [image addTarget:self action:@selector(openBook:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:image];
        [image release];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookIndex:(bookIndex *)index parentViewController:(indexViewController *)parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bookIndex = index;
        _parent = parent;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addImageViewTo:_imageView];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
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
    [_parent release];
    [_imageView release];
    [super dealloc];
}
@end
