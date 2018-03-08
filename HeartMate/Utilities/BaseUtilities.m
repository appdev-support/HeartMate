//
//  BaseUtilities.m
//  HeartMate
//
//  Created by xaoxuu on 06/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BaseUtilities.h"
#import <AXKit/FeedbackKit.h>

@implementation BaseUtilities

/**
 邮箱是否有效
 
 @param email 邮箱
 @return 是否有效
 */
+ (BOOL)validatedEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


/**
 中国手机号是否有效
 
 @param phoneNumber 手机号
 @return 是否有效
 */
+ (BOOL)validatedPhoneNumber:(NSString *)phoneNumber{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

/**
 日期描述（今天、昨天、2018-03-07 星期三）
 
 @param date 日期
 @return 描述
 */
+ (NSString *)descriptionForDate:(NSDate *)date{
    NSDate *today = [NSDate date];
    if (date.integerValue == today.integerValue) {
        return NSLocalizedString(@"Today", @"今天");
    } else if (date.addDays(1).integerValue == today.integerValue) {
        return NSLocalizedString(@"Yesterday", @"昨天");
    } else {
        return date.stringValue(@"yyyy-MM-dd EEEE");
    }
}

+ (NSString *)descriptionForTime:(NSDate *)time{
    NSDate *today = [NSDate date];
    if (time.integerValue == today.integerValue) {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Today", @"今天"), time.stringValue(@"HH:mm:ss")];
    } else if (time.addDays(1).integerValue == today.integerValue) {
        return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Yesterday", @"昨天"), time.stringValue(@"HH:mm:ss")];
    } else {
        return [NSString stringWithFormat:@"%@", time.stringValue(@"MM-dd HH:mm:ss")];
    }
    
}

+ (NSString *)descriptionForAppVersion{
    return [NSString stringWithFormat:@"%@ (%@)", [NSBundle ax_appVersion], [NSBundle ax_appBuild]];
}

+ (NSString *)descriptionForCurrentWeekday{
    return [NSDate date].stringValue(@"EEEE");
}
+ (NSString *)descriptionForCurrentTimeInDay{
    NSString *tag;
    NSInteger hour = [NSDate date].stringValue(@"HH").integerValue;
    if (hour < 5) {
        tag = NSLocalizedString(@"Before Dawn", @"凌晨");
    } if (hour >= 5 && hour < 9) {
        tag = NSLocalizedString(@"Morning", @"早上");
    } else if (hour >= 9 && hour < 11) {
        tag = NSLocalizedString(@"Forenoon", @"上午");
    } else if (hour >= 11 && hour < 14) {
        tag = NSLocalizedString(@"Nooning", @"中午");
    } else if (hour >= 14 && hour < 19) {
        tag = NSLocalizedString(@"Afternoon", @"下午");
    } else {
        tag = NSLocalizedString(@"Evening", @"晚上");
    }
    return tag;
}
+ (CGFloat)bmiWithHeight:(CGFloat)height weight:(CGFloat)weight{
    CGFloat bmi = weight / pow(height, 2);
    return bmi;
}

+ (void)sendFeedbackEmail{
    [[EmailManager sharedInstance] sendEmail:^(MFMailComposeViewController * _Nonnull mailCompose) {
        mailCompose.navigationBar.barStyle = UIBarStyleDefault;
        mailCompose.navigationBar.translucent = NO;
        mailCompose.navigationBar.opaque = YES;
        mailCompose.navigationBar.barTintColor = axThemeManager.color.background;
        mailCompose.navigationBar.tintColor = axThemeManager.color.theme;
        mailCompose.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:axThemeManager.color.theme, NSFontAttributeName:[UIFont fontWithName:axThemeManager.font.name size:20]};
        
        [mailCompose setToRecipients:@[@"feedback@xaoxuu.com"]];
        [mailCompose setSubject:@"Heart Mate"];
        
        
        [mailCompose setMessageBody:[NSString stringWithFormat:@"\n\n\n\napp name:%@ \napp version: %@",[NSBundle ax_appDisplayName], [self descriptionForAppVersion]] isHTML:NO];
        
    } completion:^(MFMailComposeResult result) {
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

+ (NSURL *)developerURL{
    return [NSURL URLWithString:@"https://xaoxuu.com"];
}

@end
