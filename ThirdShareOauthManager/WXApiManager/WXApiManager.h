//
//  WXApiManager.h
//  BeautyLab
//
//  Created by cce on 16/1/5.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"


@protocol WXApiManagerDelegate <NSObject>

@optional


// wx分享
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

// wx登陆
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;



@end

typedef void(^WXRecall)(BOOL isSuccess);
@interface WXApiManager : NSObject<WXApiDelegate>


@property (nonatomic, weak) id<WXApiManagerDelegate> delegate;
@property (nonatomic,strong)WXRecall wxRecall;
+ (instancetype)sharedManager;


- (void) shareWithTitle:(NSString*)title withPlatType:(int)type withContent:(NSString*)content withUrl:(NSString*)urlStr withImage:(id)image finish:(WXRecall)recall;

@end
