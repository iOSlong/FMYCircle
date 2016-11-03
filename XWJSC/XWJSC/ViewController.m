//
//  ViewController.m
//  XWJSC
//
//  Created by xuewu.long on 16/10/27.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)showHint:(NSString *)hint hide:(CGFloat)delay{
    __block NSString *hintBlock = hint;
    __block BOOL blockEnableBackgroundInteraction = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        //TBLog(@"show hint loading");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        // 如果允许操作下面的view, 需要禁用 mb 本身的userInteraction.
        hud.userInteractionEnabled = !blockEnableBackgroundInteraction;
        [hud.detailsLabel setFont:[UIFont systemFontOfSize:15 ]];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud.detailsLabel setText:hintBlock];
        [hud hideAnimated:YES afterDelay:delay];
        hud.center = CGPointMake(hud.center.x, 200);
    });
}


/**
 参考文档：
    1. http://nshipster.cn/javascriptcore/
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
