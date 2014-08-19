//
//  PlayControlDelegate.h
//  TtcyMngl
//
//  Created by admin on 14-6-13.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SongObject;

@protocol PlayControlDelegate <NSObject>

@optional

-(void)PlayBarHeadImagePressed:(SongObject *)aSong;
-(void)PlayBarMenuButtonPressed:(NSArray *)queueArray;
-(void)PlayBarHiddeButtonPressed:(void(^)(BOOL hidden))callBack;
-(void)playBarMoreButtonPressed;

-(void)playQueueChanged:(NSArray *)songArray;
-(void)showBufferingHud:(BOOL)isShow;

-(void)refreshPlayTime:(NSInteger)time;

-(void)changeCurrentPlayingSong:(SongObject *)song;

@end
