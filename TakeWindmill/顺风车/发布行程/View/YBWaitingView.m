//
//  YBWaitingView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBWaitingView.h"


@interface YBOrdersView ()

@property (nonatomic, weak) UIImageView *ordersTime;

@property (nonatomic, weak) UILabel *ordersLabel;

@end

@implementation YBOrdersView

- (UIImageView *)ordersTime
{
    if (!_ordersTime) {
        UIImageView *ordersTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"沙漏"]];
        
        [self addSubview:ordersTime];
        
        _ordersTime = ordersTime;
    }
    return _ordersTime;
}

- (UILabel *)ordersLabel
{
    if (!_ordersLabel) {
        UILabel *ordersLabel = [[UILabel alloc] init];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"平均接单时间为 5-15分钟  请耐心等待"];
        NSRange range1=[[hintString string]rangeOfString:@"5-15分钟"];
        [hintString addAttribute:NSForegroundColorAttributeName value:BtnOrangeColor range:range1];
        ordersLabel.attributedText = hintString;
        ordersLabel.font = YBFont(14);
        [self addSubview:ordersLabel];
        
        _ordersLabel = ordersLabel;
    }
    return _ordersLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.ordersTime.frame = CGRectMake(10, 10, 15, 20);
    self.ordersLabel.frame = CGRectMake(CGRectGetMaxX(self.ordersTime.frame) + 10, 10, YBWidth - 40, 20);
}

@end







//***********************************************超级分割线************************************************************//
#pragma mark - 车主详情
@interface YBOwnerInformationView ()

/**
 * 车主头像
 */
@property (weak, nonatomic) UIImageView *avatarImageView;

/**
 * 车主姓名
 */
@property (weak, nonatomic) UILabel *ownerNameLabel;

/**
 * 车主性别
 */
@property (weak, nonatomic) UIImageView *genderImageView;

/**
 * 印象
 */
@property (nonatomic, weak) UILabel *impressionLabel;

/**
 * 车牌号
 */
@property (nonatomic, weak) UILabel *numberPlateLabel;

/**
 * 车主车型
 */
@property (weak, nonatomic) UILabel *modelsLabel;
//
///**
// * 车主信任值
// */
//@property (weak, nonatomic) UIButton *trustValueButton;

/**
 * 车主标签
 */
@property (weak, nonatomic) UILabel *ownerTypeLabel;


@end

@implementation YBOwnerInformationView

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        //用户头像
        UIImageView *avatarImageView            = [[UIImageView alloc] init];
        avatarImageView.layer.masksToBounds     = YES;
        avatarImageView.layer.cornerRadius      = 20;
        avatarImageView.userInteractionEnabled  = YES;
        //初始化一个手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [avatarImageView addGestureRecognizer:singleTap];
        //显示
        [self addSubview:avatarImageView];
        
        _avatarImageView = avatarImageView;
    }
    return _avatarImageView;
}

- (UILabel *)ownerNameLabel
{
    if (!_ownerNameLabel) {
        //用户昵称
        UILabel *ownerNameLabel = [[UILabel alloc] init];
        ownerNameLabel.font     = YBFont(13);
        [self addSubview:ownerNameLabel];
        
        _ownerNameLabel = ownerNameLabel;
    }
    return _ownerNameLabel;
}

- (UIImageView *)genderImageView
{
    if (!_genderImageView) {
        //车主性别
        UIImageView *genderImageView = [[UIImageView alloc] init];
        [self addSubview:genderImageView];
        _genderImageView = genderImageView;
    }
    return _genderImageView;
}

- (UILabel *)impressionLabel
{
    if (!_impressionLabel) {
        UILabel *impressionLabel    = [[UILabel alloc] init];
        impressionLabel.font        = YBFont(10);
        impressionLabel.textColor   = [UIColor lightGrayColor];
        [self addSubview:impressionLabel];
        
        _impressionLabel = impressionLabel;
    }
    return _impressionLabel;
}

- (UILabel *)numberPlateLabel
{
    if (!_numberPlateLabel) {
        //车牌号
        UILabel *numberPlateLabel           = [[UILabel alloc] init];
        numberPlateLabel.font               = YBFont(11);
        numberPlateLabel.layer.cornerRadius = 2;
        [self addSubview:numberPlateLabel];
        
        _numberPlateLabel = numberPlateLabel;
    }
    return _numberPlateLabel;
}

- (UILabel *)modelsLabel
{
    if (!_modelsLabel) {
        //车主车型
        UILabel *modelsLabel        = [[UILabel alloc] init];
        modelsLabel.font            = YBFont(10);
        modelsLabel.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:modelsLabel];
        
        _modelsLabel = modelsLabel;
    }
    return _modelsLabel;
}

//- (UIButton *)trustValueButton
//{
//    if (!_trustValueButton) {
//        //车主信任值
//        UIButton *trustValueButton          = [[UIButton alloc] init];
//        trustValueButton.layer.borderWidth  = 1;
//        trustValueButton.layer.cornerRadius = 3;
//        trustValueButton.titleLabel.font    = YBFont(9);
//        trustValueButton.layer.borderColor  = BtnBlueColor.CGColor;
//        [trustValueButton setTitleColor:BtnBlueColor forState:UIControlStateNormal];
//        [self addSubview:trustValueButton];
//        
//        _trustValueButton = trustValueButton;
//    }
//    return _trustValueButton;
//}

- (UILabel *)ownerTypeLabel
{
    if (!_ownerTypeLabel) {
        //车主标签
        UILabel *ownerTypeLabel = [[UILabel alloc] init];
        ownerTypeLabel.font     = YBFont(11);
        [self addSubview:ownerTypeLabel];
        
        _ownerTypeLabel = ownerTypeLabel;
    }
    return _ownerTypeLabel;
}

