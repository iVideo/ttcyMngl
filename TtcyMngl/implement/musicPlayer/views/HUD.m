//
//  HUD.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-18.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "HUD.h"


@interface HUD ()
{
    BOOL createMenu;
    BOOL createPromt;
}
@property (nonatomic,strong)UILabel * messageLabel;

@property (nonatomic,strong,setter = setIndicator:)UIActivityIndicatorView * indicator;

@property (nonatomic,strong,setter = setPromt:)UIView * promt;

@end

@implementation HUD

- (id)initWithFrame:(CGRect)frame showMenu:(BOOL)show andPromt:(BOOL)showPromt
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        createMenu = show;
        createPromt = showPromt;
        
        [self setBaseCondition];
        [self createMessageLabel];
        if (show) {
            [self createMenuButton];
        }else{
            [self createShutButton];
        }
    }
    return self;
}
#pragma mark - init methods
-(void)setBaseCondition
{
    [self setBackgroundColor:[UIColor colorWithWhite:.2f alpha:.9f]];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
}
-(void)createShutButton
{
    UIButton *shutBut=[[UIButton alloc]init];
    [shutBut addTarget:self action:@selector(shutButClicked) forControlEvents:UIControlEventTouchUpInside];
    [shutBut setImage:[UIImage imageNamed:@"remove_btn_h@2x.png"] forState:UIControlStateNormal];
    [shutBut setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:shutBut];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-5)-[shutBut(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(shutBut)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-5)-[shutBut(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(shutBut)]];
}
-(void)shutButClicked
{
    [self removeFromSuperview];
}
-(void)createMessageLabel
{
    self.messageLabel=[[UILabel alloc]init];
    _messageLabel.font=[UIFont fontWithName:@"Menksoft Qagan" size:20.0];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.textColor = CENT_COLOR;
    [_messageLabel setBackgroundColor:[UIColor clearColor]];
    [_messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_messageLabel];
    
    if (!createMenu) {
        
        CGFloat top = 10;
        if (createPromt) {
            top += 30;
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[_messageLabel]-(%f)-|",top,10.0] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
    }
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_messageLabel]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
}
-(void)createMenuButton
{
    UIButton * cancel = [[UIButton alloc]init];
    
    [cancel setBackgroundImage:[Utils createImageWithColor:self.backgroundColor] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[Utils createImageWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
    
    cancel.titleLabel.font=[UIFont fontWithName:@"Menksoft Qagan" size:20.0];
    
    [cancel setTitle:@"" forState:UIControlStateNormal];
    [cancel.titleLabel setBackgroundColor:[UIColor clearColor]];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cancel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    cancel.tag = 0;
    
    [cancel addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * other = [[UIButton alloc]init];
    
    [other setBackgroundImage:[Utils createImageWithColor:self.backgroundColor] forState:UIControlStateNormal];
    [other setBackgroundImage:[Utils createImageWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
    
    other.titleLabel.font=[UIFont fontWithName:@"Menksoft Qagan" size:20.0];
    
    [other setTitle:@"" forState:UIControlStateNormal];
    [other setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [other.titleLabel setBackgroundColor:[UIColor clearColor]];
    [other.titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [other setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    other.tag = 1;
    [other addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancel];
    [self addSubview:other];
    
    CGFloat buttom = 10;
    if (createMenu) {
        buttom +=55;
    }
    CGFloat top = 10;
    if (createPromt) {
        top += 30;
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[_messageLabel]-5-[other]-(%f)-|",top,5.0] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel,other)]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:other attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[other]-1-[cancel]|"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(other,cancel)]];
}
-(void)menuButtonAction:(UIButton *)sender
{
    [self.delegate hud:self clickedButtonAtIndex:sender.tag];
}
-(void)setIndicator:(UIActivityIndicatorView *)indicator
{
    [indicator removeFromSuperview];
    
    _indicator = indicator;
    _indicator.hidesWhenStopped = NO;
    
    [self addSubview:_indicator];
    
    [_indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_indicator]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_indicator)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_indicator]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_indicator)]];
    
    [_indicator startAnimating];
    [self changeFrame];
}
-(void)setPromt:(UIView *)promt
{
    [_promt removeFromSuperview];
    _promt = promt;
    
    [self addSubview:_promt];
    [_promt setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_promt]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_promt)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_promt]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_promt)]];
    [self changeFrame];
}
-(void)changeFrame
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_messageLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_messageLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
}

#pragma mark - call methods

+(void)messageForBuffering
{
    [HUD clearHudFromApplication];
    
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGSize size = [@"   " sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:20.0] constrainedToSize:CGSizeMake(20, kMainScreenWidth)];
    
    HUD *loadingView=[[HUD alloc]initWithFrame:CGRectMake(0, 0, 60, size.height+40) showMenu:NO andPromt:YES];
    loadingView.center = view.center;
    loadingView.messageLabel.text = @"   ";
    
    UIActivityIndicatorView  *_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingView.indicator = _activityIndicatorView;
    
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
}
+(void)messageForComplect
{
    
}
+(void)messageForFailler
{
    [HUD clearHudFromApplication];
}

+(void)message:(NSString *)message
{
    [HUD clearHudFromApplication];
    
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGSize size = [message sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:18.0] constrainedToSize:CGSizeMake(20, kMainScreenWidth)];
    
    HUD *loadingView=[[HUD alloc]initWithFrame:CGRectMake(0, 0, 60, size.height) showMenu:NO andPromt:NO];
    loadingView.center = view.center;
    loadingView.messageLabel.text = message;
    
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
}
+(void)message:(NSString *)message promtView:(UIView *)promt
{
    [HUD clearHudFromApplication];
    
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGSize size = [message sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:18.0] constrainedToSize:CGSizeMake(20, kMainScreenWidth)];
    
    HUD *loadingView=[[HUD alloc]initWithFrame:CGRectMake(0, 0, 60, size.height) showMenu:NO andPromt:YES];
    loadingView.center = view.center;
    loadingView.messageLabel.text = message;
    
    loadingView.promt = promt;
    
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
}
+(void)clearHudFromApplication
{
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[HUD class]]) {
            [obj removeFromSuperview];
            break;
        }
    }
}
+(void)message:(NSString *)message delegate:(UIViewController<HUDDelgate> *)delegate Tag:(NSInteger)tag
{
    [HUD clearHudFromApplication];
    
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGSize size = [message sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:18.0] constrainedToSize:CGSizeMake(20, kMainScreenWidth)];
    
    HUD *loadingView=[[HUD alloc]initWithFrame:CGRectMake(0, 0, 60, size.height+70) showMenu:YES andPromt:NO];
    loadingView.center = view.center;
    loadingView.messageLabel.text = message;
    loadingView.delegate = delegate;
    loadingView.tag = tag;
    [loadingView createMenuButton];
    
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
}
@end
