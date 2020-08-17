//
//  WZQGameCenter.h
//  连连看
//
//  Created by ucsmy on 16/7/20.
//  Copyright © 2016年 ucsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GameOverBlock)(BOOL);

@interface WZQGameCenter : UIView
@property (nonatomic, copy) GameOverBlock gameOverBlock;
-(instancetype)initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col;
@end
