//
//  YBBaseView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBBaseView.h"

@interface fightView : UIView

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation fightView

@end

@interface YBBaseView ()

/**
 * 拼座
 */
@property (nonatomic, strong) fightView *fightView;

/**
 *不拼座
 */
@property (nonatomic, weak) UILabel *notFight;

/**
 * 价格
 */
@property (nonatomic, weak) UILabel *priceLabel;
@end


@implementation YBBaseView

#pragma mark - lazy
- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView  = [[UIImageView alloc] init];
        self.backgroundColor    = [UIColor whiteColor];
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

- (UILabel *)subLabel
{
    if (!_subLabel) {
        UILabel *subLalbel = [[UILabel alloc] init];
        [self addSubview:subLalbel];
        _subLabel = subLalbel;
    }
    return _subLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        UILabel *priceLabel = [[UILabel alloc] init];
        [self addSubview:priceLabel];
        _priceLabel = priceLabel;
    }
    return _priceLabel;
}

- (UILabel *)notFight
{
    if (!_notFight) {
        UILabel *notFight = [[UILabel alloc] init];
        [self addSubview:notFight];
        _notFight = notFight;
    }
    return _notFight;
}

- (fightView *)fightView {
    
    if (!_fightView) {
        _fightView = [[fightView alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 4, self.frame.size.width, self.frame.size.height / 4)];
        
        _fightView.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _fightView.frame.size.width / 2, self.fightView.frame.size.height)];
        _fightView.label.text = @"拼座";
        _fightView.label.textAlignment = NSTextAlignmentRight;
        _fightView.label.font = YBFont(12);
        [_fightView addSubview:_fightView.label];
        
        _fightView.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.fightView.frame.size.width / 2 + 5, 5, 30, self.fightView.frame.size.height - 10)];
        _fightView.subLabel.text = @"6.3折";
        _fightView.subLabel.textColor = [UIColor whiteColor];
        _fightView.subLabel.backgroundColor = [UIColor blackColor];
        _fightView.subLabel.textAlignment = NSTextAlignmentCenter;
        _fightView.subLabel.font = YBFont(9);
        [_fightView addSubview: _fightView.subLabel];
    }
    return _fightView;
}

#pragma mark - 改变内容
-   (void)setMainStr:(NSString *)mainStr
{
    self.label.text = mainStr;
}

- (void)setSecondaryStr:(NSString *)secondaryStr
{
    self.subLabel.text = secondaryStr;
}

- (void)setImageNameStr:(NSString *)imageNameStr
{
    self.imageView.image = [UIImage imageNamed:imageNameStr];
}

#pragma mark - View子视图设置frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_CanClick) {
        //添加点击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewActiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
   
    if (_CanPressLong) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestAction:)];
        //长按时间
        longPress.minimumPressDuration = 0.1;
        [self addGestureRecognizer:longPress];
    }
}

- (void)longPressGestAction:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {//识别长按
        self.backgroundColor = RGBA(245, 245, 245, 1);
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {//长按结束
        self.backgroundColor = [UIColor whiteColor];
        if (_selectBlock) {
            _selectBlock(self);
        }
    }    
}

- (void)viewActiondo:(UITapGestureRecognizer *)tapGesture {
    if (_selectBlock) {
        _selectBlock(self);
    }
}

- (void)tapGestureAction:(selectViewBlock)block {
    self.selectBlock = block;
}


- (void)aboutViewImage:(UIImage *)image imageFrame:(CGSize)iamgFrame imageBacColor:(UIColor *)bacColor LabelTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)color subTitle:(NSString *)subtitle subTitleFont:(CGFloat)subTitleFont subtitleColor:(UIColor *)subColor {
    
    CGFloat imageW = 6;
    CGFloat imageX = 10;
    CGFloat imageY = self.frame.size.height / 2 - 3;
    
    if (!image) {
        self.imageView.frame =CGRectMake(imageX, imageY, imageW, imageW);
        self.imageView.backgroundColor = bacColor;
        self.imageView.layer.cornerRadius = imageW / 2;
    }
    else {
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(imageX, self.frame.size.height / 2 - iamgFrame.height / 2, iamgFrame.width, iamgFrame.height);
    }

    CGFloat labelH = self.frame.size.height;
    CGFloat size = [YBTooler calculateTheStringWidth:title font:titleFont];
    if (size > self.frame.size.width - iamgFrame.width + 20) {
        size = self.frame.size.width - iamgFrame.width + 20;
    }
    self.label.text = title;
    self.label.textColor = color;
    self.label.font = YBFont(titleFont);
    self.label.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, size,labelH);
  
    self.subLabel.text = subtitle;
    CGFloat subSize = [YBTooler calculateTheStringWidth:subtitle font:subTitleFont];
    self.subLabel.textColor = subColor;
    self.subLabel.font = YBFont(subTitleFont);
    self.subLabel.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5, 0, subSize, labelH);
}

