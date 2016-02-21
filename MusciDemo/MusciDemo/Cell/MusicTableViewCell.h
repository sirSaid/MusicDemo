
#import <UIKit/UIKit.h>
@class MusicModel;

@interface MusicTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *MusicImagView;
@property (strong, nonatomic) IBOutlet UILabel *MusicNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *SingerLabel;

#pragma mark ----- 重写cell赋值方法
-(void)setCellWithMusicModel:(MusicModel*)model;

@end
