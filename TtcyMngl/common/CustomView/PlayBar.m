//
//  PlayBar.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "PlayBar.h"
#import "QueueItemId.h"
#import <UIImageView+WebCache.h>
#import "FMDBManager+PlayRecord.h"
#import "FMDBManager+CollectSong.h"
#import "AccountManager.h"

#define headBtnTag   2000
#define menuBtnTag   2001
#define playBtnTag   2002
#define nextBtnTag   2003
#define hiddeBtnTag  2004
#define proivBtnTag  2005
#define moreBtnTag   2006

@interface PlayBar ()
{
    double _duration;
    NSTimer * timer;
    int currentIndex;
    
    CGFloat _headAlpha;
    BOOL autoPlay;
    BOOL sendToBack;
}
@property (nonatomic,strong)NSMutableArray *listenerArray;

@property (nonatomic,strong)UIButton * headImage;
@property (nonatomic,strong)UILabel * songLabel;
@property (nonatomic,strong)UILabel * artLabel;
@property (nonatomic,strong)UIView * progress;
@property (nonatomic,strong)UILabel * frameTimeLabel;
@property (nonatomic,strong)UILabel * playTimeLabel;

@property (nonatomic,strong)UISlider * slider;

@property (nonatomic,strong) NSMutableArray * queueSongArray;

@end


@implementation PlayBar
@synthesize audioPlayer;

PlayBar * instence = nil;
+(PlayBar *)shareInstanceWithFrame:(CGRect)frame andAudioPlayer:(STKAudioPlayer *)audioPlayerIn
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instence = [[PlayBar alloc]initWithFrame:frame andAudioPlayer:audioPlayerIn];
    });
    return instence;
}
- (id)initWithFrame:(CGRect)frame andAudioPlayer:(STKAudioPlayer *)audioPlayerIn
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LOG_GENERAL_INFO(@"audio player pending queue is:%@",audioPlayerIn.pendingQueue);
        self.audioPlayer = audioPlayerIn;
        
        [self getCurrentPlayIndex];
        
        [self setBaseCondition];
        
        [self createHeadImage];
        
        [self createProgressView];
        
        [self createOtherButton];
        
        [self createOtherLabel];
        
        [self getPlayQueueData];
        
        [self setupTimer];
    }
    return self;
}
+(PlayBar *)defultPlayer
{
    return instence;
}

