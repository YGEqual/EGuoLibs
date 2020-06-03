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

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showAlert:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertVC addAction:firstAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