- (UIButton *)phoneButton
{
    if (!_phoneButton) {
        //车主电话
        UIButton *phoneButton = [[UIButton alloc] init];
        [phoneButton setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
        [self addSubview:phoneButton];
        _phoneButton = phoneButton;
    }
    return _phoneButton;
}

- (UIButton *)SMSButton
{
    if (!_SMSButton) {
        //车主短信
        UIButton *SMSButton = [[UIButton alloc] init];
        [SMSButton setImage:[UIImage imageNamed:@"短信"] forState:UIControlStateNormal];
        [self addSubview:SMSButton];
        _SMSButton = SMSButton;
    }
    return _SMSButton;
}

#pragma Mark - 乘客端_等待车主接单
- (void)WaitingTheOwnerOrders:(NSDictionary *)dict
{
    NSString *nameStr           = dict[@"NickName"];//名字
    NSString *models            = [NSString stringWithFormat:@"车类型:%@",dict[@"VehicleBrand"]];
    NSString *price             = [NSString stringWithFormat:@"%@",dict[@"ColorName"]];
    YBLog(@"%f",self.ownerNameLabel.font.pointSize);
    CGFloat nameW               = [YBTooler calculateTheStringWidth:nameStr font:self.ownerNameLabel.font.pointSize];
    CGFloat modelsW             = [YBTooler calculateTheStringWidth:models font:10];
    CGFloat priceW              = [YBTooler calculateTheStringWidth:price font:10];
    
    YBLog(@"%f",self.bounds.size.width);
    //头像
    self.backgroundColor = [UIColor whiteColor];
    self.avatarImageView.frame    = CGRectMake(15, 10, 40,40);//头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"HeadImgUrl"]] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];
    //昵称
    self.ownerNameLabel.frame           = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, 15, nameW, 15);//昵称
    self.ownerNameLabel.text            = [NSString stringWithFormat:@"%@",dict[@"NickName"]];
    //车主行呗
    self.genderImageView.frame          = CGRectMake(CGRectGetMaxX(self.ownerNameLabel.frame) + 2, self.ownerNameLabel.frame.origin.y, 10, 10);
    self.genderImageView.image          = [UIImage imageNamed:@"男士"];
    //车类型
    self.modelsLabel.frame              = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, CGRectGetMaxY(self.ownerNameLabel.frame) + 3, modelsW + 10, 15);//车类型
    self.modelsLabel.textColor          = BtnBlueColor;
    self.modelsLabel.layer.borderWidth  = 1;
    self.modelsLabel.layer.cornerRadius = 3;
    self.modelsLabel.layer.borderColor  = BtnBlueColor.CGColor;
    self.modelsLabel.text               = models;
    //车颜色
    self.ownerTypeLabel.frame           = CGRectMake(CGRectGetMaxX(self.modelsLabel.frame) + 3 ,self.modelsLabel.frame.origin.y, priceW + 5, 15);//车颜色
    self.ownerTypeLabel.text            = price;
}
#pragma mark - 点击图片
- (void)handleSingleTap:(UITapGestureRecognizer *)gest
{
    if (_iconImageViewBlock) {
        _iconImageViewBlock(gest);
    }
}

#pragma mark - 乘客端_请他接我
- (void)pleaseTakeHimDict:(NSDictionary *)dict
{
    CGFloat heit = self.frame.size.height - 20;
    self.backgroundColor = [UIColor whiteColor];
    //用户头像
    self.avatarImageView.frame = CGRectMake(10, 10, heit, heit);
    //用户姓名
    self.ownerNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, self.avatarImageView.frame.origin.y , 40, heit / 2);
    //用户性别
    self.genderImageView.frame = CGRectMake(CGRectGetMaxX(self.ownerNameLabel.frame), self.avatarImageView.frame.origin.y , heit / 2 - 2, heit / 2 - 2);
    //车牌号
    self.numberPlateLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, CGRectGetMaxY(self.ownerNameLabel.frame) + 2, 60, heit / 2);
    //车主车型详情
    self.modelsLabel.frame = CGRectMake(CGRectGetMaxX(self.numberPlateLabel.frame) + 2, CGRectGetMaxY(self.ownerNameLabel.frame) + 2, 100, heit/2);
    
    self.SMSButton.frame = CGRectMake(self.frame.size.width - 80, self.ownerNameLabel.frame.origin.y + 5, self.frame.size.height - 30, self.frame.size.height - 30);
    self.phoneButton.frame = CGRectMake(CGRectGetMaxX(self.SMSButton.frame) + 10, self.ownerNameLabel.frame.origin.y + 5, self.frame.size.height - 30, self.frame.size.height - 30);
    
    [self.avatarImageView sd_setImageWithURL:dict[@"HeadImgUrl"] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];
    
   
    self.ownerNameLabel.text             = dict[@"NickName"];
    self.genderImageView.image               = [UIImage imageNamed:@"男士"];
    self.numberPlateLabel.text               = dict[@"VehicleNumber"];
    self.numberPlateLabel.backgroundColor    = LightGreyColor;
    self.modelsLabel.text                    = [NSString stringWithFormat:@"%@ %@",dict[@"ColorName"],dict[@"VehicleBrand"]];
}

#pragma Mark - 乘客端_评价司机
- (void)evaluationDriverDict:(NSDictionary *)dict
{
    CGFloat heit         = self.frame.size.height - 20;

    //用户头像
    self.avatarImageView.frame = CGRectMake(30, 10, heit, heit);
    self.avatarImageView.layer.cornerRadius = heit / 2;
    [self.avatarImageView sd_setImageWithURL:dict[@"HeadImgUrl"] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];

    //用户姓名
    CGFloat ownerW = [YBTooler calculateTheStringWidth:dict[@"NickName"] font:16];
    self.ownerNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, self.avatarImageView.frame.origin.y , ownerW, heit / 2);
    self.ownerNameLabel.font  = YBFont(16);
    self.ownerNameLabel.text  = dict[@"NickName"];
                                            
    //车牌号
    CGFloat numberW = [YBTooler calculateTheStringWidth:dict[@"VehicleNumber"] font:14];
    self.numberPlateLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, CGRectGetMaxY(self.ownerNameLabel.frame) + 2,numberW, heit / 2);
    self.numberPlateLabel.font  = YBFont(14);
    self.numberPlateLabel.text  = dict[@"VehicleNumber"];

    //车主车型详情
    NSString *moderlsStr        = [NSString stringWithFormat:@"%@ %@",dict[@"VehicleBrand"],dict[@"VehicleSeries"]];
    CGFloat modelsW = [YBTooler calculateTheStringWidth:moderlsStr font:14];
    self.modelsLabel.frame      = CGRectMake(CGRectGetMaxX(self.numberPlateLabel.frame) + 2, CGRectGetMaxY(self.ownerNameLabel.frame) + 2, modelsW, heit/2);
    self.modelsLabel.font       = YBFont(14);
    self.modelsLabel.textColor  = [UIColor grayColor];
    self.modelsLabel.text       = moderlsStr;

    self.SMSButton.frame = CGRectMake(self.frame.size.width - 100, 20, self.frame.size.height - 40, self.frame.size.height - 40);
    self.phoneButton.frame = CGRectMake(CGRectGetMaxX(self.SMSButton.frame) + 10, 20, self.frame.size.height - 40, self.frame.size.height - 40);
}

