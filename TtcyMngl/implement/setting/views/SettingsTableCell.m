//
//  SettingsTableCell.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-26.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SettingsTableCell.h"

@interface SettingsTableCell ()
{
    CGFloat _height;
}
@property (nonatomic,strong)UIImageView * Image;

@property (nonatomic,strong)UILabel * titleLabel;

@property (nonatomic,strong)UILabel * detailLabel;

@end

@implementation SettingsTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  andRowheight:(CGFloat)rowHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _height = rowHeight;
        
        [self setBaseCondition];
        
        [self createImageView];
        
        [self createTitleLabel];
        
        [self createDetailLabel];
        
        [self createSeparatorLine];
    }
    return self;
}
-(void)setBaseCondition
{
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UILabel class]]|[obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView * v = [[UIImageView alloc]init];
    v.image = [Utils createImageWithColor:[Utils colorWithHexString:@"#66cc99"]];
    self.selectedBackgroundView = v;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.transform = CGAffineTransformMakeRotation(M_PI);
}
#pragma mark - initlizetion methods
-(void)createImageView
{
    self.Image = [[UIImageView alloc]initWithFrame:CGRectMake(10, _height/6.0f, _height*2/3.0f, _height*2/3.0f)];
    _Image.backgroundColor = [UIColor clearColor];
    _Image.layer.cornerRadius = 8;
    _Image.layer.masksToBounds = YES;
    [self.contentView addSubview:_Image];
    
    _Image.transform = CGAffineTransformMakeRotation(-M_PI_2);

}
-(void)createTitleLabel
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_height, _height/4.0f, kMainScreenHeight - 2 * _height-TopBarHeight-10,_height/2.0f)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:20.0f];
    
    _titleLabel.textColor = [Utils colorWithHexString:@"#000000"];
    [self.contentView addSubview:_titleLabel];
    
}
-(void)createDetailLabel
{
    self.detailLabel = [[UILabel alloc]init];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    _detailLabel.textColor = [UIColor whiteColor];
    [_detailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_detailLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_detailLabel(70)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_detailLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_detailLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_detailLabel)]];
}
-(void)createSeparatorLine
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenHeight, .3f)];
    line.backgroundColor = [UIColor colorWithWhite:1 alpha:.5f];
    [self.contentView addSubview:line];
}
-(void)setUpCellDataWithImage:(NSString *)image title:(NSString *)title detail:(NSString *)detail
{
    self.Image.image = [UIImage imageNamed:image];
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
}

@end
