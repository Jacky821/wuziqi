//
//  WZQGameCenter.m
//  连连看
//
//  Created by ucsmy on 16/7/20.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import "WZQGameCenter.h"
#import "WZQElement.h"
#import "WZQalgorithmClass.h"

#define MainWidth [UIScreen mainScreen].bounds.size.width
#define Mainheight [UIScreen mainScreen].bounds.size.height
/** 元素类型数量*/
#define ElementTypeNum 6
/** 边距*/
#define Padding 15

@interface WZQGameCenter()

/** 地图数据*/
@property (nonatomic, strong) NSMutableArray *mapList;
/** 元素存储字典*/
@property (nonatomic, strong) NSMutableDictionary *elementDic;
/** 元素宽高*/
@property (nonatomic, assign) NSInteger elementWH;
/** 上边距*/
@property (nonatomic, assign) NSInteger topPadding;
/** 当前点击的元素*/
@property (nonatomic, assign) WZQElement *curElement;
/** 之前点击过的元素*/
@property (nonatomic, assign) WZQElement *oldElement;
/** 地图行数*/
@property (nonatomic, assign) NSInteger mapRow;
/** 地图列数*/
@property (nonatomic, assign) NSInteger mapCol;
/** 撤销按钮*/
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BOOL isChangeColor;
@end

@implementation WZQGameCenter

-(instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.mapCol = col;
        self.mapRow = row;
        //元素宽高
        self.elementWH = (MainWidth - Padding * 2) / self.mapCol;
        self.topPadding = (Mainheight - self.mapCol * self.elementWH) * 0.5;
        self.topPadding = self.topPadding > 0 ? self.topPadding : 15;
        //创建撤销按钮
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame = CGRectMake(15, 20, MainWidth - 30, 40);
        self.backButton.backgroundColor = [UIColor orangeColor];
        [self.backButton setTitle:@"撤销" forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backClickHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backButton];
        //生成地图数据
        [self createMapData];
        //创建连连看元素
        [self createElement];
    }
    return self;
}
#pragma mark - private
/** 生成地图数据 二维数组*/
-(void)createMapData
{
    for (int i = 0; i < self.mapRow; i++) {
        NSMutableArray *subList = [NSMutableArray array];
        for (int j = 0; j < self.mapCol; j++) {
            //外围辅0
//            if (i == 0 || j == 0 || i == self.mapRow - 1 || j == self.mapCol - 1) {
                [subList addObject:@0];
//            }
//            else
//            {//内围随机
//                NSInteger value = random() % (ElementTypeNum + 1);
//                [subList addObject:[NSNumber numberWithInteger:value]];
//            }
        }
        [self.mapList addObject:subList];
    }
    /////0000000000000/////
    /////0101000200000/////
    /////0000200500000/////
    /////0003200100000/////
    /////0070045000000/////
    /////0000000000000/////
}
/** 创建连连看元素*/
-(void)createElement
{
    
    for (int i = 0; i < self.mapList.count; i++) {
        NSMutableArray *subList = self.mapList[i];
        for (int j = 0; j < subList.count; j++) {
            NSInteger type = [subList[j] integerValue];
//            if (i == 0 || j == 0 || i == self.mapRow - 1 || j == self.mapCol - 1 || type == 0) {
//                continue;
//            }
            float elementX = (j % self.mapCol) * self.elementWH + Padding;
            float elementY = (i % self.mapRow) * self.elementWH + self.topPadding;
            __weak typeof(self) weakSelf = self;
            WZQElement *element = [[WZQElement alloc] initWithFrame:CGRectMake(elementX, elementY, self.elementWH, self.elementWH) clickedBlock:^(UIButton *button) {
                WZQElement *clickElement = (WZQElement *)button;
                if (clickElement.type == 0) {
                    weakSelf.isChangeColor = !weakSelf.isChangeColor;
                    clickElement.type = weakSelf.isChangeColor ? 1 : 2;
                    weakSelf.curElement = clickElement;
                    NSMutableArray *subList = weakSelf.mapList[clickElement.row];
                    subList[clickElement.col] = [NSNumber numberWithInteger:clickElement.type];
                    NSLog(@"x == %ld, y == %ld", weakSelf.curElement.row, weakSelf.curElement.col);
                    [weakSelf checkElementConnection];
                }
            }];
//            [element setTitle:[NSString stringWithFormat:@"%d,%d,%ld", i, j, type] forState:UIControlStateNormal];
            element.row = i;
            element.col = j;
            element.type = type;
            [self.elementDic setValue:[NSNumber numberWithInteger:type] forKey:[NSString stringWithFormat:@"%d%d", i,j]];
            [self addSubview:element];
        }
    }
}
/** 检测两个元素之间的联系*/
-(void)checkElementConnection
{
    NSLog(@"x == %ld, y == %ld", self.curElement.row, self.curElement.col);
    BOOL flag = [WZQalgorithmClass wzqConnectionWithCGPoint:CGPointMake(self.curElement.row, self.curElement.col) data:self.mapList type:self.curElement.type];
//    NSLog(@"x == %ld, y == %ld, x1 == %ld, y1 == %ld", self.curElement.row, self.curElement.col, self.oldElement.row, self.oldElement.col);
    NSLog(@"是否能连===%d", flag);
    if (flag) {
        self.gameOverBlock(self.curElement.type == 1 ? YES : NO);
    }
}
-(void)backClickHandler
{
    self.isChangeColor = self.isChangeColor;
}
-(NSMutableArray *)mapList
{
    if (_mapList == nil) {
        _mapList = [NSMutableArray array];
    }
    return _mapList;
}
-(NSMutableDictionary *)elementDic
{
    if (_elementDic == nil) {
        _elementDic = [NSMutableDictionary dictionary];
    }
    return _elementDic;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
