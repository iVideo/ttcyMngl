//
//  OnlineCelebrityMusicViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineCelebrityMusicViewController.h"
#import "OnlineAlbumMusicViewController.h"
#import "OnlineCelebritView.h"
#import "CommonClass.h"
#import "AsynImageView.h"
#import "MusicCell.h"
#import "SongObject.h"
#import "PlayBar.h"
#import "Album.h"
#import <UIImageView+WebCache.h>

#define navigationWhile 51
#define sideLabelColor whiteColor

#define celebrityCellHeight kMainScreenHeight-120-44
@interface OnlineCelebrityMusicViewController ()
@end

@implementation OnlineCelebrityMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self initView];
 
    UIButton *celeMessage=[[UIButton alloc]initWithFrame:CGRectMake(navigationWhile+2, 0, kMainScreenWidth-navigationWhile-4, 86)];
    UIImageView * headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 86)];
    [headImageView setImageWithURL:[NSURL URLWithString:_celebrity.photoURL] placeholderImage:[UIImage imageNamed:@"face.jpg"]];
    
    [celeMessage addSubview: headImageView];
    UILabel *label=[[UILabel alloc]init];
    label.text=_celebrity.name;
    label.font=[CommonClass setTransformUIView:label uiFont:label.font];
    label.frame=CGRectMake(100, 0, 50, 86);
    [label setBackgroundColor:[UIColor clearColor]];
    [celeMessage addSubview: label];
    [self.mostlyView addSubview:celeMessage];
    NSArray *array=[[NSArray alloc]initWithObjects:@"",@"",nil];
    self.navigationArray=array;
    UIButton *uIButton=[[UIButton alloc]init];
    uIButton.tag=1;
    self.navigationTitle=@"";
    [self OnlineviewDidLoad];
    [self TypebtnClick:uIButton];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicCell *cell= [tableView dequeueReusableCellWithIdentifier:[MusicCell ID]];
    if (cell==nil) {
        cell=[MusicCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
    }

        if (_nonceType==1) {
            SongObject *cel=_models[indexPath.row];
            [cell celebrityWithModel:cel];
        }else{
        Album *alb=_models[indexPath.row];
        [cell albumWithModel:alb];
        }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      if (_nonceType==1) {
    SongObject *songObject=_models[indexPath.row];
    [[PlayBar defultPlayer]Play:songObject];
      }else{
      
          OnlineAlbumMusicViewController *onlineAlbumMusicViewController = [[OnlineAlbumMusicViewController alloc] init];
          onlineAlbumMusicViewController.album=_models[indexPath.row];
          [self.navigationController pushViewController:
           onlineAlbumMusicViewController animated:true];
      }
}

#pragma mark 歌曲分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    [self initialize];
    _nonceType=selButton.tag;
    
    int typeid=selButton.tag==1?3:10;
    self.navigationTitle=@"";
    self.Url= [NSString stringWithFormat:@"/iosSeve.ashx?type=%d&&id=%d",typeid,_celebrity.number];
    self.modeName=selButton.tag==1?@"SongObject":@"Album";
    [self loadMore];
}

@end
