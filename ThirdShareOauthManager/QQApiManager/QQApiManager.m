//
//  QQApiManager.m
//  BeautyLab
//
//  Created by cce on 16/1/29.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import "QQApiManager.h"

static QQApiManager *qq = nil;
@interface QQApiManager ()
@property (nonatomic, strong)NSArray* permissons;
@end
@implementation QQApiManager


+ (QQApiManager *)sharedManager
{
    @synchronized(self)
    {
        if (nil == qq)
        {
            
            qq = [[super allocWithZone:nil] init];
        }
    }
    
    return qq;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (void)resetSDK
{
    qq = nil;
}

- (id)init
{
    _oauth = [[TencentOAuth alloc] initWithAppId:kQQAppID
                                     andDelegate:self];
    
    return self;
}

#pragma mark qq分享
- (void)shareQQWithTitle:(NSString*)title withContent:(NSString*)content withUrl:(NSString*)urlStr withpreviewImageUrl:(NSString *)iconPath withComplete:(QQRecall)recall{
    self.qqRecall=recall;
    QQApiNewsObject * newsObj;
    if (iconPath&&![iconPath isEqualToString:@""]) {
        newsObj = [QQApiNewsObject
                                    objectWithURL :[NSURL URLWithString:urlStr]
                                    title: title
                                    description :content
                                    previewImageURL:[NSURL URLWithString:iconPath]];
    }else{
        UIImage * image=[UIImage imageNamed:@"Beauty_logo"];
        newsObj=[QQApiNewsObject objectWithURL:[NSURL URLWithString:urlStr] title:title description:content previewImageData:UIImagePNGRepresentation(image)];
    }

    uint64_t cflag = 0;
    [newsObj setCflag:cflag];
    QQApiObject* objc = newsObj;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:objc];
    [QQApiInterface sendReq:req];
    
    
}

#pragma mark qq登录成功

- (void)tencentDidLogin
{
    [_oauth getUserInfo];
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SAlertView showAlertWithTessage:@"QQ取消登录" andoriginY:kScreenHeight- px_Using_ByScreenHeight(300) withActionBlock:nil];
    });
    
}

- (void)tencentDidNotNetWork
{
    
}

- (void)tencentDidLogout
{
    
}

#pragma mark qq登录的回调
- (void)getUserInfoResponse:(APIResponse*) response
{
    if (_delegate&&[_delegate respondsToSelector:@selector(managerDidRecvQQAuthResponse:)]&&URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode) {
        NSString * openID=[_oauth getUserOpenID];
        NSDictionary * dict=response.jsonResponse;
        [dict setValue:openID forKey:@"QQID"];
        [_delegate managerDidRecvQQAuthResponse:response.jsonResponse];
    }
}

#pragma mark 扣扣分享的回调
- (void)onReq:(QQBaseReq *)req{
    
}
- (void)isOnlineResponse:(NSDictionary *)response{
    
}

- (void)onResp:(QQBaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToQQResp class]] ) {
        if (resp.errorDescription==nil&&[resp.result intValue]==0) {
            if (self.qqRecall) {
                self.qqRecall(YES);
            }
            [SAlertView showAlertWithTessage:@"QQ分享成功" andoriginY:kScreenHeight-150 withActionBlock:nil];
        }
    }
}

@end
