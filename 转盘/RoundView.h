//
//  RoundView.h
//  转盘
//
//  Created by meng jia on 16/10/11.
//  Copyright © 2016年 meng jia. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , FTT_RoundviewType) {
    FTT_RoundviewTypeSystem = 0,
    FTT_RoundviewTypeCustom ,
};
@interface RoundView : UIView

// 按钮风格
@property (nonatomic , assign) FTT_RoundviewType Type;
// 按钮的宽度
@property (nonatomic , assign) CGFloat BtnWitch;
// 视图的宽度
@property (nonatomic , assign) CGFloat Witch;
// 按钮的背景颜色
@property (nonatomic , strong) UIColor *BtnBackgroudColor ;
// 所有按钮中心移动
- (void)show ;
/**
 *  创建按钮
 *
 *  @param type        按钮的风格
 *  @param BtnWitch    按钮的宽度
 *  @param sizeWith    字体是否自动适应按钮的宽度
 *  @param msak        是否允许剪切
 *  @param radius      圆角的大小
 *  @param image       图片数组
 *  @param titileArray 名字数组
 *  @param titleColor  字体的颜色
 */
- (void)BtnType:(FTT_RoundviewType)type BtnWitch:(CGFloat)BtnWitch  adjustsFontSizesTowidth:(BOOL)sizeWith  msaksToBounds:(BOOL)msak conrenrRadius:(CGFloat)radius image:(NSMutableArray *)image TitileArray:(NSMutableArray *)titileArray titileColor:(UIColor *)titleColor;
@end
