//
//  EGPerformanceVC.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "EGPerformanceVC.h"
//持久化管理类
#import "EGPerformanceManager.h"
#import "EGButton.h"
#import "Person.h"


@interface EGPerformanceVC ()
@property(nonatomic, strong) EGButton *saveBtn;//保存
@property(nonatomic, strong) EGButton *readBtn;//读取
@property(nonatomic, strong) EGButton *archiveBtn;//归档
@property(nonatomic, strong) EGButton *unArchiveBtn;//解档

@end

@implementation EGPerformanceVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.saveBtn = [EGButton buttonWithType:UIButtonTypeCustom];
        self.saveBtn.btntitle = @"保存";
        [self.saveBtn addTarget:self action:@selector(saveAction:)];
        
        self.readBtn = [EGButton buttonWithType:UIButtonTypeCustom];
        self.readBtn.btntitle = @"读取";
        [self.readBtn addTarget:self action:@selector(readAction:)];
        
        self.archiveBtn = [EGButton buttonWithType:UIButtonTypeCustom];
        self.archiveBtn.btntitle = @"归档";
        [self.archiveBtn addTarget:self action:@selector(archieveAction:)];
        
        self.unArchiveBtn = [EGButton buttonWithType:UIButtonTypeCustom];
        self.unArchiveBtn.btntitle = @"解档";
        [self.unArchiveBtn addTarget:self action:@selector(unArchieveAction:)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.readBtn];
    [self.view addSubview:self.archiveBtn];
    [self.view addSubview:self.unArchiveBtn];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(UINavBarHeight + 20.f);
        make.left.equalTo(self.view.mas_left).offset(50.f);
        make.right.equalTo(self.view.mas_right).offset(-50.f);
        make.height.equalTo(@44.f);
    }];
    [self.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saveBtn.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(50.f);
        make.right.equalTo(self.view.mas_right).offset(-50.f);
        make.height.equalTo(@44.f);
    }];
    [self.archiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.readBtn.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(50.f);
        make.right.equalTo(self.view.mas_right).offset(-50.f);
        make.height.equalTo(@44.f);
    }];
    [self.unArchiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.archiveBtn.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(50.f);
        make.right.equalTo(self.view.mas_right).offset(-50.f);
        make.height.equalTo(@44.f);
    }];
}

#pragma mark - Action
//保存
- (void)saveAction:(UIButton *)button{
    NSArray *arr = @[@"fa",@"fsa",@"fasf1"];
    
    [[EGPerformanceManager sharedManager]writeToThePlist:CACHES_PATH(@"xx.plist") fileData:arr];
    
    [self.view egkit_makeToast:[NSString stringWithFormat:@"保存：%@成功",arr]];
}

//读取
- (void)readAction:(UIButton *)button{
    id fileData = [[EGPerformanceManager sharedManager]readFromThePlist:CACHES_PATH(@"xx.plist")];
    [self.view egkit_makeToast:[NSString stringWithFormat:@"fileData = %@",fileData]];
}

//归档
- (void)archieveAction:(UIButton *)button{
    Person *p = [Person new];
    p.name = @"wang ";
    p.nickName = @"wang - 1";
    p.isMan = YES;
    p.age = 18;
    
    [NSKeyedArchiver archiveRootObject:p toFile:DOCUMENT_PATH(@"person.data")];
    [self.view egkit_makeToast:@"归档成功！"];
}

//解档
- (void)unArchieveAction:(UIButton *)button{
    Person * p = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_PATH(@"person.data")];
    [self.view egkit_makeToast:[NSString stringWithFormat:@"person = %@/%@/%d/%@",p.name,p.nickName,p.age,p.isMan?@"nan":@"nv"]];
}

@end
