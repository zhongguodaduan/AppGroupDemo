//
//  ViewController.h
//  FoxitApp
//
//  Created by LSJ on 2017/7/27.
//  Copyright © 2017年 Foxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (void)reloadData;

@end

