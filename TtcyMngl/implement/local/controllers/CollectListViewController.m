//
//  CollectListViewController.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "CollectListViewController.h"
#import "AccountManager.h"

@interface CollectListViewController ()

@end

@implementation CollectListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBarTitle = @" ";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    FMDBManager* manger = [FMDBManager defaultManager];
    NSArray* collectList = [[NSArray alloc] init];
    AccountManager *accountManger = [AccountManager shareInstance];
    if (accountManger.status == onLine) {
        NSString *phone = accountManger.currentAccount.phone;
        collectList = [manger getCollectSongListWithuserID:phone];
        self.arrayWithSongObject = collectList;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
