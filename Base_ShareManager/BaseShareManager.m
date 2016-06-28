//
//  BaseShareManager.m
//  BeautyLab
//
//  Created by A_zhi on 16/4/5.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import "BaseShareManager.h"
#import "WBApiManager.h"
#import "UIImage+ImageEffects.h"
@implementation BaseShareManager

+ (void)startShareWithPlatForm:(ShareType)type
            withViewController:(UIViewController *)originalVc
                withShareModel:(BaseShareModel *)shareModel
                  withCallBack:(shareCallBackBlock)callBackBlock{
    
    if ([BLTool boolForKey:kCurrentNetWorkIsNo]) {
        [SAlertView showAlertWithTessage:BL_Internet_No andoriginY:kNotReachableHigth withActionBlock:nil];
        return;
    }
    switch (type) {
        case ShareType_QQ:{
            [self ShareToQQwithModel:shareModel withViewController:originalVc withCallBack:callBackBlock];
        }
            
            break;
        case ShareType_Sina:{
            [self ShareToToSinawithModel:shareModel withViewController:originalVc withCallBack:callBackBlock];
        }
            
            break;
        case ShareType_WechatFriend:
        case ShareType_Wechat:{
            [self ShareToWechatwithModel:shareModel withViewController:originalVc withCallBack:callBackBlock isTimeLine:type];
        }
            
            break;
            
            
        default:
            break;
    }
}

+(void)ShareToQQwithModel:(BaseShareModel *)model withViewController:(UIViewController *)originalVc withCallBack:(shareCallBackBlock)callBackBlock {
    if (![TencentOAuth iphoneQQInstalled]) {
        [SAlertView showAlertWithTessage:@"亲，您没有安装QQ哦" andoriginY:kScreenHeight/2 withActionBlock:^{
            
        }];
    }else{
        [[QQApiManager sharedManager] shareQQWithTitle:model.shareTitle withContent:model.shareContent withUrl:model.shareUrlPath withpreviewImageUrl:model.shareIconPath withComplete:callBackBlock];
    }
    
}


+(void)ShareToToSinawithModel:(BaseShareModel *)model withViewController:(UIViewController *)originalVc withCallBack:(shareCallBackBlock)callBackBlock{
    
    if (![WeiboSDK isWeiboAppInstalled]) {
        [SAlertView showAlertWithTessage:@"亲，您没有安装微博哦" andoriginY:kScreenHeight/2 withActionBlock:^{
            
        }];
    }else{
        NSData * imageData;
        imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:model.shareIconPath]];
        if (imageData==nil) {
            UIImage * image=[UIImage imageNamed:@"Beauty_logo"];
            imageData=UIImagePNGRepresentation(image);
        }
      
        
        [[WBApiManager sharedManager] shareSinaWithTitle:model.shareTitle withContent:model.shareContent withUrl:model.shareUrlPath withImage:imageData complete:callBackBlock];
    }
    
}


+(void)ShareToWechatwithModel:(BaseShareModel *)model withViewController:(UIViewController *)originalVc withCallBack:(shareCallBackBlock)callBackBlock isTimeLine:(ShareType)platform{
    if (![WXApi isWXAppInstalled]) {
        [SAlertView showAlertWithTessage:@"亲，您没有安装微信哦" andoriginY:kScreenHeight/2 withActionBlock:^{
            
        }];
    }else{
        int type=0;
        if (platform==ShareType_WechatFriend) {
            type=1;
        }
        UIImage * newImage;
        if (!model.shareIconPath||[model.shareIconPath isEqualToString:@""]) {
            newImage=[UIImage imageNamed:@"Beauty_logo"];
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.shareIconPath]];
            UIImage * image=[UIImage imageWithData:data];
            newImage=[UIImage thumbnailWithImageWithoutScale:image size:CGSizeMake(50, 50)];
        }
        
        [[WXApiManager sharedManager] shareWithTitle:model.shareTitle withPlatType:type withContent:model.shareContent withUrl:model.shareUrlPath withImage:newImage finish:callBackBlock];
    }
    
}


@end
