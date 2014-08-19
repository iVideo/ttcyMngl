//
//  SettingMainViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SettingMainViewController.h"

#import "SettingsTableCell.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "AccountInfo.h"
#import "AccountManager.h"
#import "HUD.h"
#import <sys/stat.h>
#import <SDImageCache.h>
#import <ASIFormDataRequest.h>
#import <JSONKit.h>
#import "UserShareSDK.h"

#import "Constant.h"
#import "WXPayClient.h"

@interface SettingMainViewController ()<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate,HUDDelgate>
{
    NSString * newVersionURlString;
    ASIFormDataRequest * _versionRequest;
    BOOL clearCache;
}
@property (nonatomic,strong)UITableView * settingsTable;

@property (nonatomic,strong)NSArray * imageArray;

@property (nonatomic,strong)NSArray * titleArray;

@property (nonatomic,strong)NSArray * classArray;

@property (nonatomic,strong)AccountManager * manager;

@end

@implementation SettingMainViewController

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
    // Do any additional setup after loading the view.
    
    [self setBaseCondition];
    
    [self createSettingsTable];
}
-(void)setBaseCondition
{
    getTopDistance();
    getPlayBarHeight();
    
    self.view.backgroundColor = CENT_COLOR;
    self.manager = [AccountManager shareInstance];
    self.imageArray = @[@"moren_bg",@"top_cancel",@"set_icon_refresh",@"share",@"set_icon_about"];
    
    [self checkAccountStatus];
    clearCache = NO;
    self.classArray = @[@"",@"",@"",@"",@"",@""];
}
-(void)checkAccountStatus
{
    if (_manager.status == offLine) {
        self.titleArray = @[@" ",@"",@"",@"",@"  "];
    }else if (_manager.status == onLine){
        self.titleArray = @[_manager.currentAccount.phone,@"",@"",@"",@"  "];
    }
}
-(void)createSettingsTable
{
    self.settingsTable = [[UITableView alloc]init];
    _settingsTable.backgroundColor = [UIColor clearColor];
    _settingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _settingsTable.delegate = self;
    _settingsTable.dataSource = self;
    _settingsTable.showsVerticalScrollIndicator = NO;
    _settingsTable.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _settingsTable.frame = CGRectMake(0, TopBarHeight, kMainScreenWidth, kMainScreenHeight-TopBarHeight- PlayBarHeight);
    
    [self.view addSubview:_settingsTable];
    
}
#pragma mark - Cache opration methods -
- (long long) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    
    while (((fileName = [childFilesEnumerator nextObject]) != nil) && !([[fileName pathExtension] isEqualToString:@"sqlite"])){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeWithPath:fileAbsolutePath];
        
    }
    return folderSize;
}

- (long long)fileSizeWithPath:(NSString *)filePath{
   
    struct stat st;
    
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

- (NSString *)getCacheSize{
    
    double fileSize = [self getDefaultImageCacheSize] + [self getSDImageCacheSize] + [self getLrcCacheSize];
    
    float mbSize = 1024.0*1024.0f;
    
    if (fileSize>mbSize) {
        float f = fileSize/mbSize;
        return [NSString stringWithFormat:@"%0.01f MB",f];
    }else{
        return [NSString stringWithFormat:@"%0.01f KB",fileSize/1024.0f];
    }
}
-(double)getDefaultImageCacheSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    double fileSize = [self folderSizeAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ttcy.TtcyMngl/fsCachedData"]];
    return fileSize;
}
-(double)getSDImageCacheSize
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    double fileSize = [self folderSizeAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"]];
    return fileSize;
}
-(double)getLrcCacheSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    double fileSize = [self folderSizeAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ttcy.TtcyMngl/fsCachedData"]];
    return fileSize;
}
- (void)clearCache{
    
    [[SDImageCache sharedImageCache] clearDisk];
    [self clearImageCacheAtCachePathComponent:@"com.hackemist.SDWebImageCache.default"];
    [self clearImageCacheAtCachePathComponent:@"ttcy.TtcyMngl/fsCachedData"];
    [self.settingsTable reloadData];
}
- (void)clearImageCacheAtCachePathComponent:(NSString *)PathComponent
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:PathComponent];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    
    while ((filename = [e nextObject])) {
        
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
    }
}
- ( void)clearLrcCache
{
    NSString *extension = @"lrc";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    SettingsTableCell * cell = (SettingsTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        CGFloat height;
        if ((indexPath.section == 0) && (indexPath.row == 0)) {
            height = 80;
        }else{
            height = 60;
        }
        cell = [[SettingsTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andRowheight:height];
    }
    [self checkAccountStatus];
    NSString * detail = @"";
    if (indexPath.row == 1) {
        detail = [self getCacheSize];
    }
    [cell setUpCellDataWithImage:self.imageArray[indexPath.row] title:self.titleArray[indexPath.row] detail:detail];
    cell.selected = NO;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LoginViewController * LVC = [LoginViewController shareInstance];
        LVC.delegate = self;
        [self.navigationController pushViewController:LVC animated:YES];
    }
    if (indexPath.row == 1) {
        
        clearCache = YES;
        [HUD message:@"    " delegate:self Tag:100];
        
    }if (indexPath.row ==2) {
        clearCache = NO;
        [self checkUpdateWithAPPID:@"Q859987Y2V.com.ttcy.TengriTal"];
    }
    if (indexPath.row ==3) {
        UserShareSDK *userSDK = [[UserShareSDK alloc] init];
        [userSDK shareApp];
    }
    if (indexPath.row == 4) {
        AboutViewController * AVC = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:AVC animated:YES];
    }
    SettingsTableCell *cell = (SettingsTableCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        return 80;
    }
    return 60;
}

