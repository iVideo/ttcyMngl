//
//  RegisterViewController.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-1.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountInfo;
@protocol RegisterViewControllerDelegate <NSObject>

- (void)registerSuccessByAccount:(AccountInfo *)acc;

@end

@interface RegisterViewController : UIViewController

SINGLETON_DEFINE(RegisterViewController)

@property (assign,nonatomic) id<RegisterViewControllerDelegate> registerDelegate;

@end
