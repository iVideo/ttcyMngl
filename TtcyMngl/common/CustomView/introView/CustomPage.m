//
//  CustomPage.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "CustomPage.h"

@interface CustomPage ()

@property (nonatomic,strong,setter = setImage:)NSString * image;
@property (nonatomic,strong,setter = setTitle:)NSString * title;
@property (nonatomic,strong,setter = setDetail:)NSString * detail;

@end

@implementation CustomPage

-(id)initWithImage:(NSString *)image title:(NSString *)title detail:(NSString *)detail
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.image = image;
        self.title = title;
        self.detail = detail;
    
    }
    return self;
}
-(void)setImage:(NSString *)image
{
    _image = image;
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_image]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tag = 1;
    [self addSubview:imageView];
    CGFloat top = 20;
    
    if (is4Inch) {
        top+=30;
    }
    
    NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[imageView(==355)]|",top] options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)];
    
    [self addConstraints:array];
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:20.0];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    titleLabel.tag = 2;
    titleLabel.text = _title;
    
    [self addSubview:titleLabel];
    
    UIImageView * image = (UIImageView *)[self viewWithTag:1];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:image attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
}
-(void)setDetail:(NSString *)detail
{
    _detail = detail;
    UILabel * detailLabel = [[UILabel alloc]init];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0];
    detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    detailLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;

    detailLabel.text = detail;
    [self addSubview:detailLabel];
    
    UIImageView * image = (UIImageView *)[self viewWithTag:1];
    UILabel * title = (UILabel *)[self viewWithTag:2];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:detailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:image attribute:NSLayoutAttributeTop multiplier:1 constant:30]];
    if ([@"" isEqualToString:title.text]||!title.text) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[image(==200)]-20-[detailLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(image,detailLabel)]];
    }else{
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[image(==200)]-10-[title(35)]-5-[detailLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(image,title,detailLabel)]];
    }
    
}
@end
