
#import "PlayViewController.h"
#import "MusicModel.h"
#import "MusicTool.h"
#import "MusicDataManger.h"
#import "LyricTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LyricModel.h"

#pragma mark --- 定义tag来判断播放/暂停按钮的状态
typedef enum : NSUInteger {
    playingStatus = 100,
    stopingStatus,
    nonStatus,
} musicStaus;

@interface PlayViewController ()<UITableViewDataSource,UITableViewDelegate>
/// 播放/暂停
@property (strong, nonatomic) IBOutlet UIButton *PlayAndStopBtn;
// 歌曲总时长
@property (strong, nonatomic) IBOutlet UILabel *musicSumTimeLabel;
// 演出时间
@property (strong, nonatomic) IBOutlet UILabel *singTimeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UITableView *LyricTableView;
// 显示栏转动图片
@property (strong, nonatomic) IBOutlet UIImageView *roateImageView;

// 定义一个数组 接受解析出来的歌词模型
@property (strong,nonatomic) NSArray *lyricArray;

// 定义变量接收当前正在 播放/暂停 音乐的返回值
@property (strong,nonatomic) AVPlayer *player;

// 定义一个变量 检测当前播放歌词的下标
@property (assign,nonatomic) NSInteger currentLyricIndex;

/// 定时时器
@property (weak,nonatomic) NSTimer *timer;

@property (strong, nonatomic) IBOutlet UISlider *ProgresSlider;




@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.roateImageView.layer.cornerRadius = 35;
    
}
#pragma mark ----- slide 点击事件
/*
- (IBAction)SliderDidClicked:(UIPanGestureRecognizer *)sender {

    // 获得挪动距离
    CGPoint offSet = [sender translationInView:sender.view];
    
 
    //把挪动清零
    [sender setTranslation:CGPointZero inView:sender.view];
    
    //2.控制滑块和进度条的frame
//     CGFloat sliderMaxX=self.view.width-self.slider.width;
//      self.ProgresSlider.x += offSet.x;
      //控制滑块的frame，不让其越界
//      if(self.slider.x<0)
//         {
//                   self.slider.x=0;
//             }else if (self.slider.x>sliderMaxX)
//                {
//                       self.slider.x=sliderMaxX;
//                     }
        //设置进度条的宽度
//        self.playProgress.width=self.ProgresSlider.center.x;
    
}
*/

#pragma mark ----- 弹出音乐界面并且播放音乐
-(void)showViewAndPlayMusic
{
    // 把控制器的view添加到window上面
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 把控制器的view添加到window上
    [window addSubview:self.view];
    
    // 动画出来view
    // 1.让view处于 屏幕最下方
    self.view.y = window.height;
    
    // 2.关闭交互
    window.userInteractionEnabled = NO;
    
    // 动画 让view 处于屏幕最上方
    [UIView animateWithDuration:0.5f animations:^{
        // 让view 处于最上方
        self.view.y = 0;
        
    } completion:^(BOOL finished) {
        // 打开用户交互
        window.userInteractionEnabled = YES;
        
        // 充值歌曲信息
        [self resertMusicInfo];
        
    }];
    
}

