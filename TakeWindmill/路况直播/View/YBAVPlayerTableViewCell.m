//
//  YBAVPlayerTableViewCell.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/10/27.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBAVPlayerTableViewCell.h"
#import <ZFPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation YBAVPlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self layoutIfNeeded];

    // 设置imageView的tag，在PlayerView中取（建议设置100以上）
    self.videoImage.tag = 101;
    
    // 代码添加playerBtn到imageView上
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoImage addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoImage);
        make.width.height.mas_equalTo(50);
    }];
}

- (void)setModel:(SDTimeLineCellModel *)model {
//    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
//    self.titleLabel.text = model.title;

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.HeadImgUrl]];
    
    
    NSString *imageStr = model.UploadFiles;
    NSString *newStr = [imageStr substringWithRange:NSMakeRange(0, imageStr.length - 1)];
    NSArray  *imageArray = [newStr componentsSeparatedByString:@","];
    
    NSString *mp4Str = imageArray.firstObject;
    NSURL *url = [[NSURL alloc] initWithString:mp4Str];
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    CMTime time = CMTimeMakeWithSeconds(1.0, 30);   // 1.0为截取视频1.0秒处的图片，30为每秒30帧
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *videoImage = [UIImage imageWithCGImage:cgImage];
    self.videoImage.image = videoImage;
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
