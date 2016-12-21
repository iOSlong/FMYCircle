//
//  NSLayoutConstraintViewController.m
//  XWJSC
//
//  Created by xuewu.long on 16/12/13.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "NSLayoutConstraintViewController.h"

@interface NSLayoutConstraintViewController ()

@property (nonatomic, strong) UIImageView *imgvBase;
@property (nonatomic, strong) UIImageView *imgvRed;
@property (nonatomic, strong) UIImageView *imgvGreen;
@property (nonatomic, strong) UIImageView *imgvBlue;


@end

@implementation NSLayoutConstraintViewController

- (void)configureImageViews {
    _imgvBase   = [UIImageView imgvFrame:CGRectZero backgroundColor:[UIColor lightGrayColor] mode:UIViewContentModeScaleAspectFit];
    _imgvRed    = [UIImageView imgvFrame:CGRectZero backgroundColor:[UIColor redColor] mode:UIViewContentModeScaleAspectFit];
    _imgvGreen  = [UIImageView imgvFrame:CGRectZero backgroundColor:[UIColor greenColor] mode:UIViewContentModeScaleAspectFit];
    _imgvBlue   = [UIImageView imgvFrame:CGRectZero backgroundColor:[UIColor blueColor] mode:UIViewContentModeScaleAspectFit];
        
    [self.view addSubview:_imgvBase];
    [self.imgvBase addSubview:_imgvRed];
    [self.imgvBase addSubview:_imgvGreen];
    [self.imgvBase addSubview:_imgvBlue];
}

- (void)setSize:(CGSize)size toView:(UIView *)view;{
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:view
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1
                         constant:size.width]];
    
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:view
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1
                         constant:size.height]];
}
- (void)configureConstraints {
    
    
    
#if 0
    // 设置绝对尺寸， 相对位置
    // 1. 单独设置imgvRed的尺寸和锚点
    [_imgvRed layoutSize:CGSizeMake(50, 150)];
    [_imgvRed layoutAuthor:CGPointMake(k_SpanLeft, k_SpanLeft)];
    
    // 2. 单独设置imgvBlue的尺寸和锚点
    [_imgvBlue layoutSize:CGSizeMake(100, 100)];
    [_imgvBlue layoutAuthor:CGPointMake(SCREENW * 0.6, SCREENH * 0.5)];
    
#else
    // 设置相对尺寸， 绝对位置
    // 1.设置imgvRed的相对边距
    [_imgvRed layoutAuthor:CGPointMake(k_SpanLeft, k_SpanLeft)];
    [_imgvRed rightSpan:k_SpanLeft toItem:_imgvBlue];
    
    [_imgvGreen topSpan:k_SpanLeft toItem:_imgvRed];
    [_imgvGreen layoutLeft:k_SpanLeft];
    [_imgvGreen layoutRight:k_SpanLeft];
    [_imgvGreen layoutBottom:k_SpanLeft];
    

    // 注意根据约束的添加顺序，会存在有约束优先级判断及覆盖的情况，（可以在实际运用练习的时候去理解和体会）
    // A
    [_imgvBlue equalAttribute:NSLayoutAttributeHeight toItem:_imgvRed];
    [_imgvBlue equalAttribute:NSLayoutAttributeWidth toItem:_imgvRed];
    // B
//    [_imgvBlue equalAttribute:NSLayoutAttributeBottom toItem:_imgvGreen];
    // C
    [_imgvGreen equalAttribute:NSLayoutAttributeHeight toItem:_imgvRed];
    
    [_imgvBlue layoutTop:k_SpanLeft];
    [_imgvBlue layoutRight:k_SpanLeft];
    
    
#endif
    
    [self.imgvBase layoutAuthor:CGPointMake(k_SpanLeft, k_SpanLeft)];
    [self.imgvBase layoutRight:k_SpanLeft];
    [self.imgvBase layoutBottom:k_SpanLeft + 44];
//    [self.imgvBase layoutSize:CGSizeMake(300, 200)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = CNCOLOR_ITEM;
    
    [self configureImageViews];
    
    [self configureConstraints];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(k_SpanLeft, k_SpanLeft, 100, 50)];
    view1.backgroundColor = [UIColor orangeColor];
    [self.imgvGreen addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(k_SpanLeft+view1.right, k_SpanLeft, 100, 50)];
    view2.backgroundColor = [UIColor purpleColor];
    [self.imgvGreen addSubview:view2];

    
/*
 Visual Format Language
 1. https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html#//apple_ref/doc/uid/TP40010853-CH27-SW1
 2. http://www.jianshu.com/p/385070898e77
 */
    
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views         = @{@"myView":view1};
    NSString *formatH           = @"H:|-left-[myView]-right-|";
    NSString *formatV           = @"V:|-top-[myView]-bottom-|";
    NSDictionary *metricsH       = @{@"left":@20, @"right": @20};
    NSDictionary *metricsV       = @{@"top":@20, @"bottom": @20};
    NSArray *constraintsH        = [NSLayoutConstraint constraintsWithVisualFormat:formatH options:NSLayoutFormatDirectionLeadingToTrailing metrics:metricsH views:views];
    NSArray *constraintsV        = [NSLayoutConstraint constraintsWithVisualFormat:formatV options:NSLayoutFormatDirectionLeadingToTrailing metrics:metricsV views:views];
    [self.imgvGreen addConstraints:constraintsH];
    [self.imgvGreen addConstraints:constraintsV];
    
    
    
    
    view2.translatesAutoresizingMaskIntoConstraints = NO;
//    NSDictionary * metrics  = @{@"left":@5,@"right":@5,@"height":@150.0};
    NSString * format       = @"[view2(200.0,30)]";
    NSDictionary *views2    = @{@"view2":view2};
    NSArray *constraintsH2  = [NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views2];
    [view2 addConstraints:constraintsH2];
//
//
//    NSString * format2       = @"V:|-[view2(20.0)]";
//    NSArray *constraintsV2  = [NSLayoutConstraint constraintsWithVisualFormat:format2 options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views2];
//    [view2 addConstraints:constraintsV2];
    


    
    
    
    
    
//    NSString *hVFL = @"H:|-space-[leftView(==rightView)]-space1-[rightView]-space-|";
//    
//    NSDictionary *metircs = @{@"space":@20,@"space1":@30};
//    
//    NSDictionary *views = @{@"leftView":view1,@"rightView":view2};
//
//    NSArray *hconstraint = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:NSLayoutFormatDirectionLeadingToTrailing metrics:metircs views:views];
//    
//    [self.view addConstraints:hconstraint];
    
    
    
    
    
//    [NSLayoutConstraint constraintsWithVisualFormat:<#(nonnull NSString *)#> options:<#(NSLayoutFormatOptions)#> metrics:<#(nullable NSDictionary<NSString *,id> *)#> views:<#(nonnull NSDictionary<NSString *,id> *)#>]
}


@end
