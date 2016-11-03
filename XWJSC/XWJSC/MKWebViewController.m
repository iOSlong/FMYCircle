//
//  MKWebViewController.m
//  XWJSC
//
//  Created by xuewu.long on 16/10/27.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "MKWebViewController.h"
#import <WebKit/WebKit.h>
#import "WeakDelegate.h"

@interface MKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UITextFieldDelegate>

@property (nonatomic, strong) WKWebView   *mywkView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation MKWebViewController

- (WKWebView *)mywkView {
    if (!_mywkView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // web内容处理池
        config.processPool = [[WKProcessPool alloc] init];
        
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        
        // 注入JS对象名称jsCallMethod，当JS通过hanleName来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        // [config.userContentController addScriptMessageHandler:id<delegate> name:@"setCount"];
        [config.userContentController addScriptMessageHandler:[[WeakDelegate alloc] initWithWKScriptMessageHandlerDelegate:self] name:@"jsCallNoti1"];
        [config.userContentController addScriptMessageHandler:[[WeakDelegate alloc] initWithWKScriptMessageHandlerDelegate:self] name:@"jsCallNoti2"];
        
        // config.dataDetectorTypes     = UIDataDetectorTypeAll;
        
        _mywkView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.textField.center.y + 20, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - self.textField.center.y - 20) configuration:config];
        _mywkView.backgroundColor       = [UIColor whiteColor];
        _mywkView.navigationDelegate    = self;
        _mywkView.UIDelegate            = self;
        _mywkView.allowsBackForwardNavigationGestures = YES;
        
    }
    return _mywkView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MKWebView";
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;

    [self loadLocalItems];
    
    [self.view addSubview:self.mywkView];

    
    
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
        [self.mywkView evaluateJavaScript:@"alert('alert Show')" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"%@",obj);
        }];
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
        [self.mywkView evaluateJavaScript:callJS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"%@",obj);
        }];
    }
}




- (void)loadWebContent {
    NSURL *localHtmlURL = [NSURL URLWithString:@"https://github.com"];
    localHtmlURL =  [[NSBundle mainBundle] URLForResource:@"mkweb" withExtension:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfURL:localHtmlURL encoding:NSUTF8StringEncoding error:nil];
    NSURL *sourceUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.mywkView loadHTMLString:htmlString baseURL:sourceUrl];
}

#pragma mark - WKNavigationDelegate  &  WKUIDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation { // 类似UIWebView的 -webViewDidStartLoad:
    NSLog(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
    /*
     important ,添加这行代码，WebView详情页面才能够实现右滑回到上一个界面的功能。
     三种情况，
     1. 不能右滑动
     2. 加载静态HTML文本或者其他HTML正常文本，可以右滑动，切UINavigationController+XKObjcSugar得到发挥
     3. 现下情况，h5有一些问题，所以添加代码，实现系统原生效果，在触及最右侧时候可以进行右滑，与Android效果一致。
     */
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.mywkView.allowsBackForwardNavigationGestures = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似 UIWebView 的 －webViewDidFinishLoad:
    NSLog(@"didFinishNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 判断本地数据库是否存在数据
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    NSLog(@"didFailProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}



#pragma mark  WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@",message.name);
    NSLog(@"%@",message.body);
    
    NSString *imgLocalJS = @"jsImageHaveOne(100)";
    __weak __typeof(self) weakself = self;
    [self.mywkView evaluateJavaScript:imgLocalJS completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        NSLog(@"%@",error);
        NSLog(@"滑动到评论区域");
    }];

    if ([message.name isEqualToString:@"jsCallNoti1"]) {
        NSLog(@"%s",__FUNCTION__);
        [weakself showHint:[NSString stringWithUTF8String:__FUNCTION__] hide:delayTime];
    }else if ([message.name isEqualToString:@"jsCallNoti2"]) {
        NSLog(@"%s :%@",__FUNCTION__, message.body);
        [self showHint:[NSString stringWithFormat:@"js giveVal:%@",message.body] hide:delayTime];
    }
    
}






#pragma mark - AlertDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
}


- (void)dealloc {
    NSLog(@"%s",__func__);
    [[_mywkView configuration].userContentController removeScriptMessageHandlerForName:@"jsCallNoti1"];
    [[_mywkView configuration].userContentController removeScriptMessageHandlerForName:@"jsCallNoti2"];
    [_mywkView stopLoading];
    _mywkView = nil;
}



@end
