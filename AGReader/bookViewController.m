//
//  bookViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "bookViewController.h"


float fontValue = 15.0f;
int textViewHeight = 410;
int textViewWidth = 320;
float leftInsets = 15.0;

BOOL hasNavView = YES;

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




//gen index and text view
- (NSString *)loadStringFrom:(NSString *)resource ofType:(NSString *)type{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

- (int) getStartWith:(NSString *)text From:(int)end{
    UIFont *font = [UIFont systemFontOfSize:fontValue];
    CGSize textViewSize = CGSizeMake(textViewWidth-30.0, textViewHeight*2);
    NSString *temp = [[NSString alloc] init];
    for (int i=end-1; i>-1; i--){
        temp = [[text substringWithRange:NSMakeRange(i, 1)] stringByAppendingFormat:@"%@", temp];
        CGSize size = [temp sizeWithFont:font constrainedToSize:textViewSize lineBreakMode:UILineBreakModeWordWrap];
        if (size.height > textViewHeight){
            return i+1;
        }
    }
    return 0;
}

- (int) getEndWith:(NSString *)text From:(int)start{
    UIFont *font = [UIFont systemFontOfSize:fontValue];
    CGSize textViewSize = CGSizeMake(textViewWidth-30.0, textViewHeight*2);
    NSString *temp = [[NSString alloc] init];
    for (int i=start; i<text.length; i++){
        temp = [temp stringByAppendingFormat:@"%@", [text substringWithRange:NSMakeRange(i, 1)]];
        CGSize size = [temp sizeWithFont:font constrainedToSize:textViewSize lineBreakMode:UILineBreakModeWordWrap];
        if (size.height > textViewHeight){
            return i;
        }
    }
    return text.length;
}

- (void)genPageIndexFromStart:(int)startPos withPage:(int)pageStart{
    int page = pageStart;
    int start = startPos;
    int end = 0;
    
    for (int i=0; i<3; i++){
        end = [self getEndWith:_content From:start];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:start], @"start", [NSNumber numberWithInt:end], @"end", [NSNumber numberWithInt:page], @"page", nil];
        [_pageIndex addObject:dict];
        page ++;
        start = end;
    }
}

- (BOOL)genPageIndexPrev{
    int page = [[[_pageIndex objectAtIndex:0] objectForKey:@"page"] intValue]-1;
    int end = [[[_pageIndex objectAtIndex:0] objectForKey:@"start"] intValue];
    if (end == 0 || _showPageNum == 2){
        return NO;
    }
    else {
        int start = [self getStartWith:_content From:end];
        
        NSDictionary *dict0 = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:start], @"start", [NSNumber numberWithInt:end], @"end", [NSNumber numberWithInt:page], @"page", nil];
        NSDictionary *dict1 = [_pageIndex objectAtIndex:0];
        NSDictionary *dict2 = [_pageIndex objectAtIndex:1];
        
        [_pageIndex removeAllObjects];
        [_pageIndex addObject:dict0];
        [_pageIndex addObject:dict1];
        [_pageIndex addObject:dict2];
        
        return YES;
    }
}

- (BOOL)genPageIndexNext{
    int page = [[[_pageIndex objectAtIndex:2] objectForKey:@"page"] intValue]+1;
    int start = [[[_pageIndex objectAtIndex:2] objectForKey:@"end"] intValue];

    if (start == _content.length || _showPageNum == 0){
        return NO;
    }
    else {
        int end = [self getEndWith:_content From:start];
        
        NSDictionary *dict0 = [_pageIndex objectAtIndex:1];
        NSDictionary *dict1 = [_pageIndex objectAtIndex:2];
        NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:start], @"start", [NSNumber numberWithInt:end], @"end", [NSNumber numberWithInt:page], @"page", nil];
        
        [_pageIndex removeAllObjects];
        [_pageIndex addObject:dict0];
        [_pageIndex addObject:dict1];
        [_pageIndex addObject:dict2];
        
        return YES;
    }
}

- (void)initTextView{
    UIFont *font = [UIFont systemFontOfSize:fontValue];
    
    for (int i=0; i<3; i++){
        CGRect rect = CGRectMake(i*320, 0, textViewWidth, textViewHeight);
        goshanLabel *view = [[goshanLabel alloc] initWithFrame:rect andLeftInsets:leftInsets];
        [view setFont:font];
        view.lineBreakMode = UILineBreakModeWordWrap;
        view.numberOfLines = 0;
        [_views addObject:view];
    }
}

