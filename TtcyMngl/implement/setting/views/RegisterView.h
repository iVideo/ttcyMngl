//
//  RegisterView.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-1.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol RegisterViewDelegate <NSObject>

@optional
- (void) regist:(NSString*) userName pwd:(NSString*) pwd;

@end

@interface RegisterView : UIView

@property (nonatomic, strong, setter = setUser:) NSString* user;//用户名
@property (nonatomic, strong) NSString* pwd;//密码
@property (nonatomic, weak) id<RegisterViewDelegate> delegate;

-(void)reset;

- (void) loading:(BOOL) isshow;

@end
