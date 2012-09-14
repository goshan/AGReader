//
//  bookViewController.m
//  AGReader
//
//  Created by Qiu Han on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "bookViewController.h"
#import "Utils.h"
#import "Toast+UIView.h"

int currentPage = 0;
float fontValue = 13.0f;
int textViewHeight = 350;
int textViewWidth = 320;

@implementation bookViewController

@synthesize initPageNum = _initPageNum;
@synthesize marks = _marks;
@synthesize adView = _adView;
@synthesize scrollView = _scrollView;
@synthesize book = _book;
@synthesize views = _views;




- (NSString *)loadStringFrom:(NSString *)resource ofType:(NSString *)type{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSString *content  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

- (int) getEndWith:(NSString *)text From:(int)start{
    UIFont *font = [UIFont boldSystemFontOfSize:fontValue];
    CGSize textViewSize = CGSizeMake(textViewWidth-16.0, textViewHeight-16.0);
    NSString *temp = [[NSString alloc] init];
    for (int i=start; i<text.length; i++){
        temp = [temp stringByAppendingFormat:@"%@", [text substringWithRange:NSMakeRange(i, 1)]];
        CGSize size = [temp sizeWithFont:font constrainedToSize:textViewSize lineBreakMode:UILineBreakModeWordWrap];
        if (size.height > textViewSize.height){
            [temp release];
            return i;
        }
    }
    [temp release];
    return text.length;
}

- (void)genPageIndex:(NSString *)text toFile:(NSString *)filename{
    NSString *indexContent = [[NSString alloc] init];
    int page = 0;
    int start = 0;
    int end = 0;
    while (end < text.length) {
        end = [self getEndWith:text From:start];
        indexContent = [indexContent stringByAppendingFormat:@"%d\t%d\t%d\n", page, start, end];
        NSLog(@"^^^^^^%d     %d    %d", page, start, end);
        page ++;
        start = end;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//获得需要的路径    
    NSLog(@"file directory is: %@", documentsDirectory);
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSData *data = [indexContent dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:NO];
    [indexContent release];
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

- (NSArray *)genTextViewsWithContent:(NSString *)content withIndex:(NSDictionary *)index{
    UIFont *font = [UIFont boldSystemFontOfSize:fontValue];
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i=0; i<index.count; i++){
        int start = [[[index objectForKey:[NSNumber numberWithInt:i]] objectAtIndex:0] intValue];
        int end = [[[index objectForKey:[NSNumber numberWithInt:i]] objectAtIndex:1] intValue];
        NSString *text = [content substringWithRange:NSMakeRange(start, end-start)];
        CGRect rect = CGRectMake(i*320, 0, textViewWidth, textViewHeight);
        UITextView *view = [[UITextView alloc] initWithFrame:rect];
        view.text = text;
        [view setFont:font];
        [view setEditable:NO];
        [views addObject:view];
        start = end;
    }
    return views;
}

- (int)getCurrentPageNum{
    return _scrollView.contentOffset.x/textViewWidth;
}

- (void)addBookMark{
    int currentPage = [self getCurrentPageNum];
    UITextView *view = [_views objectAtIndex:currentPage];
    NSString *content = [view.text substringToIndex:39];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSDictionary *mark = [[NSDictionary alloc] initWithObjectsAndKeys:[_book objectForKey:Utils.BOOKID], Utils.MARKBOOKID, [NSString stringWithFormat:@"%d", currentPage], Utils.MARKPAGENUM, content, Utils.MARKCONTENT, nil];
    [_marks addMark:mark];
    [self.view makeToast:@"收藏成功" duration:2.0 position:@"center" title:@""];
}

#define in .h file

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bookInfo:(NSDictionary *)book pageNum:(int)pageNum marks:(bookMarks *)marks{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _book = book;
        _initPageNum = pageNum;
        _marks = marks;
        NSString *content = [self loadStringFrom:[_book objectForKey:Utils.FILENAME] ofType:@"txt"];
        
        //gen index
        //[self genPageIndex:content toFile:@"index.txt"];
        
        //normal use
        NSDictionary *pageIndex = [self loadPageIndexFrom:[_book objectForKey:Utils.PAGEINDEX] ofType:@"ind"];
        _views = [self genTextViewsWithContent:content withIndex:pageIndex];
        [pageIndex release];
        NSLog(@"page total num is: %d", _views.count);
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
    [_scrollView setContentSize:CGSizeMake(textViewWidth*_views.count, textViewHeight)];
    for (int i=0; i<_views.count; i++){
        [_scrollView addSubview:[_views objectAtIndex:i]];
        [[_views objectAtIndex:i] release];
    }
    [_scrollView setContentOffset:CGPointMake((textViewWidth*_initPageNum), 0)];
    
    //set rightNavItem
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStyleBordered target:self action:@selector(addBookMark)] autorelease];
    
    // adView1
    _adView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
    
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
    _adView.delegate = self;
    
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
	//[_adView start];
    
	//[self.view addSubview:_adView];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setScrollView:nil];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc {
    [_views release];
    [_adView release];
    [_scrollView release];
    [super dealloc];
}

@end
