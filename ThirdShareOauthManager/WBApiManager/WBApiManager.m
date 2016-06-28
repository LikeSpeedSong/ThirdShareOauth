//
//  WBApiManager.m
//  BeautyLab
//
//  Created by cce on 16/1/5.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import "WBApiManager.h"

@interface WBApiManager ()
@property (copy, nonatomic) void (^recallBlock)(BOOL isS);
@end

@implementation WBApiManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static WBApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WBApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
    
}

- (void) shareSinaWithTitle:(NSString*)title withContent:(NSString*)content withUrl:(NSString*)urlStr withImage:(id)image complete:(WBRecall)recall{
 
    self.wbRecall=recall;
    WBMessageObject *message = [WBMessageObject message];
    NSString * name=@"#魔镜魔镜#「";
    if (content.length>100) {
        content=[[content substringToIndex:100] stringByAppendingString:@"...."];
    }
    content=[content stringByAppendingString:urlStr];
    message.text = [[[name stringByAppendingString:title]stringByAppendingString:@"」" ]stringByAppendingString:content];
    WBImageObject *images = [WBImageObject object];
    images.imageData = image;
    message.imageObject = images;
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": @"WBApiManager",
                         @"info": @"123"};
    [WeiboSDK sendRequest:request];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (response.statusCode==WeiboSDKResponseStatusCodeSuccess) {
            if (self.wbRecall) {
                self.wbRecall(YES);
            }
            [SAlertView showAlertWithTessage:@"微博分享成功" andoriginY:kScreenHeight-150 withActionBlock:nil];
            
        }
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        WBAuthorizeResponse *autoResponse=(WBAuthorizeResponse*)response;
        [_delegate managerDidRecvAuthWBResponse:autoResponse];
    }
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = NSLocalizedString(@"分享网页标题", nil);
//    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
//    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
//        webpage.webpageUrl = @"http://sina.cn?a=1";
//    message.mediaObject = webpage;

@end
