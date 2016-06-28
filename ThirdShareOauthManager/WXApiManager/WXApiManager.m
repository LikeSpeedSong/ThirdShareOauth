//
//  WXApiManager.m
//  BeautyLab
//
//  Created by cce on 16/1/5.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import "WXApiManager.h"

@interface WXApiManager  ()
@property (nonatomic,assign)BOOL isWeChatFriend;
@end

@implementation WXApiManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}



- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]&&resp.errCode==0) {
        if (!self.isWeChatFriend) {
            [SAlertView showAlertWithTessage:@"微信分享成功" andoriginY:kScreenHeight-150 withActionBlock:nil];
        }else{
            [SAlertView showAlertWithTessage:@"朋友圈分享成功" andoriginY:kScreenHeight-150 withActionBlock:nil];
        }
        
        
        if (self.wxRecall) {
            self.wxRecall(YES);
        }
        
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    }
    
}

- (void) shareWithTitle:(NSString*)title withPlatType:(int)type withContent:(NSString*)content withUrl:(NSString*)urlStr withImage:(id)image finish:(WXRecall)recall{
    self.wxRecall=recall;
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlStr;
    self.isWeChatFriend=type;
    WXMediaMessage *message = [self messageWithTitle:title
                                         Description:content
                                              Object:ext
                                          MessageExt:nil
                                       MessageAction:nil
                                          ThumbImage:image
                                            MediaTag:@""];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
    req.message=message;
    req.scene=type;
    [WXApi sendReq:req];
    
}



- (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = mediaObject;
    message.messageExt = messageExt;
    message.messageAction = action;
    message.mediaTagName = tagName;
    [message setThumbImage:thumbImage];
    return message;
}

@end
