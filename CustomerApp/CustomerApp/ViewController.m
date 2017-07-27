//
//  ViewController.m
//  CustomerApp
//
//  Created by LSJ on 2017/7/27.
//  Copyright © 2017年 Foxit. All rights reserved.
//

#import "ViewController.h"

#define AppGroupID @"group.com.appgroup.demo.group"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableData = [NSMutableArray array];
    [self prepareData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainCell = @"mainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: mainCell];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cell.frame.size.width, 40)];
        label.tag = 100;
        label.textColor = [UIColor blackColor];
        label.font =[UIFont systemFontOfSize:16.0f];
        [cell.contentView addSubview:label];
    }
    UILabel *label = [cell.contentView viewWithTag:100];
    NSString *filePath = [tableData objectAtIndex:indexPath.row];
    label.text = [filePath lastPathComponent];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = [tableData objectAtIndex:indexPath.row];
    [self openOtherApp:filePath];
}

- (void)prepareData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:docsDir];
    NSString *fileName;
    while (fileName = [dirEnum nextObject]) {
        [tableData addObject:[docsDir stringByAppendingPathComponent:fileName]];
    }
}

- (void)openOtherApp:(NSString*)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AppGroupID];
    NSURL *destGroupURL = [groupURL URLByAppendingPathComponent:[filePath lastPathComponent]];
    
    NSData *sourceData = [NSData dataWithContentsOfFile:filePath];
    
    [sourceData writeToURL:destGroupURL atomically:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"FoxitApp://fromCustomerApp%@",destGroupURL.absoluteString];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