#pragma mark - 司机端_正在寻找乘客
- (void)lookingForPassengersFrame:(NSString *)name ImageView:(NSString *)image
{
    CGFloat heit = self.frame.size.height - 20;
    self.backgroundColor = [UIColor whiteColor];
    //用户头像
    self.avatarImageView.frame = CGRectMake(10, 10, heit, heit);
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];
    //用户姓名
    self.ownerNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, self.avatarImageView.frame.origin.y, self.frame.size.width / 2, heit);
    self.ownerNameLabel.text = name;
    self.SMSButton.hidden = YES;
    self.phoneButton.hidden = YES;
}

#pragma mark - 附近乘客(正在寻找乘客的下一个界面)
-(void)nearbyPassengersFrame
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat heit = self.frame.size.height - 20;
    //用户头像
    self.avatarImageView.frame = CGRectMake(20, 10, heit, heit);
    //用户姓名
    self.ownerNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, self.avatarImageView.frame.origin.y , self.frame.size.width / 2, heit);
    self.SMSButton.frame        = CGRectMake(self.frame.size.width - 90, self.avatarImageView.frame.origin.y + 5 , 30, 30);
    self.phoneButton.frame      = CGRectMake(CGRectGetMaxX(self.SMSButton.frame) + 10, self.SMSButton.frame.origin.y, 30, 30);
}

#pragma mark 司机端- 寻找乘客的下一个界面
- (void)dictWitihDataDict:(NSDictionary *)dict
{
    [self nearbyPassengersFrame];
    
    [self.avatarImageView sd_setImageWithURL:dict[@"HeadImgUrl"] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];
    self.ownerNameLabel.text                 = dict[@"NickName"];
}

#pragma mark - 乘客评价
- (void)evaluatioOfPassengers
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat heit                = self.frame.size.height - 20;
    //用户头像
    self.avatarImageView.frame  = CGRectMake(10, 10, heit, heit);
    //用户姓名
    self.ownerNameLabel.frame   = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 5, self.avatarImageView.frame.origin.y , 40, heit);
    //用户性别
//    self.genderImageView.frame  = CGRectMake(CGRectGetMaxX(self.ownerNameLabel.frame), self.avatarImageView.frame.origin.y , heit / 3 - 2, heit / 3 - 3);
    //印象
//    self.impressionLabel.frame  = CGRectMake(CGRectGetMaxX(self.genderImageView.frame) + 10, self.avatarImageView.frame.origin.y, 100, heit / 3);
    //收到的印象次数
//    self.numberPlateLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 5, CGRectGetMaxY(self.ownerNameLabel.frame) + 2, 100, heit / 3);
    //出行次数
//    self.ownerTypeLabel.frame   = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 5, CGRectGetMaxY(self.numberPlateLabel.frame) + 2, 100, heit/3);
    //电话
    self.phoneButton.frame      = CGRectMake(self.frame.size.width - 80, 15, self.frame.size.height - 30, self.frame.size.height - 30);
    //短信
    self.SMSButton.frame        = CGRectMake(CGRectGetMaxX(self.phoneButton.frame) + 10, 15, self.frame.size.height - 30, self.frame.size.height - 30);
}

- (void)evaluatioOfPassengersDict:(NSDictionary *)dict
{
    [self.avatarImageView sd_setImageWithURL:dict[@"HeadImgUrl"] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];
    self.ownerNameLabel.text        = dict[@"NickName"];
//    self.impressionLabel.text       = @"90后·贸易 物流·外贸";
//    self.genderImageView.image      = [UIImage imageNamed:@"男士"];
//    self.numberPlateLabel.text      = @"收到了328个印象";
//    self.numberPlateLabel.textColor = [UIColor lightGrayColor];
//    self.ownerTypeLabel.text        = @"顺风车出行了233次";
//    self.ownerTypeLabel.textColor   = [UIColor lightGrayColor];
}


#pragma mark - 乘客or司机头部- 两行
- (void)completeTheEvaluationOfPassengers
{
    CGFloat heit                = self.frame.size.height - 20;
    self.backgroundColor = [UIColor whiteColor];
    //用户头像
    self.avatarImageView.frame  = CGRectMake(10, 10, heit, heit);

    //用户姓名
    self.ownerNameLabel.frame   = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 5, self.avatarImageView.frame.origin.y + 10, 40, heit / 3);
    //收到的印象次数
    self.numberPlateLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 5, CGRectGetMaxY(self.ownerNameLabel.frame) + 2, 100, heit / 3);
    //电话
    self.phoneButton.frame      = CGRectMake(self.frame.size.width - 80, 15, self.frame.size.height - 30, self.frame.size.height - 30);
    //短信
    self.SMSButton.frame        = CGRectMake(CGRectGetMaxX(self.phoneButton.frame) + 10, 15, self.frame.size.height - 30, self.frame.size.height - 30);

}
- (void)completeTheEvaluationOfPassengersDict:(NSDictionary *)dict
{
    [self.avatarImageView sd_setImageWithURL:dict[@"HeadImgUrl"] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];
    self.ownerNameLabel.text        = @"木星";
    self.numberPlateLabel.text      = @"一个月前同行";
    self.numberPlateLabel.textColor = [UIColor lightGrayColor];
    self.ownerTypeLabel.hidden      = YES;
}

@end

//***********************************************超级分割线************************************************************//
#pragma mark - 地址详情
@interface YBOrderAddressDetails ()

/**
 * 行程时间与要求
 */
@property (nonatomic, weak) YBBaseView *timeView;

/**
 * 行程的起点
 */
@property (nonatomic, weak) YBBaseView *startingPointView;

/**
 * 行程的终点
 */
@property (nonatomic, weak) YBBaseView *endView;

/**
 * 拼成价格
 */
@property (nonatomic, weak) UILabel *spellLabel;

/**
 * 拼不成价格
 */
@property (nonatomic, weak) UILabel *noSpellLabel;

@end

@implementation YBOrderAddressDetails

#pragma mark -lazy
- (YBBaseView *)timeView
{
    if (!_timeView) {
        YBBaseView *timeView = [[YBBaseView alloc] init];
        [self addSubview:timeView];
        _timeView = timeView;
    }
    return _timeView;
}

