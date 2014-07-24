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

-(void)updateAccountWithPassword:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email gender:(PIXUserGender)gender address:(NSString *)address phone:(NSString *)phone birth:(NSDate *)birth education:(PIXUserEducation)education avatar:(UIImage *)avatar completion:(PIXHandlerCompletion)completion{
    if (password == nil || password.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing password"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:11];
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
//TODO: 大頭照的更新還沒完成，待後台修正
    if (avatar) {
        /*
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
         */
        params[@"avatar"] = [self PIXEncodedImageData:avatar];
        params[@"upload_method"] = @"base64";
    }
    [[PIXAPIHandler new] callAPI:@"account/info" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"account/info", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}

-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing userName"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"users/%@", userName];
    [[PIXAPIHandler new] callAPI:path parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[[NSString stringWithFormat:@"users/%@", userName], [NSNull null], completion] receiver:[PIXAPIHandler new]];
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

    [[PIXAPIHandler new] callAPI:@"account" httpMethod:@"GET" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:uploadData:parameters:requestCompletion:) parameters:@[@"account", @"GET", @YES, [NSNull null], params, completion] receiver:[PIXAPIHandler new]];
}

-(void)getAccountMIBWithHistoryDays:(NSUInteger)historyDays completion:(PIXHandlerCompletion)completion{
    if (historyDays<1) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"historyDays 不可小於1"]);
        return;
    }
    
    NSDictionary *param = @{@"history_days":[NSString stringWithFormat:@"%lu", historyDays]};
    [[PIXAPIHandler new] callAPI:@"account/mib" httpMethod:@"GET" shouldAuth:YES parameters:param requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"account/mib", @"GET", @YES, param, completion] receiver:[PIXAPIHandler new]];
}
-(void)createAccountMIBWithRealName:(NSString *)realName idNumber:(NSString *)idNumber idImageFront:(UIImage *)idImageFront idImageBack:(UIImage *)idImageBack email:(NSString *)email cellPhone:(NSString *)cellPhone mailAddress:(NSString *)mailAddress domicile:(NSString *)domicile enableVideoAd:(BOOL)enableVideoAd completion:(PIXHandlerCompletion)completion{
    if (!realName || realName.length==0 || !idNumber || idNumber.length==0 || !idImageFront || !idImageBack || !email || email.length==0 || !cellPhone || cellPhone.length==0 || !mailAddress || mailAddress.length==0 || !domicile || domicile.length==0) {
        completion(NO, nil , [NSError PIXErrorWithParameterName:@"缺乏必要參數"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    params[@"id_number"] = idNumber;

    params[@"upload_method"] = @"base64";
    params[@"id_image_front"] = [self PIXEncodedStringWithImage:idImageFront];
    params[@"id_image_back"] = [self PIXEncodedStringWithImage:idImageBack];

    params[@"email"] = email;
    params[@"cellphone"] = cellPhone;
    params[@"mail_address"] = mailAddress;
    params[@"domicile"] = domicile;
    params[@"enable_video_ad"] = [NSString stringWithFormat:@"%i", enableVideoAd];
    params[@"name"] = realName;
    [[PIXAPIHandler new] callAPI:@"account/mib" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"account/mib", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
    
//    NSDictionary *upload1 = @{@"id_image_front": UIImageJPEGRepresentation(idImageFront, 1.0)};
//    NSDictionary *upload2 = @{@"id_image_back": UIImageJPEGRepresentation(idImageBack, 1.0)};
//    NSArray *uploads = @[upload1, upload2];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:uploadData:parameters:requestCompletion:) parameters:@[@"account/mib", @"POST", @YES, uploads, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)getAccountMIBPositionWithPositionID:(NSString *)positionId completion:(PIXHandlerCompletion)completion{
    if (!positionId || positionId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"positionId 有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"account/mib/positions/%@", positionId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"GET" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"GET", @YES, [NSNull null], completion] receiver:[PIXAPIHandler new]];
}
-(void)updateAccountMIBPositionWithPositionID:(NSString *)positionId enabled:(NSNumber *)enabled fixedAdBox:(NSNumber *)fixedAdBox completion:(PIXHandlerCompletion)completion{
    if (!positionId || positionId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"positionId 是必要欄位"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"account/mib/positions/%@", positionId];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    if (enabled) {
        params[@"enabled"] = [enabled stringValue];
    }
    if (fixedAdBox) {
        params[@"fixedadbox"] = [fixedAdBox stringValue];
    }
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)askAccountMIBPayWithCompletion:(PIXHandlerCompletion)completion{
    [[PIXAPIHandler new] callAPI:@"account/mibpay" httpMethod:@"GET" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"account/mibpay", @"GET", @YES, [NSNull null], completion] receiver:[PIXAPIHandler new]];
}
-(void)getAccountAnalyticsWithStaticDays:(NSUInteger)staticDays referDays:(NSUInteger)referDays completion:(PIXHandlerCompletion)completion{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    if (staticDays) {
        params[@"statics_days"] = [NSString stringWithFormat:@"%lu", staticDays];
    }
    if (referDays) {
        params[@"refer_days"] = [NSString stringWithFormat:@"%lu", referDays];
    }
    [[PIXAPIHandler new] callAPI:@"account/analytics" httpMethod:@"GET" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"account/analytics", @"GET", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)updateAccountPasswordWithOriginalPassword:(NSString *)originalPassword newPassword:(NSString *)newPassword completion:(PIXHandlerCompletion)completion{
    if (!originalPassword || originalPassword.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"原始密碼有誤"]);
        return;
    }
    if (!newPassword || newPassword.length<4) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"新密碼格式有誤"]);
        return;
    }
    NSDictionary *params = @{@"password":originalPassword, @"new_password": newPassword};
    [[PIXAPIHandler new] callAPI:@"account/password" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"account/password", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
@end
