//
//  LoginView.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "LoginView.h"
#import "AccountInfo.h"
#import <objc/runtime.h>
#import "AccountManager.h"

@interface LoginView()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    
    UIImageView* head_;//头像
    
    UITextField* userinput_;//用户名输入
    
    UITextField* pwd_;//密码输入
    
    UIImageView* rempwd;//记录密码
    
    
    int top_;//登录view的上坐标
    //    CGFloat bottom_;
    BOOL keyboard_is_show;//键盘是否显示
    
    UIView* moreUserDetailView_;
    UIView* inner_MoreUserDetailView_;
    NSMutableDictionary* userViewDic_;
    
    //newer
    UIView* headView_;
    NSLayoutConstraint* headExplanConstrints_;
    NSLayoutConstraint* headShrinkConstrints_;
    CGFloat headViewExplanHegiht_;
    CGFloat headViewShrinkHegiht_;
    
    //登录部分
    UIView* loginView_;
    NSLayoutConstraint* loginConstrinets_;
    CGFloat loginHeight_;
    
    //更多账号部分
    NSLayoutConstraint* moreUserConstrints_;
    
    UIView* mainView_;
    NSLayoutConstraint* mainConstraints_;
    
    UIButton* moreUserBtn_;
    BOOL isOpenMoreBtn_;
    
    UIView* loadingView_;
    
    BOOL isDeleteUserState_;//是否是删除用户的状态
    NSMutableArray* deleteBtnArr_;//删除用户的uibutton集合
}

@end

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) init
{
    self = [super initWithFrame:kMainScreenFrame];
    if (self) {
        getTopDistance()
        getPlayBarHeight()
        
        isDeleteUserState_ = NO;
        mainView_ = [[UIView alloc] init];
        [mainView_ setTranslatesAutoresizingMaskIntoConstraints:NO];
        mainView_.backgroundColor = CENT_COLOR;
        [self addSubview:mainView_];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mainView_]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(mainView_)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[mainView_(%f)]", [[UIScreen mainScreen] bounds].size.height] options:0 metrics:0 views:NSDictionaryOfVariableBindings(mainView_)]];
        
        mainConstraints_ = [NSLayoutConstraint constraintWithItem:mainView_ attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:mainConstraints_];
        
        [self createHeadView];
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
    [self showDeleteIcon:NO];
}
- (void) setHead:(NSString *)head
{
    if (head && ![@"" isEqualToString:head]) {
        [self setImg:head_ image:head];
    }else{
        [self setImg:head_ image:@"moren_bg"];
    }
    
}
//
- (void) setremPwd:(BOOL)rememberPwd
{
    _rememberPwd = rememberPwd;
    if (rememberPwd) {
        [self setImg:rempwd image:@"moreSelected.png"];
    }else{
        [self setImg:rempwd image:@"uncheck.png"];
    }
}
//
- (void) setImg:(UIImageView*) view image:(NSString *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (image) {
            UIImage* img = [UIImage imageWithContentsOfFile:image];
            if (!img) {
                
                if (!img) {
                    img = [UIImage imageNamed:image];
                }
            }
            if (img) {
                [view setImage:img];
            }
        }
    });
}
//
- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (phone) {
            [userinput_ setText:phone];
        }else{
            [userinput_ setText:@""];
        }
    });
}
//
- (void)setPass:(NSString *)pass
{
    _pass = pass;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pass) {
            [pwd_ setText:pass];
        }else{
            [pwd_ setText:@""];
        }
    });
}
- (UIView*) createSplitLine
{
    UIView* line = [[UIView alloc] init];
    [line setTranslatesAutoresizingMaskIntoConstraints:NO];
    line.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
    return line;
}

