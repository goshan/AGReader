//
//  bookViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "bookViewController.h"


float fontValue = 15.0f;
int textViewHeight = 366;
int textViewWidth = 320;
float leftInsets = 20.0;

BOOL hasFuncView = NO;

@implementation bookViewController

@synthesize totalPageNum = _totalPageNum;
@synthesize currentPageNum = _currentPageNum;
@synthesize showPageNum = _showPageNum;
@synthesize content = _content;
@synthesize marks = _marks;
@synthesize config = _config;
@synthesize adView = _adView;
@synthesize scrollView = _scrollView;
@synthesize funcView = _funcView;
@synthesize viewModeButton = _viewModeButton;
@synthesize addMarkButton = _addMarkButton;
@synthesize book = _book;
@synthesize pageIndex = _pageIndex;
@synthesize views = _views;




- (NSString *)loadStringFrom:(NSString *)resource ofType:(NSString *)type{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

- (NSDictionary *)loadPageIndexFrom:(NSString *)resource ofType:(NSString *)type{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSString *content  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    while (1){
        NSRange range = [content rangeOfString:@"\n"];
        if (range.location == NSNotFound){
            break;
        }
        NSString *line = [content substringToIndex:range.location];
        content = [content substringFromIndex:range.location+range.length];
        
        NSRange lineRange = [line rangeOfString:@"\t"];
        int page = [[line substringToIndex:lineRange.location] intValue];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        lineRange = [line rangeOfString:@"\t"];
        int start = [[line substringToIndex:lineRange.location] intValue];
        line = [line substringFromIndex:lineRange.location+lineRange.length];
        int end = [line intValue];
        
        NSArray *wordRange = [NSArray arrayWithObjects:[NSNumber numberWithInt:start], [NSNumber numberWithInt:end], nil];
        [dict setObject:wordRange forKey:[NSNumber numberWithInt:page]];
    }
    return dict;
}

- (NSArray *)genTextViewsWithContent{
    UIFont *font = [UIFont systemFontOfSize:fontValue];
    NSMutableArray *views = [[NSMutableArray alloc] init];
    int basePage = 0;
    if (_currentPageNum == 0){
        basePage = 0;
    }
    else {
        basePage = _currentPageNum - 1;
    }
    for (int i=0; i<3; i++){
        int start = [[[_pageIndex objectForKey:[NSNumber numberWithInt:i+basePage]] objectAtIndex:0] intValue];
        int end = [[[_pageIndex objectForKey:[NSNumber numberWithInt:i+basePage]] objectAtIndex:1] intValue];
        NSString *text = [_content substringWithRange:NSMakeRange(start, end-start)];
        CGRect rect = CGRectMake(i*320, 0, textViewWidth, textViewHeight);
        goshanLabel *view = [[goshanLabel alloc] initWithFrame:rect andLeftInsets:leftInsets];
        view.text = text;
        [view setFont:font];
        view.lineBreakMode = UILineBreakModeWordWrap;
        view.numberOfLines = 0;
        [views addObject:view];
    }
    return views;
}

- (int)reloadShowPageNum{
     return _scrollView.contentOffset.x/textViewWidth;
}

- (void)addBookMark{
    UITextView *view = [_views objectAtIndex:_showPageNum];
    NSString *content = [view.text substringToIndex:39];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSDictionary *mark = [[NSDictionary alloc] initWithObjectsAndKeys:[_book objectForKey:Utils.BOOKID], Utils.MARKBOOKID, [NSString stringWithFormat:@"%d", _currentPageNum], Utils.MARKPAGENUM, content, Utils.MARKCONTENT, nil];
    [_marks addMark:mark];
    MBProgressHUD* checkmark = [[[MBProgressHUD alloc] initWithView:self.view]autorelease];
    [self.view addSubview:checkmark];
    checkmark.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]] autorelease];
    checkmark.mode = MBProgressHUDModeCustomView;
    checkmark.labelText = @"收藏成功";
    [checkmark show:YES];
    [checkmark hide:YES afterDelay:1];
}

- (void)reloadViewsWithViewMode{
    for (int i=0; i<_views.count; i++){
        goshanLabel *view = [_views objectAtIndex:i];
        if (_config.viewMode == 0){
            view.backgroundColor = [UIColor whiteColor];
            view.textColor = [UIColor blackColor];
        }
        else {
            view.backgroundColor = [UIColor blackColor];
            view.textColor = [UIColor whiteColor];
        }
    }
    //set viewMode button content
    if (_config.viewMode == 0){
        [_viewModeButton setBackgroundImage:[UIImage imageNamed:@"night.png"] forState:UIControlStateNormal];
    }
    else {
        [_viewModeButton setBackgroundImage:[UIImage imageNamed:@"day.png"] forState:UIControlStateNormal];
    }
}

- (void)changeViewMode{
    if(_config.viewMode == 0){
        _config.viewMode = 1;
    }
    else {
        _config.viewMode = 0;
        
    }
    [_config saveConfig];
    [self reloadViewsWithViewMode];
}

- (void)loadFuncView{
    if (hasFuncView){
        CGRect frame = _funcView.frame;
        frame.origin.y = 0;
        [_funcView setFrame:frame];
    }
    else{
        CGRect frame = _funcView.frame;
        frame.origin.y = -50;
        [_funcView setFrame:frame];
    }
}

- (void)changeFuncView{
    if (hasFuncView){
        hasFuncView = NO;
    }
    else{
        hasFuncView = YES;
    }
    
    //Animations
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionNone forView:_funcView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    [self loadFuncView];
    
    [UIView commitAnimations];
}

