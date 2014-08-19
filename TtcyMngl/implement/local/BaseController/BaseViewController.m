//
//  BaseViewController.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "BaseViewController.h"
#import <UIImageView+WebCache.h>

@interface BaseViewController ()


@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.arrayWithSongObject = [[NSArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CENT_COLOR;
    [self createBaseTableView];
}

- (void)createBaseTableView
{
    _baseTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _baseTableView.frame = CGRectMake(0, 0, 320, kMainScreenHeight - PlayBarHeight);
    [self.view addSubview:_baseTableView];
}

# pragma mark  -  UITableViewDelegate  methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayWithSongObject.count > 0 && _arrayWithSongObject.count < 5) {
        //当cell少于一个屏幕的时候，tableView不可滑动
        tableView.bounces = NO;
        return self.arrayWithSongObject.count;
    }
    else if (_arrayWithSongObject.count > 4){
        
        return self.arrayWithSongObject.count + 1;
    }
    else{
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _arrayWithSongObject.count) {
        return 60 - 15;
    }
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addViewWithCell:cell];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];

        cell.selectedBackgroundView.backgroundColor = [Utils colorWithHexString:@"#66cc99"];//象牙黑,透明度0.8
    }
    if (indexPath.row == _arrayWithSongObject.count ) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    NSString* songName = ((SongObject *)[_arrayWithSongObject objectAtIndex:indexPath.row]).songName;
    NSString* artist = ((SongObject *)[_arrayWithSongObject objectAtIndex:indexPath.row]).artist;

    UIImageView* singerImageView = (UIImageView *)[cell viewWithTag:20];
    [singerImageView setImageWithURL:[NSURL URLWithString:((SongObject *)[_arrayWithSongObject objectAtIndex:indexPath.row]).avatarImageUrl] placeholderImage:[UIImage imageNamed:@"players_img_default"]];
    UILabel* singerLabel = (UILabel *)[cell viewWithTag:21];
    singerLabel.text = [NSString stringWithFormat:@": %@",artist];//歌手
    UILabel* songLabel = (UILabel *)[cell viewWithTag:22];
    songLabel.text = [NSString stringWithFormat:@"%@",songName];//歌曲名
    
    return cell;
}

- (void)addViewWithCell:(UITableViewCell *)cell
{
    UIImageView* singerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"players_img_default.png"]];//players_img_default
    singerImage.tag = 20;
    singerImage.transform = CGAffineTransformMakeRotation(M_PI_2);
    //顺时针旋转90°后更新singerImage的frame(因为TableView逆时针旋转了90°,所以零点在左下角,竖轴:X,横轴:Y)
    singerImage.frame = CGRectMake(kMainScreenHeight - 60, 5, 50, 50);
    [cell addSubview:singerImage];
    
    UILabel* singerLabel = [[UILabel alloc] init];
    singerLabel.transform = CGAffineTransformMakeRotation(M_PI);
    //顺时针旋转180°后更新singerLabel的frame(因为TableView逆时针旋转了90°,所以零点在左下角,竖轴:X,横轴:Y)
    singerLabel.frame =CGRectMake(0, 0, kMainScreenHeight - 64 - 10 , 30);
    singerLabel.tag = 21;
    singerLabel.text = @"歌手";
    singerLabel.textColor = [UIColor blackColor];
    [singerLabel setLineBreakMode:NSLineBreakByWordWrapping];//设置换行模式，默认值
    singerLabel.numberOfLines = 0;//按几行显示，（0：不限制行数）
    singerLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0f];
    singerLabel.backgroundColor = [UIColor clearColor];
    [cell addSubview:singerLabel];
    
    UILabel* songLabel = [[UILabel alloc] init];
    songLabel.transform = CGAffineTransformMakeRotation(M_PI);
    //旋转后更新songLabel的frame
    songLabel.frame = CGRectMake(0, 30, kMainScreenHeight - 64 - 10, 30);
    songLabel.tag = 22;
    songLabel.text = @"歌曲名";
    songLabel.textColor = [UIColor blackColor];
    songLabel.lineBreakMode = NSLineBreakByWordWrapping;//默认值
    songLabel.numberOfLines = 0;//按几行显示，（0：不限制行数）
    songLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0f];
    songLabel.backgroundColor = [UIColor clearColor];
    [cell addSubview:songLabel];
    
    //给 cell 添加自定义分隔线
    UIView *separateView = [[UIView alloc] init];
    separateView.frame = CGRectMake(7, 59, kMainScreenHeight - PlayBarHeight - 14, 1);
    separateView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:separateView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//当点击完 cell 后取消被选中状态
    SongObject *songObj = [[SongObject alloc] init];
    songObj = (SongObject *)[_arrayWithSongObject objectAtIndex:indexPath.row];
    PlayBar *playbar = [PlayBar defultPlayer];
    [playbar Play:songObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
