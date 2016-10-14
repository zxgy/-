//
//  RoundView.m
//  转盘
//
//  Created by meng jia on 16/10/11.
//  Copyright © 2016年 meng jia. All rights reserved.
//

#import "RoundView.h"
@interface RoundView ()<CAAnimationDelegate>{
//    UIButton *btn;
    UIImageView *_picImg;//未选中图片
    UIImageView *_selImg;//选中图片
    CALayer *_selectlayer;
    //弹出红包结果图
    UIView *_resView;
}
// 按钮数组
@property (nonatomic , strong) NSMutableArray *btnArray;
//按钮frame数组
@property (nonatomic , strong) NSMutableArray *btnFrameArray;
@property (nonatomic , assign) CGFloat rotationAngleInRadians;
// 是否展示
@property (nonatomic , assign) BOOL isShow;

@property (nonatomic , strong) NSMutableArray *nameArray ;

@end
@implementation RoundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2 ;
        self.Witch = self.frame.size.width;
        self.backgroundColor = [UIColor clearColor];
        _btnArray = [NSMutableArray new];
        _btnFrameArray = [NSMutableArray new];
        _nameArray = [NSMutableArray new];
//        [self addGestureRecognizer:[[KTOneFingerRotationGestureRecognizer alloc]initWithTarget:self action:@selector(changeMove:)]];
        _isShow = NO;
    }
    return self;
}
//创建按钮
- (void)BtnType:(FTT_RoundviewType)type BtnWitch:(CGFloat)BtnWitch  adjustsFontSizesTowidth:(BOOL)sizeWith  msaksToBounds:(BOOL)msak conrenrRadius:(CGFloat)radius image:(NSMutableArray *)image TitileArray:(NSMutableArray *)titileArray titileColor:(UIColor *)titleColor {
    CGFloat corner = -M_PI * 2.0 / 12;
    CGFloat r = (self.Witch  - BtnWitch) / 2 ;
    CGFloat x = self.Witch  / 2 ;
    CGFloat y = self.Witch  / 2 ;
    _nameArray = titileArray;
    for (int i = 0 ; i < 12; i++) {
        //图片的位置
        _picImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongb0.png"]];
        _picImg.frame =CGRectMake(0, 0, 32, 32);
        CGFloat  num = (i + 3 - 0.1) * 1.0;
        _picImg.center = CGPointMake(x + r * cos(corner * num), y + r *sin(corner * num));
        self.BtnWitch = BtnWitch;
        [self addSubview:_picImg];
        [_btnFrameArray addObject:[NSValue valueWithCGPoint:_picImg.center]];
        [_btnArray addObject:_picImg];
    }
    //行走的覆盖图层
    if (!_selImg) {
        
        // 选中框
        _selectlayer = [CALayer layer];
        UIButton *btn1 = _btnArray[0];
        _selectlayer.frame = CGRectMake(0, 0, 41, 41);
        _selectlayer.position = btn1.center;
        _selectlayer.contents = (id)[UIImage imageNamed:@"hongb0.png"].CGImage;
        _selectlayer.opacity = 0.6;//layer在z轴上的位置；
        //设置阴影
        _selectlayer.shadowColor=[UIColor grayColor].CGColor;
        _selectlayer.shadowOffset=CGSizeMake(2, 2);
        _selectlayer.shadowOpacity=.9;
        [self.layer addSublayer:_selectlayer];
    }
    _selectlayer.hidden = YES;

}
/**
 *  是否展示视图
 */
- (void)show {
    //核心动画,平移
    CAKeyframeAnimation *keyAnima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //规划路线
    keyAnima.values = _btnFrameArray;
//     1.2设置动画执行完毕后，删除动画
//    keyAnima.removedOnCompletion = YES;
//    // 1.3设置恢复动画的最初状态
//    keyAnima.fillMode = kCAFillModeRemoved;
    // 1.4设置动画执行的圈数
    keyAnima.repeatCount = 2;
    // 1.5设置动画执行的时间
    keyAnima.duration = 0.8;
    // 1.6设置动画的节奏,线性
    keyAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyAnima.calculationMode = kCAAnimationDiscrete;
    // 1.7设置代理，开始—结束
    keyAnima.delegate = self;
    [_selectlayer addAnimation:keyAnima forKey:nil];
//    for (int i = 0; i<8; i++) {
//        [UIView animateWithDuration:4.8 delay:0.6 options:0 animations:^{
//            UIButton *selBtn = _btnArray[i];
//            selBtn.selected = !selBtn.selected;
//        } completion:^(BOOL finished) {
//            if (i != 0) {
//                NSLog(@"动画结束");
//                UIButton *selBtn_old = _btnArray[i-1];
//                selBtn_old.selected = !selBtn_old.selected;
//            }
//        }];
//    }
    
    
//    if (_isShow) {
//        [UIView animateWithDuration:0.5 animations:^{
//            CGFloat corner = -M_PI * 2.0 / _btnArray.count;
//            CGFloat r = (self.Witch  - self.BtnWitch) / 2 ;
//            CGFloat x = self.Witch  / 2 ;
//            CGFloat y = self.Witch  / 2 ;
//            for (int i = 0 ; i < _btnArray.count ; i ++) {
//                UIButton *btn = _btnArray[i];
//                CGFloat  num = (i + 3 - 0.1) * 1.0;
//                btn.center = CGPointMake(x + r * cos(corner * num), y + r *sin(corner * num));
//                btn.alpha = 1 ;
//            }
//        }];
//    }else {//全部按钮中心转移
//        [UIView animateWithDuration:0.5 animations:^{
//            for (int i = 0; i < _btnArray.count; i++ ) {
//                UIButton *btn = _btnArray[i];
//                btn.center = CGPointMake(self.Witch   / 2 ,self.Witch   /2);
//                btn.alpha = 0 ;
//            }
//        }];
//    }
//    _isShow = !_isShow;
}

-(void)btn:(id) sender{
    
}
#pragma mark - AnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
        NSLog(@"开始动画");
    _selectlayer.hidden = NO;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"结束动画");
    _selectlayer.hidden = YES;
    [UIView animateWithDuration:1.0 animations:^{
        //弹出红包结果图
        _resView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.height/2, self.frame.size.width/2, 40, 80)];
        UIImageView *resImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongb3.png"]];
        resImgView.frame = CGRectMake(0, 0, _resView.frame.size.width, _resView.frame.size.height);
        _resView.backgroundColor = [UIColor clearColor];
//        _resView.transform = CGAffineTransformMakeScale(2, 2);
        [_resView addSubview:resImgView];
        [self addSubview:_resView];
    } completion:^(BOOL finished) {
        
    }];
}
@end
