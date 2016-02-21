
#import "MusicModel.h"

@implementation MusicModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.numberID = [value integerValue];
    }
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    // 限制性父类的方法
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"duration"]) {
        // 转换成秒
        NSInteger sumSeconds = [value integerValue]/1000;
        self.duration = [NSString stringWithFormat:@"%ld:%ld",sumSeconds/60,sumSeconds%60];
    }
}

@end
