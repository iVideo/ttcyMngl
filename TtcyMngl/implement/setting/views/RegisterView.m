//
//  RegisterView.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-1.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UITextField* userinput_;//用户名输入
    UITextField* pwd_;//密码输入
    UITextField* con_pwd_; //确认密码
    
    int top_;//view的上坐标
    CGFloat beganTop;
    
    BOOL keyboard_is_show;//键盘是否显示
    
    UIView* loginView_;
    NSLayoutConstraint* loginConstrinets_;
    CGFloat loginHeight_;
    
    UIView* mainView_;
    NSLayoutConstraint* mainConstraints_;
    UIView* loadingView_;
}
@end

@implementation RegisterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        getTopDistance();
        getPlayBarHeight();
        getTopDistance();
        
        mainView_ = [[UIView alloc] init];
        [mainView_ setTranslatesAutoresizingMaskIntoConstraints:NO];
        mainView_.backgroundColor = CENT_COLOR;
        [self addSubview:mainView_];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mainView_]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(mainView_)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-44-[mainView_(%f)]", [[UIScreen mainScreen] bounds].size.height] options:0 metrics:0 views:NSDictionaryOfVariableBindings(mainView_)]];
        
        mainConstraints_ = [NSLayoutConstraint constraintWithItem:mainView_ attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:mainConstraints_];
        
        [self createOtherView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touched)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        LOG_UI_FATAL(@"login mian view subViews%@",mainView_.subviews);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)touched
{
    [userinput_ endEditing:YES];
    [pwd_ endEditing:YES];
    [con_pwd_ endEditing:YES];
}
- (void) createOtherView
{
    [self createUserTextView];
    [self createPwdView];
    [self createRegistBtnView];
}
-(void)createUserTextView
{
    beganTop = 80;
    if (isIOS7) {
        beganTop += 44;
    }
    if (is4Inch) {
        beganTop +=20;
    }
    //
    UILabel* user_label = [[UILabel alloc] init];
    user_label.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    user_label.text = @" \n   ";
    user_label.transform = CGAffineTransformMakeRotation(M_PI_2);
    user_label.backgroundColor = [UIColor clearColor];
    [user_label setTextColor:[UIColor whiteColor]];
    [user_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    user_label.numberOfLines = 0;
    
    [mainView_ addSubview:user_label];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[user_label(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(user_label)]];
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[user_label(==44)]",beganTop] options:0 metrics:nil views:NSDictionaryOfVariableBindings(user_label)]];
    
    userinput_ = [[UITextField alloc] init];
    [userinput_ setTranslatesAutoresizingMaskIntoConstraints:NO];
    userinput_.autocorrectionType = UITextAutocorrectionTypeNo;
    userinput_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userinput_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userinput_.textAlignment = NSTextAlignmentCenter;
    userinput_.placeholder = @"13012345678";
    userinput_.keyboardType = UIKeyboardTypePhonePad;
    userinput_.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userinput_ setTextColor:[UIColor colorWithRed:38/255.0f green:38/255.0 blue:38/255.0 alpha:1]];
    userinput_.backgroundColor = [UIColor whiteColor];
    [mainView_ addSubview:userinput_];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[user_label]-0-[userinput_]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(user_label,userinput_)]];
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[userinput_(==44)]",beganTop] options:0 metrics:nil views:NSDictionaryOfVariableBindings(userinput_)]];
    
    
}
-(void)createPwdView
{
    //密码
    UILabel* pwd_label = [[UILabel alloc] init];
    pwd_label.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    pwd_label.text = @" \n ";
    pwd_label.transform = CGAffineTransformMakeRotation(M_PI_2);
    pwd_label.backgroundColor = [UIColor clearColor];
    [pwd_label setTextColor:[UIColor whiteColor]];
    [pwd_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    pwd_label.numberOfLines = 0;
    
    [mainView_ addSubview:pwd_label];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pwd_label(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwd_label)]];
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[pwd_label(==44)]",beganTop+=45] options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwd_label)]];
    
    pwd_ = [[UITextField alloc] init];
    [pwd_ setTranslatesAutoresizingMaskIntoConstraints:NO];
    pwd_.autocorrectionType = UITextAutocorrectionTypeNo;
    pwd_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwd_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwd_.textAlignment = NSTextAlignmentCenter;
    pwd_.secureTextEntry = YES;
    pwd_.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pwd_ setTextColor:[UIColor colorWithRed:38/255.0f green:38/255.0 blue:38/255.0 alpha:1]];
    pwd_.backgroundColor = [UIColor whiteColor];
    pwd_.delegate = self;
    pwd_.returnKeyType = UIReturnKeyNext;
    [mainView_ addSubview:pwd_];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pwd_label]-0-[pwd_]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwd_label,pwd_)]];
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[pwd_(==44)]",beganTop] options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwd_)]];
    
    //确认密码
    UILabel* con_label = [[UILabel alloc] init];
    con_label.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    con_label.text = @"\n  ";
    con_label.transform = CGAffineTransformMakeRotation(M_PI_2);
    con_label.backgroundColor = [UIColor clearColor];
    [con_label setTextColor:[UIColor whiteColor]];
    [con_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    con_label.numberOfLines = 0;
    
    [mainView_ addSubview:con_label];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[con_label(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(con_label)]];
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[con_label(==44)]",beganTop+=45] options:0 metrics:nil views:NSDictionaryOfVariableBindings(con_label)]];
    
    con_pwd_ = [[UITextField alloc] init];
    [con_pwd_ setTranslatesAutoresizingMaskIntoConstraints:NO];
    con_pwd_.autocorrectionType = UITextAutocorrectionTypeNo;
    con_pwd_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    con_pwd_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    con_pwd_.textAlignment = NSTextAlignmentCenter;
    con_pwd_.secureTextEntry = YES;
    con_pwd_.clearButtonMode = UITextFieldViewModeWhileEditing;
    [con_pwd_ setTextColor:[UIColor colorWithRed:38/255.0f green:38/255.0 blue:38/255.0 alpha:1]];
    con_pwd_.backgroundColor = [UIColor whiteColor];
    con_pwd_.delegate = self;
    con_pwd_.returnKeyType = UIReturnKeyDone;
    [mainView_ addSubview:con_pwd_];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[con_label]-0-[con_pwd_]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(con_label,con_pwd_)]];
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[con_pwd_(==44)]",beganTop] options:0 metrics:nil views:NSDictionaryOfVariableBindings(con_pwd_)]];
    
}
- (void) createRegistBtnView
{
    UIButton* btn = [[UIButton alloc] init];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    btn.backgroundColor = NVC_COLOR;
    UIFont* font = [UIFont fontWithName:@"Menksoft Qagan" size:20.0f];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn.titleLabel.numberOfLines = 0;
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setBackgroundImage:[Utils createImageWithColor:[UIColor colorWithRed:0.0f green:111/255.0f blue:173/255.0f alpha:1]] forState:UIControlStateHighlighted];
    btn.transform = CGAffineTransformMakeRotation(M_PI_2);
    [btn addTarget:self action:@selector(registButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView_ addSubview:btn];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[btn(==80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
    NSLog(@"%@",mainView_.subviews.lastObject);
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[btn(==80)]",beganTop+=70] options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
}
- (void) loading:(BOOL) isshow
{
#warning 添加loading效果
    
}
-(void)registButtonPressed
{
    [self beganRegister];
}
-(void)beganRegister
{
    if ([self checkFormat]) {
        
        [self.delegate regist:_user pwd:_pwd];
        [userinput_ endEditing:YES];
        [pwd_ endEditing:YES];
        [con_pwd_ endEditing:YES];
        
        [self loading:YES];
    }
}
-(BOOL)checkFormat
{
    _user = userinput_.text;
    _pwd = pwd_.text;
    if ([@""isEqualToString:_user]) {
        
        
        return NO;
    }else if ([@"" isEqualToString: _pwd]){
    
        
        return NO;
    }else if(![_pwd isEqualToString:con_pwd_.text]){
        
        
        return NO;
    }
    return YES;
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    if (keyboard_is_show) {
        keyboard_is_show = NO;
        if ([[UIScreen mainScreen] bounds].size.height > 480) {
            top_ += 100;
        }else{
            top_ += 80;
        }
        [UIView animateWithDuration:0.3 animations:^{
            mainConstraints_.constant = top_;
            [self layoutIfNeeded];
        }];
    }
}
//
-(void)keyboardWillShow:(NSNotification *)notification
{
    if (!keyboard_is_show) {
        keyboard_is_show = YES;
        if ([[UIScreen mainScreen] bounds].size.height > 480) {
            top_ -= 100;
        }else{
            top_ -= 80;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            mainConstraints_.constant = top_;
            [self layoutIfNeeded];
        }];
    }
}
-(void)reset
{
    userinput_.text = @"";
    pwd_.text = @"";
    con_pwd_.text = @"";
}
#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isMemberOfClass:[UIButton class]]) {
        
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:pwd_]) {
        
        [con_pwd_ becomeFirstResponder];
    }else if([textField isEqual:con_pwd_]){
        [self beganRegister];
    }
    return YES;
}

@end














































