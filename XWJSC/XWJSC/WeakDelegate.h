//
//  WeakDelegate.h
//  XWJSC
//
//  Created by xuewu.long on 16/11/3.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

//JSExportAs(<#PropertyName#>, <#Selector#>)
@protocol JSExportProtocalDelegate <JSExport>

- (void)jsCallMethod1;
- (void)jsCallMethod2:(id)item;
- (id)jsCallMethod3:(id)item;

@end


@interface WeakDelegate : NSObject <WKScriptMessageHandler, JSExportProtocalDelegate>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
@property (nonatomic, weak) id<JSExportProtocalDelegate> jsExportDelegate;
- (instancetype)initWithWKScriptMessageHandlerDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
- (instancetype)initWithJSExportProtocalDelegate:(id<JSExportProtocalDelegate>)jsExportDelegate;


//- (void)jsCallMethod1;
//- (void)jsCallMethod2:(id)item;
//- (id)jsCallMethod3:(id)item;

@end
