//
//  WZQalgorithmClass.h
//  连连看
//
//  Created by ucsmy on 16/7/19.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WZQalgorithmClass : NSObject
/** 判断两点之间是否能连*/
+(BOOL)connectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data;
/** 五子棋是否能连*/
+(BOOL)wzqConnectionWithCGPoint:(CGPoint)pointA data:(NSMutableArray *)data type:(NSInteger)type;
@end
