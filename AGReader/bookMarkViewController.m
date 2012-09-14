//
//  bookMarkViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "bookMarkViewController.h"


@implementation bookMarkViewController

@synthesize loadingSpinner = _loadingSpinner;
@synthesize bookView = _bookView;
@synthesize marks = _marks;
@synthesize index = _index;
@synthesize tableView = _tableView;


- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
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

- (void) showBookViewControllerByInitWith:(NSArray *)markInfo{
    _bookView=[[bookViewController alloc] initWithNibName:@"bookViewController" bundle:nil bookInfo:[markInfo objectAtIndex:0] pageNum:[[markInfo objectAtIndex:1] intValue] marks:_marks];
    [_loadingSpinner hide:YES];
    [self.navigationController pushViewController:_bookView animated:YES];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookMark:(bookMarks *)marks bookIndex:(bookIndex *)index
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _index = index;
        _marks = marks;
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
    [_marks release];
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
    return [_marks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"markCell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* objects =  [[NSBundle  mainBundle] loadNibNamed:@"markCell" owner:nil options:nil];
        cell = [objects objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    }
    
    NSDictionary *mark = [_marks markAtIndex:indexPath.row];
    
    // Set up the cell...
    UILabel* bookName = (UILabel*)[cell viewWithTag:1];
    UILabel* pageName = (UILabel*)[cell viewWithTag:2];
    UILabel* content = (UILabel*)[cell viewWithTag:3];
    
    NSDictionary *bookInfo = [_index bookInfoAtIndex:[[mark objectForKey:Utils.MARKBOOKID] intValue]];
    bookName.text = [bookInfo objectForKey:Utils.BOOKNAME];
    pageName.text = [NSString stringWithFormat:@"第%d页", [[mark objectForKey:Utils.MARKPAGENUM] intValue]+1];
    content.text = [[mark objectForKey:Utils.MARKCONTENT] stringByAppendingString:@"..."];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showSpinner];
    NSDictionary *mark = [_marks markAtIndex:indexPath.row];
    NSDictionary *book = [_index bookInfoAtIndex:[[mark objectForKey:Utils.MARKBOOKID] intValue]];
    NSArray *markInfo = [NSArray arrayWithObjects:book, [mark objectForKey:Utils.MARKPAGENUM], nil];
    [self performSelector:@selector(showBookViewControllerByInitWith:) withObject:markInfo afterDelay:0.0];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_marks removeMarkAtIndex:indexPath.row];
        
        [self.tableView beginUpdates];        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }   
}

@end
