//
//  OnlineCelebrityMusicViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineAlbumMusicViewController.h"
#import "CommonClass.h"
#import "AsynImageView.h"
#import "MusicCell.h"
#import "SongObject.h"
#import "PlayBar.h"
#import "OnlineCelebritView.h"
#import <UIImageView+WebCache.h>
#define navigationWhile 51
#define sideLabelColor whiteColor

#define celebrityCellHeight kMainScreenHeight-120-44
@interface OnlineAlbumMusicViewController (){

}

@end

@implementation OnlineAlbumMusicViewController

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
    [super viewDidLoad];
   [self initView];
    
    UIButton *celeMessage=[[UIButton alloc]initWithFrame:CGRectMake(navigationWhile+2, 0, kMainScreenWidth-navigationWhile-4, 86)];
    
    UIImageView * headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 86)];
    [headImageView setImageWithURL:[NSURL URLWithString:_album.photoURL] placeholderImage:[UIImage imageNamed:@"face.jpg"]];
    [celeMessage addSubview: headImageView];
    UILabel *label=[[UILabel alloc]init];
    label.text=_album.name;
    label.font=[CommonClass setTransformUIView:label uiFont:label.font];
    [label setBackgroundColor:[UIColor clearColor]];
    label.frame=CGRectMake(100, 0, 50, 86);
    [celeMessage addSubview: label];
    [self.mostlyView addSubview:celeMessage];
    self.navigationTitle=@"";
    self.Url=[NSString stringWithFormat:@"/iosSeve.ashx?type=%d&&id=%d",12,_album.number];
    [self OnlineviewDidLoad];
        self.modeName=@"SongObject";
    [self initialize];
    [self loadMore];
}
#pragma mark  数据源方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicCell *cell= [tableView dequeueReusableCellWithIdentifier:[MusicCell ID]];
    if (cell==nil) {
        cell=[MusicCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if (indexPath.row<_models.count) {
            SongObject *cel=_models[indexPath.row];
            [cell celebrityWithModel:cel];
        }
 
    return cell;
    
}


#pragma mark --代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SongObject *songObject=_models[indexPath.row];
    
    [[PlayBar defultPlayer]Play:songObject];
  
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
