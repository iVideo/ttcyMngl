//
//  SongInfoView.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SongInfoView.h"
#import "SongObject.h"
#import <UIImageView+WebCache.h>

@interface SongInfoView ()

@property (nonatomic,weak)SongObject * currentSong;

@property (nonatomic,strong)UIView * imageBG;
@property (nonatomic,strong)UIImageView * artImage;
@property (nonatomic,strong)UILabel * artLabel;
@property (nonatomic,strong)UILabel * songLabel;
@property (nonatomic,strong)UILabel * albumLabel;

@end

@implementation SongInfoView

- (id)initWithFrame:(CGRect)frame Song:(SongObject *)song
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.currentSong = song;
        
        [self setBaseCondition];
        
        [self createArtistsImage];
        
        [self createArtNameLabel];
        
        [self createSongNameLabel];

        [self createAlbumLabel];

        [self updateSubViews];
        
    }
    return self;
}

#pragma mark - 初始化子视图方法

-(void)setBaseCondition
{
    self.backgroundColor = [UIColor clearColor];
}
-(void)createArtistsImage
{
    self.imageBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.height/5.0f, self.bounds.size.height/5.0f)];
    
    _imageBG.center = CGPointMake(self.bounds.size.width*2/3.0f, self.bounds.size.height/6.0f);
    _imageBG.backgroundColor = [UIColor colorWithWhite:.0 alpha:.5f];
    [_imageBG setTranslatesAutoresizingMaskIntoConstraints:NO];
    _imageBG.layer.cornerRadius = _imageBG.frame.size.width/8.0f;
    _imageBG.layer.masksToBounds = YES;
    [self addSubview:_imageBG];
    
    self.artImage = [[UIImageView alloc]init];
    [_artImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_artImage setImage:[UIImage imageNamed:@"players_img_default"]];
    
    [_imageBG addSubview:_artImage];
    
    [_imageBG addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_artImage]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_artImage)]];
    [_imageBG addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_artImage]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_artImage)]];
    _artImage.layer.cornerRadius = 8;
    _artImage.layer.masksToBounds = YES;
}
-(void)createArtNameLabel
{
    self.artLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.height*2/4.0f,self.bounds.size.height/8.0-5)];
    _artLabel.backgroundColor = [UIColor clearColor];
    _artLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
    
    _artLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    _artLabel.center = CGPointMake(_imageBG.frame.origin.x + _artLabel.frame.size.width/2.0f, _imageBG.frame.origin.y + _imageBG.frame.size.height + 20 + _artLabel.frame.size.height/2.0f);
    [self addSubview:_artLabel];
}
-(void)createAlbumLabel
{
    CGFloat width = _artLabel.frame.size.height;
    CGFloat height = _artLabel.frame.size.width;
    
    self.albumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width,height)];
    _albumLabel.backgroundColor = [UIColor clearColor];
    _albumLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
    
    _albumLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _albumLabel.center = CGPointMake(_imageBG.frame.origin.x + _imageBG.frame.size.width - _albumLabel.frame.size.width/2.0f, _artLabel.center.y);
    [self addSubview:_albumLabel];
}
-(void)createSongNameLabel
{
    CGFloat width = self.bounds.size.height*3/4.0f;
    CGFloat height = _artLabel.frame.size.width;
    
    self.songLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width,height)];
    _songLabel.backgroundColor = [UIColor clearColor];
    _songLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:25.0f];
    _songLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _songLabel.center = CGPointMake(self.bounds.size.width/4.0f, _imageBG.frame.origin.y + _songLabel.frame.size.height/2.0f);
    [self addSubview:_songLabel];
}
#pragma mark - 设置内容方法
-(void)refreshData:(SongObject *)song
{
    self.currentSong = song;
    [self updateSubViews];
}
-(void)updateSubViews
{
    if (!([_currentSong.imageUrl isKindOfClass:[NSNull class]]||_currentSong.imageUrl == nil ||[@"" isEqualToString:_currentSong.imageUrl])) {
        [_artImage setImageWithURL:[NSURL URLWithString:_currentSong.imageUrl] placeholderImage:[UIImage imageNamed:@"players_img_default"]];
    }else if (!([_currentSong.avatarImageUrl isKindOfClass:[NSNull class]]||_currentSong.avatarImageUrl == nil||[@"" isEqualToString:_currentSong.avatarImageUrl])) {
        [_artImage setImageWithURL:[NSURL URLWithString:_currentSong.avatarImageUrl] placeholderImage:[UIImage imageNamed:@"players_img_default"]];
    }
    
    _artLabel.text = [@": " stringByAppendingString:_currentSong.artist];
    _songLabel.text = _currentSong.songName;
    _albumLabel.text = [@": " stringByAppendingString:_currentSong.albumTitle];
}

@end







