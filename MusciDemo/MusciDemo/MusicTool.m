

#import "MusicTool.h"

@interface MusicTool ()

@property (strong,nonatomic) AVPlayer *player;

// 创建存储Item的字典
@property (strong,nonatomic) NSMutableDictionary *dict;



@end

static MusicTool *_tool;

@implementation MusicTool

#pragma mark --- 为了能再加号方法里获取实例变量
+(instancetype)sharedTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == _tool) {
            _tool = [[MusicTool alloc] init];
            _tool.dict = [NSMutableDictionary dictionary];
        }
    });
    return _tool;
}


#pragma mark --- 懒加载 ---
-(AVPlayer *)player
{
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

#pragma mark --- 播放音乐 ---
+(AVPlayer *)playMusicWithMusicUrlString:(NSString *)urlString
{
    // 播放每一首歌曲,使用一个Item,根据url去播放
    AVPlayerItem *item = [MusicTool sharedTool].dict[urlString];
    
    // 判断item是否存在
    if (item == nil) {
        item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
        // 把 item 存入到字典中
        [[MusicTool sharedTool].dict setObject:item forKey:urlString];
    }
    // 获取当前 item 并实现替换
    [[MusicTool sharedTool].player replaceCurrentItemWithPlayerItem:item];
    
    // 开始播放
    [[MusicTool sharedTool].player play];
    
    return [MusicTool sharedTool].player;
}

#pragma mark --- 暂停音乐 ---
+(AVPlayer *)stopMusicWithMusicUtlString:(NSString *)urlString
{
    // 音乐暂停
    [[MusicTool sharedTool].player pause];
    
    return [MusicTool sharedTool].player;
}

#pragma mark --- 移除当前播放的Item ---
+(void)removeCurrentItem:(NSString *)urlString
{
    [[MusicTool sharedTool].dict removeObjectForKey:urlString];
}

@end
