//
//  ContactCell.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "ContactCell.h"
#import "ContactCircleView.h"
#import <Contacts/Contacts.h>

@interface ContactCell ()

@property (nonatomic, strong) ContactCircleView *circleView;

@property (nonatomic, strong) UIImageView *userAvatarView;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *phoneNumberLabel;

@end

@implementation ContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.userAvatarView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.phoneNumberLabel];
        [self setupConstraints];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupConstraints{
    
    float width = ContactCellHeight - ContactCellMargin * 2;
    
    NSArray *circleViewConstraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_circleView(width)]-margin-[_userNameLabel]-[_phoneNumberLabel(<=150)]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"width":@(width),@"margin":@(ContactCellMargin)} views:NSDictionaryOfVariableBindings(_circleView,_userNameLabel,_phoneNumberLabel)];
    NSArray *circleViewConstraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_circleView]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"margin":@(ContactCellMargin)} views:NSDictionaryOfVariableBindings(_circleView)];
    [self.contentView addConstraints:circleViewConstraints_H];
    [self.contentView addConstraints:circleViewConstraints_V];
    
    NSArray *avatarViewConstraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_userAvatarView(width)]" options:NSLayoutFormatAlignAllLeft metrics:@{@"width":@(width),@"margin":@(ContactCellMargin)} views:NSDictionaryOfVariableBindings(_userAvatarView)];
    NSArray *avatarViewConstraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_userAvatarView]-margin-|" options:NSLayoutFormatAlignAllLeft metrics:@{@"margin":@(ContactCellMargin)} views:NSDictionaryOfVariableBindings(_userAvatarView)];
    [self.contentView addConstraints:avatarViewConstraints_H];
    [self.contentView addConstraints:avatarViewConstraints_V];
    
    NSArray *nameLabelConstraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_userNameLabel]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"margin":@(ContactCellMargin)} views:NSDictionaryOfVariableBindings(_userNameLabel)];
    [self.contentView addConstraints:nameLabelConstraints_V];
    
    NSArray *phoneLabelConstrants_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_phoneNumberLabel]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"margin":@(ContactCellMargin)} views:NSDictionaryOfVariableBindings(_phoneNumberLabel)];
    [self.contentView addConstraints:phoneLabelConstrants_V];
}

#pragma mark - setter

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfo:(ContactInfo *)info{
    if (info != _info) {
        _info = info;
        NSString *showedString = [NSString stringWithFormat:@"%@%@",info.givenName,info.familyName];
        if (showedString.length > 0) {
            
        }else{
            showedString = info.organizationName;
        }
        
        self.userNameLabel.text = showedString;
        
        if (info.imageData) {
            self.userAvatarView.hidden = NO;
            self.circleView.hidden = YES;
            self.userAvatarView.image = [UIImage imageWithData:info.imageData];
        }else{
            self.userAvatarView.hidden = YES;
            self.circleView.hidden = NO;
            self.circleView.title = showedString;
        }
        
        if (info.phoneNumbers.count > 0) {
            
            CNPhoneNumber *phoneNumber = [(CNLabeledValue *)info.phoneNumbers.firstObject value];
            self.phoneNumberLabel.text = phoneNumber.stringValue;
        }else if (info.emailAddresses.count > 0) {
            self.phoneNumberLabel.text = [(CNLabeledValue *)info.emailAddresses.firstObject value];
            
        }
        
    }
}

#pragma mark - getter

-(ContactCircleView *)circleView{
    if (_circleView == nil) {
        _circleView = [[ContactCircleView alloc] init];
        _circleView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _circleView;
}

-(UIImageView *)userAvatarView{
    if (_userAvatarView == nil) {
        _userAvatarView = [[UIImageView alloc] init];
        _userAvatarView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _userAvatarView;
}

-(UILabel *)userNameLabel{
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.adjustsFontSizeToFitWidth = YES;
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _userNameLabel;
}

-(UILabel *)phoneNumberLabel{
    if (_phoneNumberLabel == nil) {
        _phoneNumberLabel = [[UILabel alloc] init];
        _phoneNumberLabel.adjustsFontSizeToFitWidth = YES;
        _phoneNumberLabel.textColor = [UIColor blackColor];
        _phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _phoneNumberLabel;
}

@end
