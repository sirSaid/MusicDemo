
#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

/// 歌词
@property (nonatomic,copy) NSString *lyric;

/// 歌词对应的时间
@property (nonatomic,assign) NSInteger time;

// 自定义初始化
-(instancetype)initWithLyric:(NSString *)lyric
                    withTime:(NSInteger)time;


@end
