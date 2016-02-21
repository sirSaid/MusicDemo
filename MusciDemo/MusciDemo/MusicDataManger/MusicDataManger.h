
#import <Foundation/Foundation.h>
@class MusicModel;

typedef void(^NETWORKbLOCK)(BOOL isFinished);

@interface MusicDataManger : NSObject

// 单例
+(instancetype)sharedMusicHandle;

// 存储歌曲模型数组
@property (nonatomic,strong) NSArray *dataArray;


// 网络请求
-(void)getDataFromNetWorkWithBlock:(NETWORKbLOCK)finishBlock;

#pragma mark --- 获取当前播放的音乐 ---
-(MusicModel *)currentPlayMusic;

#pragma mark --- 获取上一首歌曲 ---
-(MusicModel *)previousPlayMusic;

#pragma mark --- 获取下一首歌曲 ---
-(MusicModel *)nextPlayMusic;

#pragma mark --- 设置当前应该播放的歌曲 ---
-(void)setCurrentPlayMusic:(MusicModel *)model;

#pragma mark --- 设置歌词 ---
-(NSArray *)getCurrentLyric;


@end
