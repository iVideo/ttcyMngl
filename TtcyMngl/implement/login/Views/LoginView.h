//
//  LoginView.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfo.h"

@protocol LoginViewDelegate <NSObject>

@optional
- (void) login:(NSString*) user pwd:(NSString*) pwd savepwd:(BOOL) save;
- (void) deleteAccount:(NSString*) user;

-(void)registButtonPressed;
-(void)forgetButtonPressed;

@end

@interface LoginView : UIView

@property (nonatomic, strong, setter = setHead:) NSString* head;//头像
@property (nonatomic, strong, setter = setPhone:) NSString* phone;//用户名
@property (nonatomic, strong) NSString* pass;//密码

@property (nonatomic, setter = setremPwd:) BOOL rememberPwd;//记住密码

@property (nonatomic, strong) NSArray* moreAccount;
@property (nonatomic, strong, setter = setUsers:) AccountInfo* currentAccount;

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

//- (void) draw;

@end