- (void)hiddenFuncView{
    if (hasFuncView){
        hasFuncView = NO;
        
        //Animations
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionNone forView:_funcView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.4];
        
        [self loadFuncView];
        
        [UIView commitAnimations]; 
    }
}

#define in .h file

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookInfo:(NSDictionary *)book pageNum:(int)pageNum marks:(bookMarks *)marks config:(Config *)config{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _book = book;
        _currentPageNum = pageNum;
        _marks = marks;
        _config = config;
        _content = [self loadStringFrom:[_book objectForKey:Utils.FILENAME] ofType:@"txt"];
        _pageIndex = [self loadPageIndexFrom:[_book objectForKey:Utils.PAGEINDEX] ofType:@"ind"];
        _totalPageNum = _pageIndex.count;
        _views = [self genTextViewsWithContent];
        _showPageNum = pageNum == 0 ? 0 : 1;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    self.title = [_book objectForKey:Utils.BOOKNAME];
    [super viewDidLoad];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.clipsToBounds = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delaysContentTouches = YES;
    _scrollView.canCancelContentTouches = YES;
    [_scrollView setContentSize:CGSizeMake(textViewWidth*3, textViewHeight)];
    
    for (int i=0; i<3; i++){
        [_scrollView addSubview:[_views objectAtIndex:i]];
    }
    
    //set content offset
    if (_currentPageNum == 0){
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(textViewWidth, 0) animated:NO];
    }
    
    //add single tap in scrollView for hidden funcView
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenFuncView)];
    [_scrollView addGestureRecognizer:singleTap];
    
    //set view mode info
    [self reloadViewsWithViewMode];
    
    [_addMarkButton setBackgroundImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
    
    //set func view
    [self loadFuncView];
    
    //set rightNavItem
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"功能" style:UIBarButtonItemStyleBordered target:self action:@selector(changeFuncView)] autorelease];
    
    // adView1
    _adView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
    _adView.frame = CGRectMake(0, 366, 320, 50);
    
    ////////////////[必填]///////////////////
    // 设置APP ID 和 APP Secret
    _adView.appID = @"3ce7458bf27f044a";
    _adView.appSecret = @"797d9e42d0a89c21";
    
    ////////////////[可选]///////////////////
    // 设置您应用的版本信息
    _adView.appVersion = @"1.0";
    
    // 设置您应用的推开渠道号
    // adView1.channelID = 1;
    
    // 设置您应用的广告请求模式
    // adView1.testing = NO;
    
    // 可以设置委托
    //_adView.delegate = (id)self;
    
    // 设置文字广告的属性
    // adView1.indicateBorder = NO;
    // adView1.indicateTranslucency = YES;
    // adView1.indicateRounded = NO;
    
    // adView1.indicateBackgroundColor = [UIColor purpleColor];
    // adView1.textColor = [UIColor whiteColor];
    // adView1.subTextColor = [UIColor yellowColor];
    
    // 添加对应的关键词
    // [adView1 addKeyword:@"女性"];
    // [adView1 addKeyword:@"19岁"];
    
    // 开始请求广告
	[_adView start];
    
	[self.view addSubview:_adView];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setFuncView:nil];
    [self setViewModeButton:nil];
    [self setAddMarkButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
//}

- (void)dealloc {
    [_content release];
    [_marks release];
    [_views release];
    [_adView release];
    [_scrollView release];
    [_book release];
    [_pageIndex release];
    [_funcView release];
    [_viewModeButton release];
    [_addMarkButton release];
    [super dealloc];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int newPageNum = [self reloadShowPageNum];
    if (newPageNum < _showPageNum){
        //prev page
        UITextView *view0 = [_views objectAtIndex:0];
        UITextView *view1 = [_views objectAtIndex:1];
        UITextView *view2 = [_views objectAtIndex:2];
        _currentPageNum --;
        if (_currentPageNum == 0){

        }
        else if (_currentPageNum == _totalPageNum-2){
            
        }
        else {
            int start = [[[_pageIndex objectForKey:[NSNumber numberWithInt:_currentPageNum-1]] objectAtIndex:0] intValue];
            int end = [[[_pageIndex objectForKey:[NSNumber numberWithInt:_currentPageNum-1]] objectAtIndex:1] intValue];
            NSString *text = [_content substringWithRange:NSMakeRange(start, end-start)];
            view2.text = view1.text;
            view1.text = view0.text;
            view0.text = text;
            [_scrollView setContentOffset:CGPointMake(textViewWidth, 0) animated:NO];
        }
    }
    else if(newPageNum > _showPageNum){
        //next page
        UITextView *view0 = [_views objectAtIndex:0];
        UITextView *view1 = [_views objectAtIndex:1];
        UITextView *view2 = [_views objectAtIndex:2];
        _currentPageNum ++;
        if (_currentPageNum == 1){
            
        }
        else if (_currentPageNum == _totalPageNum-1){
            
        }
        else {
            int start = [[[_pageIndex objectForKey:[NSNumber numberWithInt:_currentPageNum+1]] objectAtIndex:0] intValue];
            int end = [[[_pageIndex objectForKey:[NSNumber numberWithInt:_currentPageNum+1]] objectAtIndex:1] intValue];
            NSString *text = [_content substringWithRange:NSMakeRange(start, end-start)];
            view0.text = view1.text;
            view1.text = view2.text;
            view2.text = text;
            [_scrollView setContentOffset:CGPointMake(textViewWidth, 0) animated:NO];
        }
    }
    else{
        //current page
    }
    _showPageNum = [self reloadShowPageNum];
}

- (IBAction)addMark:(id)sender {
    [self addBookMark];
}

- (IBAction)changeMode:(id)sender {
    [self changeViewMode];
}
@end
