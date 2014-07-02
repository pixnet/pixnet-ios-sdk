//
//  PIXUser.m
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/3/22.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import "PIXUser.h"
#import "NSError+PIXCategory.h"
#import "NSObject+PIXCategory.h"

@implementation PIXUser

-(void)editAccountWithPassword:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email gender:(PIXUserGender)gender address:(NSString *)address phone:(NSString *)phone birth:(NSDate *)birth education:(PIXUserEducation)education avatar:(UIImage *)avatar completion:(PIXHandlerCompletion)completion{
    if (password == nil || password.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing password"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    params[@"password"] = password;
    if (displayName) {
        params[@"display_name"] = displayName;
    }
    if (email) {
        params[@"email"] = email;
    }
    NSString *genderString = nil;
    switch (gender) {
        case PIXUserGenderFemale:
            genderString = @"0";
            break;
        case PIXUserGenderMale:
            genderString = @"1";
            break;
        case PIXUserGenderNone:
        default:
            break;
    }
    if (genderString) {
        params[@"gender"] = genderString;
    }
    if (address) {
        params[@"address"] = address;
    }
    if (phone) {
        params[@"phone"] = phone;
    }
    if (birth) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyyMMdd"];
        params[@"birth"] = [formatter stringFromDate:birth];
    }
    NSString *educationString = nil;
    switch (education) {
        case PIXUserEducationJuniorHigh:
            educationString = @"中學以下";
            break;
        case PIXUserEducationSeniorHigh:
            educationString = @"高中/高職";
            break;
        case PIXUserEducationJuniorCollege:
            educationString = @"專科";
            break;
        case PIXUserEducationCollege:
            educationString = @"大學";
            break;
        case PIXUserEducationGradurate:
            educationString = @"研究所";
            break;
        case PIXUserEducationNone:
        default:
            break;
    }
    if (educationString) {
        params[@"education"] = educationString;
    }
#warning 大頭照的更新還沒完成，待後台修正
    if (avatar) {
        NSData *data = UIImageJPEGRepresentation(avatar, 1.0);
        NSData *encodedData = nil;
        if ([data respondsToSelector:@selector(base64EncodedDataWithOptions:)]) {
            encodedData = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } else {
            #pragma GCC diagnostic push
            #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            encodedData = [[data base64Encoding] dataUsingEncoding:NSUTF8StringEncoding];
            #pragma GCC diagnostic pop
        }
        params[@"avatar"] = encodedData;
    }
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"account/info", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}

-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing userName"]);
        return;
    }
    
    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[[NSString stringWithFormat:@"users/%@", userName], [NSNull null], completion] receiver:[PIXAPIHandler new]];
}

-(void)getAccountWithNotification:(BOOL)withNotification notificationType:(PIXUserNotificationType)notificationType withBlogInfo:(BOOL)withBlogInfo withMib:(BOOL)withMib withAnalytics:(BOOL)withAnalytics completion:(PIXHandlerCompletion)completion{
    NSString *typeString = nil;
    switch (notificationType) {
        case PIXUserNotificationTypeAppMarket:
            typeString = @"appmarket";
            break;
        case PIXUserNotificationTypeComment:
            typeString = @"comment";
            break;
        case PIXUserNotificationTypeFriend:
            typeString = @"friend";
            break;
        case PIXUserNotificationTypeSystem:
            typeString = @"system";
            break;
        case PIXUserNotificationTypeAll:
        default:
            break;
    }
    NSMutableDictionary *params = nil;
    if (typeString) {
        params = [NSMutableDictionary dictionaryWithCapacity:5];
        params[@"notification_type"] = typeString;
    } else {
        params = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    params[@"with_notification"] = [NSString stringWithFormat:@"%i", withNotification];
    params[@"with_blog_info"] = [NSString stringWithFormat:@"%i", withBlogInfo];
    params[@"with_mib"] = [NSString stringWithFormat:@"%i", withMib];
    params[@"with_analytics"] = [NSString stringWithFormat:@"%i", withAnalytics];
    
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:uploadData:parameters:requestCompletion:) parameters:@[@"account", @"GET", @YES, [NSNull null], params, completion] receiver:[PIXAPIHandler new]];
}



@end
