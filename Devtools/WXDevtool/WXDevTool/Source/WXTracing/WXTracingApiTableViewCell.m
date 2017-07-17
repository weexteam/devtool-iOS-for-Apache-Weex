//
//  WXTracingTableViewCell.m
//  TBWXDevTool
//
//  Created by 齐山 on 2017/7/4.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import "WXTracingApiTableViewCell.h"
@interface WXTracingApiTableViewCell()
@property(nonatomic,strong)UIColor *bgColor;
@end
@implementation WXTracingApiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 20)];
        [self.contentView addSubview:_nameLabel];
        _classLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 320, 20)];
        _classLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_classLabel];
    }
    
    return self;
}

- (void)config:(NSDictionary *)dict
{
    self.nameLabel.text = [NSString stringWithFormat:@"name:%@",dict[@"name"]];
    if(dict[@"class"]){
        self.classLabel.text = [NSString stringWithFormat:@"class:%@",dict[@"class"]];
    }else{
        self.classLabel.text = [NSString stringWithFormat:@"class:%@",dict[@"clazz"]];
    }
}
@end
