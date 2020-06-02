//  UIView+Toast.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "UIView+EGKitToast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat EGKitToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat EGKitToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat EGKitToastHorizontalPadding   = 10.0;
static const CGFloat EGKitToastVerticalPadding     = 10.0;
static const CGFloat EGKitToastCornerRadius        = 10.0;
static const CGFloat EGKitToastOpacity             = 0.8;
static const CGFloat EGKitToastFontSize            = 16.0;
static const CGFloat EGKitToastMaxTitleLines       = 0;
static const CGFloat EGKitToastMaxMessageLines     = 0;
static const NSTimeInterval EGKitToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat EGKitToastShadowOpacity       = 0.8;
static const CGFloat EGKitToastShadowRadius        = 6.0;
static const CGSize  EGKitToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    EGKitToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval EGKitToastDefaultDuration  = 1.0;

// image view size
static const CGFloat EGKitToastImageViewWidth      = 80.0;
static const CGFloat EGKitToastImageViewHeight     = 80.0;

// activity
static const CGFloat EGKitToastActivityWidth       = 100.0;
static const CGFloat EGKitToastActivityHeight      = 100.0;
static const NSString * EGKitToastActivityDefaultPosition = @"center";

// interaction
static const BOOL EGKitToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * EGKitToastTimerKey         = @"CSToastTimerKey";
static const NSString * EGKitToastActivityViewKey  = @"CSToastActivityViewKey";
static const NSString * EGKitToastTapCallbackKey   = @"CSToastTapCallbackKey";

// positions
NSString * const EGKitToastPositionTop             = @"top";
NSString * const EGKitToastPositionCenter          = @"center";
NSString * const EGKitToastPositionBottom          = @"bottom";

@interface UIView (EGKitToastPrivate)

- (void)egkit_hideToast:(UIView *)toast;
- (void)egkit_toastTimerDidFinish:(NSTimer *)timer;
- (void)egkit_handleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)egkit_centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)egkit_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
- (CGSize)egkit_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@implementation UIView (EGKitToast)

#pragma mark - Toast Methods

- (void)egkit_makeToast:(NSString *)message {
    [self egkit_makeToast:message duration:EGKitToastDefaultDuration position:EGKitToastPositionCenter];
}

- (void)egkit_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self egkit_viewForMessage:message title:nil image:nil];
    [self egkit_showToast:toast duration:duration position:position];
}

- (void)egkit_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self egkit_viewForMessage:message title:title image:nil];
    [self egkit_showToast:toast duration:duration position:position];
}

- (void)egkit_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image {
    UIView *toast = [self egkit_viewForMessage:message title:nil image:image];
    [self egkit_showToast:toast duration:duration position:position];  
}

- (void)egkit_makeToast:(NSString *)message duration:(NSTimeInterval)duration  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self egkit_viewForMessage:message title:title image:image];
    [self egkit_showToast:toast duration:duration position:position];
}

- (void)egkit_showToast:(UIView *)toast {
    [self egkit_showToast:toast duration:EGKitToastDefaultDuration position:nil];
}


- (void)egkit_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    [self egkit_showToast:toast duration:duration position:position tapCallback:nil];
    
}


- (void)egkit_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position
      tapCallback:(void(^)(void))tapCallback
{
    toast.center = [self egkit_centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    if (EGKitToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(egkit_handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:EGKitToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(egkit_toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &EGKitToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (toast, &EGKitToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}


- (void)egkit_hideToast:(UIView *)toast {
    [UIView animateWithDuration:EGKitToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)egkit_toastTimerDidFinish:(NSTimer *)timer {
    [self egkit_hideToast:(UIView *)timer.userInfo];
}

- (void)egkit_handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &EGKitToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &EGKitToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self egkit_hideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)egkit_makeToastActivity {
    [self egkit_makeToastActivity:EGKitToastActivityDefaultPosition];
}

- (void)egkit_makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &EGKitToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EGKitToastActivityWidth, EGKitToastActivityHeight)];
    activityView.center = [self egkit_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:EGKitToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = EGKitToastCornerRadius;
    
    if (EGKitToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = EGKitToastShadowOpacity;
        activityView.layer.shadowRadius = EGKitToastShadowRadius;
        activityView.layer.shadowOffset = EGKitToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &EGKitToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:EGKitToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)egkit_hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &EGKitToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:EGKitToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &EGKitToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)egkit_centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:EGKitToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + EGKitToastVerticalPadding);
        } else if([point caseInsensitiveCompare:EGKitToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - EGKitToastVerticalPadding);
}

- (CGSize)egkit_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)egkit_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = EGKitToastCornerRadius;
    
    if (EGKitToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = EGKitToastShadowOpacity;
        wrapperView.layer.shadowRadius = EGKitToastShadowRadius;
        wrapperView.layer.shadowOffset = EGKitToastShadowOffset;
    }

    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:EGKitToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(EGKitToastHorizontalPadding, EGKitToastVerticalPadding, EGKitToastImageViewWidth, EGKitToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = EGKitToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = EGKitToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:EGKitToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * EGKitToastMaxWidth) - imageWidth, self.bounds.size.height * EGKitToastMaxHeight);
        CGSize expectedSizeTitle = [self egkit_sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = EGKitToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:EGKitToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * EGKitToastMaxWidth) - imageWidth, self.bounds.size.height * EGKitToastMaxHeight);
        CGSize expectedSizeMessage = [self egkit_sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = EGKitToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + EGKitToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + EGKitToastHorizontalPadding;
        messageTop = titleTop + titleHeight + EGKitToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }

    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (EGKitToastHorizontalPadding * 2)), (longerLeft + longerWidth + EGKitToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + EGKitToastVerticalPadding), (imageHeight + (EGKitToastVerticalPadding * 2)));
                         
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
        
    return wrapperView;
}

@end
