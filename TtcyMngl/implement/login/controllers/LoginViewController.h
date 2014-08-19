//
//  LoginViewController.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountInfo;
@protocol LoginViewControllerDelegate <NSObject>

-(void)loginSuccessByAccount:(AccountInfo *)acc;

@end

@interface LoginViewController : UIViewController

@property (nonatomic) BOOL _isChangeAccount;

@property (nonatomic,weak) __weak id <LoginViewControllerDelegate>delegate;

SINGLETON_DEFINE(LoginViewController);

@end