- (YBBaseView *)startingPointView
{
    if (!_startingPointView) {
        YBBaseView *startingPointView = [[YBBaseView alloc] init];
        [self addSubview:startingPointView];
        
        _startingPointView = startingPointView;
    }
    return _startingPointView;
}

- (YBBaseView *)endView
{
    if (!_endView) {
        YBBaseView *endView = [[YBBaseView alloc] init];
        [self addSubview:endView];
        
        _endView = endView;
    }
    return _endView;
}

- (UILabel *)spellLabel
{
    if (!_spellLabel) {
        UILabel *spellLabel         = [[UILabel alloc] init];
        spellLabel.font             = YBFont(14);
        spellLabel.textAlignment    = NSTextAlignmentCenter;
        spellLabel.backgroundColor  = [UIColor whiteColor];
        [self addSubview:spellLabel];
        
        _spellLabel = spellLabel;
    }
    return _spellLabel;
}

- (UILabel *)noSpellLabel
{
    if (!_noSpellLabel) {
        UILabel *noSpellLabel           = [[UILabel alloc] init];
        noSpellLabel.font               = YBFont(11);
        noSpellLabel.textColor          = [UIColor grayColor];
        noSpellLabel.backgroundColor    = [UIColor whiteColor];
        [self addSubview:noSpellLabel];
        
        _noSpellLabel = noSpellLabel;
    }
    return _noSpellLabel;
    
}

