//
//  QQApiManager.h
//  BeautyLab
//
//  Created by cce on 16/1/29.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>



@protocol QQApiManagerDelegate <NSObject>

@optional

// qq 登陆
- (void)managerDidRecvQQAuthResponse:(NSDictionary *)response;

@end

typedef void(^QQRecall)(BOOL isSuccess);
@interface QQApiManager : NSObject< TencentSessionDelegate, TCAPIRequestDelegate,QQApiInterfaceDelegate>

@property (nonatomic, weak) id<QQApiManagerDelegate> delegate;
@property (nonatomic,strong)QQRecall qqRecall;
+ (QQApiManager *)sharedManager;

- (void)shareQQWithTitle:(NSString*)title withContent:(NSString*)content withUrl:(NSString*)urlStr withpreviewImageUrl:(NSString*)iconPath withComplete:(QQRecall)recall;

@property (nonatomic, strong)TencentOAuth *oauth;
@end
