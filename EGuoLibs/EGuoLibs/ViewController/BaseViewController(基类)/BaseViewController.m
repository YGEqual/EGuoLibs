//
//  BaseViewController.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/5/28.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

static NSString *EGuoLibsBaseCellID = @"EGuoLibsBaseCellID";

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

//self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//-(void)backAction{
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
