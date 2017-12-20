//
//  YBInformationCell.m
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/20.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBInformationCell.h"
@interface YBInformationCell()<UITextFieldDelegate>
{
    
}

@end

@implementation YBInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    WEAK_SELF;
  //CGFloat font = 14;
    
   UILabel * ins = [[UILabel alloc]init];
    //ins.text = @"公司信息";
    //ins.font = YBFont(font);
   // ins.textAlignment = NSTextAlignmentCenter;
    ins.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kpadding);
        make.centerY.equalTo(weakSelf);
    }];
    weakSelf.text = ins;
    
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_chose_arrow_nor"]];
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kpadding);
        make.centerY.equalTo(weakSelf);
    }];
    weakSelf.imageV = imageV;
    
    
    UITextField *textField = [[UITextField alloc]init];
    //textField.text = @"公司信息";
    //textField.font = YBFont(font);
    textField.textAlignment = NSTextAlignmentRight;
    textField.delegate = weakSelf;
    textField.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.imageV.mas_left);
        make.centerY.equalTo(weakSelf);
    }];
    weakSelf.textField = textField;
    
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.tag = 1;
    moreBtn.hidden = YES;
    //[moreBtn setTitle:@" " forState:UIControlStateNormal];
    [moreBtn setTitleColor:kTextGreyColor forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"下角"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    self.btnAZ = moreBtn;
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.textField.mas_left);
        make.centerY.mas_equalTo(weakSelf);
        make.width.mas_equalTo(50);
    }];
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.tag = 2;
    moreBtn.hidden = YES;
    //moreBtn.backgroundColor = [UIColor redColor];
    //[moreBtn setTitle:@" " forState:UIControlStateNormal];
    [moreBtn setTitleColor:kTextGreyColor forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"下角"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    self.btnCity = moreBtn;
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.btnAZ.mas_left);
        make.centerY.mas_equalTo(weakSelf);
        make.width.mas_equalTo(50);
    }];
    
}
-(void)btnClick:(UIButton *)sender{
    WEAK_SELF;
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (sender.tag == 1) {//A-z
        NSMutableArray * dataSource = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V"@"W",@"X",@"Y",@"Z", nil];
        [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSource defaultSelValue:weakSelf.btnAZ.titleLabel.text isAutoSelect:YES resultBlock:^(id selectValue) {
            [weakSelf.btnAZ setTitle:selectValue forState:UIControlStateNormal];
        }];
    } else {
         NSMutableArray * dataSource = [NSMutableArray arrayWithObjects:
//        北京市（京）
                                        @"京",
//        天津市（津）
                                         @"津",
//        上海市（沪）
                                         @"沪",
//        重庆市（渝）
                                         @"渝",
//        河北省（冀）
                                         @"冀",
//        河南省（豫）
                                         @"豫",
//        云南省（云）
                                         @"云",
//        辽宁省（辽）
                                         @"辽",
//        黑龙江省（黑）
                                         @"黑",
//        湖南省（湘）
                                         @"湘",
//        安徽省（皖）
                                         @"皖",
//        山东省（鲁）
                                         @"鲁",
//        新疆维吾尔（新）
                                         @"新",
//        江苏省（苏）
                                         @"苏",
//        浙江省（浙）
                                         @"浙",
//        江西省（赣）
                                         @"赣",
//        湖北省（鄂）
                                         @"鄂",
//        广西壮族（桂）
                                         @"桂",
//        甘肃省（甘）
                                         @"甘",
//        山西省（晋）
                                         @"晋",
//        内蒙古（蒙）
                                         @"蒙",
//        吉林省（吉）
                                         @"吉",
//        福建省（闽）
                                         @"闽",
//        贵州省（贵）
                                         @"贵",
//        广东省（粤）
                                         @"粤",
//        青海省（青）
                                         @"青",
//        西藏（藏）
                                         @"藏",
//        四川省（川）
                                         @"川",
//        宁夏回族（宁）
                                         @"宁",
//        海南省（琼）
                                         @"琼",
        nil];
        [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSource defaultSelValue:weakSelf.btnCity.titleLabel.text isAutoSelect:YES resultBlock:^(id selectValue) {
            [weakSelf.btnCity setTitle:selectValue forState:UIControlStateNormal];
        }];
    }
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //[[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}
@end
