//
//  MusicCell.m
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-9.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import "CelebrityCell.h"
#import "AsynImageView.h"
#import <UIImageView+WebCache.h>
#define CellH 350
@implementation CelebrityCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(NSString *)ID{
    return @"celebrityCell";
}
-(id)initWith{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}
+(id)newCell{
    CelebrityCell *celebrityCell=[[NSBundle mainBundle]loadNibNamed:@"CelebrityCell" owner:nil options:nil][0];
    celebrityCell.transform = CGAffineTransformMakeRotation(M_PI);
        [celebrityCell setBackgroundColor:[UIColor clearColor]];
     celebrityCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return celebrityCell;
}



-(void)celebrityWithModel:(Celebrity *)model{
    if (model.photoURL!=nil) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 50, 50)];
        image.tag=1001;
        [image setImageWithURL:[NSURL URLWithString:model.photoURL] placeholderImage:[UIImage imageNamed:@"face.jpg"]];
        
        image.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self addSubview:image];
    }
    
    _lblName.text=model.name;
    _lblName.font=[self setTransformuiFont:_lblName.font];
}

-(void)setLoadTitle:(NSString*)title{
    _lblName.text=title;
    _lblName.font=[self setTransformuiFont:_lblName.font];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
}
-(id) setTransformuiFont:(UIFont *)uiFont{
    uiFont = [UIFont fontWithName:@"Menksoft Qagan" size:20];
    return uiFont;
    
}

@end
