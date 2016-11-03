//
//  ViewController.h
//  XWJSC
//
//  Created by xuewu.long on 16/10/27.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>


//如果有Debug这个宏的话,就允许log输出...可变参数
//#ifdef DEBUG
//#define NSLog(fmt, ...) NSLog((@"%s [Line %d]" fmt), __PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
//#else
//#define NSLog(...)
//#endif

#define delayTime   2.0f


@interface ViewController : UIViewController


- (void)showHint:(NSString *)hint hide:(CGFloat)delay;


@end