- (UIView*) createHeadCircleView
{
    UIView* view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    //164
    UIImageView* outCircle = [[UIImageView alloc] init];//]WithFrame:CGRectMake(0, 0, 82, 82)];
    [outCircle setTranslatesAutoresizingMaskIntoConstraints:NO];
#warning  //    [outCircle setImage:];
    [view addSubview:outCircle];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[outCircle(80)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(outCircle)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[outCircle(80)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(outCircle)]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:outCircle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:outCircle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    head_ = [[UIImageView alloc] init];
    [head_ setTranslatesAutoresizingMaskIntoConstraints:NO];
#warning    [head_ setImage:[UIImage imageNamed:@""]];
    head_.layer.cornerRadius = 8;
    head_.layer.masksToBounds = YES;
    
    [head_ setBackgroundColor:[UIColor greenColor]];
    [self setImg:head_ image:@"moren_bg"];
    
    [view addSubview:head_];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[head_(75)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(head_)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[head_(75)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(head_)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:head_ attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:head_ attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    return view;
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

- (void) userChanged:(id) sender
{
    [self showDeleteIcon:NO];
    UITextField* text = (UITextField*)sender;
    pwd_.text = @"";
#warning    [self setImg:head_ image:@""];
    [userViewDic_ enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        UIView* v = (UIView*) obj;
        v.alpha = 0.0;
    }];
    //设置备选头像
    if (userViewDic_) {
        UIView* view = [userViewDic_ objectForKey:text.text];
        if (view) {
            //设置选中状态
            view.alpha = 0.5;
        }
    }
    if (self.currentAccount && [self.currentAccount.phone isEqualToString:text.text]) {
        self.phone = self.currentAccount.phone;
        self.pass = self.currentAccount.pass;
        self.head = self.currentAccount.userIcon;
        self.rememberPwd = self.currentAccount.savePasswd;
        return;
    }else{
        for (AccountInfo* acc in self.moreAccount) {
            if ([acc.phone isEqualToString:text.text]) {
                self.phone = acc.phone;
                self.pass = acc.pass;
                self.head = acc.userIcon;
                self.rememberPwd = acc.savePasswd;
                return;
            }
        }
    }
    
}
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIView *)createBtnViewWithTitle:(NSString *)title andAction:(SEL)action
{
    UIButton* btn = [[UIButton alloc] init];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    btn.backgroundColor = [UIColor clearColor];
    UIFont* font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:[Utils colorWithHexString:@"3366ff"] forState:UIControlStateNormal];
    [btn setTitleColor:[Utils colorWithHexString:@"333399"] forState:UIControlStateSelected];
    [btn setTitleColor:[Utils colorWithHexString:@"333399"] forState:UIControlStateHighlighted];
    btn.titleLabel.numberOfLines = 0;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    
    UIView* view = [[UIView alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    view.backgroundColor = [Utils colorWithHexString:@"#3333ff"];
    
    [btn addSubview:view];
    
    [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[view]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[view(==1)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    btn.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
//
- (UIView*) createLogBtnView
{
    UIButton* btn = [[UIButton alloc] init];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    btn.backgroundColor = NVC_COLOR;
    UIFont* font = [UIFont fontWithName:@"Menksoft Qagan" size:20.0f];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn.titleLabel.numberOfLines = 0;
    [btn setTitle:@"\n" forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:0.0f green:111/255.0f blue:173/255.0f alpha:1]] forState:UIControlStateHighlighted];
    btn.transform = CGAffineTransformMakeRotation(M_PI_2);
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
- (void) login
{
    if (isOpenMoreBtn_) {
        [self more:moreUserBtn_];
    }
    [self.delegate login:userinput_.text pwd:pwd_.text savepwd:self.rememberPwd];
    [userinput_ endEditing:YES];
    [pwd_ endEditing:YES];
}
//
- (void) createExtraView:(UIView *)view
{
    UIView* lview = [self createBtnViewWithTitle:@" \n  " andAction:@selector(rememberPwd:)];
    [view addSubview:lview];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lview(==50)]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(lview)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[lview(==85)]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(lview)]];
    
    rempwd = [[UIImageView alloc] init];
    [rempwd setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setImg:rempwd image:@"uncheck.png"];
    rempwd.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [lview addSubview:rempwd];
    //
    [lview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[rempwd(==20)]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(rempwd)]];
    [lview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[rempwd(20)]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(rempwd)]];
    
    
    UIView* NewView = [self createBtnViewWithTitle:@"\n " andAction:@selector(registor:)];
    [view addSubview:NewView];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[NewView(==50)]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(NewView)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[NewView(==113)]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(NewView)]];
}
-(void)registor:(UIButton *)sender
{
    [self.delegate registButtonPressed];
}
-(void)forget:(UIButton *)sender
{
    [self.delegate forgetButtonPressed];
}
//
- (void) rememberPwd:(id) sender
{
    self.rememberPwd = !self.rememberPwd;
}

