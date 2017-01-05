//
//  ViewController.m
//  猜拳游戏
//
//  Created by 张志敏 on 16/1/13.
//  Copyright © 2016年 张志敏. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "ZMFistBtn.h"
#import "ZMRoot.h"
#import "ZMPlayer.h"

@interface ViewController ()

@property (nonatomic,strong)ZMPlayer *player;
@property (nonatomic,strong)ZMRoot *robot;

/**
 *  猜拳结果
 */
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
/**
 *  机器人出拳图案
 */
@property (weak, nonatomic) IBOutlet UIImageView *robotFist;
/**
 *  玩家出拳图案
 */
@property (weak, nonatomic) IBOutlet UIImageView *playerFist;


@property (weak, nonatomic) IBOutlet ZMFistBtn *shitouBtn;
@property (weak, nonatomic) IBOutlet ZMFistBtn *jianBtn;
@property (weak, nonatomic) IBOutlet ZMFistBtn *buBtn;

@property (weak, nonatomic) IBOutlet UILabel *robotScore;
@property (weak, nonatomic) IBOutlet UILabel *playerScore;


@property (weak, nonatomic) IBOutlet UIImageView *lauchImage;


//@property (nonatomic,strong)AVAudioPlayer *myPlayer;


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultLabel.text = nil;
    self.robotScore.text = @"得分：0";
    self.playerScore.text = @"得分：0";
    self.shitouBtn.fistType = 2;
    self.buBtn.fistType = 3;
    self.jianBtn.fistType = 1;
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    
    [self.lauchImage addGestureRecognizer:tap];
    
}

#pragma mark - 开始动画
static int countTouch = 0;
-(void)click:(UITapGestureRecognizer*)tap{
    
    UIImage* image = [[UIImage alloc] init];
    countTouch++;
    if (countTouch == 1)
    {
        image = [UIImage imageNamed:@"paper"];
    }
    else if(countTouch == 2)
    {
        image = [UIImage imageNamed:@"rock"];
    }
    else if (countTouch == 3)
    {
        image = [UIImage imageNamed:@"scissors"];
    }
    else
    {
        [self.lauchImage removeGestureRecognizer:tap];
        self.lauchImage.hidden = YES;
        return;
    }

    //设置背景图片
    UIImage* backgroundImage = [UIImage imageNamed:@"background"];
    UIImage* newImage =[self imageFormbackgroundIamge:backgroundImage andSourceImage:image];
    
    //设置新图片
    self.lauchImage.image = newImage;

    //设置转场动画
    CATransition *animation = [CATransition animation];
    [animation setType:@"kCATransitionFade"];
    animation.duration = 0.5;
//    animation.type = @"pageCurl";
    animation.subtype = kCATransitionFromTop;
    [self.lauchImage.layer addAnimation:animation forKey:nil];
    
}

-(UIImage*)imageFormbackgroundIamge:(UIImage*)backgroundImage andSourceImage:(UIImage*)sourceImage
{
    //获取开启上下文
    UIGraphicsBeginImageContext(self.lauchImage.bounds.size);
    //绘制背景
    [backgroundImage drawInRect:self.lauchImage.bounds];
    //绘制图片
    [sourceImage drawInRect:self.lauchImage.bounds];
    //获取当前图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    //返回合成的图片
    return newImage;
}




#pragma mark -点击按钮调用方法
/**
 *  三个出拳点击的处理方法
 *
 *  @param sender 点了哪个按钮
 */
-(IBAction)playerChooseFist:(ZMFistBtn*)sender{
    
    //如果正在出拳，就不能再出拳了
    if ([self.playerFist isAnimating])
    {
        return;
    }
    self.player.fist = sender.fistType;
    [self.robot showFist];
    [self judge];
    
}


#pragma mark - 判断谁胜谁负
- (void) judge{
    
    NSString* str = nil;
    
    int res = self.player.fist- self.robot.fist;
    
    if (res == 1 || res ==-2){
        str =  @"玩家赢了";
        self.player.score += 1;
        self.robot.score -= 1;
    }
    else if(res == -1 || res ==2){
        str = @"电脑赢了" ;
        self.player.score -= 1;  //[player score];
        self.robot.score += 1;   //[robot score];
    }
    else
    {
        str = @"平局";
    }
    
    //根据出拳，选择图片
    NSString* robotFist = [NSString stringWithFormat:@"%d",self.robot.fist];
    NSString* palyerFist = [NSString stringWithFormat:@"%d%d",self.player.fist,self.player.fist];
    
    
    //先来一段准备动画压压惊
    [self perpareAnimation];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //设置玩家最终出拳
        self.playerFist.image =[UIImage imageNamed:palyerFist];
        //设置机器人最终出拳
        self.robotFist.image = [UIImage imageNamed:robotFist];
        //返回结果
        self.resultLabel.text = str;
        self.robotScore.text = [NSString stringWithFormat:@"得分：%d",self.robot.score];
        self.playerScore.text = [NSString stringWithFormat:@"得分：%d",self.player.score];
    });

}

#pragma mark - 出拳前的动画
/**
 *  出拳前的动画
 */
-(void)perpareAnimation{

    //设置动画图片
    UIImage* jian = [UIImage imageNamed:@"1"];
    UIImage* shitou = [UIImage imageNamed:@"2"];
    UIImage* bu = [UIImage imageNamed:@"3"];
    UIImage* playerShiTou = [UIImage imageNamed:@"22"];
    UIImage* playerBu = [UIImage imageNamed:@"33"];
    UIImage* playerJian = [UIImage imageNamed:@"11"];
    NSArray* robotImageArr = @[shitou,bu,jian];
    NSArray* playerImageArr = @[playerBu,playerShiTou,playerJian];
    
//  将序列帧数组赋给UIImageView的animationImages属性
    [self.robotFist setAnimationImages:robotImageArr];
    //设置动画时间
    [self.robotFist setAnimationDuration:0.5];
    //设置动画次数4   0 表示无限
    [self.robotFist setAnimationRepeatCount:4];
    [self.playerFist setAnimationImages:playerImageArr];
    [self.playerFist setAnimationDuration:0.5];
    [self.playerFist setAnimationRepeatCount:4];
    //开始播放动画
    [self.robotFist startAnimating];
    [self.playerFist startAnimating];
    
}


#pragma mark - 懒加载
#pragma mark 用户
-(ZMPlayer *)player{
    if (_player == nil) {
        _player = [[ZMPlayer alloc] init];
    }
    return _player;
}
#pragma mark 机器人
-(ZMRoot *)robot{
    if (_robot == nil) {
        _robot = [[ZMRoot alloc] init];
    }
    return _robot;
}

@end
