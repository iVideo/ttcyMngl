//
//  SongInfoListCell.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SongObject;

@interface SongInfoListCell : UITableViewCell

@property (nonatomic,strong)UIColor * fontColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  andRowheight:(NSInteger)rowHeight;

-(void)setUpCellWithSOngObject:(SongObject *)song;

@end
