
#import "LyricModel.h"

@implementation LyricModel

-(instancetype)initWithLyric:(NSString *)lyric withTime:(NSInteger)time
{
    self = [super init];
    if (self) {
        _lyric = lyric;
        _time = time;
    }
    return self;
}


@end
