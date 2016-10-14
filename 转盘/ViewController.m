//
//  ViewController.m
//  转盘
//
//  Created by meng jia on 16/10/10.
//  Copyright © 2016年 meng jia. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<CAAnimationDelegate,AVAudioPlayerDelegate>{
    //    UIButton *btn;
    UIImageView *_picImg;//未选中图片
    UIImageView *_selImg;//选中图片
    CALayer *_selectlayer;
    //弹出红包结果图
    UIView *_resView;
    //确定按钮
    UIButton *_sureBtn;
}
@property (nonatomic,strong) AVAudioPlayer *player;//音频播放器
@property (nonatomic,strong) NSTimer *timer;//时间定时器
@property (nonatomic,strong) UIView *roundView;//＝圆底盘
@property (nonatomic,strong) UIView *mengBView;//蒙板
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic , strong) UIButton *button;//中心按钮
// 按钮数组
@property (nonatomic , strong) NSMutableArray *btnArray;
//按钮frame数组
@property (nonatomic , strong) NSMutableArray *btnFrameArray;
@property (nonatomic , assign) CGFloat rotationAngleInRadians;
// 是否展示
@property (nonatomic , assign) BOOL isShow;

@property (nonatomic , strong) NSMutableArray *nameArray ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //创建红包图层
    _roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    _roundView.layer.masksToBounds = YES;
    _roundView.layer.cornerRadius = self.view.frame.size.width / 2 ;
    self.Witch = self.view.frame.size.width;
    _roundView.backgroundColor = [UIColor clearColor];
    _btnArray = [NSMutableArray new];
    _btnFrameArray = [NSMutableArray new];
    _nameArray = [NSMutableArray new];
    _isShow = NO;

    _roundView.center = self.view.center;
    _roundView.backgroundColor = [UIColor greenColor];
    [self BtnType:FTT_RoundviewTypeCustom BtnWitch:100 adjustsFontSizesTowidth:YES msaksToBounds:YES conrenrRadius:50 image:_imageArray TitileArray:_titleArray titileColor:[UIColor blackColor]];
    [self.view addSubview:_roundView];
    
    //创建中心抽奖按钮
    _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _button.center = self.view.center;
    _button.backgroundColor = [UIColor yellowColor];
    _button.layer.cornerRadius = 50;
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_button setTitle:@"开始抽奖" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(showItems:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    //抽奖结果蒙板
    _mengBView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mengBView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //隐藏萌版
    _mengBView.hidden = YES;
    [self.view addSubview:_mengBView];
    
    //领取红包确定按钮
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake((self.view.bounds.size.width-100)/2, self.view.bounds.size.height-200, 100, 35);
    [_sureBtn setTitle:@"领取红包" forState:UIControlStateNormal];
    [_sureBtn setBackgroundColor:[UIColor redColor]];
    //开启圆角
    [_sureBtn.layer setMasksToBounds:YES];
    [_sureBtn.layer setCornerRadius:5.0];
    [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //默认隐藏
    _sureBtn.hidden = YES;
    [_mengBView addSubview:_sureBtn];
    
    //红包结果图
    _resView = [[UIView alloc] initWithFrame:CGRectMake(_button.center.x-32, _button.center.y-32, 64, 64)];
    UIImageView *resImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongb3.png"]];
    resImgView.frame = CGRectMake(0, 0, _resView.frame.size.width, _resView.frame.size.height);
    _resView.backgroundColor = [UIColor blueColor];
    //默认隐藏
    _resView.hidden = YES;
    [_resView addSubview:resImgView];
    [_mengBView addSubview:_resView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 懒加载
//音频播放器
-(void)setPlayer:(AVAudioPlayer *)player{
    NSString *string= [[NSBundle mainBundle] pathForResource:@"yy" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
}
//定时器
-(void)setTimer:(NSTimer *)timer{
    //初始化时间定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(mp3Timer) userInfo:nil repeats:YES];
}
#pragma mark点击事件
- (void)showItems:(UIButton *)sender{
    _button.enabled = NO;//关闭抽奖按钮交互。防止多次点击
    [self show];
    
}
//领取红包
-(void)sureBtnClick:(UIButton *)sureBtnClick{
    _sureBtn.hidden = YES;
    [UIView animateWithDuration:0.6 animations:^{
        //缩小隐藏红包结果图
        _resView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        //显示确定按钮
        _mengBView.hidden = YES;
        //开启抽奖按钮交互
        _button.enabled = YES;
    }];
}
//时间定时器
-(void)mp3Timer{
    //播放音效
    NSString *string= [[NSBundle mainBundle] pathForResource:@"yinx" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    [_player play];
}
//创建按钮
- (void)BtnType:(FTT_RoundviewType)type BtnWitch:(CGFloat)BtnWitch  adjustsFontSizesTowidth:(BOOL)sizeWith  msaksToBounds:(BOOL)msak conrenrRadius:(CGFloat)radius image:(NSMutableArray *)image TitileArray:(NSMutableArray *)titileArray titileColor:(UIColor *)titleColor {
    CGFloat corner = -M_PI * 2.0 / 8;
    CGFloat r = (self.Witch  - BtnWitch) / 2 ;
    CGFloat x = self.Witch  / 2 ;
    CGFloat y = self.Witch  / 2 ;
    _nameArray = titileArray;
    for (int i = 0 ; i < 8; i++) {
        //图片的位置
        _picImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongb0.png"]];
        _picImg.frame =CGRectMake(0, 0, 32, 32);
        CGFloat  num = (i + 3 - 0.1) * 1.0;
        _picImg.center = CGPointMake(x + r * cos(corner * num), y + r *sin(corner * num));
        self.BtnWitch = BtnWitch;
        [_roundView addSubview:_picImg];
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
        [_roundView.layer addSublayer:_selectlayer];
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
}
-(void)btn:(id) sender{
    
}
#pragma mark - AnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"开始动画");
    _selectlayer.hidden = NO;
    //初始化时间定时器,创建timer的同时就已经开始倒计时了,0.2秒后自动调用singleCycleTimerAction，不用启动timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(mp3Timer) userInfo:nil repeats:YES];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"结束动画");
    //暂停时间定时器
    [_timer setFireDate:[NSDate distantFuture]];
    _selectlayer.hidden = YES;//隐藏红包选中layer
    _mengBView.hidden = NO;//显示蒙板
    [UIView animateWithDuration:0.6 animations:^{
        //弹出红包结果图
        _resView.hidden = NO;
        _resView.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        //显示确定按钮
        _sureBtn.hidden = NO;
    }];
}
#pragma mark - AVAudioPlayerDelegate

// 音频播放完成时
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    // 音频播放完成时，调用该方法。
    // 参数flag：如果音频播放无法解码时，该参数为NO。
    //当音频被终端时，该方法不被调用。而会调用audioPlayerBeginInterruption方法
    // 和audioPlayerEndInterruption方法
    [player stop];
    
}
// 解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"解码错误！");
}
// 当音频播放过程中被中断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    // 当音频播放过程中被中断时，执行该方法。比如：播放音频时，电话来了！
    // 这时候，音频播放将会被暂停。
}

// 当中断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
    // AVAudioSessionInterruptionFlags_ShouldResume 表示被中断的音频可以恢复播放了。
    // 该标识在iOS 6.0 被废除。需要用flags参数，来表示视频的状态。
    
    NSLog(@"中断结束，恢复播放");
    if (flags == AVAudioSessionInterruptionFlags_ShouldResume && player != nil){
        [player play];
    }
    
}
@end
