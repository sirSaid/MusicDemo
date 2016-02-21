
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class PlayViewController;

@interface MusicTool : NSObject

#pragma mark --- 播放音乐 ---
+(AVPlayer *)playMusicWithMusicUrlString:(NSString *)urlString;

#pragma mark --- 暂停音乐 ---
+(AVPlayer *)stopMusicWithMusicUtlString:(NSString *)urlString;

#pragma mark --- 移除当前播放的Item ---
+(void)removeCurrentItem:(NSString *)urlString;

@property (nonatomic,assign) CGFloat allTimes;
// 计时器
@property (nonatomic,weak) NSTimer *timer;

@property (nonatomic,strong) PlayViewController *playVC;


@end
