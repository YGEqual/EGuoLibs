//
//  EGButton.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "EGButton.h"

@implementation EGButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setMainUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMainUI];
    }
    return self;
}

// UI
- (void)setMainUI{
    self.backgroundColor = UIButtonBgColor;
    [self setTitleColor:UIColorWhite forState:UIControlStateNormal];
    self.layer.cornerRadius = 10.f;
}

-(void)setBtntitle:(NSString *)btntitle{
    _btntitle = btntitle;
    [self setTitle:_btntitle forState:UIControlStateNormal];
}

-(void)addTarget:(id)target action:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
