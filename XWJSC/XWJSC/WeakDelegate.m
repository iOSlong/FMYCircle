//
//  WeakDelegate.m
//  XWJSC
//
//  Created by xuewu.long on 16/11/3.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "WeakDelegate.h"

@implementation WeakDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate
{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (instancetype)initWithJSExportProtocalDelegate:(id<JSExportProtocalDelegate>)jsExportDelegate {
    self = [super init];
    if (self) {
        _jsExportDelegate = jsExportDelegate;
    }
    return self;
}
- (instancetype)initWithWKScriptMessageHandlerDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

- (void)jsCallMethod1;{
    NSLog(@"");
    [self.jsExportDelegate jsCallMethod1];

}
- (void)jsCallMethod2:(id)item;{
    NSLog(@"");
    [self.jsExportDelegate jsCallMethod2:item];
}
- (id)jsCallMethod3:(id)item;{
    NSLog(@"");
   return [self.jsExportDelegate jsCallMethod3:item];
    return nil;
}



@end
