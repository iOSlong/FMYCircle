//
//  XWARCSignlView.m
//  XWJSC
//
//  Created by xuewu.long on 16/12/26.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "XWARCSignlView.h"

@interface XWARCSignlView ()
@property (nonatomic, strong) UIButton *btnSignl;
@end

@implementation XWARCSignlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSignlItems];
    }
    return self;
}

- (void)configureSignlItems {
    self.btnSignl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnSignl.size = CGSizeMake(self.width * 0.5, 30);
    self.btnSignl.origin = CGPointMake(k_SpanLeft, k_SpanIn);
    [self.btnSignl setTitle:@"signlSent" forState:UIControlStateNormal];
    [self.btnSignl addTarget:self action:@selector(signalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnSignl];
}


- (void)signalBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.isSelected) {
        self.width = SCREENW * 0.5;
    }else{
        self.width = SCREENW * 0.4;
    }
}
@end
