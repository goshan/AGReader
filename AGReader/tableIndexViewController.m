//
//  tableIndexViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tableIndexViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "indexViewController.h"

@implementation tableIndexViewController

@synthesize bookIndex = _bookIndex;
@synthesize parent = _parent;
@synthesize tableView = _tableView;


- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookIndex:(NSArray *)index parentViewController:(indexViewController *)parent
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
    //hidden seperator line for empty cell
    [self setExtraCellLineHidden:_tableView];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
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
    [_tableView release];
    [super dealloc];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_bookIndex count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"indexCell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* objects =  [[NSBundle  mainBundle] loadNibNamed:@"indexCell" owner:nil options:nil];
        cell = [objects objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    }
    
    NSDictionary *book = [_bookIndex objectAtIndex:indexPath.row];
    
    // Set up the cell...
    UIImageView* bookImage = (UIImageView*)[cell viewWithTag:1];
    UILabel* bookName = (UILabel*)[cell viewWithTag:2];
    
    [bookImage setImage:[UIImage imageNamed:[book objectForKey:@"bookImage"]]];
    bookName.text = [NSString stringWithString:[book objectForKey:@"bookName"]];
    
    //make image round
    CALayer *layer = bookImage.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_parent showSpinner];
    NSDictionary *book = [_bookIndex objectAtIndex:indexPath.row];
    if(_parent.bookView && [_parent.bookView.book objectForKey:@"id"] == [book objectForKey:@"id"]){
        [_parent showBookViewController];
    }
    else {
        [_parent performSelector:@selector(showBookViewControllerByInitWith:) withObject:book afterDelay:0.0];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}



@end