#pragma mark - initalize Methods
-(void) setAudioPlayer:(STKAudioPlayer*)value
{
	if (audioPlayer)
	{
		audioPlayer.delegate = nil;
	}
    
	audioPlayer = value;
	audioPlayer.delegate = self;
}
-(void)getPlayQueueData
{
    if (_queueSongArray.count != 0) {
        [_queueSongArray removeAllObjects];
    }
    NSArray *array = [[FMDBManager defaultManager] getPlayRecordList];
    self.queueSongArray = [NSMutableArray arrayWithArray:array];
    [self updateQueueDataLocalized:NO];
    
    if (_queueSongArray.count != 0) {
        [self setPlayerData:currentIndex];
    }
}
-(void)getCurrentPlayIndex
{
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"history_play_index" ofType:@"plist"]];
    currentIndex = [[dict objectForKey:@"index"] intValue];
}
-(void)setBaseCondition
{
    _headAlpha = 1.0;
    self.backgroundColor = [UIColor colorWithWhite:.3f alpha:1];
    self.listenerArray = [NSMutableArray array];
    self.queueSongArray = [NSMutableArray array];
    sendToBack = NO;
}
-(void)createHeadImage
{
    self.headImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _headImage.frame = CGRectMake(10, 30-8, self.bounds.size.height - 30, self.bounds.size.height - 30);
    [_headImage addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headImage setBackgroundImage:[UIImage imageNamed:@"players_img_default"] forState:UIControlStateNormal];
    _headImage.tag = headBtnTag;
    [self addSubview:_headImage];
    
    _headImage.backgroundColor = [UIColor clearColor];
}
-(void)createProgressView
{
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(40,0, kMainScreenWidth-16 - 80, 10)];
    _slider.continuous = YES;
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    _slider.minimumValue = 0;
    _slider.maximumValue = 1;
    _slider.value = .5f;
    [_slider setMinimumTrackImage:[UIImage imageNamed:@"progress_bar_play"] forState:UIControlStateNormal]; ;
    [_slider setMaximumTrackImage:[UIImage imageNamed:@"progress_bar"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"playBar_slider_thum"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"playBar_slider_thum"] forState:UIControlStateHighlighted];
    
    [self addSubview:_slider];
}
-(void)createOtherLabel
{
    self.frameTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 16 - 40, 0, 40, 15)];
    _frameTimeLabel.backgroundColor = [UIColor clearColor];
    _frameTimeLabel.textColor = [UIColor whiteColor];
    _frameTimeLabel.font = [UIFont systemFontOfSize:15];
    _frameTimeLabel.text = @"00:00";
    [self addSubview:_frameTimeLabel];
    
    self.playTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
    _playTimeLabel.backgroundColor = [UIColor clearColor];
    _playTimeLabel.textColor = [UIColor whiteColor];
    _playTimeLabel.font = [UIFont systemFontOfSize:15];
    _playTimeLabel.text = @"00:00";
    [self addSubview:_playTimeLabel];
    
}
-(void)createOtherButton
{
    UIButton * menu = [UIButton buttonWithType:UIButtonTypeCustom];
    menu.frame = CGRectMake(0, 0, 30, 30);
    menu.center = CGPointMake(_headImage.frame.origin.x + _headImage.frame.size.width + 30, _headImage.center.y);
    [menu addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    menu.tag = menuBtnTag;
    [menu setBackgroundImage:[UIImage imageNamed:@"playlists_btn"] forState:UIControlStateNormal];
    [menu setBackgroundImage:[UIImage imageNamed:@"playlists_btn_h"] forState:UIControlStateSelected];
    [self addSubview:menu];
    
    
    UIButton * proiv = [UIButton buttonWithType:UIButtonTypeCustom];
    proiv.frame = CGRectMake(0, 0, 30, 30);
    proiv.center = CGPointMake(menu.frame.origin.x + menu.frame.size.width + 30, menu.center.y);
    [proiv addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    proiv.tag = proivBtnTag;
    [proiv setBackgroundImage:[UIImage imageNamed:@"previous_btn"] forState:UIControlStateNormal];
    [proiv setBackgroundImage:[UIImage imageNamed:@"previous_btn_h"] forState:UIControlStateSelected];
    [self addSubview:proiv];
    
    
    UIButton * play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(0, 0, 30, 30);
    play.center = CGPointMake(proiv.frame.origin.x + proiv.frame.size.width + 30, proiv.center.y);
    [play addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    play.tag = playBtnTag;
    [play setBackgroundImage:[UIImage imageNamed:@"all_play"] forState:UIControlStateNormal];
    [play setBackgroundImage:[UIImage imageNamed:@"all_play_h"] forState:UIControlStateSelected];
    [self addSubview:play];
    [self changePlaybtnImage];
    
    
    UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.frame = CGRectMake(0, 0, 30, 30);
    next.center = CGPointMake(play.frame.origin.x + play.frame.size.width + 30, play.center.y);
    [next addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    next.tag = nextBtnTag;
    [next setBackgroundImage:[UIImage imageNamed:@"next_btn"] forState:UIControlStateNormal];
    [next setBackgroundImage:[UIImage imageNamed:@"next_btn_h"] forState:UIControlStateSelected];
    [self addSubview:next];
    
    
    UIButton * more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.frame = CGRectMake(0, 0, 30, 30);
    more.center = CGPointMake(next.frame.origin.x + next.frame.size.width + 30, play.center.y);
    [more addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    more.tag = moreBtnTag;
    [more setBackgroundImage:[UIImage imageNamed:@"player_menu_btn"] forState:UIControlStateNormal];
    [more setBackgroundImage:[UIImage imageNamed:@"player_menu_btn_h"] forState:UIControlStateSelected];
    [self addSubview:more];
    
    
    UIButton * hidde = [UIButton buttonWithType:UIButtonTypeCustom];
    hidde.frame = CGRectMake(0, 0, 16, self.bounds.size.height);
    hidde.center = CGPointMake(kMainScreenWidth - 8, self.bounds.size.height/2.0f);
    [hidde addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    hidde.tag = hiddeBtnTag;
    [hidde setBackgroundImage:[UIImage imageNamed:@"players_hide_btn"] forState:UIControlStateNormal];
    [hidde setBackgroundImage:[UIImage imageNamed:@"players_hide_btn_h"] forState:UIControlStateNormal];
    [self addSubview:hidde];
}

#pragma mark - listener methods
-(void)addListener:(id<PlayControlDelegate>)listener
{
    if (_listenerArray.count>0) {
        BOOL flag = NO;
        for (id <PlayControlDelegate> d in _listenerArray) {
            if ([d isEqual:listener]) {
                flag = YES;
                break;
            }
        }
        if (flag == NO) {
            [_listenerArray addObject:listener];
        }
    }else{
        [_listenerArray addObject:listener];
    }
    LOG_GENERAL_INFO(@"成功添加监听者 %@",listener);
}

#pragma mark - opration methods

-(void)sliderChanged
{
    if (!audioPlayer)
	{
		return;
	}
	
	[audioPlayer seekToTime:_slider.value];
}
-(void) setupTimer
{
	timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(tick) userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void) tick
{
	if (!audioPlayer)
	{
		_slider.value = 0;
		
		return;
	}
	
    if (audioPlayer.duration != 0)
    {
        _slider.minimumValue = 0;
        _slider.maximumValue = audioPlayer.duration;
        _slider.value = audioPlayer.progress;
        _playTimeLabel.text = [self formatTimeFromSeconds:audioPlayer.progress];
        _frameTimeLabel.text = [self formatTimeFromSeconds:audioPlayer.duration];
        [self broadPlayerProgressTime];
    }
    else
    {
        _slider.value = 0;
        _slider.minimumValue = 0;
        _slider.maximumValue = 0;
    }
    static int os = 1;
    _headAlpha -= os * 0.003;
    
    if (_headAlpha<0.400) {
        os = -1;
    }
    if (_headAlpha>1.0) {
        os = 1;
    }
    _headImage.alpha = _headAlpha;
}
-(void)broadPlayerProgressTime
{
    for (id<PlayControlDelegate> listener in _listenerArray) {
        
        if ([listener respondsToSelector:@selector(refreshPlayTime:)]) {
            [listener refreshPlayTime:audioPlayer.progress];
        }
    }
}
-(void)ButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case headBtnTag:{
            if (_queueSongArray.count>0) {
                [self.delegate PlayBarHeadImagePressed:_queueSongArray[currentIndex]];
            }else{
                [self.delegate PlayBarHeadImagePressed:nil];
            }
            break;
        }
        case menuBtnTag:
            [self.delegate PlayBarMenuButtonPressed:_queueSongArray];                       break;
        
        case playBtnTag:
        {
            [self changePlaybtnImage];
            [self resumeOrPause];
        }break;
        
        case proivBtnTag:
            [self playPrevMusic];                                                           break;
        
        case nextBtnTag:
            [self playNextMusic];                                                           break;
        
        case moreBtnTag:
            [self.delegate playBarMoreButtonPressed];                                       break;
        
        case hiddeBtnTag:
        {
            [self.delegate PlayBarHiddeButtonPressed:^(BOOL hidden) {
                UIButton * button = (UIButton *)[self viewWithTag:hiddeBtnTag];
                if (hidden) {
                    [button setBackgroundImage:[UIImage imageNamed:@"players_show_btn"] forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"players_show_btn_h"] forState:UIControlStateSelected];
                }else{
                    [button setBackgroundImage:[UIImage imageNamed:@"players_hide_btn"] forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"players_hide_btn_h"] forState:UIControlStateSelected];
                }
            }];
        }                                      break;
        
        default:
            break;
    }
}
-(void)changePlaybtnImage
{
    UIButton * sender = (UIButton *)[self viewWithTag:playBtnTag];
    
    if (audioPlayer.state == STKAudioPlayerStatePaused) {
        [sender setBackgroundImage:[UIImage imageNamed:@"all_play"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"all_play_h"] forState:UIControlStateSelected];
    }else{
        
        [sender setBackgroundImage:[UIImage imageNamed:@"all_stop"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"all_stop_h"] forState:UIControlStateSelected];
    }
}
-(void)changeHeadImage
{
    UIImageView * image = [[UIImageView alloc]initWithFrame:_headImage.bounds];
    if (_queueSongArray.count >0) {
        SongObject * obj = _queueSongArray[currentIndex];
        [image setImageWithURL:[NSURL URLWithString:obj.avatarImageUrl] placeholderImage:[UIImage imageNamed:@"players_img_default"]];
    }else{
        image.image = [UIImage imageNamed:@"players_img_default"];
    }
    [_headImage addSubview:image];
}
#pragma mark - player control methods－－－－－－－－－－－－－－

-(void)playPrevMusic
{
    autoPlay = NO;
    currentIndex = currentIndex + (int)_queueSongArray.count - 1;
    currentIndex %= (int)_queueSongArray.count;
    [audioPlayer clearQueue];
    [self setPlayerData:currentIndex];
}
-(void)resumeOrPause
{
	if (!audioPlayer)
	{
		return;
	}
	if (audioPlayer.state == STKAudioPlayerStatePaused)
	{
		[audioPlayer resume];
	}
	else
	{
		[audioPlayer pause];
	}
}
-(void)playNextMusic
{
    autoPlay = NO;
    currentIndex ++;
    currentIndex %= (int)_queueSongArray.count;
    [audioPlayer clearQueue];
    [self setPlayerData:currentIndex];
}


#pragma mark - 辅助方法

-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
#pragma mark - setUpMethods
-(int)checkQueueEncomPassingAsong:(SongObject *)song
{
    for (int i=0; i<_queueSongArray.count;i++) {
        
        if ([[_queueSongArray[i] description] isEqualToString:[song description]]) {
            return i;
        }
    }
    return -1;
}
-(void)Play:(id )obj
{
    if (obj) {
        autoPlay = NO;
        int flag = [self checkQueueEncomPassingAsong:obj];
        
        if ( flag == -1) {
            [audioPlayer clearQueue];
            currentIndex = (int)_queueSongArray.count;
            [self queue:obj];
            
            for (id<PlayControlDelegate> listener in _listenerArray) {
                if ([listener respondsToSelector:@selector(changeCurrentPlayingSong:)]) {
                    [listener changeCurrentPlayingSong:_queueSongArray[currentIndex]];
                }
            }
        }else{
            currentIndex = flag;
        }
        [self changeHeadImage];
        [self setPlayerData:currentIndex];
    }
}
-(void)queue:(SongObject *)obj
{
    autoPlay = NO;
    [_queueSongArray addObject:obj];
    [self updateQueueDataLocalized:YES];
}
-(void)clearQueue
{
    [audioPlayer clearQueue];
   
    [[FMDBManager defaultManager] deleteAllPlayRecord];
    [self getPlayQueueData];
}
-(SongObject *)getCurrentPlayingSong
{
    if (_queueSongArray.count >0) {
        return _queueSongArray[currentIndex];
    }
    return nil;
}
-(NSArray *)getPlayerQueueData
{
    return _queueSongArray;
}
-(void)delelteQueueWithItem:(SongObject *)obj
{
    for (int i=0;i<_queueSongArray.count;i++) {
        
        if ([[_queueSongArray[i] description] isEqualToString:[obj description]]) {
            
            [[FMDBManager defaultManager] deletePlayRecordSongBySongUrl:((SongObject *)_queueSongArray[i]).songUrl];
            [_queueSongArray removeObjectAtIndex:i];
            autoPlay = NO;
            if (_queueSongArray.count == 0) {
                
                [audioPlayer stop];
                
            }else {
                
                if (i == currentIndex) {
                    currentIndex --;
                    [self playNextMusic];
                }
            }
            
            break;
        }
    }
    [self getPlayQueueData];

}
- (void)collectCurrentSong:(void (^)(BOOL))callBack
{
    
    SongObject * song = [self getCurrentPlayingSong];
    AccountManager * aManager = [AccountManager shareInstance];
    
    [[FMDBManager defaultManager] addCollectSong:song userID:aManager.currentAccount.phone callBack:callBack];
    
}
-(void)updateQueueDataLocalized:(BOOL)localize
{
    if (localize) {
        SongObject * obj =[_queueSongArray lastObject];
        [[FMDBManager defaultManager] addPlayRecordSong:obj];
    }
    for (id <PlayControlDelegate> listener in _listenerArray) {
        if ([listener respondsToSelector:@selector(playQueueChanged:)]) {
             [listener playQueueChanged:_queueSongArray];
        }
    }
    [self changeHeadImage];
    
}
-(void)setPlayerData:(int)index
{
    SongObject * obj = (SongObject *)_queueSongArray[index];
    if (!([obj.songLocalPath isKindOfClass:[NSNull class]]||obj.songLocalPath == nil || [@"" isEqualToString:obj.songLocalPath])) {
        NSURL* url = [NSURL fileURLWithPath:obj.songLocalPath];
        
        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
        
        [audioPlayer setDataSource:dataSource withQueueItemId:[[QueueItemId alloc] initWithUrl:url andCount:index]];
    }else if (!([obj.songUrl isKindOfClass:[NSNull class]]||obj.songUrl == nil || [@"" isEqualToString:obj.songUrl])) {
        NSURL* url = [NSURL URLWithString:obj.songUrl];
        
        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
        
        [audioPlayer setDataSource:dataSource withQueueItemId:[[QueueItemId alloc] initWithUrl:url andCount:index]];
    }
}

#pragma mark - STKAudioPlayerDelegate methods
-(void) audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    [self.delegate showBufferingHud:(state == STKAudioPlayerStateBuffering)];
    [self changePlaybtnImage];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
	
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    [self changeHeadImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didStartPlaying" object:_queueSongArray[currentIndex]];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    autoPlay = YES;
    [self changePlaybtnImage];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    [self changePlaybtnImage];
    QueueItemId* queueId = (QueueItemId*)queueItemId;
    if (autoPlay) {
        currentIndex = queueId.count + 1;
        if (currentIndex == _queueSongArray.count) { //循环播放
            currentIndex = 0;
        }
        [self setPlayerData:currentIndex];
    }
    if (_queueSongArray.count>0) {
        for (id<PlayControlDelegate> listener in _listenerArray) {
            if ([listener respondsToSelector:@selector(changeCurrentPlayingSong:)]) {
                [listener changeCurrentPlayingSong:_queueSongArray[currentIndex]];
            }
        }
    }
}

-(void) audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line
{
    LOG_GENERAL_ERROR(@"%@", line);
}
@end