#pragma mark - 乘客端_等待车接单
- (void)passengerSide_WaitingTheOwnerOrders:(NSDictionary *)dict
{
    self.backgroundColor         = [UIColor whiteColor];

    CGFloat labelH               = self.frame.size.height / 3;
    self.timeView.frame          = CGRectMake(10, 0, self.frame.size.width - 10, labelH);
    self.startingPointView.frame = CGRectMake(10, CGRectGetMaxY(self.timeView.frame) , self.frame.size.width - 10, labelH);
    self.endView.frame           = CGRectMake(10, CGRectGetMaxY(self.startingPointView.frame), self.frame.size.width - 10, labelH);
    
    NSArray *timeArray = [dict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:[NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]] titleFont:13 titleColor:[UIColor grayColor] subTitle:[NSString stringWithFormat:@"%@座 顺路程度%@",dict[@"SeatNumber"],dict[@"MatchRateStr"]] subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@座 顺路程度%@",dict[@"SeatNumber"],dict[@"MatchRateStr"]]];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:[NSString stringWithFormat:@"顺路程度%@",dict[@"MatchRateStr"]]];
    [hintString addAttribute:NSForegroundColorAttributeName value:BtnOrangeColor range:range1];
    self.timeView.subLabel.attributedText = hintString;
    
    [self.startingPointView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnBlueColor LabelTitle:[NSString stringWithFormat:@"%@·%@",dict[@"StartCity"],dict[@"StartAddress"]] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.endView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnGreenColor LabelTitle:[NSString stringWithFormat:@"%@·%@",dict[@"EndCity"],dict[@"EndAddress"]] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
}

#pragma Mark - 两个价格 拼成拼不成
- (void)basseView
{
    CGFloat labelH = self.frame.size.height / 3;
    
    self.timeView.frame          = CGRectMake(0, 0, self.frame.size.width, labelH);
    self.startingPointView.frame = CGRectMake(0, CGRectGetMaxY(self.timeView.frame) , self.frame.size.width - 80, labelH);
    self.endView.frame           = CGRectMake(0, CGRectGetMaxY(self.startingPointView.frame), self.frame.size.width - 80, labelH);
    self.spellLabel.frame        = CGRectMake(CGRectGetMaxX(self.startingPointView.frame),labelH * 0.5 , 80, labelH * 1.5);
    self.noSpellLabel.frame      = CGRectMake(CGRectGetMaxX(self.endView.frame), CGRectGetMaxY(self.spellLabel.frame),80, labelH);
    self.backgroundColor         = [UIColor whiteColor];
}

- (void)orderDetailsDictionary:(NSDictionary *)dict
{
    NSString *isJone    = [dict[@"IsJoin"] intValue] > 0 ? @"愿意拼座" : @"不愿意拼座";
    NSArray *timeStr    = [dict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    NSString * ste      = [NSString stringWithFormat:@"%@人·%@",dict[@"PeopleNumber"],isJone];
    NSArray *endArray   = [dict[@"EndAddress"] componentsSeparatedByString:@","];
    
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:[NSString stringWithFormat:@"%@ %@",timeStr[0],timeStr[1]] titleFont:13 titleColor:[UIColor grayColor] subTitle:ste subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
    [self.startingPointView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnBlueColor LabelTitle:dict[@"StartAddress"] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.endView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnGreenColor LabelTitle:endArray[0] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    self.spellLabel.text = [NSString stringWithFormat:@"拼成%@元",dict[@"TravelCostJoin"]];
    self.noSpellLabel.text = [NSString stringWithFormat:@"拼不成%@元",dict[@"TravelCost"]];
    ;
}

#pragma Mark - 请他接我
- (void)InvitePeersWithDict:(NSDictionary *)driverDict
{
    //frame
    [self basseView];
    
    NSArray *array = [driverDict[@"SetoutTimeStr"]  componentsSeparatedByString:@"+"];
    NSString *ste = [NSString stringWithFormat:@"%@ %@",array[0],array[1]];
    
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:ste titleFont:13 titleColor:[UIColor grayColor] subTitle:[NSString stringWithFormat:@"%@人 %@",driverDict[@"PeopleNumber"],[driverDict[@"IsJoin"] intValue] > 0 ? @"愿拼座" : @"不愿拼座"] subTitleFont:12 subtitleColor:[UIColor grayColor]];
    
    [self.startingPointView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnBlueColor LabelTitle:[NSString stringWithFormat:@"%@",driverDict[@"StartAddress"]] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    
    NSArray *endArray = [driverDict[@"EndAddress"] componentsSeparatedByString:@","];
    [self.endView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnGreenColor LabelTitle:[NSString stringWithFormat:@"%@",endArray[0]] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    
    self.spellLabel.text   = [NSString stringWithFormat:@"%.2f元",[driverDict[@"TravelCostJoin"] floatValue]];
    self.spellLabel.font   = YBFont(17);
    self.noSpellLabel.text = [NSString stringWithFormat:@"拼不成%.2f元",[driverDict[@"TravelCost"] floatValue]];
}

#pragma mark - 一个价格 拼成
- (void)confirmTheItinerary
{
    self.backgroundColor = [UIColor whiteColor];
    self.timeView.frame          = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 3);
    self.startingPointView.frame = CGRectMake(0, CGRectGetMaxY(self.timeView.frame) , self.frame.size.width - 80, self.frame.size.height / 3);
    self.endView.frame           = CGRectMake(0, CGRectGetMaxY(self.startingPointView.frame), self.frame.size.width - 80, self.frame.size.height / 3);
    self.spellLabel.frame        = CGRectMake(CGRectGetMaxX(self.startingPointView.frame),CGRectGetMaxY(self.timeView.frame) , 80, self.frame.size.height / 3 * 2);
}

- (void)confirmTheItineraryDict:(NSDictionary *)dict
{
    NSString * ste = [NSString stringWithFormat:@"%@人",dict[@"PeopleNumber"]];
    
    NSArray *timeArray = [dict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:[NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]] titleFont:13 titleColor:[UIColor grayColor] subTitle:ste subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
    [self.startingPointView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnBlueColor LabelTitle:dict[@"StartAddress"] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.endView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnGreenColor LabelTitle:dict[@"EndAddress"] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    self.spellLabel.text            = [NSString stringWithFormat:@"%@元",dict[@"TravelCost"]];
    self.spellLabel.font            = YBFont(20);
    self.spellLabel.textAlignment   = NSTextAlignmentCenter;
}

- (void)LookingPassengersDict:(NSDictionary *)dict
{
//    YBLog(@"%@",dict);
    NSString *isJoin = [dict[@"IsJoin"] intValue] == 1 ? @"愿拼座" : @"不愿拼座";
    NSString *byWay  = [NSString stringWithFormat:@"顺路程度%@",dict[@"MatchRateStr"]];
    NSString *ste = [NSString stringWithFormat:@"%@人 %@",dict[@"PeopleNumber"],isJoin];
    NSString *str = [NSString stringWithFormat:@"%@ %@",ste,byWay];

    NSArray *array = [dict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@",array[0],array[1]];
    
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:timeStr titleFont:13 titleColor:[UIColor grayColor] subTitle:str subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
    //改变顺路程度的颜色
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:str];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:byWay];
    [hintString addAttribute:NSForegroundColorAttributeName value:BtnOrangeColor range:range1];
    self.timeView.subLabel.attributedText = hintString;
    
    [self.startingPointView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnBlueColor LabelTitle:[NSString stringWithFormat:@"%@·%@",dict[@"StartCity"],dict[@"StartAddress"]] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.endView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnGreenColor LabelTitle:[NSString stringWithFormat:@"%@·%@",dict[@"EndCity"],dict[@"EndAddress"]] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    self.spellLabel.text            = [NSString stringWithFormat:@"%@元",[dict[@"IsJoin"] intValue] == 1 ? dict[@"TravelCostJoin"] : dict[@"TravelCost"]];//愿拼座
    self.spellLabel.font            = YBFont(20);
    self.spellLabel.textAlignment   = NSTextAlignmentCenter;
}

#pragma mark - 没有价格
- (void)noPriceItinerary:(BOOL)isHinde
{
    self.backgroundColor = [UIColor whiteColor];

    int high = isHinde ? 2 : 3;
    self.startingPointView.hidden = isHinde;
    self.timeView.frame           = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / high);
    self.startingPointView.frame  = CGRectMake(0, CGRectGetMaxY(self.timeView.frame) , self.frame.size.width,self.frame.size.height / high);
    CGFloat startingHigh = isHinde ? CGRectGetMaxY(self.timeView.frame) :CGRectGetMaxY(self.startingPointView.frame);
    self.endView.frame            = CGRectMake(0, startingHigh, self.frame.size.width , self.frame.size.height / high);
}

- (void)noPriceItineraryWithDict:(NSDictionary *)dict
{
    NSString * ste = [NSString stringWithFormat:@"%@座",dict[@"SeatNumber"]];
    NSArray *timeArray = [dict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:[NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]] titleFont:13 titleColor:[UIColor grayColor] subTitle:ste subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
    [self.startingPointView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnBlueColor LabelTitle:[NSString stringWithFormat:@"%@·%@",dict[@"StartCity"],dict[@"StartAddress"]] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.endView aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnGreenColor LabelTitle:[NSString stringWithFormat:@"%@·%@",dict[@"EndCity"],dict[@"EndAddress"]] titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
}



@end

//***********************************************超级分割线************************************************************//

@interface YBWaitingView ()

/**
 * 头部试图
 */
@property (nonatomic, weak) UIView *headView;

/**
 * 下划线
 */
@property (nonatomic, weak) UIView *line;

/**
 * 行程信息
 */
@property (nonatomic, weak) YBOrderAddressDetails *detailsView;

/**
 * 下划线
 */
@property (nonatomic, weak) UIView *line1;

/**
 * 底部view
 */
@property (nonatomic, weak) UIView *bottomView;

/**
 * 叫车内容
 */
@property (weak, nonatomic) UILabel *contentLabel;

/**
 * 叫他来接我
 */
@property (weak, nonatomic) UIButton *callButton;

/**
 * 价格
 */
@property (weak, nonatomic) UILabel *priceLabel;


@end

@implementation YBWaitingView

#pragma mark - lazy

- (UIView *)headView
{
    if (!_headView) {
        UIView *view         = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        UIButton *foldButton = [[UIButton alloc] init];
        [foldButton setImage:[UIImage imageNamed:@"下角"] forState:UIControlStateNormal];
        [foldButton addTarget:self action:@selector(foldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:foldButton];
        [foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            //将size设置成(300,300)
            make.size.mas_equalTo(CGSizeMake(30, 15));
        }];
        
        _headView = view;
    }
    return _headView;
}

- (YBOwnerInformationView *)formationView
{
    if (!_formationView) {
        YBOwnerInformationView *formationView = [[YBOwnerInformationView alloc] init];
        formationView.iconImageViewBlock = ^(UITapGestureRecognizer *gest) {
            if (_iconImageViewBlock) {
                _iconImageViewBlock(gest);
            }
        };
        [self addSubview:formationView];
        
        _formationView = formationView;
    }
    return _formationView;
}

- (UIView *)line
{
    if (!_line) {
        UIView *line         = [[UIView alloc] init];
        line.backgroundColor =LineLightColor;
        [self addSubview:line];
        _line = line;
    }
    return _line;
}

- (YBOrderAddressDetails *)detailsView
{
    if (!_detailsView) {
        YBOrderAddressDetails *detailsView = [[YBOrderAddressDetails alloc] init];
        [self addSubview:detailsView];
        
        _detailsView = detailsView;
    }
    return _detailsView;
}

- (UIView *)line1
{
    if (!_line1) {
        UIView *line         = [[UIView alloc] init];
        line.backgroundColor = LineLightColor;
        [self addSubview:line];
        _line1 = line;
    }
    return _line1;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        UIView *bottomView         = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}


- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        //叫车内容
        UILabel *contentLabel      = [[UILabel alloc] init];
        contentLabel.text          = @"车主与你顺路,你可以主动邀请他来接你";
        contentLabel.font          = YBFont(13);
        contentLabel.numberOfLines = 0;
        [self.bottomView addSubview:contentLabel];

        _contentLabel = contentLabel;
    }
    return _contentLabel;
}

- (UIButton *)callButton
{
    if (!_callButton) {
        //
        UIButton *callButton          = [[UIButton alloc] init];
        callButton.tag                = 0;
        callButton.titleLabel.font    = YBFont(11);
        callButton.layer.cornerRadius = 5;
        callButton.imageEdgeInsets    = UIEdgeInsetsMake(0, - 10, 0, 0);
        [callButton setBackgroundColor:BtnBlueColor];
        [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [callButton addTarget:self action:@selector(callButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:callButton];
        _callButton = callButton;
    }
    return _callButton;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        //价格
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        
        _priceLabel = label;
    }
    return _priceLabel;
}

- (YBMoreBottomView *)moreBottomView
{
    if (!_moreBottomView) {
        YBMoreBottomView *moreBottomView = [[YBMoreBottomView alloc] init];
        moreBottomView.backgroundColor   = [UIColor whiteColor];
        [self.bottomView addSubview:moreBottomView];
        
        _moreBottomView = moreBottomView;
    }
    return _moreBottomView;
}

#pragma mark - 乘客端_等待车主接单cell
- (void)waitingTheOwnerOrdersCell:(NSDictionary *)dict
{
    self.backgroundColor                = [UIColor whiteColor];
    //司机信息
    self.formationView.frame            = CGRectMake(0, 0, self.frame.size.width, 60);
    [self.formationView WaitingTheOwnerOrders:dict];
    //线
    self.line.frame                     = CGRectMake(10,CGRectGetMaxY(self.formationView.frame),self.frame.size.width - 20, 1);
    //司机行程信息
    self.detailsView.frame              = CGRectMake(0, CGRectGetMaxY(self.line.frame) + 1, self.frame.size.width, 90);
    [self.detailsView passengerSide_WaitingTheOwnerOrders:dict];
    //线2
    self.line1.frame                    = CGRectMake(10,CGRectGetMaxY(self.detailsView.frame), self.frame.size.width - 20, 1);
    //底部
    self.bottomView.frame               = CGRectMake(0, CGRectGetMaxY(self.detailsView.frame) + 1, self.frame.size.width, 40);
    self.contentLabel.frame             = CGRectMake(15,10,self.frame.size.width - 100 , 25);
    self.contentLabel.text              = @"正在寻找乘客";
    self.contentLabel.textColor         = BtnOrangeColor;
    
    self.callButton.frame               = CGRectMake(CGRectGetMaxX(self.contentLabel.frame)+ 5, 10 ,70, 25);
    self.callButton.layer.borderWidth   = 1;
    self.callButton.layer.cornerRadius  = 3;
    self.callButton.layer.borderColor   = BtnBlueColor.CGColor;
    [self.callButton setBackgroundColor:[UIColor whiteColor]];
    [self.callButton setTitle:@"请他接我" forState:UIControlStateNormal];
    [self.callButton setTitleColor:BtnBlueColor forState:UIControlStateNormal];
}

- (void)passenger_PleaseTakeHim
{
    self.moreBottomView.frame       = CGRectMake(0, 0, self.frame.size.width, 40);
    [self.moreBottomView PassengerTravelButtonsArray:@[@"感谢费",@"联系客服",@"更多"]];
    
    self.bottomView.frame           = CGRectMake(0, CGRectGetMaxY(self.detailsView.frame) , self.frame.size.width, 60 + 40);
    
    self.contentLabel.frame         = CGRectMake(10, CGRectGetMaxY(self.moreBottomView.frame) + 10, self.frame.size.width / 2 - 20, 40);
    self.contentLabel.text          = @"请在到达乘客起点后，点击【到达乘客起点】";
    
    self.callButton.frame           = CGRectMake(CGRectGetMaxX(self.contentLabel.frame) + 10, self.contentLabel.frame.origin.y ,self.frame.size.width / 2 - 20, 40);
    self.callButton.tag             = 1;
    self.callButton.titleLabel.font = YBFont(15);
    [self.callButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.callButton setTitle:@"确认上车并付费" forState:UIControlStateNormal];


    CGRect viewFrame = self.frame;
    viewFrame.origin.y = viewFrame.origin.y - 50;
    viewFrame.size.height = viewFrame.size.height + 40;
    self.frame = viewFrame;
}

- (void)duringTheTrip
{
    [self.callButton setTitle:@"确认到达" forState:UIControlStateNormal];
//    self.callButton.tag ++;
}


- (void)callButtonAction:(UIButton *)action
{
    if (_clickeBlock) {
        _clickeBlock(action);
    }
}

#pragma mark - 乘客端_请他接我
- (void)passengerPriceWithDict:(NSDictionary *)dict driverDict:(NSDictionary *)driver
{
    self.backgroundColor     = LightGreyColor;
    //下角
    self.headView.frame      = CGRectMake(0, 0, self.frame.size.width, 15);
    
    //司机信息
    self.formationView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), self.frame.size.width, 60);
    [self.formationView pleaseTakeHimDict:driver];
    
    //本人行程信息
    self.detailsView.frame   = CGRectMake(0, CGRectGetMaxY(self.formationView.frame) + 1, self.frame.size.width, 90);
    [self.detailsView InvitePeersWithDict:dict];
    
    //底部
    self.bottomView.frame    = CGRectMake(0, CGRectGetMaxY(self.detailsView.frame) + 1, self.frame.size.width, 53);
    self.contentLabel.frame = CGRectMake(10,10,self.frame.size.width - 100 , 40);
    self.callButton.frame   = CGRectMake(CGRectGetMaxX(self.contentLabel.frame)+ 5, 10 ,80, 30);
    [self.callButton setTitle:@"请他接我" forState:UIControlStateNormal];
    [self.callButton setImage:[UIImage imageNamed:@"请他接我"] forState:UIControlStateNormal];
//    [self.callButton addTarget:self action:@selector(callButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 刷新价格金额
- (void)refreshThePriceDict:(NSDictionary *)dict
{
    [self.detailsView InvitePeersWithDict:dict];
}

- (void)foldButtonAction:(UIButton *)sender
{
    WEAK_SELF;
    sender.selected = !sender.selected;
    if (sender.selected) {//收回
        [UIView animateWithDuration:0.2 animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            
            CGRect details              = weakSelf.detailsView.frame;
            details.size.height         = 0;
            weakSelf.detailsView.frame  = details;
            weakSelf.detailsView.hidden = YES;
            
            CGRect bottom               = weakSelf.bottomView.frame;
            bottom.origin.y             = CGRectGetMaxY(weakSelf.detailsView.frame);
            weakSelf.bottomView.frame   = bottom;
            
            CGRect frame = weakSelf.frame;
            frame.size.height = CGRectGetMaxY(weakSelf.bottomView.frame);
            frame.origin.y = YBHeight - CGRectGetMaxY(weakSelf.bottomView.frame) - 20;
            weakSelf.frame = frame;
        }];
    }
    else {//展开
        [UIView animateWithDuration:0.2 animations:^{
            sender.imageView.transform = CGAffineTransformIdentity;
            
            CGRect details = weakSelf.detailsView.frame;
            details.size.height = 90;
            weakSelf.detailsView.frame = details;
            weakSelf.detailsView.hidden = NO;

            CGRect bottom               = weakSelf.bottomView.frame;
            bottom.origin.y             = CGRectGetMaxY(weakSelf.detailsView.frame) + 1;
            weakSelf.bottomView.frame   = bottom;
            
            CGRect frame = weakSelf.frame;
            frame.origin.y = YBHeight - CGRectGetMaxY(weakSelf.bottomView.frame) - 20;
            frame.size.height = CGRectGetMaxY(weakSelf.bottomView.frame);
            weakSelf.frame = frame;
        }];
    }
}

#pragma mark - 司机端_附近乘客页面
- (void)nearbyPassengersAndOwners:(NSDictionary *)dict
{
    self.formationView.frame = CGRectMake(0, 0, self.frame.size.width, 60);
    [self.formationView lookingForPassengersFrame:dict[@"NickName"] ImageView:dict[@"HeadImgUrl"]];
    
    self.detailsView.frame   = CGRectMake(0, CGRectGetMaxY(self.formationView.frame) + 1, self.frame.size.width, 100);
    [self.detailsView confirmTheItinerary];
    [self.detailsView LookingPassengersDict:dict];
    
    //请他来接我
    self.callButton.frame = CGRectMake(self.frame.size.width - 80, CGRectGetMaxY(self.detailsView.frame) + 5,70, 20);
    self.callButton.layer.borderWidth = 1;
    self.callButton.layer.borderColor = BtnBlueColor.CGColor;
    self.callButton.layer.cornerRadius = 5;
    [self.callButton setTitle:@"确认同行" forState:UIControlStateNormal];
    [self.callButton setTitleColor:BtnBlueColor forState:UIControlStateNormal];
    [self.callButton setBackgroundColor:[UIColor whiteColor]];

    self.priceLabel.text = [NSString stringWithFormat:@"%@元",dict[@"TravelCost"]];
    [self.priceLabel setAttributedText:[YBTooler changeLabelWithText:self.priceLabel.text]];

    self.contentLabel.hidden = YES;
}

#pragma mark - 司机_乘客行程(正在寻找乘客的下一个界面)
- (void)driverPassengerTravel:(NSDictionary *)driverDict
{
    self.backgroundColor     = LightGreyColor;
    self.headView.frame      = CGRectMake(0, 0, self.frame.size.width, 15);
    //乘客的信息
    self.formationView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), self.frame.size.width, 60);
    [self.formationView dictWitihDataDict:driverDict];
    //乘客行程信息
    self.detailsView.frame   = CGRectMake(0, CGRectGetMaxY(self.formationView.frame) + 1, self.frame.size.width, 90);
    [self.detailsView InvitePeersWithDict:driverDict];
    
    //底部
    self.bottomView.frame    = CGRectMake(0, CGRectGetMaxY(self.detailsView.frame) + 1, self.frame.size.width, 60);
    self.callButton.frame   = CGRectMake(10, 10 ,self.frame.size.width - 20, 40);
    [self.callButton setTitle:@"确认同行" forState:UIControlStateNormal];
}

