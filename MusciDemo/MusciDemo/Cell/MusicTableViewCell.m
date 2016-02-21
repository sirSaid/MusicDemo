
#import "MusicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MusicModel.h"

@implementation MusicTableViewCell

-(void)setCellWithMusicModel:(MusicModel *)model
{
    [self.MusicImagView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"loading_1@2x"]];
    self.MusicNameLabel.text = model.name;
    self.SingerLabel.text = model.singer;
}


- (void)awakeFromNib {
    self.MusicImagView.layer.cornerRadius = 50;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
