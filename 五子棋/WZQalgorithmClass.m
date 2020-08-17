//
//  WZQalgorithmClass.m
//  连连看
//
//  Created by ucsmy on 16/7/19.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import "WZQalgorithmClass.h"

@implementation WZQalgorithmClass

+(BOOL)connectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data
{
    if ([self oneConnectionWithCGPoint:pointA pointB:pointB data:data]) {
        return YES;
    }
    else if ([self twoConnectionWithCGPoint:pointA pointB:pointB data:data])
    {
        return YES;
    }
    else if ([self thirdConnectionWithCGPoint:pointA pointB:pointB data:data])
    {
        return YES;
    }
    return NO;
}
/** 直连*/
+(BOOL)oneConnectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data
{
    NSInteger minValue = -1;
    NSInteger maxValue = -1;
    //同行
    if (pointA.x == pointB.x) {
        //相邻
        if (fabs(pointA.y - pointB.y) == 1) {
            return YES;
        }
        //判断哪个值大小
        if (pointA.y > pointB.y) {
            minValue = pointB.y;
            maxValue = pointA.y;
        }
        else
        {
            maxValue = pointB.y;
            minValue = pointA.y;
        }
        //遍历数据minValue 与 maxValue 之间的数值 如果为0代表通路 否则有阻碍
        if (pointA.x > data.count) {
            return NO;
        }
        NSMutableArray *list = data[(NSInteger)pointA.x];
        for (NSInteger i = minValue + 1; i < maxValue; i++)
        {
            NSNumber *number = list[i];
            if ([number integerValue] != 0) {
                return NO;
            }
        }
    }
    //同列
    else if (pointA.y == pointB.y)
    {
        //相邻
        if (fabs(pointA.x - pointB.x) == 1) {
            return YES;
        }
        //判断哪个值大小
        if (pointA.x > pointB.x) {
            minValue = pointB.x;
            maxValue = pointA.x;
        }
        else
        {
            maxValue = pointB.x;
            minValue = pointA.x;
        }
        //遍历数据minValue 与 maxValue 之间的数值 如果为0代表通路 否则有阻碍
        if (pointA.y > data.count) {
            return NO;
        }
        for (NSInteger i = minValue + 1; i < maxValue; i++)
        {
            NSMutableArray *list = data[i];
            NSNumber *number = list[(NSInteger)pointA.y];
            if ([number integerValue] != 0) {
                return NO;
            }
        }
    }
    else
    {
        return NO;
    }
    return YES;
}
/** 一折连*/
+(BOOL)twoConnectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data
{
    CGPoint point1 = CGPointMake(pointA.x, pointB.y);//取第一个拐点
    CGPoint point2 = CGPointMake(pointB.x, pointA.y);//取第二个拐点
    NSArray *list = data[(NSInteger)point1.x];
    NSNumber *number = list[(NSInteger)point1.y];
    if ([number integerValue] == 0) {//判断第一个拐点的位置是不是通路(通路为0)
        //拿到拐点分别和要进行一折连的两个点 进行直连判断 如果都能直连 可以一折连
        BOOL flagA = [self oneConnectionWithCGPoint:point1 pointB:pointB data:data];
        BOOL flagB = [self oneConnectionWithCGPoint:point1 pointB:pointA data:data];
        if (flagA && flagB)
        {
            NSLog(@"拐点：%@", NSStringFromCGPoint(point1));
            NSLog(@"pointA : %@", NSStringFromCGPoint(pointA));
            NSLog(@"pointB : %@", NSStringFromCGPoint(pointB));
            return YES;
        }
    }
    
    list = data[(NSInteger)point2.x];
    number = list[(NSInteger)point2.y];
    if ([number integerValue] == 0) {//判断第二个拐点的位置是不是通路(通路为0)
        //拿到拐点分别和要进行一折连的两个点 进行直连判断 如果都能直连 可以一折连
        BOOL flagA = [self oneConnectionWithCGPoint:point2 pointB:pointB data:data];
        BOOL flagB = [self oneConnectionWithCGPoint:point2 pointB:pointA data:data];
        if (flagA && flagB)
        {
            NSLog(@"%@", NSStringFromCGPoint(point2));
            NSLog(@"pointA : %@", NSStringFromCGPoint(pointA));
            NSLog(@"pointB : %@", NSStringFromCGPoint(pointB));
            return YES;
        }
    }
    return NO;
}

