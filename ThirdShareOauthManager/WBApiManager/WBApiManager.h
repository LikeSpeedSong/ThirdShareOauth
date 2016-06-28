//
//  WBApiManager.h
//  BeautyLab
//
//  Created by cce on 16/1/5.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@protocol WBApiManagerDelegate <NSObject>

@optional
// WB分享
- (void)managerDidRecvMessageWBResponse:(WBSendMessageToWeiboResponse *)response;

// WB登陆
- (void)managerDidRecvAuthWBResponse:(WBAuthorizeResponse *)response;


@end

typedef void(^WBRecall)(BOOL isSuccess);
@interface WBApiManager : NSObject<WeiboSDKDelegate>

@property (nonatomic, weak) id<WBApiManagerDelegate> delegate;
@property (nonatomic,strong)WBRecall wbRecall;
+ (instancetype)sharedManager;

- (void) shareSinaWithTitle:(NSString*)title withContent:(NSString*)content withUrl:(NSString*)urlStr withImage:(id)image complete:(WBRecall)recall;
@end
