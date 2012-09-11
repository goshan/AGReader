//
//  indexViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "indexViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation indexViewController

@synthesize bookIndex = _bookIndex;
@synthesize tableView = _tableView;
@synthesize bookViewController = _bookViewController;
@synthesize loadingSpinner = _loadingSpinner;

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
        int id = [[line substringToIndex:lineRange.location] intValue];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *bookName = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *resource = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        NSString *pageIndex = [line substringToIndex:lineRange.location];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        NSString *bookImage = [NSString stringWithString:line];
        
        NSDictionary *book = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:id], @"id", bookName, @"bookName", resource, @"resource", pageIndex, @"pageIndex", bookImage, @"bookImage", nil];
        [index addObject:book];
    }
    return index;
}

- (void)showSpinner {
    //display loading spinner when adding cell
    if(!self.loadingSpinner) {
        self.loadingSpinner = [[MBProgressHUD alloc] initWithView:self.view];
        self.loadingSpinner.labelText = @"小说加载中...";
        [self.view addSubview:self.loadingSpinner];
    }
    [self.loadingSpinner show:YES];
}

- (void) showBookViewController:(NSDictionary *)book{
    _bookViewController=[[bookViewController alloc] initWithNibName:@"bookViewController" bundle:nil bookInfo:book];
    [_loadingSpinner hide:YES];
    [self.navigationController pushViewController:_bookViewController animated:YES];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bookIndex = [self loadBookIndexFrom:@"bookIndex" ofType:@"txt"];
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
    [self showSpinner];
    NSDictionary *book = [_bookIndex objectAtIndex:indexPath.row];
    if(_bookViewController && [_bookViewController.book objectForKey:@"id"] == [book objectForKey:@"id"]){
        //[self performSelector:@selector(initBookViewController:) withObject:book afterDelay:0.0];
        //_bookViewController=[[bookViewController alloc]initWithNibName:@"bookViewController" bundle:nil resource:[book objectForKey:@"resource"] index:[book objectForKey:@"bookIndex"]];
        [_loadingSpinner hide:YES];
        [self.navigationController pushViewController:_bookViewController animated:YES];
    }
    else {
        [self performSelector:@selector(showBookViewController:) withObject:book afterDelay:0.0];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

@end