- (void)printTextViewsWithPageIndex{
    for (int i=0; i<_views.count; i++){
        int start = [[[_pageIndex objectAtIndex:i] objectForKey:@"start"] intValue];
        int end = [[[_pageIndex objectAtIndex:i] objectForKey:@"end"] intValue];
        NSString *text = [_content substringWithRange:NSMakeRange(start, end-start)];
        goshanLabel *view = [_views objectAtIndex:i];
        view.text = text;
    }
}






//view animate function
- (int)reloadShowPageNum{
     return _scrollView.contentOffset.x/textViewWidth;
}

- (void)addBookMark{
    int startPos = [[[_pageIndex objectAtIndex:0] objectForKey:@"start"] intValue];
    
    UITextView *view = [_views objectAtIndex:_showPageNum];
    NSString *content = [view.text substringToIndex:39];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSDictionary *mark = [[NSDictionary alloc] initWithObjectsAndKeys:[_book objectForKey:BOOKID], MARKBOOKID, [NSString stringWithFormat:@"%d", _currentPageNum], MARKPAGENUM, [NSString stringWithFormat:@"%d", startPos], MARKSTARTPOS, content, MARKCONTENT, nil];
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

- (void)loadViewByHasNav{
    if (hasNavView){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        CGRect frame = _funcView.frame;
        frame.origin.y = 356;
        [_funcView setFrame:frame];
    }
    else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        CGRect frame = _funcView.frame;
        frame.origin.y = 460;
        [_funcView setFrame:frame];
    }
}

- (void)changeNavView{
    if (hasNavView){
        hasNavView = NO;
    }
    else{
        hasNavView = YES;
    }
    
    //Animations
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionNone forView:_funcView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    [self loadViewByHasNav];
    
    [UIView commitAnimations];
}

- (void)hiddenNavView{
    if (hasNavView){
        hasNavView = NO;
        
        //Animations
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionNone forView:_funcView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.4];
        
        [self loadViewByHasNav];
        
        [UIView commitAnimations]; 
    }
}

#define in .h file

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookInfo:(NSDictionary *)book pageNum:(int)pageNum textStart:(int)start marks:(bookMarks *)marks config:(Config *)config{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _book = book;
        _currentPageNum = pageNum;
        _marks = marks;
        _config = config;
        _content = [self loadStringFrom:[_book objectForKey:FILENAME] ofType:@"txt"];
        int temp_page = pageNum == 0 ? pageNum : pageNum-1;
        _pageIndex = [[NSMutableArray alloc] init];
        [self genPageIndexFromStart:start withPage:temp_page];
        _totalPageNum = _pageIndex.count;
        _views = [[NSMutableArray alloc] init];
        [self initTextView];
        [self printTextViewsWithPageIndex];
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
    self.title = [_book objectForKey:BOOKNAME];
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
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNavView)];
    [_scrollView addGestureRecognizer:singleTap];
    
    //set rightNavItem
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"全屏" style:UIBarButtonItemStyleBordered target:self action:@selector(hiddenNavView)] autorelease];
    
    // adView1
    _adView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
    _adView.frame = CGRectMake(0, 410, 320, 50);
    
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
    
    _funcView = [[UIView alloc] initWithFrame:CGRectMake(0, 460, 320, 70)];  //10 pixel for animate
    _funcView.backgroundColor = [UIColor colorWithRed:0x3A/255 green:0x3A/255 blue:0x3A/255 alpha:0.5];
    _viewModeButton = [[UIButton alloc] initWithFrame:CGRectMake(45, 6, 90, 48)];
    _addMarkButton = [[UIButton alloc] initWithFrame:CGRectMake(185, 6, 90, 48)];
    
    //set view mode info
    [self reloadViewsWithViewMode];
    
    [_addMarkButton setBackgroundImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
    
    [_viewModeButton addTarget:self action:@selector(changeViewMode) forControlEvents:UIControlEventTouchUpInside];
    [_addMarkButton addTarget:self action:@selector(addBookMark) forControlEvents:UIControlEventTouchUpInside];
    [_funcView addSubview:_viewModeButton];
    [_funcView addSubview:_addMarkButton];
    
    //set func view
    [self loadViewByHasNav];
    
    [self.view addSubview:_funcView];
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
        _currentPageNum --;
        BOOL mid = [self genPageIndexPrev];
        [self printTextViewsWithPageIndex];
        if (mid){
            [_scrollView setContentOffset:CGPointMake(textViewWidth, 0) animated:NO];
        }
    }
    else if(newPageNum > _showPageNum){
        //next page
        _currentPageNum ++;
        BOOL mid = [self genPageIndexNext];
        [self printTextViewsWithPageIndex];
        if (mid){
            [_scrollView setContentOffset:CGPointMake(textViewWidth, 0) animated:NO];
        }
    }
    else{
        //current page
    }
    _showPageNum = [self reloadShowPageNum];
}
@end