#pragma mark - 司机_改变当前乘客显示信息
- (void)changeheCurrentDisplayInformation:(NSDictionary *)dict
{
    [self.formationView dictWitihDataDict:dict];
    [self.detailsView InvitePeersWithDict:dict];
}

#pragma mark -司机端_接送乘客行程变化
- (void)passengerTravel_ConfirmPeer:(NSInteger)page
{
    self.callButton.tag = page;
    if (page == 0) {
        //底部
        [self.callButton setTitle:@"确认同行" forState:UIControlStateNormal];
    }
    else if (page == -1) {// 取消行程
        self.contentLabel.text          = @"行程已取消,试试重新发布吧";
        self.contentLabel.font          = YBFont(17);
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.callButton setTitle:@"我知道了" forState:UIControlStateNormal];
    }
    else {
        [self.moreBottomView driver_sideCarpoolOrders:@[@"导航",@"取消行程",@"更多"] tagPage:page];
        switch (self.callButton.tag) {
            case 1://已点击确认同行
                self.contentLabel.text      = @"请在到达乘客起点后，点击【到达乘客起点】";
                [self.callButton setTitle:@"到达乘客起点" forState:UIControlStateNormal];
                break;
            case 2://已点击到达乘客起点
                self.contentLabel.text      = @"请在乘客上车之后，点击【接到乘客】";
                [self.callButton setTitle:@"接到乘客" forState:UIControlStateNormal];
                break;
            case 3://已点击接到乘客
                self.contentLabel.text      = @"请在乘客下车之后，点击【到达目的地】";
                [self.callButton setTitle:@"到达目的地" forState:UIControlStateNormal];
                break;
            case 4://已点击接到乘客
                self.contentLabel.text      = @"如果您想去评价,点击【去评价】";
                [self.callButton setTitle:@"去评价" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (void)passengerTravel_ConfirmPeerFrame:(NSInteger)page
{
    if (page == -1) {// 取消行程
        self.bottomView.frame           = CGRectMake(0, CGRectGetMaxY(self.detailsView.frame), self.frame.size.width, 100);
        self.contentLabel.frame         = CGRectMake(0, 0, self.frame.size.width, self.bottomView.frame.size.height / 2);
        self.callButton.frame           = CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) ,self.frame.size.width - 20, 40);
        
        CGRect viewFrame = self.frame;
        viewFrame.origin.y = viewFrame.origin.y - 10;
        viewFrame.size.height = viewFrame.size.height + 40;
        self.frame = viewFrame;
    }
    else {
        self.bottomView.frame       = CGRectMake(0, CGRectGetMaxY(self.detailsView.frame), self.frame.size.width, 60 + 40);
        self.moreBottomView.frame   = CGRectMake(0, 0, self.frame.size.width, 40);
        
        self.contentLabel.frame     = CGRectMake(10, CGRectGetMaxY(self.moreBottomView.frame) + 10, self.frame.size.width / 2 - 20, 40);
        self.callButton.frame       = CGRectMake(CGRectGetMaxX(self.contentLabel.frame) + 10,self.contentLabel.frame.origin.y,self.frame.size.width / 2 - 20, 40);
        self.callButton.titleLabel.font = YBFont(15);
    }
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.bottomView.frame);
    self.frame = frame;

}

