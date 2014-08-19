//
//  LooksPwdViewController.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-30.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "LooksPwdViewController.h"

@interface LooksPwdViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UITextField * userinput_;//用户名输入
    UITextField * checkNumInput; //验证码
    
    UIView* mainView_;
    NSLayoutConstraint* mainConstraints_;
    
    int top_;
    CGFloat beganTop;
    
    BOOL keyboard_is_show;//键盘是否显示
    
}
@end

@implementation LooksPwdViewController

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
    
    [self createMainView];
    [self addConstrains];
    [self addGesture];
    [self addKeyboardNotification];
    [self createOtherView];
}
-(void)setBaseCondition
{
    self.view.backgroundColor = CENT_COLOR;
    getTopDistance();
    getPlayBarHeight();
    getTopDistance();
}
-(void)createMainView
{
    mainView_ = [[UIView alloc] init];
    [mainView_ setTranslatesAutoresizingMaskIntoConstraints:NO];
    mainView_.backgroundColor = CENT_COLOR;
    [self.view addSubview:mainView_];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mainView_]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(mainView_)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[mainView_(%f)]", [[UIScreen mainScreen] bounds].size.height] options:0 metrics:0 views:NSDictionaryOfVariableBindings(mainView_)]];
}
-(void)addConstrains
{
    mainConstraints_ = [NSLayoutConstraint constraintWithItem:mainView_ attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:mainConstraints_];
}
-(void)addGesture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touched)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
-(void)touched
{
    [userinput_ endEditing:YES];
    [checkNumInput endEditing:YES];
}
-(void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)createOtherView
{
    [self createUserTextView];
    [self createCheckNumField];
}
-(void)createUserTextView
{
    beganTop = 80;
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
-(void)createCheckNumField
{
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
    
    checkNumInput = [[UITextField alloc] init];
    [checkNumInput setTranslatesAutoresizingMaskIntoConstraints:NO];
    checkNumInput.autocorrectionType = UITextAutocorrectionTypeNo;
    checkNumInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    checkNumInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    checkNumInput.textAlignment = NSTextAlignmentCenter;
    checkNumInput.secureTextEntry = YES;
    checkNumInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    [checkNumInput setTextColor:[UIColor colorWithRed:38/255.0f green:38/255.0 blue:38/255.0 alpha:1]];
    checkNumInput.backgroundColor = [UIColor whiteColor];
    checkNumInput.delegate = self;
    checkNumInput.returnKeyType = UIReturnKeyDone;
    [mainView_ addSubview:checkNumInput];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pwd_label]-0-[checkNumInput]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwd_label,checkNumInput)]];
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[checkNumInput(==44)]",beganTop] options:0 metrics:nil views:NSDictionaryOfVariableBindings(checkNumInput)]];
}
-(void)getCheckNumber
{
#warning 获取验证码
    
}
-(void)request
{
#warning 获取密码
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - KeyboardNotification methods
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
            [self.view layoutIfNeeded];
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
            [self.view layoutIfNeeded];
        }];
    }
}
#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self request];
    return YES;
}
@end
