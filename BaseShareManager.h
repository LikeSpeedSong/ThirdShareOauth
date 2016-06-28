//
//  BaseShareManager.h
//  BeautyLab
//
//  Created by A_zhi on 16/4/5.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseShareModel.h"
typedef  NS_ENUM(NSUInteger,ShareType){
    ShareType_QQ,
    ShareType_Wechat,
    ShareType_WechatFriend,
    ShareType_Sina,
};

typedef void(^shareCallBackBlock)(BOOL  isSuccess);
@interface BaseShareManager : NSObject


+ (void)startShareWithPlatForm:(ShareType)type
            withViewController:(UIViewController *)originalVc
                withShareModel:(BaseShareModel *)shareModel
                  withCallBack:(shareCallBackBlock)callBackBlock;

@end