@end


//***********************************************超级分割线************************************************************//

@interface YBMoreBottomView ()

/**
 * 第1个
 */
@property (nonatomic, weak) UIButton *button1;

/**
 * 第2个
 */
@property (nonatomic, weak) UIButton *button2;

/**
 * 第3个
 */
@property (nonatomic, weak) UIButton *button3;
@end

@implementation YBMoreBottomView

- (UIButton *)button1
{
    if (!_button1) {
        UIButton *moreBtn                   = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, self.frame.size.height)];
        moreBtn.tag                         = 1;
        moreBtn.titleLabel.font             = YBFont(14);
        moreBtn.layer.borderWidth           = 0.5;
        moreBtn.layer.borderColor           = LineLightColor.CGColor;
        moreBtn.titleLabel.textAlignment    = NSTextAlignmentCenter;
        [moreBtn setTitleColor:LineLightColor forState:UIControlStateDisabled];
        [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
        
        _button1 = moreBtn;
    }
    return _button1;
}

- (UIButton *)button2
{
    if (!_button2) {
        UIButton *moreBtn                   = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 3, 0, self.frame.size.width / 3 , self.frame.size.height)];
        moreBtn.tag                         = 2;
        moreBtn.titleLabel.font             = YBFont(14);
        moreBtn.layer.borderWidth           = 0.5;
        moreBtn.layer.borderColor           = LineLightColor.CGColor;
        moreBtn.titleLabel.textAlignment    = NSTextAlignmentCenter;
        [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
        
        _button2 = moreBtn;
    }
    return _button2;
}

