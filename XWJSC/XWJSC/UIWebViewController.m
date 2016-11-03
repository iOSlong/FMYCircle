//
//  UIWebViewController.m
//  XWJSC
//
//  Created by xuewu.long on 16/10/27.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "UIWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WeakDelegate.h"


@interface UIWebViewController ()<UIWebViewDelegate,JSExportProtocalDelegate,UITextFieldDelegate>

@property (strong, nonatomic)  UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;// must be strong
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) WeakDelegate *weakDelegate;
@end


@implementation UIWebViewController





- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,_textField.frame.origin.y + 150, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - _textField.frame.origin.y - 100)];
        _webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = YES;
        [_webView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)]];
    }
    return _webView;
}

#pragma mark - JSExportProtocalDelegate
- (void)jsCallMethod1 {
    NSLog(@"%s",__FUNCTION__);
    [self showHint:[NSString stringWithUTF8String:__FUNCTION__] hide:delayTime];
}

- (void)jsCallMethod2:(id)item {
    NSLog(@"%s :%@",__FUNCTION__, item);
    [self showHint:[NSString stringWithFormat:@"js giveVal:%@",item] hide:delayTime];
}

- (id)jsCallMethod3:(id)item {
    NSLog(@"%@",item);
    id retVal = [NSNumber numberWithInteger:1000];
    [self showHint:[NSString stringWithFormat:@"js giveVal:%@",item] hide:delayTime];
    return retVal;
}

- (void)tapEvent:(id)sender{
    NSLog(@"%s,",__FUNCTION__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"UIWebVeiw";
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.webView];
    
    
    [self loadLocalItems];

    [self loadWebContent];
    
}

- (void)loadLocalItems {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"Native Event to JS";
    [self.view addSubview:label];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(10, label.center.y + 20, 150, 20)];
    btn.layer.cornerRadius  = 10;
    btn.layer.borderColor   = [UIColor cyanColor].CGColor;
    btn.layer.borderWidth   = 1;
    [btn setTitle:@"CallJS withOut parm" forState:UIControlStateNormal];
    btn.tag = 1;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10,btn.center.y + 20, 250, 20)];
    _textField.delegate = self;
    _textField.font = [UIFont systemFontOfSize:12];
    _textField.textColor = [UIColor blueColor];
    _textField.layer.borderColor = [UIColor cyanColor].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.placeholder = @"输入需要通过JS传递的内容";
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textField];

    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setFrame:CGRectMake(_textField.center.x + 130, _textField.frame.origin.y, 80, 20)];
    btn2.layer.cornerRadius  = 10;
    btn2.layer.borderColor   = [UIColor cyanColor].CGColor;
    btn2.layer.borderWidth   = 1;
    [btn2 setTitle:@"CallJS " forState:UIControlStateNormal];
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:11]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 1) {
        [self.jsContext evaluateScript:@"alert('alert Show');"];
    }
    else if (btn.tag == 2)
    {
        NSDictionary *dict = @{@"title":_textField.text};
        NSData  *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        NSString *callJS = [NSString stringWithFormat:@"nativeGiveVal(%@)",jsonString];
        if (_textField.text.length == 0) {
            callJS = @"nativeGiveVal()";
        }
        [self.jsContext evaluateScript:callJS];
    }
}





- (void)loadWebContent {
    NSURL *localHtmlURL = [NSURL URLWithString:@"https://github.com"];
    localHtmlURL =  [[NSBundle mainBundle] URLForResource:@"uiweb" withExtension:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfURL:localHtmlURL encoding:NSUTF8StringEncoding error:nil];
    NSURL *sourceUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.webView loadHTMLString:htmlString baseURL:sourceUrl];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"");
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
//
    [self regestJSBlockMethods];
}


- (void)regestJSBlockMethods {
    
    __weak __typeof(self) weakself = self;
    //      注册JSContext Block 方法
    self.jsContext[@"jsCallMethod4"] = ^(){
        NSLog(@"%s",__FUNCTION__);
        [weakself showHint:[NSString stringWithUTF8String:__FUNCTION__] hide:delayTime];
    };
    
    self.jsContext[@"jsCallMethod5"] = ^(){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *obj in args) {
            NSLog(@"%s :%@",__FUNCTION__, obj);
            [weakself showHint:[NSString stringWithFormat:@"js giveVal:%@",obj] hide:delayTime];
        }
    };
    
    self.jsContext[@"jsCallMethod6"] = ^(NSNumber *returnVal){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *obj in args) {
            NSLog(@"%s :%@",__FUNCTION__, obj);
            [weakself showHint:[NSString stringWithFormat:@"js giveVal:%@",obj] hide:delayTime];
        }
        return [NSNumber numberWithInteger:2000];
    };
    
    
    //     JSExportProtocalDelegate 注册协议方法。
    //      注意，这个地方，如果将JSExport 代理直接指定为self， 会导致dealloc 无法调用，所以这个地方代理使用WeakDelegate取消直接联系。
    self.weakDelegate = [[WeakDelegate alloc] initWithJSExportProtocalDelegate:self];
    self.jsContext[@"JSExport"] = self.weakDelegate;
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.jsContext[@"JSExport"] = nil;
    self.jsContext = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}



@end
