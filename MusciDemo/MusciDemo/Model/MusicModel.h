
#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

/// 歌曲链接
@property (nonatomic,copy) NSString *mp3Url;
/// 歌曲id
@property (nonatomic,assign) NSInteger numberID;
/// 歌曲名称
@property (nonatomic,copy) NSString *name;
/// 图片网址
@property (nonatomic,copy) NSString *picUrl;
/// 歌手
@property (nonatomic,copy) NSString *singer;
/// 歌词
@property (nonatomic,copy) NSString *lyric;
/// 歌曲总时间
@property (nonatomic,copy) NSString *duration;

@end
