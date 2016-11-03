//
//  UIWebViewController.h
//  XWJSC
//
//  Created by xuewu.long on 16/10/27.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "ViewController.h"


@interface UIWebViewController : ViewController

/*
 JavaScript Type	JSValue method      Objective-C Type	Swift Type
    string              toString            NSString        String!
    boolean             toBool              BOOL            Bool
    number              toNumber            NSNumber
                        toDouble    double
                        toInt32
                        toUInt32
 
 int32_t
 uint32_t	NSNumber!
 Double
 Int32
 UInt32
 Date	toDate	NSDate	NSDate!
 Array	toArray	NSArray	[AnyObject]!
 Object	toDictionary	NSDictionary	[NSObject : AnyObject]!
 Object	toObject
 toObjectOfClass:	custom type	custom type
 */

@end
