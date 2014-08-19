//
//  LocalMenuButon.m
//  TtcyMngl
//
//  Created by admin on 14-6-10.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "LocalMenuButon.h"

@interface LocalMenuButon()

@property (nonatomic,strong)UIImageView * icon;
@property (nonatomic,strong)UILabel * textLabel;
@property (nonatomic,strong)UILabel * infoLabel;

@end

@implementation LocalMenuButon

-(LocalMenuButon *)initWithTitle:(NSString *)title Icon:(NSString *)iconName Class:(NSString *)className item:(NSString *)itemName
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenWidth/2.0 - 1, kMainScreenWidth/2.0 - 1);
        [self setBackgroundImage:[Utils createImageWithColor:LVORYWHITE_COLOR_ALPHA09] forState:UIControlStateNormal];
        
        self.vcClass = className;
        [self createIconWithIconName:iconName];
        [self createTextLabel:title];
        [self createInfoLabel:itemName];
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
        [self setTransform:rotate];
    }
    return self;
}
-(void)createIconWithIconName:(NSString *)iconName
{
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    _icon.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
    _icon.frame = CGRectMake(0, 0, 30, 30);
    _icon.center = CGPointMake(self.bounds.size.width /4.0f-10, self.bounds.size.height/2.0f+30);//self.bounds.size.width = 159   self.bounds.size.height = 159
    [self addSubview:_icon];
}
-(void)createTextLabel:(NSString *)textString
{
    self.textLabel = [[UILabel alloc]init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = textString;
    _textLabel.numberOfLines = 0;
    UIFont *textfont = [UIFont fontWithName:@"Menksoft Qagan" size:20.0f];
    _textLabel.font = textfont;
    //限制 label 的宽度
    CGSize widthSize = CGSizeMake(self.frame.size.width/2.0f, 60);
    //label 的真实size
    CGSize actualSize = [textString sizeWithFont:textfont constrainedToSize:widthSize lineBreakMode:NSLineBreakByWordWrapping];//此方法要求font和lineBreakMode与之前设置的完全一致
    //label 自适应高度
    _textLabel.frame = CGRectMake(0, 0, actualSize.width, actualSize.height);
    _textLabel.center = CGPointMake(_icon.frame.origin.x + _icon.frame.size.width + 15 + _textLabel.frame.size.width/2.0f, _icon.center.y);
    [self addSubview:_textLabel];
}
-(void)createInfoLabel:(NSString *)infoString
{
    self.infoLabel = [[UILabel alloc]init];
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.text = infoString;
    _infoLabel.textColor = LVORYBLACK_COLOR_ALPHA06;//象牙黑，透明度0.6
    _infoLabel.numberOfLines = 0;
    UIFont *infoFont = [UIFont fontWithName:@"Menksoft Qagan" size:16.0f];
    _infoLabel.font = infoFont;
    //限制 label 的宽度
    CGSize width = CGSizeMake(self.frame.size.width - 20, 40);
    //label 的真实size
    CGSize actualSize = [infoString sizeWithFont:infoFont constrainedToSize:width lineBreakMode:NSLineBreakByWordWrapping];//此方法要求font和lineBreakMode与之前设置的完全一致
    //label 自适应高度
    _infoLabel.frame = CGRectMake(0, 0,actualSize.width , actualSize.height);
    _infoLabel.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f - 20);
    [self addSubview:_infoLabel];
}
/**
 * 通过点击的button的tag出发对应方法
 *
 * @TAG 从上往下：全部，收藏，下载，历史播放
 */
-(void)buttonAction:(LocalMenuButon *)sender
{
    [self.delegate menuItemPressed:sender];
}


@end
