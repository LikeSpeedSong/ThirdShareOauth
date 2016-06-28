//
//  BaseShareModel.h
//  BeautyLab
//
//  Created by A_zhi on 16/4/5.
//  Copyright © 2016年 CCE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseShareModel : NSObject
@property (nonatomic,copy)NSString * shareTitle;
@property (nonatomic,copy)NSString * shareContent;
@property (nonatomic,copy)NSString * shareIconPath;
@property (nonatomic,copy)NSString * shareUrlPath;
@property (copy, nonatomic) UIImage * shareImage;;
@end