#pragma mark - 调用微信支付

- (void)payProduct
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddeHUD) name:HUDDismissNotification object:nil];
    
    [HUD messageForBuffering];
    [[WXPayClient shareInstance] payProduct];
}
- (void)hiddeHUD
{
    [HUD clearHudFromApplication];
}
#pragma mark - LoginViewControllerDelegate methods
-(void)loginSuccessByAccount:(AccountInfo *)acc
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    SettingsTableCell * cell = (SettingsTableCell *)[self tableView:_settingsTable cellForRowAtIndexPath:indexPath];
    [cell setUpCellDataWithImage:acc.userIcon title:acc.phone detail:@""];
}
#pragma mark - HUDDelgate methods
-(void)hud:(HUD *)hud clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (hud.tag == 100) {
        if (buttonIndex == 0) {
            [HUD clearHudFromApplication];
        }else{
            [HUD clearHudFromApplication];
            [self clearCache];
        }
    }else if(hud.tag == 101){
        
        if (buttonIndex == 0) {
            
            [HUD clearHudFromApplication];
            
        }else{
            
            [HUD clearHudFromApplication];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVersionURlString]];
            
        }
    }
    
}

#pragma mark - 检查更新
- (void)checkUpdateWithAPPID:(NSString *)APPID
{
    NSString *updateUrlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=TengrTal&entity=software"];
    updateUrlString = [updateUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *updateUrl = [NSURL URLWithString:updateUrlString];
    _versionRequest = [ASIFormDataRequest requestWithURL:updateUrl];
    
    [_versionRequest setRequestMethod:@"GET"];
    [_versionRequest setTimeOutSeconds:60];
    [_versionRequest addRequestHeader:@"Content-Type" value:@"application/json"];

    [_versionRequest setDelegate:self];
    [_versionRequest setDidFailSelector:@selector(versionRequestFailler:)];
    [_versionRequest setDidFinishSelector:@selector(versionRequestFinish:)];
    
    [HUD messageForBuffering];
    [_versionRequest startAsynchronous];
    
}

- (void)versionRequestFailler:(ASIHTTPRequest *)request
{
    [HUD message:@"     "];
}
- (void)versionRequestFinish:(ASIHTTPRequest *)request
{
    
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"appInfo = %@",appInfo);
    NSString *currentVersion = [appInfo objectForKey:@"CFBundleVersion"];
    
    NSDictionary *dict = [[request responseData] objectFromJSONData];
    
    NSArray *infoArray = [dict objectForKey:@"results"];
    
    if ([infoArray count]) {
        
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            
            newVersionURlString = [releaseInfo objectForKey:@"trackViewUrl"];
            NSLog(@"lastVersion = %@ currentVersion = %@ lastVersion trackViewUrl = %@",lastVersion,currentVersion,newVersionURlString);
            [HUD message:@"    " delegate:self Tag:101];
            
        }else{
            [HUD message:@"     "];
        }
    }else{
        [HUD message:@"     "];
    }
}
@end


