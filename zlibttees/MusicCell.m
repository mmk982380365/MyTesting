//
//  MusicCell.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "MusicCell.h"

@interface MusicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *singerLbl;



@end

@implementation MusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMusic:(MusicModel *)music{
    _music = music;
    
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:music.albumpic_small]];
    self.musicNameLbl.text = music.songname;
    self.singerLbl.text = music.singername;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