/** 两折连*/
+(BOOL)thirdConnectionWithCGPoint:(CGPoint)pointA pointB:(CGPoint)pointB data:(NSMutableArray *)data
{
    NSInteger row = data.count;
    NSInteger col = [[data lastObject] count];
    //左
    for (NSInteger i = pointA.y - 1; i >= 0; i--) {
        NSArray *list = data[(NSInteger)pointA.x];
        NSNumber *number = list[i];
        if ([number integerValue] != 0) {
            break;
        }
        BOOL flag = [self twoConnectionWithCGPoint:CGPointMake(pointA.x, i) pointB:pointB data:data];
        if (flag) {
            return flag;
        }
    }
    //右
    for (NSInteger i = pointA.y + 1; i < col; i++) {
        NSArray *list = data[(NSInteger)pointA.x];
        NSNumber *number = list[i];
        if ([number integerValue] != 0) {
            break;
        }
        BOOL flag = [self twoConnectionWithCGPoint:CGPointMake(pointA.x, i) pointB:pointB data:data];
        if (flag) {
            return flag;
        }
    }
    //上
    for (NSInteger i = pointA.x - 1; i >= 0; i--) {
        NSArray *list = data[i];
        NSNumber *number = list[(NSInteger)pointA.y];
        if ([number integerValue] != 0) {
            break;
        }
        BOOL flag = [self twoConnectionWithCGPoint:CGPointMake(i, pointA.y) pointB:pointB data:data];
        if (flag) {
            return flag;
        }
    }
    //下
    for (NSInteger i = pointA.x + 1; i < row; i++) {
        NSArray *list = data[i];
        NSNumber *number = list[(NSInteger)pointA.y];
        if ([number integerValue] != 0) {
            break;
        }
        BOOL flag = [self twoConnectionWithCGPoint:CGPointMake(i, pointA.y) pointB:pointB data:data];
        if (flag) {
            return flag;
        }
    }
    return NO;
}
/** 五子连*/
+(BOOL)wzqConnectionWithCGPoint:(CGPoint)pointA data:(NSMutableArray *)data type:(NSInteger)type
{
    //左右判断
    if ([self leftAndRightConnectionWithCGPoint:pointA type:type data:data]) {
        return YES;
    }
    //上下判断
    else if ([self upAndDownConnectionWithCGPoint:pointA type:type data:data])
    {
        return YES;
    }
    //左上 右下 判断
    else if ([self leftUpAndRightDownConnectionWithCGPoint:pointA type:type data:data])
    {
        return YES;
    }
    //左下 右上 判断
    else if ([self leftDownAndRightUpConnectionWithCGPoint:pointA type:type data:data])
    {
        return YES;
    }
    return NO;
}
+(BOOL)leftAndRightConnectionWithCGPoint:(CGPoint)pointA type:(NSInteger)type data:(NSMutableArray *)data
{
    NSInteger count = 1;
    NSInteger row = data.count;
//    NSInteger col = [[data lastObject] count];
    for (NSInteger i = pointA.y; i < row; i ++) {
        if (i == pointA.y) {
            continue;
        }
        NSArray *list = data[(NSInteger)pointA.x];
        NSNumber *number = list[i];
        if ([number integerValue] == type) {
            count++;
        }
        else
        {
            break;
        }
    }
    
    for (NSInteger i = pointA.y; i >= 0; i--) {
        if (i == pointA.y) {
            continue;
        }
        NSArray *list = data[(NSInteger)pointA.x];
        NSNumber *number = list[i];
        if ([number integerValue] == type) {
            count++;
        }
        else
        {
            break;
        }
    }
    if (count >= 5) {
        return YES;
    }
    return NO;
}
+(BOOL)upAndDownConnectionWithCGPoint:(CGPoint)pointA type:(NSInteger)type data:(NSMutableArray *)data
{
    NSInteger count = 1;
//    NSInteger row = data.count;
    NSInteger col = [[data lastObject] count];
    for (NSInteger i = pointA.x; i < col; i ++) {
        if (i == pointA.x) {
            continue;
        }
        NSArray *list = data[i];
        NSNumber *number = list[(NSInteger)pointA.y];
        if ([number integerValue] == type) {
            count++;
        }
        else
        {
            break;
        }
    }
    
    for (NSInteger i = pointA.x; i >= 0; i--) {
        if (i == pointA.x) {
            continue;
        }
        NSArray *list = data[i];
        NSNumber *number = list[(NSInteger)pointA.y];
        if ([number integerValue] == type) {
            count++;
        }
        else
        {
            break;
        }
    }
    if (count == 5) {
        return YES;
    }
    return NO;
}
+(BOOL)leftUpAndRightDownConnectionWithCGPoint:(CGPoint)pointA type:(NSInteger)type data:(NSMutableArray *)data
{
    NSInteger count = 1;
    NSInteger indexX = pointA.x;
    NSInteger indexY = pointA.y;
    indexX--;
    indexY--;
    while (indexX >= 0 && indexY >= 0) {
        NSArray *list = data[indexX];
        NSNumber *number = list[indexY];
        if ([number integerValue] == type) {
            count++;
        }
        else
        {
            break;
        }
        indexX--;
        indexY--;
    }
    indexX = pointA.x;
    indexY = pointA.y;
    indexX++;
    indexY++;
    while (indexX < data.count && indexY < [[data lastObject] count]) {
        NSArray *list = data[indexX];
        NSNumber *number = list[indexY];
        if ([number integerValue] == type) {
            count++;
        }
        else
        {
            break;
        }
        indexX++;
        indexY++;
    }
    if (count == 5) {
        return YES;
    }
    return NO;
}
+(BOOL)leftDownAndRightUpConnectionWithCGPoint:(CGPoint)pointA type:(NSInteger)type data:(NSMutableArray *)data
{
    NSInteger count = 1;
    NSInteger indexX = pointA.x;
    NSInteger indexY = pointA.y;
    indexX--;
    indexY++;
    while (indexX >= 0 && indexY < [[data lastObject] count]) {
        NSArray *list = data[indexX];
        NSNumber *number = list[indexY];
        if ([number integerValue] == type) {
            count++;
        }
        else
        {
            break;
        }
        indexX--;
        indexY++;
    }
    indexX = pointA.x;
    indexY = pointA.y;
    indexX++;
    indexY--;
    while (indexX < data.count && indexY >= 0) {
        NSArray *list = data[indexX];
        NSNumber *number = list[indexY];
        if ([number integerValue] == type) {
            count++;
        }
        else
        {
            break;
        }
        indexX++;
        indexY--;
    }
    if (count == 5) {
        return YES;
    }
    return NO;
}
@end
