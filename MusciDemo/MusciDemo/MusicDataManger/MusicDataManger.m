
#import "MusicDataManger.h"
#import "MusicModel.h"
#import "LyricModel.h"

@interface MusicDataManger ()
{
    MusicModel *_currentPlayModel;
}

@end

static MusicDataManger *musicHandle = nil;

@implementation MusicDataManger

+(instancetype)sharedMusicHandle
{
    return [[self alloc] init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == musicHandle) {
            musicHandle = [super allocWithZone:zone];
        }
    });
    return musicHandle;
}

-(void)getDataFromNetWorkWithBlock:(NETWORKbLOCK)finishBlock
{
    // 创建子线程进行网路请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        @autoreleasepool {
            // 定义一个临时数组接受请求下来的数据
            NSMutableArray *tempArray = [NSMutableArray array];
            // 网络请求
            NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"]];
            // 遍历请求下来的数据
            for (NSDictionary *dic in array) {
                MusicModel *model = [[MusicModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [tempArray addObject:model];
            }
            // 临时数组加入到存储数组
            self.dataArray = [NSArray arrayWithArray:tempArray];
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.dataArray.count > 0) {
                    finishBlock(YES);
                }else{
                    finishBlock(NO);
                }
                
            });
        }
    });
}

#pragma mark --- 设置当前应该播放的歌曲 ---
-(void)setCurrentPlayMusic:(MusicModel *)model
{
    // 如果设置的音乐存在当前列表中,进行赋值
    if ([self.dataArray containsObject:model]) {
        _currentPlayModel = model;
    }
}


#pragma mark --- 获取当前播放的音乐 ---
-(MusicModel *)currentPlayMusic
{
    return _currentPlayModel;
}

#pragma mark --- 获取上一首歌曲 ---
-(MusicModel *)previousPlayMusic
{
    // 获取当前播放的模型下标
    NSInteger index = [self.dataArray indexOfObject:_currentPlayModel];
    
    // 如果是第一手 直接返回最后一个元素
    if (index == 0) {
        _currentPlayModel = self.dataArray.lastObject;
        return self.dataArray.lastObject;
    }
    // 如果不是第一个 直接返回上一首
    index = index - 1;
    _currentPlayModel = self.dataArray[index];

    return self.dataArray[index];
}

#pragma mark --- 获取下一首歌曲 ---
-(MusicModel *)nextPlayMusic
{
    // 获取当前播放音乐的下标
    NSInteger index = [self.dataArray indexOfObject:_currentPlayModel];
    
    // 如果是最后一首
    if (index == self.dataArray.count - 1) {
        // 将第一首音乐设为当前播放的模型
        _currentPlayModel = self.dataArray.firstObject;
        return self.dataArray.firstObject;
    }
    // 如果不是 返回下一首
    index ++;
    _currentPlayModel = self.dataArray[index];
    return self.dataArray[index];
}

#pragma mark --- 设置 歌词 ---
// 歌词某行类型    [03:44.200]曾幻想过永恒
-(NSArray *)getCurrentLyric
{
    // 获取当前歌词
    NSString *lyricString = _currentPlayModel.lyric;
    
    // 解析歌词 \n分割 歌词和时间
    NSArray *sumLyricArray = [lyricString componentsSeparatedByString:@"\n"];
    
    // 定义数组  用来存储 所有的 时间 歌词
    NSMutableArray *finalArray = [NSMutableArray array];
    
    // 遍历分割后的数组
    for (int i = 0; i < sumLyricArray.count - 1; i++) {
        // **** 遍历取出时间
        // 获取到分割的某一行
        NSString *lineLyricStr = sumLyricArray[i];
        if (![lineLyricStr hasPrefix:@"["]) {
            LyricModel *model = [[LyricModel alloc] initWithLyric:lineLyricStr withTime:0];
            [finalArray addObject:model];
            continue;
        }
        
        // 根据"]"分割取出 时间
        NSArray *timeLyricArray = [lineLyricStr componentsSeparatedByString:@"]"];
        // 去分割后的时间字符串的部分值
        NSString *timeStr = [timeLyricArray[0] substringWithRange:NSMakeRange(1, 5)];
        // 根据冒号分割出分和秒
        NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
        // 将分割出来的数据 转换成秒
        NSInteger time = [timeArray[0] integerValue]*60+[timeArray[1] integerValue];
        // 取出歌词
        NSString *lyric = timeLyricArray[1];
        
        // 判断改行歌词是否为空
        if (lyric.length < 1) {
            continue;
        }
        // 创建歌词模型 存数 时间 和歌词
        LyricModel *lyricMod = [[LyricModel alloc] initWithLyric:lyric withTime:time];
        
        // 将模型添加到数组
        [finalArray addObject:lyricMod];
    }
    return finalArray;
}





@end
