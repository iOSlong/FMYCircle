//
//  XMRACBaseViewController.m
//  XWJSC
//
//  Created by xuewu.long on 16/12/26.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "XMRACBaseViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "XWJSC-Swift.h"
#import "XWARCSignlView.h"


@interface XMRACBaseViewController ()

@property (nonatomic, strong) RACSubject    *subscriber;
@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) UILabel   *labelInfo;
@property (nonatomic, strong) UIButton  *btnSignal;

@end

@implementation XMRACBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC_Base ";
    
    [self signal];
    
    
    [self subject];
    
    [self replaySubject];
    
    
    [self arrayTuple];
    
    [self dictTuple];
    
    [self dicToModel];
    
    
    [self multicastConnection];
    
    
    [self command];
    
    
    [self racMacro];
    
    [self racObserve];
    
    [self racTupleAbout];
    
    
    [self signalForSelector];
}

// RACSignal使用步骤：
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id subscriber))didSubscribe
// 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 - (void)sendNext:(id)value
- (void)signal{
    
    // 1. 创建信号
    weakSelf();
    RACSignal *signal   = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        strongSelf();
        strongSelf.subscriber = subscriber;
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"默认信号发送完毕被取消");
        }];
    }];
    
    
    // 2. 订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [self.subscriber sendNext:@1];
    
    
    // 取消订阅
    [disposable dispose];
}

// RACSubject使用步骤
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 sendNext:(id)value
- (void)subject {
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者一%@",x);

    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者二%@",x);

    }];
    
    
    // 发送信号
    [subject sendNext:@"111"];
    
}


// RACReplaySubject使用步骤:
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.可以先订阅信号，也可以先发送信号。
// 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 2.2 发送信号 sendNext:(id)value
- (void)replaySubject {
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //发送信号
    [replaySubject sendNext:@"222"];
    
    [replaySubject sendNext:@"333"];

    //订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    
    //如果想一个信号被订阅，就重复播放之前所有值，需要先发送信号，再订阅信号。
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    

}
//RACTuple:元组类,类似NSArray,用来包装值.
//RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
//使用场景：1.字典转模型
- (void)arrayTuple {
    NSArray *array = @[@1,@2,@3];
    
    [array.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

- (void)dictTuple {
    NSDictionary *dict = @{@"name":@"张三",@"age":@"20",@"sex":@"男"};
    
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        // RACTupleUnpack这是个宏,后面会介绍
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        NSLog(@"%@---%@",key,value);
        
        //相当与
        //        NSString *key = x[0];
        //        NSString *value = x[1];
    }];
}

//  RAC高级写法:
- (void)dicToModel {
    NSArray *array = @[@{@"name":@"关羽",@"ID":@"1"},
                       @{@"name":@"张飞",@"ID":@"2"},
                       @{@"name":@"赵云",@"ID":@"3"},
                       @{@"name":@"马超",@"ID":@"4"},
                       @{@"name":@"黄忠",@"ID":@"5"}];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *musicArray = [[array.rac_sequence map:^id(id value) {
        MTTest *test = [[MTTest alloc] init];
        [test setValuesForKeysWithDictionary:value];
        return test;
    }] array];

    NSLog(@"%@",musicArray);
}



//RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
//
//使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
//
//
//
// RACMulticastConnection使用步骤:
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id subscriber))didSubscribe
// 2.创建连接 RACMulticastConnection *connect = [signal publish];
// 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
// 4.连接 [connect connect]
// 5.发送信号

// 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
// 解决：使用RACMulticastConnection就能解决.
- (void)multicastConnection {
    
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        
        NSLog(@"请求一次");
        
        //5.发送信号
        [subscriber sendNext:@"2"];
        
        return nil;
    }];
    
    //2.把信号转化为连接类
    RACMulticastConnection *connection = [signal publish];
    
    //3.订阅连接类信号
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第三个订阅者%@",x);
    }];
    
    //4.链接信号
    [connection connect];
}


//RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
//使用场景:监听按钮点击，网络请求
//
//
//RACCommand简单使用



// 一、RACCommand使用步骤:
// 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
// 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
// 3.执行命令 - (RACSignal *)execute:(id)input

// 二、RACCommand使用注意:
// 1.signalBlock必须要返回一个信号，不能传nil.
// 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
// 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。

// 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
// 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
// 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。

// 四、如何拿到RACCommand中返回信号发出的数据。
// 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
// 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。

- (void)command {
    
    //1创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //命令内部传递的参数
        NSLog(@"input===%@",input);
        
        //2.返回一个信号,可以返回一个空信号 [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable *(id subscriber) {
            
            NSLog(@"发送数据");
            //发送信号
            [subscriber sendNext:@"22"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    //强引用
//    __command = command;
    
    //拿到返回信号方式二:
    //command.executionSignals信号中的信号 switchToLatest转化为信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"拿到信号的方式二%@",x);
    }];
    
    //拿到返回信号方式一:
    RACSignal *signal =  [command execute:@"11"];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"拿到信号的方式一%@",x);
    }];
    
    //3.执行命令
    [command execute:@"11"];
    
    //监听命令是否执行完毕
    [command.executing subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            
            NSLog(@"命令正在执行");
        }
        else {
            
            NSLog(@"命令完成/没有执行");
        }
    }];
    
}

//RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
- (void)racMacro {
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(k_SpanLeft, 70, 200, 40)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.textField];
    self.labelInfo = [[UILabel alloc] initWithFrame:self.textField.frame];
    self.labelInfo.top = self.textField.bottom + k_SpanLeft;
    self.labelInfo.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.labelInfo];
    
    RAC(self.labelInfo, text) = self.textField.rac_textSignal;
}

//RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
- (void)racObserve {
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
//@weakify(Obj)和@strongify(Obj),一般两个都是配套使用,解决循环引用问题.
//RACTuplePack：把数据包装成RACTuple（元组类）
- (void)racTupleAbout {
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@10,@20);
    NSLog(@"tuple =%@",tuple);
    
//    RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
    // 把参数中的数据包装成元组
    RACTuple *tuple2 = RACTuplePack(@"ZKQ",@25);
    
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
//     name = @"ZKQ" age = <a href='http://www.jobbole.com/members/Laidong1306992'>@25</a>
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple2;
    NSLog("name = %@, age = %@",name,age);
}


- (void)signalForSelector {
    
    XWARCSignlView *signalView  = [[XWARCSignlView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    signalView.backgroundColor = [UIColor lightGrayColor];
    signalView.left = self.textField.left;
    signalView.top  = self.labelInfo.bottom + k_SpanLeft;
    
    [self.view addSubview:signalView];
//    rac_signalForSelector：用于替代代理。
//RACSubject:也用于代理.

    [[signalView rac_signalForSelector:@selector(signalBtnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击了蓝色视图上的按扭");
    }];
    
//    代替KVO :
//    rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
    [[signalView rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    
    self.btnSignal = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnSignal.bounds = self.textField.bounds;
    self.btnSignal.top      = signalView.bottom + k_SpanLeft;
    self.btnSignal.left     = signalView.left;
    [self.btnSignal setTitle:@"signalEvent" forState:UIControlStateNormal];
    self.btnSignal.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.btnSignal];
//    监听事件:
//    rac_signalForControlEvents：用于监听某个事件。
    [[self.btnSignal rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了按扭");
    }];
    
    


//    代替通知:
//      rac_addObserverForName:用于监听某个通知。
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘frame发生改变%@",x);
    }];
    
    
    
//    监听文本框文字改变:
//rac_textSignal:只要文本框发出改变就会发出这个信号。
    
    // 5.监听文本框的文字改变
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
