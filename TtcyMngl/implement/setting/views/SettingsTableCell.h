//
//  SettingsTableCell.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-26.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  andRowheight:(CGFloat)rowHeight;

-(void)setUpCellDataWithImage:(NSString *)image title:(NSString *)title detail:(NSString *)detail;

@end
