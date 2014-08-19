//
//  OnlineCelebritView.h
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CelebritTypeDelegate <NSObject>

-(void)TypebtnClick:(UIButton *)selButton;


@end
@interface OnlineCelebritView : UIView{
    int  _nonceType;

}

+(id)addCelebritTypesViewWhitFram:(CGRect)frame ViewTitle:(NSString *)viewTitle stringtypes:(NSArray *)array;

+(id)addCelebritTypesViewWhitFram:(CGRect)frame ViewTitle:(NSString *)viewTitle url:(NSString*)url;


@property (assign,nonatomic) id<CelebritTypeDelegate> delegate;
@end
