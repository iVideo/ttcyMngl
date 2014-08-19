//
//  MusicPlayerViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-10.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "SongLrcTableView.h"
#import "SongObject.h"
#import <ASIHTTPRequest.h>
#import "PlayBar.h"
#import "UIBarButtonItem+Addition.h"
#import "MainViewControllerDelegate.h"
#import "SongObject.h"
#import "SongInfoView.h"
#import "HUD.h"

@interface MusicPlayerViewController ()<ASIHTTPRequestDelegate,UIScrollViewDelegate>
{
    NSInteger currentLrcIndex;
}
@property (nonatomic,strong)NSString * lrcFile;

@property (nonatomic,strong)SongObject * currentSong;

@property (nonatomic,strong)NSString * currentLrcInlocalPath;

@property (nonatomic,strong)SongLrcTableView * lrcTableView;

@property (nonatomic,strong)UIScrollView * contentView;

@property (nonatomic,strong)UIPageControl * pageControl;

@property (nonatomic,strong)UIViewController * callInitController;

@property (nonatomic,strong)SongInfoView * infoView;

@end

@implementation MusicPlayerViewController

- (id)initWithSongObject:(SongObject *)obj andViewController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.callInitController = controller;
        self.currentSong = obj;
        currentLrcIndex = 0;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    getPlayBarHeight()
    getTopDistance()
    self.view.backgroundColor = CENT_COLOR;
    if (![_callInitController isKindOfClass:NSClassFromString(@"MainViewController")]) {
        [[PlayBar defultPlayer] Play:_currentSong];
    }
    
    [self createPageControl];
    
    [self createScorwView];
    
    [self createLrcTableView];
    
    [self createInfoView];
    
    [self getCurrentLrc];
    
}
#pragma mark -  获取当前歌词
-(void)getCurrentLrc
{
    self.lrcFile = nil;
    if (![self checkLrcFileInDocuments]) {
        
        [self grabLrcInBackground];
        
    }else{
        [_lrcTableView showEmptyLabel:NO];
        [self refreshLrcTable];
    }
    
}
-(BOOL )checkLrcFileInDocuments
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory,
                                                            NSUserDomainMask, YES) objectAtIndex: 0];
    self.currentLrcInlocalPath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@.lrc",_currentSong.songName]];
    
    BOOL check = [[NSFileManager defaultManager] fileExistsAtPath:_currentLrcInlocalPath];
    if (check) {
        self.lrcFile = _currentLrcInlocalPath;
        return YES;
    }
    return NO;
}
-(void)createScorwView
{
    CGRect frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.contentView = [[UIScrollView alloc]initWithFrame:frame];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.contentSize = CGSizeMake(kMainScreenWidth*2, 0);
    _contentView.contentOffset = CGPointMake(0, 0);
    
    _contentView.pagingEnabled=YES;
    _contentView.showsVerticalScrollIndicator=NO;
    
    
    _contentView.delegate = self;
    
    [self.view addSubview:_contentView];
}
-(void)createPageControl
{
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectZero];
    
    [self.pageControl setBounds:CGRectMake(0, 0, 30*(self.pageControl.numberOfPages-1), 30)];
    [_pageControl.layer setCornerRadius:8];
    
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages=2;
    _pageControl.currentPage=0;
    _pageControl.enabled=YES;
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem itemWithTarget:nil action:nil name:@""],
                                                [UIBarButtonItem itemWithTarget:nil action:nil name:@""],
                                                [UIBarButtonItem itemWithTarget:nil action:nil name:@""]] ;
//    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:self.pageControl];
    
}
-(void)pageTurn:(UIPageControl *)sender
{
    int pageNum=_pageControl.currentPage;
    CGSize viewSize=_contentView.frame.size;
    [_contentView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
}
-(void)createLrcTableView
{
    self.lrcTableView = [[SongLrcTableView alloc]initWithFrame:CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight) andRowHeight:60.0f];
    [self.contentView addSubview:_lrcTableView];
    
}

-(void)createInfoView
{
    self.infoView = [[SongInfoView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) Song:_currentSong];
    [self.contentView addSubview:_infoView];
}

-(void)refreshLrcTable
{
    [_lrcTableView refreshLrcDataWithFileName:self.lrcFile];
}
-(void)refreshInfoView
{
    [_infoView refreshData:_currentSong];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PlayControlDelegate methods----------------

-(void)refreshPlayTime:(NSInteger)time
{
    static int count = 0;
    if (count == 10) {
        [_lrcTableView displaySondWord:time];
        count = 0;
    }
    count ++;
}
-(void)changeCurrentPlayingSong:(SongObject *)song
{
    _currentSong = song;
    [self refreshInfoView];
    [self getCurrentLrc];
    
}
#pragma mark - 获取歌词
- (void)grabLrcInBackground
{
    [HUD messageForBuffering];
    if (_currentSong && !([@"" isEqualToString:_currentSong.lrc_url] || nil == _currentSong.lrc_url || [_currentSong.lrc_url isKindOfClass:[NSNull class]])) {
        NSURL * url = [NSURL URLWithString: _currentSong.lrc_url];
        
        __unsafe_unretained ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.timeOutSeconds = 6;
        [request setCompletionBlock:^{
            
            NSString *responseString = [request responseString];
            
            [responseString writeToFile:_currentLrcInlocalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            [self refreshLrcTable];
            
        }];
        [request setFailedBlock:^{
        
            [HUD clearHudFromApplication];
            [self refreshLrcTable];
            
        }];
        [request startAsynchronous];
    }else{
        [HUD clearHudFromApplication];
        [self refreshLrcTable];
    }
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.contentView.frame.size.width;
    int currentPage=floor((self.contentView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    self.pageControl.currentPage=currentPage;
}

@end