- (void) userClick:(id) sender
{
    UIButton* btn = (UIButton*) sender;
    AccountInfo* user = objc_getAssociatedObject(btn, @"obj_connect_account");
    UIView* head = objc_getAssociatedObject(btn, @"obj_connect_view");
    self.phone = user.phone;
    self.pass = user.pass;
    self.rememberPwd = user.savePasswd;
    self.head = user.userIcon;
    [userViewDic_ enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        UIView* v = (UIView*) obj;
        v.alpha = 0.0;
    }];
    head.alpha = 0.5;
}

- (void) longPress:(id) sender
{
    [self showDeleteIcon:YES];
}

- (void) showDeleteIcon:(BOOL) show
{
    isDeleteUserState_ = show;
    for (UIButton* btn in deleteBtnArr_) {
        btn.hidden = !show;
    }
}

- (void) deleteUser:(id) sender
{
    UIButton* btn = (UIButton*) sender;
    AccountInfo* acc = objc_getAssociatedObject(btn, @"obj_delete_account");
    [self.delegate deleteAccount:acc.phone];
}
- (UIView*) createOneUserView:(CGRect) rect account:(AccountInfo*) user
{
    UIButton* view = [[UIButton alloc] initWithFrame:rect];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [view addGestureRecognizer:longPress];
    
    UIImageView *head = [[UIImageView alloc] init];
    //
    if (user.userIcon && ![user.userIcon isEqualToString:@""]) {
        [self setImg:head image:user.userIcon];
    }else{
        [self setImg:head image:@"moren_bg"];
    }
    head.layer.cornerRadius = 55 / 2.0;
    head.layer.masksToBounds = YES;
    [head setTranslatesAutoresizingMaskIntoConstraints:NO];
    [head setUserInteractionEnabled:NO];
    [view addSubview:head];
    
    
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[head(55)]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(head)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[head(55)]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(head)]];
    
    UIView* foreView = [[UIView alloc] init];
    [foreView setTranslatesAutoresizingMaskIntoConstraints:NO];
    foreView.layer.cornerRadius = 55 / 2.0;
    foreView.layer.masksToBounds = YES;
    if ([user.phone isEqualToString:self.currentAccount.phone]) {
        foreView.alpha = 0.5;
    }else{
        foreView.alpha = 0.0;
    }
    
    [head addSubview:foreView];
    [head addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[foreView(55)]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(foreView)]];
    [head addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[foreView(55)]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(foreView)]];
    
    [view addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(view, @"obj_connect_account", user, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(view, @"obj_connect_view", foreView, OBJC_ASSOCIATION_RETAIN);
    [userViewDic_ setObject:foreView forKey:user.phone];
    
    
    UIButton* delete = [[UIButton alloc] init];
    objc_setAssociatedObject(delete, @"obj_delete_account", user, OBJC_ASSOCIATION_RETAIN);
    [delete setImage:[UIImage imageNamed:@"remove_btn"] forState:UIControlStateNormal];
    [delete setImage:[UIImage imageNamed:@"remove_btn_h"] forState:UIControlStateHighlighted];
    [delete setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:delete];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[delete(20)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(delete)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[delete(20)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(delete)]];
    [delete addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
    delete.hidden = !isDeleteUserState_;
    if (!deleteBtnArr_) {
        deleteBtnArr_ = [[NSMutableArray alloc] init];
    }
    [deleteBtnArr_ addObject:delete];
    return view;
}

- (UIView*) createMoreUserViewDetail:(BOOL) isDelete
{
    UIView * view = [[UIView alloc] init];
    userViewDic_ = [[NSMutableDictionary alloc] initWithCapacity:self.moreAccount.count];
    if (isDelete) {
        
    }else{
        //没有删除状态
        if (self.moreAccount){
            if (self.moreAccount.count < 4) {
                //居中
                //55*n+35*（n-1）=90*n-35
                int left = ([[UIScreen mainScreen] bounds].size.width - 90 * (self.moreAccount.count) + 35) / 2;
                for(int i = 0; i < self.moreAccount.count; ++i){
                    AccountInfo* acc = (AccountInfo*)(self.moreAccount[i]);
                    CGRect rect = CGRectMake(left + i * 90, 8, 59, 59);
                    UIView* one = [self createOneUserView:rect account:acc];
                    [view addSubview:one];
                }
            }else{
                //左对齐
                int left = 25;
                int n = self.moreAccount.count;
                UIScrollView* sv = [[UIScrollView alloc] init];
                [sv setTranslatesAutoresizingMaskIntoConstraints:NO];
                sv.showsHorizontalScrollIndicator = NO;
                sv.showsVerticalScrollIndicator = NO;
                sv.contentSize = CGSizeMake(left + 55 * n + (n - 1) * 35 + 10, 79);//CGRectMake(0, 0, left + 55 * n + (n - 1) * 35, 79);
                [view addSubview:sv];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sv]-0-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(sv)]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sv]-0-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(sv)]];
                for(int i = 0; i < self.moreAccount.count; ++i){
                    AccountInfo* acc = (AccountInfo*)(self.moreAccount[i]);
                    CGRect rect = CGRectMake(left + i * 90, 8, 59, 59);
                    UIView* one = [self createOneUserView:rect account:acc];
                    [sv addSubview:one];
                }
            }
        }
    }
    return view;
}
//
- (void) setUsers:(AccountInfo *)currentAccount
{
    _currentAccount = currentAccount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (inner_MoreUserDetailView_) {
            [inner_MoreUserDetailView_ removeFromSuperview];
        }
        inner_MoreUserDetailView_ = [self createMoreUserViewDetail:NO];
        [inner_MoreUserDetailView_ setTranslatesAutoresizingMaskIntoConstraints:NO];
        [moreUserDetailView_ addSubview:inner_MoreUserDetailView_];
        [moreUserDetailView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[inner_MoreUserDetailView_]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(inner_MoreUserDetailView_)]];
        [moreUserDetailView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inner_MoreUserDetailView_]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(inner_MoreUserDetailView_)]];
        
    });
}

