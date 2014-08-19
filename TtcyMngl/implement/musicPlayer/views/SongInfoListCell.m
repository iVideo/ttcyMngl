//
//  SongInfoListCell.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SongInfoListCell.h"
#import "SongObject.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>

@interface SongInfoListCell ()
{
    NSInteger _height;
}
@property (nonatomic,strong)UIImageView * headImage;

@property (nonatomic,strong)UILabel * artistsLabel;

@property (nonatomic,strong)UILabel * songLabel;

@property (nonatomic,strong)SDWebImageManager * webManager;

@end

@implementation SongInfoListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  andRowheight:(NSInteger)rowHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _height = rowHeight;
        
        [self setBaseCondition];
        
        [self createHeadImage];
        
        [self createSongNameLabel];
        
        [self createArtistsLabel];
        
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
    UIImageView * v = [[UIImageView alloc]init];
    v.image = [Utils createImageWithColor:[Utils colorWithHexString:@"#66cc99"]];
    self.selectedBackgroundView = v;
    
    self.backgroundColor = [UIColor clearColor];
    self.transform = CGAffineTransformMakeRotation(M_PI);
}
#pragma mark - initlizetion methods
-(void)createHeadImage
{
    self.headImage = [[UIImageView alloc]init];  //WithFrame:CGRectMake(0, 10, _height-20, _height-20)
    _headImage.backgroundColor = [UIColor clearColor];
    _headImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [_headImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    _headImage.layer.cornerRadius = 5.0;
    _headImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_headImage]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImage)]];
}
-(void)createSongNameLabel
{
    self.songLabel = [[UILabel alloc]init];
    _songLabel.backgroundColor = [UIColor clearColor];
    _songLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
    _songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:_songLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_headImage(60)]-15-[_songLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImage,_songLabel)]];
}
-(void)createArtistsLabel
{
    self.artistsLabel = [[UILabel alloc]init];
    _artistsLabel.backgroundColor = [UIColor clearColor];
    _artistsLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    _artistsLabel.text = @": ";
    [_artistsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addSubview:_artistsLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_headImage]-15-[_artistsLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImage,_artistsLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_songLabel]-5-[_artistsLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_songLabel,_artistsLabel)]];
}

-(void)createSeparatorLine
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenHeight, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.8f alpha:1];
    [self.contentView addSubview:line];
}
#pragma mark - setUp methods

-(void)setUpCellWithSOngObject:(SongObject *)song
{
    
    if (!([song.avatarImageUrl isKindOfClass:[NSNull class]]||song.avatarImageUrl == nil)) {
        [_headImage setImageWithURL:[NSURL URLWithString:song.avatarImageUrl]  placeholderImage:[UIImage imageNamed:@"players_img_default"]];
        
        _headImage.center = CGPointMake(_headImage.bounds.size.width/2.0f, _height/2.0f);
        
        _artistsLabel.text = [_artistsLabel.text stringByAppendingString:song.artist];
        _artistsLabel.textColor = _fontColor;
        
        _songLabel.text = song.songName;
        _songLabel.textColor = _fontColor;
    }

}
@end
