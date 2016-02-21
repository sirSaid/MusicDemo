
#import <UIKit/UIKit.h>


@interface PlayViewController : UIViewController

#pragma mark ----- 弹出音乐界面并且播放音乐
-(void)showViewAndPlayMusic;

/// 进度条
@property (strong, nonatomic) IBOutlet UIProgressView *playProgress;

@end