#pragma mark ----- 重置歌曲
-(void)resertMusicInfo
{
    // View 加载完之后开始播放音乐
    // 获取应该播放的音乐模型
    MusicModel *model = [[MusicDataManger sharedMusicHandle] currentPlayMusic];
    
    // 根据网址播放音乐
    self.player = [MusicTool playMusicWithMusicUrlString:model.mp3Url];
    
    // 设置背景音乐
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"musicbackGround@2x"]];
    
    // 设置控制栏 转圈图片
    [self.roateImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"musicbackGround@2x.png"]];
    
    // 给播放/暂停按钮添加一个tag值t
    self.PlayAndStopBtn.tag = playingStatus;
    
    // 设置总时长
    self.musicSumTimeLabel.text = model.duration;
    
    // 设置歌词
    self.lyricArray = [[MusicDataManger sharedMusicHandle] getCurrentLyric];
    
    // 刷新界面
    [self.LyricTableView reloadData];
    
    // 初始化定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    // 开启子线程的RunLoop
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
// 实现定时器更新方法
-(void)updateProgress
{
    // 获取当前播放的时间
    NSInteger currentTime = self.player.currentTime.value/self.player.currentTime.timescale;
    
    // 循环找出当前播放的歌词
    for (int i = 0; i < self.lyricArray.count; i++) {
        LyricModel *moedl = self.lyricArray[i];
        if (currentTime == moedl.time) {
            // 记录当前播放歌词的下标
            self.currentLyricIndex = i;
            break;
        }
    }
    
    // 让tableView 滚动
    [self.LyricTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLyricIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    // 刷新tableView
    [self.LyricTableView reloadData];

    // 拿到当前播放的歌曲
    MusicModel *model = [[MusicDataManger sharedMusicHandle] currentPlayMusic];
    // 切割 时间字符串
    NSArray *timeArray = [model.duration componentsSeparatedByString:@":"];
    // 获取integer 类型的时间
    NSInteger sum = [timeArray[0] integerValue]*60+[timeArray[1] integerValue];

    // 设置 进度条 左侧时间
    self.singTimeLabel.text = [NSString stringWithFormat:@"%ld:%02ld",currentTime/60,currentTime%60];
    
    // 设置剩余总时长
    NSInteger remainTime = sum - currentTime;
    if (remainTime % 60 < 10) {
        self.musicSumTimeLabel.text = [NSString stringWithFormat:@"%ld:0%ld",remainTime/60,remainTime%60];
    }else{
         self.musicSumTimeLabel.text = [NSString stringWithFormat:@"%ld:%ld",remainTime/60,remainTime%60];
    }

    // 当剩余总时长为0的时候,自动播放下一首
//    if ([NSString stringWithFormat:@"%ld",currentTime] == self.musicSumTimeLabel.text) {
//        NSLog(@"%@",[NSString stringWithFormat:@"%ld",currentTime]);
//        [self nextBtnDidClicked:nil];
//    }
    if ([self.musicSumTimeLabel.text isEqualToString:@"0:00"]) {
        NSLog(@"%@",[NSString stringWithFormat:@"%ld",currentTime]);
        [self nextBtnDidClicked:nil];
    }

    
    // 更新进度条
    self.playProgress.progress = currentTime/(sum *1.0f);
    
    // 小图片转动
    self.roateImageView.transform = CGAffineTransformRotate(self.roateImageView.transform, M_PI_2/30);
    
}


#pragma mark ----- 暂停当前播放音乐并移除 -----
-(void)pauseCurrentMusic
{
    // 取出当前播放的音乐
    MusicModel *model = [[MusicDataManger sharedMusicHandle] currentPlayMusic];
    // 先暂停当前播放的歌曲
    [MusicTool stopMusicWithMusicUtlString:model.mp3Url];
    
    // 在移除当前播放的音乐
    [MusicTool removeCurrentItem:model.mp3Url];
    
    // 移除计时器
    [self.timer invalidate];
}

#pragma mark -- 退出界面按钮点击事件
- (IBAction)QuietBtnDidClicked:(id)sender
{
    // 1.拿到当前的window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 2.关闭用户交互
    window.userInteractionEnabled = NO;
    
    // 3.执行退出动画
    [UIView animateWithDuration:0.5f animations:^{
        // 让view 视图处于 window最下方
        self.view.y = window.size.height;
        
    } completion:^(BOOL finished) {
        // 开启用户交互
        window.userInteractionEnabled = YES;
        
        // 从父视图上移除,避免每次点击cell都加载一个view
        [self.view removeFromSuperview];
    }];
}

#pragma mark --- 上一曲
- (IBAction)previousBtnDidClicked:(id)sender
{
    // 暂停当前音乐,并移除
    [self pauseCurrentMusic];
    
    // 取出需要播放的音乐(即下一首)
    MusicModel *model = [[MusicDataManger sharedMusicHandle] previousPlayMusic];
    
    // 把下一首歌曲设置为当前应该播放的歌曲
    [[MusicDataManger sharedMusicHandle] setCurrentPlayMusic:model];
    // 重置歌曲
    [self resertMusicInfo];
}

#pragma mark --- 播放/暂停
- (IBAction)playAndStopBtnDidClicked:(id)sender
{
    // 获取当前播放的音乐
    MusicModel *model = [[MusicDataManger sharedMusicHandle] currentPlayMusic];
    
    // 根据按钮的 tag值 判断是播放还是暂停
    if (self.PlayAndStopBtn.tag == playingStatus) {
        // 修改tag值
        self.PlayAndStopBtn.tag = stopingStatus;
        
        // 修改按钮的背景图片
        [self.PlayAndStopBtn setBackgroundImage:[UIImage imageNamed:@"play@2x.png"] forState:UIControlStateNormal];
        
        // 点击时暂停
        [MusicTool stopMusicWithMusicUtlString:model.mp3Url];
        
        // 暂停计时器
        self.timer.fireDate = [NSDate distantFuture];
        
    }else{
        // 修改tag值
        self.PlayAndStopBtn.tag = playingStatus;
        
        // 修改图片
        [self.PlayAndStopBtn setBackgroundImage:[UIImage imageNamed:@"pause@2x.png"] forState:UIControlStateNormal];
        
        // 点击时继续播放音乐
        [MusicTool playMusicWithMusicUrlString:model.mp3Url];
        
        // 恢复计时器
        self.timer.fireDate = [NSDate distantPast];
    }
}

#pragma mark --- 下一曲
- (IBAction)nextBtnDidClicked:(id)sender
{
    // 先暂停当前音乐并移除
    [self pauseCurrentMusic];
    
    // 取出要播放的下一首
    MusicModel *model = [[MusicDataManger sharedMusicHandle] nextPlayMusic];
    
    // 把下一首设置为当前应该播放的歌曲
    [[MusicDataManger sharedMusicHandle] setCurrentPlayMusic:model];
    
    // 重置歌曲
    [self resertMusicInfo];
}

#pragma mark ----- LyricTableView 协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LyricTableViewCell"];
    // 获取当前播放的歌曲
    LyricModel *lyricModel = self.lyricArray[indexPath.row];
    cell.LyricTable.text = lyricModel.lyric;
    
    // 判断歌词是否在播放
    if (indexPath.row == self.currentLyricIndex) {
        cell.LyricTable.textColor = [UIColor yellowColor];
        cell.LyricTable.font = [UIFont systemFontOfSize:17];
    }else{
        cell.LyricTable.textColor = [UIColor whiteColor];
        cell.LyricTable.font = [UIFont systemFontOfSize:13];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
