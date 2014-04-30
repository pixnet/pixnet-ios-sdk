//
//  PIXCredentialStorage.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/8/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
#import "PIXCredentialStorage.h"
@interface PIXCredentialStorage()
@property (nonatomic, strong) NSURLProtectionSpace *space;
@property (nonatomic, strong) NSURLCredentialStorage *storage;

@end

@implementation PIXCredentialStorage
+(instancetype)sharedInstance{
    static PIXCredentialStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PIXCredentialStorage alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _space = [[NSURLProtectionSpace alloc] initWithHost:@"noneHost" port:0 protocol:@"http" realm:nil authenticationMethod:NSURLAuthenticationMethodDefault];
        _storage = [NSURLCredentialStorage sharedCredentialStorage];
    }
    return self;
}
-(void)storeStringForIdentifier:(NSString *)identifier string:(NSString *)string{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:identifier password:string persistence:NSURLCredentialPersistencePermanent];
    [_storage setCredential:credential forProtectionSpace:_space];
}
-(NSURLCredential *)credentialForIdentifier:(NSString *)identifier{
    NSDictionary *credentials = [_storage credentialsForProtectionSpace:_space];
    if (credentials) {
        return credentials[identifier];
    } else {
        return nil;
    }
}

-(NSString *)stringForIdentifier:(NSString *)identifier{
    NSURLCredential *credential = [self credentialForIdentifier:identifier];
    if (credential) {
        return credential.password;
    } else {
        return nil;
    }
}
-(void)removeStringForIdentifier:(NSString *)identifier{
    NSURLCredential *credential = [self credentialForIdentifier:identifier];
    if (credential) {
        [_storage removeCredential:credential forProtectionSpace:_space];
    }
}
@end
