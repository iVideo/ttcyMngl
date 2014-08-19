//
//  BaseViewController.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "BaseViewController.h"
#import <UIImageView+WebCache.h>
#import "SongInfoListCell.h"

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

-(void)createBaseTableView
{
    self.baseTableView = [[UITableView alloc]init];
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.rowHeight = 80;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    [_baseTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_baseTableView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_baseTableView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_baseTableView)]];
    CGFloat top = 0;
    if (isIOS7) {
        top += 44;
    }
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_baseTableView(%f)]", kMainScreenHeight - PlayBarHeight - 44] options:0 metrics:0 views:NSDictionaryOfVariableBindings(_baseTableView)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_baseTableView attribute:NSLayoutAttributeBottom multiplier:1 constant:PlayBarHeight]];
    
}
#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayWithSongObject.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SongInfoListCell * cell = (SongInfoListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SongInfoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andRowheight:tableView.rowHeight];
    }
    if (_arrayWithSongObject.count == 0||_arrayWithSongObject == nil) {
        
    }else{
        
        [cell setUpCellWithSOngObject:_arrayWithSongObject[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[PlayBar defultPlayer]Play:_arrayWithSongObject[indexPath.row]];
    SongInfoListCell * cell = (SongInfoListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
