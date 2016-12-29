//
//  XWJLibsTableViewController.m
//  XWJSC
//
//  Created by xuewu.long on 16/12/26.
//  Copyright © 2016年 fmylove. All rights reserved.
//

#import "XWJLibsTableViewController.h"
#import "XMRACBaseViewController.h"

@interface XWJLibsTableViewController ()

@property (nonatomic) NSMutableArray<NSArray *> *arrDataSource;

@end

@implementation XWJLibsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LibTool";
    
    self.arrDataSource = [NSMutableArray array];
    
    
    NSArray  *sectionRAC = @[@"RACSiganl简单使用",
                             @"RACSubject简单使用",
                             @"RACReplaySubject的简单使用",
                             @"RACSequence和RACTuple简单使用",
                             @"字典转模型",
                             @"RACMulticastConnection简单使用",
                             @"RACCommand简单使用",
                             @"ReactiveCocoa常见宏"];
    
    [self.arrDataSource addObject:sectionRAC];
    
    [self.tableView reloadData];
    
}



#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return  @"ReactiveCocoa基本使用";
    }
    return  @"Others ……";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrDataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"libCellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *sectionArr = self.arrDataSource[indexPath.section];
    cell.textLabel.text = sectionArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMRACBaseViewController *racBaseVC = [[XMRACBaseViewController alloc] init];
    [self.navigationController pushViewController:racBaseVC animated:YES];
    
}



@end
