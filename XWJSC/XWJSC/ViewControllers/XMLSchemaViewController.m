//
//  XMLSchemaViewController.m
//  XWJSC
//
//  Created by xuewu.long on 16/12/21.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "XMLSchemaViewController.h"
#import "RegionCountry.h"

@interface XMLSchemaViewController ()<NSURLSessionDataDelegate,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RegionCountry *regionC;
@property (nonatomic, strong) NSMutableArray *list;
//标记当前标签，以索引找到XML文件内容
@property (nonatomic, copy) NSString *currentElement;

@end

@implementation XMLSchemaViewController{
    NSMutableData *_muData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RegionCountry";
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self netGetCityList];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"regionCountry";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
    }
    RegionCountry *regionC = self.list[indexPath.row];
    cell.textLabel.text = regionC.name;
    cell.detailTextLabel.text = regionC.ID;
    return cell;
}


#define kWeatherUrl @"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx"
- (void)netGetCityList {
    NSString *urlRegion = @"http://ws.webxml.com.cn/WebServices/WeatherWS.asmx/getRegionCountry";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRegion]];
//    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task =  [session dataTaskWithRequest:request];
    [task resume];
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data;
{
    if (_muData == nil) {
        _muData = [NSMutableData data];
    }
    
    [_muData appendData:data];
    NSLog(@"%@",_muData);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"error = %@",error);
    
    // TODO , 搁置到后台线程中去解析处理。
    NSXMLParser *par  = [[NSXMLParser alloc] initWithData:_muData];
    par.delegate = self;
    [par parse];

    NSString *dataStr = [[NSString alloc] initWithData:_muData encoding:NSUTF8StringEncoding];
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:_muData options:NSJSONReadingMutableContainers error:nil];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics{
    NSLog(@"%@",session);
}





//几个代理方法的实现，是按逻辑上的顺序排列的，但实际调用过程中中间三个可能因为循环等问题乱掉顺序
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidStartDocument...");
}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    self.currentElement = elementName;
    
    if ([self.currentElement isEqualToString:@"string"]){
        self.regionC = [[RegionCountry alloc] init];
    }
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([self.currentElement isEqualToString:@"string"])
    {
        [self.regionC setRegionCountry:string];
    }
    else if ([self.currentElement isEqualToString:@"others"]){
        NSLog(@"%@",string);
    }else{
        NSLog(@"%@",string);
    }
}

//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    if ([elementName isEqualToString:@"string"]) {
        NSLog(@"%@",self.currentElement);
        [self.list addObject:self.regionC];
    }
    self.currentElement = nil;
}

//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidEndDocument...");
    NSLog(@"%@",self.list);
    [self.tableView reloadData];
}


@end
