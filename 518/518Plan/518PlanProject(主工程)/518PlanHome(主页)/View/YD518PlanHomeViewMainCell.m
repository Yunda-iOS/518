//
//  YD518PlanHomeViewMainCell.m
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import "YD518PlanHomeViewMainCell.h"

@interface YD518PlanHomeViewMainCell()

@property (nonatomic, strong) UIButton *fuCaiButton;

@end

@implementation YD518PlanHomeViewMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContent];
    }
    return self;
}

- (void)initContent {
    self.contentView.backgroundColor = UIColor.purpleColor;
    [self.contentView addSubview:self.fuCaiButton];
    [self.fuCaiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(58);
        make.right.equalTo(self.contentView).offset(-58);
        make.top.equalTo(self.contentView).offset(29);
        make.bottom.equalTo(self.contentView).offset(-29);
    }];
}

- (UIButton *)fuCaiButton {
    if (_fuCaiButton == nil) {
        _fuCaiButton = [UIButton new];
        _fuCaiButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:18];
        [_fuCaiButton setTitleColor:UIColor.purpleColor forState:UIControlStateNormal];
        _fuCaiButton.backgroundColor = UIColor.redColor;
        _fuCaiButton.layer.cornerRadius = 8;
        _fuCaiButton.layer.masksToBounds = YES;
        _fuCaiButton.userInteractionEnabled = NO;
    }
    return _fuCaiButton;
}

- (void)setFuCaiItemModel:(YD518PlanHomeItemModel *)fuCaiItemModel {
    [self.fuCaiButton setTitle:fuCaiItemModel.lottery_name forState:UIControlStateNormal];
}

@end