- (UIButton *)button3
{
    if (!_button3) {
        UIButton *moreBtn                   = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 3 * 2, 0, self.frame.size.width / 3, self.frame.size.height)];
        moreBtn.tag                         = 3;
        moreBtn.titleLabel.font             = YBFont(14);
        moreBtn.layer.borderWidth           = 0.5;
        moreBtn.layer.borderColor           = LineLightColor.CGColor;
        moreBtn.titleLabel.textAlignment    = NSTextAlignmentCenter;
        [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
        
        _button3 = moreBtn;
    }
    return _button3;
}

- (void)PassengerTravelButtonsArray:(NSArray *)array
{
    [self.button1 setTitle:array[0] forState:UIControlStateNormal];
    [self.button2 setTitle:array[1] forState:UIControlStateNormal];
    [self.button3 setTitle:array[2] forState:UIControlStateNormal];
}

- (void)driver_sideCarpoolOrders:(NSArray *)array tagPage:(NSInteger)tag
{
    [self.button1 setEnabled:NO];
    [self.button1 setTitle:array[0] forState:UIControlStateDisabled];
    [self.button2 setTitle:array[1] forState:UIControlStateNormal];
    [self.button3 setTitle:array[2] forState:UIControlStateNormal];
    
    if (tag == 3) {
        [self.button1 setEnabled:YES];
        [self.button1 setTitle:array[0] forState:UIControlStateNormal];
    }
    
}

- (void)moreBtnAction:(UIButton *)sender
{
    if (_selectBtn) {
        _selectBtn(sender);
    }
}
@end



@interface YBEvaluationButtonView ()


@end

@implementation YBEvaluationButtonView

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)evaluationButtonIsDisplayed:(NSArray *)array;
{
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
        
        [self.selectArray removeAllObjects];
    }
    
    CGFloat btnWith = 0.0;
    NSInteger row   = 0;
    NSInteger col   = 0;
    _selectArray    = [NSMutableArray array];
    YBLog(@"%ld",array.count);
    for (int i = 0; i < array.count; i ++) {
        
        CGFloat buttonW = [YBTooler calculateTheStringWidth:array[i][@"FName"] font:12] + 20;
        
        UIButton *btn                   = [[UIButton alloc] init];
        [self addSubview:btn];

        //row > 0 && col == 0
        CGFloat with = btnWith + col * 10 + 60 + buttonW;
        if (with > self.frame.size.width) {
            btnWith = 0;
            col = 0;
            row++;
        }
        btn.frame = CGRectMake(btnWith + col * 10 + 30, row * (30 + 10) + 20, buttonW, 30);
        btnWith += buttonW;
        col ++;
        btn.tag                         = i;
        btn.titleLabel.font             = YBFont(12);
        btn.titleLabel.textAlignment    = NSTextAlignmentCenter;
        btn.layer.cornerRadius          = 5;
        btn.layer.borderWidth           = 1;
        btn.layer.borderColor           = [UIColor lightGrayColor].CGColor;
        [btn setTitle:array[i][@"FName"] forState:UIControlStateNormal];
        [btn setTitleColor:BtnOrangeColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(evaluationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      
        if (i == array.count - 1) {
//            YBLog(@"%ld",row * (30 + 10) + 20 + 30);
            CGRect frameV = self.frame;
            frameV.size.height  = row * (30 + 10) + 20 + 30;
            self.frame = frameV;
        }
    }
}

- (void)evaluationButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = BtnOrangeColor.CGColor;
        [self.selectArray addObject:sender.titleLabel.text];
    }
    else {
        sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.selectArray removeObject:sender.titleLabel.text];
    }
}

@end











