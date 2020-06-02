//
//  EGButton.h
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGButton : UIButton

@property(nonatomic, copy) NSString *btntitle;

-(void)addTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
