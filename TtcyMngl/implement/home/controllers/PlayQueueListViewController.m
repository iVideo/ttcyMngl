//
//  PlayQueueListViewController.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-20.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "PlayQueueListViewController.h"

#import "SongInfoListCell.h"
#import "SongObject.h"

#import "MusicPlayerViewController.h"

#import "PlayBar.h"

@interface PlayQueueListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger playingSongIndex;
}
@property (nonatomic,strong)NSMutableArray * listData;

@property (nonatomic,strong)UITableView * dataTabel;

@end

@implementation PlayQueueListViewController

- (id)initWithListArray:(NSArray *)listArray 
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.listData = [NSMutableArray array];
        self.listData = [NSMutableArray arrayWithArray:listArray];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CENT_COLOR;
    getTopDistance();
    getPlayBarHeight();
    [self createTable];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeCurrentPlayingSong:[[PlayBar defultPlayer] getCurrentPlayingSong]];
}
-(void)createTable
{
    self.dataTabel = [[UITableView alloc]init];
    _dataTabel.backgroundColor = [UIColor clearColor];
    _dataTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataTabel.rowHeight = 80;
    _dataTabel.delegate = self;
    _dataTabel.dataSource = self;
    _dataTabel.showsVerticalScrollIndicator = NO;
    _dataTabel.transform = CGAffineTransformMakeRotation(-M_PI_2);

    [_dataTabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_dataTabel];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_dataTabel]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_dataTabel)]];
    CGFloat top = 0;
    if (isIOS7) {
        top += 44;
    }
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_dataTabel(%f)]", kMainScreenHeight - PlayBarHeight - 44] options:0 metrics:0 views:NSDictionaryOfVariableBindings(_dataTabel)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_dataTabel attribute:NSLayoutAttributeBottom multiplier:1 constant:PlayBarHeight]];
    
}
-(void)updatesubviews
{
    [_dataTabel reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SongInfoListCell * cell = (SongInfoListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SongInfoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andRowheight:tableView.rowHeight];
    }
    if (_listData.count == 0||_listData == nil) {
        
    }else{
        if (indexPath.row == playingSongIndex) {
            cell.fontColor = [Utils colorWithHexString:@"#362875"];
        } else {
            cell.fontColor = [Utils colorWithHexString:@"#762836"];
        }
        [cell setUpCellWithSOngObject:_listData[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[PlayBar defultPlayer]Play:_listData[indexPath.row]];
}
#pragma mark - PlayControlDelegate methods
-(void)changeCurrentPlayingSong:(SongObject *)song
{
    for (int i = 0;i<_listData.count;i++) {
        
        if ([[song description] isEqualToString:[_listData[i] description]]) {
            [self updateLrcTableView:i];
            break;
        }
    }
}
-(void)playQueueChanged:(NSArray *)songArray
{
    [_listData removeAllObjects];
    _listData = [NSMutableArray arrayWithArray:songArray];
    [self updatesubviews];
}

- (void)updateLrcTableView:(NSUInteger)lineNumber {
    
    playingSongIndex = lineNumber;
    
    if (playingSongIndex>=1) {
        [UIView animateWithDuration:0.3f animations:^{
            _dataTabel.contentOffset = CGPointMake(0, (playingSongIndex-1)*_dataTabel.rowHeight);
        }];
    }else{
        _dataTabel.contentOffset = CGPointMake(0, 0);
    }
    [_dataTabel reloadData];
}
@end