//头像部分的view
- (UIView*) createHeadView
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];

    [mainView_ addSubview:view];
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    CGFloat top = 0;
    if (isIOS7) {
        top +=44;
    }
    if (is4Inch) {
        top += 20;
    }
    
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[view(100)]",top] options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    
    UIView* btn = [[UIView alloc] init];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:btn];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(128)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(btn)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn(128)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(btn)]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    UIView* head = [self createHeadCircleView];
    [btn addSubview:head];
    
    [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[head(80)]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(head)]];
    [btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[head(80)]" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(head)]];
    [btn addConstraint:[NSLayoutConstraint constraintWithItem:head attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [btn addConstraint:[NSLayoutConstraint constraintWithItem:head attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    return view;
}

- (void) createOtherView
{
    [self createLoginView];
    [self createUserTextView];
    [self createMoreUserView];
    [self createPwdAndSavePwdView];
}

- (UIView*) createLoginView
{
    UIView* view = [[UIView alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [mainView_ addSubview:view];
    
    CGFloat bottom;
    if (is4Inch) {
        bottom = 674 / 2;
    }else{
        bottom = 586 / 2;
    }
    
    loginHeight_ = bottom;
    getPlayBarHeight();
    [mainView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    [mainView_ addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bottom + PlayBarHeight-topDistance]];
    
    loginConstrinets_ = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mainView_ attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    
    [mainView_ addConstraint: loginConstrinets_];
    
    loginView_ = view;
    
    return view;
}

- (UIView*) createUserTextView
{
    UIView* view = [[UIView alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loginView_ addSubview:view];
    
    UIView* sp1 = [self createSplitLine];
    [view addSubview:sp1];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sp1]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sp1)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sp1(==0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sp1)]];
    
    [view addSubview:sp1];
    
    UIView* user = [[UIView alloc] init];
    [user setTranslatesAutoresizingMaskIntoConstraints:NO];
    user.backgroundColor = [UIColor whiteColor];
    [view addSubview:user];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[user]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(user)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sp1]-0-[user(44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sp1, user)]];
    
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
    [userinput_ addTarget:self action:@selector(userChanged:) forControlEvents:UIControlEventEditingChanged];
    [userinput_ addTarget:self action:@selector(userEnter:) forControlEvents:UIControlEventTouchDown];
    //
    [user addSubview:userinput_];
    
    UIButton* more = [[UIButton alloc] init];
    [more setTranslatesAutoresizingMaskIntoConstraints:NO];

    [more setBackgroundColor:[UIColor redColor]];
    [more setTitle:@">>" forState:UIControlStateNormal];
    
    [more addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [user addSubview:more];
    
    [user addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[userinput_]-0-[more(==45)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(userinput_, more)]];
    [user addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[userinput_]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(userinput_)]];
    [user addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[more]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(more)]];
    
    UIView* sp2 = [self createSplitLine];
    [view addSubview:sp2];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sp2]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sp2)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[user]-0-[sp2(==0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(user, sp2)]];
    
    UILabel* user_label = [[UILabel alloc] init];
    user_label.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    user_label.text = @" \n   ";
    user_label.transform = CGAffineTransformMakeRotation(M_PI_2);
    user_label.backgroundColor = [UIColor clearColor];
    [user_label setTextColor:[UIColor whiteColor]];
    [user_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    user_label.numberOfLines = 0;
    
    [loginView_ addSubview:user_label];
    
    [loginView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[user_label(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(user_label)]];
    [loginView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[user_label(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(user_label)]];
    
    [loginView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[view]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(view)]];
    [loginView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(45)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(view)]];
    
    moreUserBtn_ = more;
    return view;
}
- (void) more:(id) sender
{
    UIButton* more = (UIButton*) sender;
    static BOOL is_open = YES;
    isOpenMoreBtn_ = is_open;
    [UIView animateWithDuration:0.3 animations:^{
        [self openMoreUserView:is_open button:more];
        is_open = !is_open;
    }];
}

