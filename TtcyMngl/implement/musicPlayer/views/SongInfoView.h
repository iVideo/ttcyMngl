//
//  SongInfoView.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SongObject;

@interface SongInfoView : UIView

- (id)initWithFrame:(CGRect)frame Song:(SongObject *)song;

-(void)refreshData:(SongObject *)song;

@end