#pragma maerk - 上下View
- (void)upAndDownImage:(UIImage *)image imageSize:(CGSize)iamgFrame imageBacColor:(UIColor *)bacColor LabelTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)color subTitle:(NSString *)subtitle subTitleFont:(CGFloat)subTitleFont subtitleColor:(UIColor *)subColor {
    
    CGFloat imageW = 6;
    CGFloat imageX = 10;
    CGFloat imageY = self.frame.size.height / 2 - 3;
    
    if (!image) {
        self.imageView.frame =CGRectMake(imageX, imageY, imageW, imageW);
        self.imageView.backgroundColor = bacColor;
        self.imageView.layer.cornerRadius = imageW / 2;
    }
    else {
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(imageX, self.frame.size.height / 2 - iamgFrame.height / 2, iamgFrame.width, iamgFrame.height);
    }
    
    CGFloat labelW = self.frame.size.width - 10;
    labelW = labelW - CGRectGetMaxX(self.imageView.frame);
    CGFloat titleSize = [YBTooler accordingToTheWidthOfTheCalculationOfHigh:title with:labelW font:titleFont];
    if (titleSize > self.frame.size.height) {
        titleSize = self.frame.size.height;
    }
    self.label.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, self.frame.size.height / 8 , labelW,titleSize);
    self.label.text = title;
    self.label.textColor = color;
    self.label.font = YBFont(titleFont);
    
    self.subLabel.text = subtitle;
    CGFloat subSize = [YBTooler accordingToTheWidthOfTheCalculationOfHigh:subtitle with:labelW font:subTitleFont];;
    if (titleSize > self.frame.size.height) {
        titleSize = self.frame.size.height;
    }
    self.subLabel.textColor = subColor;
    self.subLabel.font = YBFont(subTitleFont);
    self.subLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, CGRectGetMaxY(self.label.frame) + 3, labelW, subSize);
}

- (void)increaseTheThankYouYee {
    
    self.fightView.frame = CGRectMake(0, 5, self.frame.size.width, self.frame.size.height / 2);
    [self addSubview:self.fightView];
    
    self.fightView.label.frame = CGRectMake(0, 0, self.fightView.frame.size.width / 2, self.fightView.frame.size.height);
    self.fightView.label.text = @"增加感谢费";
    self.fightView.label.font = YBFont(12);
    
    self.fightView.subLabel.frame = CGRectMake(self.fightView.frame.size.width / 2 + 5, (self.fightView.frame.size.height - 20) / 2, 30, 20);
    self.fightView.subLabel.text = @"推荐";
    self.fightView.subLabel.font = YBFont(12);
    self.fightView.subLabel.backgroundColor = BtnBlueColor;
    
    self.priceLabel.frame = CGRectMake(0, CGRectGetMaxY(self.fightView.frame)+ 5, self.frame.size.width, self.frame.size.height / 4);
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.text = @"可提高60%接单率";
    self.priceLabel.font = YBFont(12);
    self.priceLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.priceLabel];
}

#pragma mark - 价格
- (void)ridePriceisIsFight:(BOOL)isFight priceStr:(NSString *)str{
    
    if (isFight) {
        [self addSubview:self.fightView];
        
        self.priceLabel.frame = CGRectMake(0, CGRectGetMaxY(self.fightView.frame), self.frame.size.width, self.frame.size.height / 4);
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.text = str;
        [self.priceLabel setAttributedText:[YBTooler changeLabelWithText:str frontTextFont:20 Subscript:0 TextLength:[str length] - 2 BehindTxetFont:13 Subscript:[str length] - 2 TextLength:2]];
        [self addSubview:self.priceLabel];

    }else  {
        self.notFight.frame = CGRectMake(0, self.frame.size.height / 4, self.frame.size.width, self.frame.size.height / 4);
        self.notFight.text = @"不拼座";
        self.notFight.textAlignment = NSTextAlignmentCenter;
        self.notFight.font = YBFont(12);
        [self addSubview:self.notFight];
        
        self.priceLabel.frame = CGRectMake(0, CGRectGetMaxY(self.notFight.frame), self.frame.size.width, self.frame.size.height / 4);
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.text = str;
        [self.priceLabel setAttributedText:[YBTooler changeLabelWithText:str frontTextFont:20 Subscript:0 TextLength:[str length] - 1 BehindTxetFont:13 Subscript:[str length] - 1 TextLength:1]];
        [self addSubview:self.priceLabel];
    }
}

- (NSString *)getTheNumberOfPrices
{
    return self.priceLabel.text;
}

- (void)checkTheStatus:(BOOL)isSelected success:(void (^)(id isSelected))success
{
    self.CanClick = YES;
    
    if (isSelected) {
        self.fightView.label.textColor = BtnOrangeColor;
        self.fightView.subLabel.backgroundColor = BtnOrangeColor;
        self.priceLabel.textColor = BtnOrangeColor;
        self.notFight.textColor = BtnOrangeColor;
    }
    else {
        self.fightView.label.textColor = [UIColor blackColor];
        self.fightView.subLabel.backgroundColor = [UIColor blackColor];
        self.priceLabel.textColor = [UIColor blackColor];
        self.notFight.textColor = [UIColor blackColor];
    }
    
    if (success) {
        success(nil);
    }
}

- (void)initLabelStr:(NSString *)str {
    
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName: YBFont(14)}];
    self.label.text = str;
    self.label.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, ceil(size.width),self.frame.size.height);
}

/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (CGFloat)heightForString:(UITextView *)textView andWidth:(float)width
{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

@end
