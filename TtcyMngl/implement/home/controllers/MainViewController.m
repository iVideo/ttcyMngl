//
//  MainViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "MainViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "CustemTabBar.h"
#import "PlayBar.h"
#import "STKAudioPlayer.h"
#import "QueueItemId.h"
#import "AccountManager.h"

#import "LocalMainViewController.h"
#import "OnlineMainViewController.h"
#import "SettingMainViewController.h"
#import "MusicPlayerViewController.h"
#import "PlayQueueListViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "DownloadListViewController.h"
#import "HUD.h"
#import "IntroViewManager.h"

#import "UserShareSDK.h"

@interface MainViewController ()<UINavigationControllerDelegate,PlayControlDelegate,IntroViewManagerDelegate>
{
    STKAudioPlayer* _audioPlayer;
    NSInteger _currentPlayIndex;
    NSTimer * timer;
    
    BOOL playBarHeadPressed;
    BOOL playBarMenuPressed;
}
@property (nonatomic,strong)UINavigationController * navigation;
@property (nonatomic,strong)CustemTabBar * tab ;
@property (nonatomic,strong)PlayBar * playBar;

@property (nonatomic,strong)CustemTabBar * MusicOprationBar;

@end

@implementation MainViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createPlayer];
    
    [self setBaseCondition];
    
    [self createContentView];
    
    [self createTabbar];
    
    [self createPlayBarBG];
    
    [self createPlayBar];
    
    [self checkFirst];
}
- (void)checkFirst
{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [self showIntroView];
    }else{
        
    }
    
}
- (void)showIntroView
{
    IntroViewManager * introManager = [[IntroViewManager alloc]initWithView:self.view delegate:self];
    [introManager showCustomIntro];
}
#pragma mark - 创建播放器
-(void)createPlayer
{
    _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
	_audioPlayer.meteringEnabled = YES;
	_audioPlayer.volume = 1;
}
#pragma mark - 初始化控件－－－－－－－－－－－
-(void)setBaseCondition
{
    getPlayBarHeight()
    getTopDistance()

    
    MenuItem * item0 = [MenuItem itemWithIcon:@"menu_local" hightLightIcon:@"menu_local_h" title:@"" vcClass:@"LocalMainViewController" andTag:10000];
    
    MenuItem * item1 = [MenuItem itemWithIcon:@"menu_online" hightLightIcon:@"menu_online_h" title:@"" vcClass:@"OnlineMainViewController" andTag:10001];
    
    MenuItem * item2 = [MenuItem itemWithIcon:@"menu_setting" hightLightIcon:@"menu_setting_h" title:@"" vcClass:@"SettingMainViewController" andTag:10002];
    
    NSArray * array = [NSArray arrayWithObjects:item0,item1,item2, nil];
    
    
    self.tab = [[CustemTabBar alloc]initWithFrame:CGRectMake(0, topDistance, kMainScreenWidth, TopBarHeight) andItems:array];
    _tab.backgroundColor = NVC_COLOR;
    
    __unsafe_unretained MainViewController *main = self;
    
    _tab.itemClick = ^(MenuItem *item) {
        
        Class c = NSClassFromString(item.vcClass);
        UIViewController *vc = [[c alloc] init];
        [main.navigation setViewControllers:@[vc]];
        
        [main.tab setSelectedWithItemTag:item.tag];
    };
    
    if (isIOS7) {
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
}
-(void)createTabbar
{
    [self.view addSubview:_tab];
}
-(void)createContentView
{
    self.view.backgroundColor = NVC_COLOR;
    self.navigation = [[UINavigationController alloc]initWithRootViewController:[[OnlineMainViewController alloc]init]];
    _navigation.delegate = self;
    
    _navigation.view.frame = CGRectMake(0, topDistance, kMainScreenWidth, kMainScreenHeight);
    
    _tab.itemClick(_tab.menuItems[1]);
    
    [self addChildViewController:_navigation];

    [self.view addSubview:_navigation.view];
    
}
-(void)createPlayBar
{
    self.playBar = [PlayBar shareInstanceWithFrame:CGRectMake(0, kMainScreenHeight - PlayBarHeight + topDistance, kMainScreenWidth,PlayBarHeight)  andAudioPlayer:_audioPlayer];
    
    _playBar.delegate = self;
    [self.view addSubview:_playBar];
}
-(void)createPlayBarBG
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = CENT_COLOR;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:view];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(view)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[view(%f)]",PlayBarHeight] options:0 metrics:0 views:NSDictionaryOfVariableBindings(view)]];
    
    UIView * spl = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, .5f)];
    spl.backgroundColor = [UIColor colorWithWhite:.8f alpha:1];
    [view addSubview:spl];
    
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    
    label.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    label.text = @"\n\n\n\n\n\n\n\n";
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    [view addSubview:label];
    
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(label)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[label]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(label)]];
    
}
#pragma mark - 导航控制器代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *root = navigationController.viewControllers[0];
    if (viewController != root) {
        // 1.添加左边的返回键
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) name:@"back_btn"];
//        viewController.title = @"Tengri Tal";
        _tab.hidden = YES;
        viewController.navigationController.navigationBar.hidden = NO;
    }else{
        _tab.hidden = NO;
        viewController.navigationController.navigationBar.hidden = YES;
    }
}
- (void)back
{
    if ([_navigation.topViewController isKindOfClass:[MusicPlayerViewController class]]) {
        playBarHeadPressed = NO;
    }else if([_navigation.topViewController isKindOfClass:[PlayQueueListViewController class]]){
        playBarMenuPressed = NO;
    }
    [_navigation popViewControllerAnimated:YES];
}
#pragma mark - 注册后台播放远程控制－－－－－－－－－－－－－－－－

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	[self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlPause:
                [_playBar resumeOrPause]; // 暂停按钮
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [_playBar resumeOrPause]; // 播放按钮
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [_playBar resumeOrPause]; // 切换播放、暂停按钮
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [_playBar playPrevMusic]; // 播放上一曲按钮
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [_playBar playNextMusic]; // 播放下一曲按钮
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - PlayBarDelegate @optional methods ----------------------

-(void)PlayBarHeadImagePressed:(SongObject *)aSong
{
    if (aSong) {
        if (!(playBarHeadPressed|[_navigation.topViewController isKindOfClass:[MusicPlayerViewController class]])) {
            
            MusicPlayerViewController * MVC = [[MusicPlayerViewController alloc]initWithSongObject:aSong andViewController:self];
            [_playBar addListener:MVC];
            [_navigation pushViewController:MVC animated:YES];
        }
        playBarHeadPressed = YES;
    }else{}
    
}
-(void)PlayBarMenuButtonPressed:(NSArray *)queueArray
{
    if (!playBarMenuPressed) {
        
        PlayQueueListViewController * listVC = [[PlayQueueListViewController alloc]initWithListArray:queueArray];
        [_playBar addListener:listVC];
        [_navigation pushViewController:listVC animated:YES];
    }
    playBarMenuPressed = YES;
}
-(void)PlayBarHiddeButtonPressed:(void (^)(BOOL))callBack
{
    [UIView animateWithDuration:0.3f animations:^{
        if (_playBar.frame.origin.x<0) {
            
            _playBar.frame = CGRectMake(_playBar.frame.origin.x + (_playBar.frame.size.width - 16), _playBar.frame.origin.y, _playBar.frame.size.width, _playBar.frame.size.height);
            callBack(NO);
        }else{
            _playBar.frame = CGRectMake(_playBar.frame.origin.x - (_playBar.frame.size.width - 16), _playBar.frame.origin.y, _playBar.frame.size.width, _playBar.frame.size.height);
            callBack(YES);
        }
        _MusicOprationBar.frame = CGRectMake(_playBar.frame.origin.x, _MusicOprationBar.frame.origin.y, _MusicOprationBar.frame.size.width, _MusicOprationBar.frame.size.height);
    }];
}

static BOOL musicBarFlag = YES;

-(void)playBarMoreButtonPressed
{
    
    if (musicBarFlag) {
        
        MenuItem * item0 = [MenuItem itemWithIcon:@"collect_btn" hightLightIcon:@"collect_btn_h" title:@"" vcClass:nil andTag:10000];
        
        MenuItem * item1 = [MenuItem itemWithIcon:@"share_btn" hightLightIcon:@"share_btn_h" title:@"" vcClass:nil andTag:10001];
        
        MenuItem * item2 = [MenuItem itemWithIcon:@"download_btn" hightLightIcon:@"download_btn_h" title:@"" vcClass:nil andTag:10002];
        
        MenuItem * item4 = [MenuItem itemWithIcon:@"cancel_btn" hightLightIcon:@"cancel_btn_h" title:@"" vcClass:nil andTag:10003];
        
        NSArray * array = [NSArray arrayWithObjects:item0,item1,item2,item4, nil];
        
        self.MusicOprationBar = [[CustemTabBar alloc]initWithFrame:CGRectMake(0, kMainScreenHeight - PlayBarHeight - TopBarHeight*4/5.0f + topDistance, kMainScreenWidth, TopBarHeight*4/5.0f) andItems:array];
        
        _MusicOprationBar.backgroundColor = [UIColor colorWithWhite:.3f alpha:.8f];
        
        [self.view addSubview:_MusicOprationBar];
        [self.view bringSubviewToFront:_MusicOprationBar];
        
        __unsafe_unretained MainViewController *main = self;
        
        _MusicOprationBar.itemClick = ^(MenuItem *item) {
            
            switch (item.tag-10000) {
                    
                case 0:
                    [main oprationCollect];
                    break;
                case 1:
                    [main oprationShare];
                    break;
                case 2:
                    [main oprationDownLoad];
                    break;
                case 3:
                    [main oprationDelete];
                    break;
                    
                default:
                    break;
            }
        };
        musicBarFlag = !musicBarFlag;
    }else{
        [self musicOprationBarHidde];
    }
}
-(void)musicOprationBarHidde
{
    musicBarFlag = !musicBarFlag;
    [_MusicOprationBar removeFromSuperview];
}
-(void)showBufferingHud:(BOOL)isShow
{
    if (isShow) {
        [HUD messageForBuffering];
    }else{
        [HUD clearHudFromApplication];
    }
}

#pragma mark - 操作当前歌曲的方法
//移除
-(void)oprationDelete
{
    [self musicOprationBarHidde];
    if ([[PlayBar defultPlayer] getCurrentPlayingSong]) {
        [[PlayBar defultPlayer] delelteQueueWithItem:[[PlayBar defultPlayer] getCurrentPlayingSong]];
    }
}

//推荐
-(void)oprationRecommend
{
    [self musicOprationBarHidde];
}

//分享
-(void)oprationShare
{
    [self musicOprationBarHidde];
    UserShareSDK *userSDK = [[UserShareSDK alloc] init];
    NSDictionary * songDict = [[[PlayBar defultPlayer] getCurrentPlayingSong] dictionary];
    [userSDK shareSongWithDictionary:songDict];
    
}

//收藏
-(void)oprationCollect
{
    [self musicOprationBarHidde];
    @autoreleasepool {
        
        AccountManager * aManager = [AccountManager shareInstance];
        
        if (aManager.status == onLine) {
            [[PlayBar defultPlayer] collectCurrentSong:^(BOOL isOK) {
                if (isOK) {
                    [HUD message:@"     \n  -> "];
                }else{
                    [HUD message:@"    "];
                }
            }];
        }else{
            [HUD message:@"  "];
        }
        
    }
    
    
}

//下载
-(void)oprationDownLoad
{
    [self musicOprationBarHidde];
    [[DownloadListViewController shareInstance] setDownLoadObject:[[PlayBar defultPlayer] getCurrentPlayingSong]];
    [HUD message:@"     \n  -> "];
}

#pragma mark - IntroViewManagerDelegate methods
- (void)introDidFinish {
    NSLog(@"Intro callback");
}

@end