- (void) userEnter:(id) sener
{
    [self showDeleteIcon:NO];
}

- (BOOL) openMoreUserView:(BOOL) open button:(UIButton*) btn
{
    [UIView animateWithDuration:0.3 animations:^{
        if (open) {
            moreUserConstrints_.constant = 79.5 + 45;
#warning            [btn setImage:[] forState:UIControlStateNormal];
#warning            [btn setImage:[] forState:UIControlStateHighlighted];
            
        }else{
#warning            [btn setImage:[] forState:UIControlStateNormal];
#warning            [btn setImage:[] forState:UIControlStateHighlighted];
            moreUserConstrints_.constant = 45;
        }
        [self layoutIfNeeded];
    }];
    return !open;
}

- (UIView*) createMoreUserView
{
    UIView* view = [[UIView alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    view.backgroundColor = [UIColor whiteColor];
    [loginView_ addSubview:view];
    
    [loginView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(view)]];
    [loginView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[view(79.5)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(view)]];
    
    UIView* sp = [self createSplitLine];
    [view addSubview:sp];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sp]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(sp)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sp(0.5)]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(sp)]];
    moreUserDetailView_ = view;
    return view;
}

#warning 密码
- (UIView*) createPwdAndSavePwdView
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = CENT_COLOR;
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loginView_ addSubview:view];
    
    [loginView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [loginView_ addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat: @"V:[view(%f)]", loginHeight_ - 45] options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    moreUserConstrints_ = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:loginView_ attribute:NSLayoutAttributeTop multiplier:1 constant:45];
    [loginView_ addConstraint:moreUserConstrints_];
    
    UILabel* Pwd_label = [[UILabel alloc] init];
    Pwd_label.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    Pwd_label.text = @" \n ";
    Pwd_label.transform = CGAffineTransformMakeRotation(M_PI_2);
    Pwd_label.backgroundColor = [UIColor clearColor];
    [Pwd_label setTextColor:[UIColor whiteColor]];
    [Pwd_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    Pwd_label.numberOfLines = 0;
    
    [view addSubview:Pwd_label];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[Pwd_label(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(Pwd_label)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[Pwd_label(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(Pwd_label)]];
    
    
    UIView* p = [[UIView alloc] init];
    [p setTranslatesAutoresizingMaskIntoConstraints:NO];
    p.backgroundColor = [UIColor whiteColor];
    [view addSubview:p];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[p]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(p)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[p(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(p)]];
    
    pwd_ = [[UITextField alloc] init];
    pwd_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwd_.textAlignment = NSTextAlignmentCenter;
    pwd_.secureTextEntry = YES;
    pwd_.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pwd_ setTranslatesAutoresizingMaskIntoConstraints:NO];
    [pwd_ setFont:[UIFont fontWithName:@"STHeitiSC-Thin" size:15.0f]];
    [pwd_ setTextColor:[UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:1]];
    [pwd_ addTarget:self action:@selector(userEnter:) forControlEvents:UIControlEventTouchDown];
    pwd_.returnKeyType = UIReturnKeyDone;
    pwd_.delegate = self;
    [p addSubview:pwd_];
    
    
    [p addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[pwd_]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwd_)]];
    [p addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pwd_]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pwd_)]];
    
    UIView* login = [self createLogBtnView];
    [view addSubview:login];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-220-[login(80)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(login)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[p]-50-[login(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(p, login)]];
    
    [self createExtraView:view];
    return view;
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
    [self login];
    
    return YES;
}
@end
