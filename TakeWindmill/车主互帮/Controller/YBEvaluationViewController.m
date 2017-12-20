//
//  YBEvaluationViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBEvaluationViewController.h"
#import "XHStarRateView.h"
#import "YBOwnerInView.h"
#import "YBChatVC.h"


@interface YBEvaluationViewController ()<XHStarRateViewDelegate,UITextViewDelegate>
{
    NSInteger myCurrentScore;
}
/**
 */
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)YBOwnerInView *owner;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UITextView *content;
@property (nonatomic, strong)UITextView *helpContent;
@property (nonatomic, strong)UITextView *otherContent;
@property (nonatomic, strong)UILabel *otherLabel;//他对我的评价
@property (nonatomic, strong)UITextView *myContent;
//评星
@property (strong, nonatomic)XHStarRateView *StarRatingView;
@property (strong, nonatomic)XHStarRateView *otherStarRatingView;//他对我的评价
@property (strong, nonatomic)UIButton *submitButton;




@end

@implementation YBEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    
    [self setUI];
    
    [self setData];
}
-(void)setData{
    WEAK_SELF;
    
    [_owner.imageView sd_setImageWithURL:[NSURL URLWithString:_userInfoList.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"车主认证"]];
    _owner.nameLabel.text = _userInfoList.NickName;
    _owner.licensePlate.text = _userInfoList.VehicleNumber;
    _owner.modelsLabel.text = _userInfoList.VehicleSeries;
    
    _helpContent.text = _userInfoList.Message;
    _helpContent.textColor = kTextGreyColor;
    
    BOOL show = NO;
    if (_isSend) {
        if (_userInfoList.ToUserComment.length && _userInfoList.ToUserCommentStar) {
            show = YES;
        }
    }else{
        if (_userInfoList.UserComment.length && _userInfoList.UserCommentStar) {
            show = YES;
        }
    }
    
    if (show) {
        weakSelf.otherStarRatingView.currentScore = _isSend ? _userInfoList.ToUserCommentStar:_userInfoList.UserCommentStar;
        weakSelf.otherContent.text = _isSend ? _userInfoList.ToUserComment:_userInfoList.UserComment;
        weakSelf.otherContent.userInteractionEnabled = NO;
        weakSelf.otherContent.layer.borderColor = LightGreyColor.CGColor;
        weakSelf.otherContent.textColor = kTextGreyColor;
    }else{
        //weakSelf.otherStarRatingView.height = 0;
        //weakSelf.otherContent.height = 0;
        
        weakSelf.otherStarRatingView.hidden = YES;
        weakSelf.otherLabel.hidden = YES;
        weakSelf.otherContent.hidden = YES;
        
        [weakSelf.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.helpContent.mas_bottom).offset(kpadding);
        }];
    }
    
    
    show = NO;
    if (_isSend) {
        if (_userInfoList.UserComment.length && _userInfoList.UserCommentStar) {
            show = YES;
        }
    }else{
        if (_userInfoList.ToUserComment.length && _userInfoList.ToUserCommentStar) {
            show = YES;
        }
    }
    
    if (show) {
        weakSelf.StarRatingView.currentScore = _isSend ? _userInfoList.UserCommentStar : _userInfoList.ToUserCommentStar;
        weakSelf.StarRatingView.userInteractionEnabled = NO;
        weakSelf.content.text = _isSend ? _userInfoList.UserComment : _userInfoList.ToUserComment;
        weakSelf.content.layer.borderColor = LightGreyColor.CGColor;
        weakSelf.content.userInteractionEnabled = NO;
        weakSelf.content.textColor = kTextGreyColor;
        weakSelf.submitButton.hidden = YES;
    }
}
-(void)setUI{
    WEAK_SELF;
    CGFloat textH = 80;
    CGFloat ownerH = 40;
    
    CGSize starSize = CGSizeMake(YBWidth/2, 40);
    
    weakSelf.scrollView = [[UIScrollView alloc]init];
    weakSelf.scrollView.showsVerticalScrollIndicator = NO;
    weakSelf.scrollView.showsHorizontalScrollIndicator = NO;
    weakSelf.scrollView.backgroundColor = [UIColor whiteColor];
    [weakSelf.view addSubview:weakSelf.scrollView];
    [weakSelf.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(YBHeight);
    }];
    
    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(grTap)];
    [weakSelf.scrollView addGestureRecognizer:gr];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [weakSelf.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.width.mas_equalTo(YBWidth);
    }];
    weakSelf.contentView = contentView;
    
    //司机信息
    YBOwnerInView *owner = [[YBOwnerInView alloc] initWithFrame:CGRectMake(10,10, YBWidth-20, ownerH)];
    [owner.phoneButton addTarget:weakSelf action:@selector(phoneButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [owner.SMSButton addTarget:weakSelf action:@selector(SMSButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:owner];
    [owner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kpadding);
        make.right.mas_equalTo(-kpadding);
        make.height.mas_equalTo(ownerH);
    }];
    weakSelf.owner = owner;
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [weakSelf.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.owner.mas_bottom).offset(kpadding);
        make.left.mas_equalTo(kpadding);
        make.right.mas_equalTo(-kpadding);
        make.height.mas_equalTo(1);
    }];
    weakSelf.line = line;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"求助内容";
    label.textColor = [UIColor grayColor];
    label.font = YBFont(12);
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.line.mas_bottom).offset(kpadding);
        make.left.equalTo(weakSelf.owner);
    }];
    weakSelf.label = label;
    
    UITextView * text = [[UITextView alloc] init];
    text.backgroundColor = [UIColor whiteColor];
    text.layer.cornerRadius = 10;
    text.layer.borderWidth = 1;
    text.layer.borderColor = LightGreyColor.CGColor;
    text.delegate = weakSelf;
    //text.returnKeyType = UIReturnKeyDefault;
    text.userInteractionEnabled = NO;
    [contentView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.label.mas_bottom).offset(kpadding);
        make.left.mas_equalTo(kpadding);
        make.right.mas_equalTo(-kpadding);
        make.height.mas_equalTo(textH);
    }];
    weakSelf.content = text;
    weakSelf.helpContent = text;
    
    label = [[UILabel alloc] init];
    label.text = @"他对我的评价";
    label.textColor = [UIColor grayColor];
    label.font = YBFont(12);
    [weakSelf.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.content.mas_bottom).offset(kpadding);
        make.centerX.equalTo(weakSelf.owner);
    }];
    weakSelf.label = label;
    weakSelf.otherLabel = label;
    
    //评分
    XHStarRateView *starRatingView = [[XHStarRateView alloc] initWithFrame: CGRectMake(0, 0, starSize.width, starSize.height)];
    starRatingView.isAnimation = YES;
    starRatingView.rateStyle = WholeStar;
    //starRatingView.delegate = weakSelf;
    starRatingView.userInteractionEnabled = NO;
    [weakSelf.contentView addSubview:starRatingView];
    [starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.label.mas_bottom).offset(kpadding);
        make.centerX.mas_equalTo(weakSelf.contentView);
        make.size.mas_equalTo(starSize);
    }];
    weakSelf.StarRatingView = starRatingView;
    weakSelf.otherStarRatingView = starRatingView;
    
    
    text = [[UITextView alloc] init];
    text.backgroundColor = [UIColor whiteColor];
    text.layer.cornerRadius = 10;
    text.layer.borderWidth = 1;
    text.delegate = weakSelf;
    //text.returnKeyType = UIReturnKeyDefault;
    [weakSelf.contentView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.StarRatingView.mas_bottom).offset(kpadding);
        make.left.mas_equalTo(kpadding);
        make.right.mas_equalTo(-kpadding);
        make.height.mas_equalTo(textH);
    }];
    weakSelf.content = text;
    weakSelf.otherContent = text;
    
    starRatingView.currentScore = _isSend ? _userInfoList.ToUserCommentStar:_userInfoList.UserCommentStar;
    text.text = _isSend ? _userInfoList.ToUserComment:_userInfoList.UserComment;
    text.userInteractionEnabled = NO;
    text.layer.borderColor = LightGreyColor.CGColor;
    text.textColor = kTextGreyColor;
    
    
    label = [[UILabel alloc] init];
    label.text = @"我对他的评价";
    label.textColor = [UIColor grayColor];
    label.font = YBFont(12);
    [weakSelf.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.content.mas_bottom).offset(kpadding);
        make.centerX.equalTo(weakSelf.owner);
    }];
    weakSelf.label = label;
    
    //评分
    starRatingView = [[XHStarRateView alloc] initWithFrame: CGRectMake(0, 0, starSize.width, starSize.height)];
    starRatingView.isAnimation = YES;
    starRatingView.rateStyle = WholeStar;
    starRatingView.delegate = weakSelf;
    [weakSelf.contentView addSubview:starRatingView];
    [starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.label.mas_bottom).offset(kpadding);
        make.centerX.mas_equalTo(weakSelf.contentView);
        make.size.mas_equalTo(starSize);
    }];
    weakSelf.StarRatingView = starRatingView;
    
    
    text = [[UITextView alloc] init];
    text.backgroundColor = [UIColor whiteColor];
    text.layer.cornerRadius = 10;
    text.layer.borderWidth = 1;
    text.layer.borderColor = BtnBlueColor.CGColor;
    text.delegate = weakSelf;
    //text.returnKeyType = UIReturnKeyDefault;
    [weakSelf.contentView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.StarRatingView.mas_bottom).offset(kpadding);
        make.left.mas_equalTo(kpadding);
        make.right.mas_equalTo(-kpadding);
        make.height.mas_equalTo(textH);
    }];
    weakSelf.content = text;
    weakSelf.myContent = text;
    
    //提交
    UIButton * btn = [[UIButton alloc]init];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 8;
    [btn setTitle:@"提交评价" forState:UIControlStateNormal];
    [btn addTarget:weakSelf action:@selector(submitButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = BtnBlueColor;
    [weakSelf.contentView addSubview:btn];
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.content.mas_bottom).offset(kpadding*3);
        make.left.mas_equalTo(kpadding*2);
        make.right.mas_equalTo(-kpadding*2);
        make.height.mas_equalTo(45);
    }];
    weakSelf.submitButton = btn;
    
    
    
    [weakSelf.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.submitButton.mas_bottom).offset(10);
    }];
}
-(void)setUserInfoList:(UserInfoList *)userInfoList{
    _userInfoList = userInfoList;
}
-(void)setIsSend:(BOOL)isSend
{
    _isSend = isSend;
}
#pragma mark XHStarRateViewDelegate
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    NSLog(@"%ld----  %f",starRateView.tag,currentScore);
    myCurrentScore = currentScore;
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //按下return
        //[self endEditing:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//phoneButtonTap
- (void)phoneButtonTap:(UIButton *)sender {
    WEAK_SELF;
    if (weakSelf.userInfoList.Mobile.length==0) {
        [MBProgressHUD showError:@"电话号码不能为空" toView:weakSelf.view];
    }
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [[[Tools alloc]init] callAction:weakSelf.userInfoList.Mobile Delegate:weakSelf];
    });
}

- (void)SMSButtonTap:(UIButton *)sender {
    
    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:self.userInfoList.UserId name:self.userInfoList.NickName portrait:self.userInfoList.HeadImgUrl];
    
    //新建一个聊天会话View Controller对象,建议这样初始化
    YBChatVC *chat = [[YBChatVC alloc] initWithConversationType:ConversationType_PRIVATE
                                                       targetId:userInfo.userId];
    [self.navigationController pushViewController:chat animated:YES];
}
-(void)grTap{
    [self.view endEditing:YES];
}
- (void)submitButton:(UIButton *)sender {
    
    WEAK_SELF;
    [self.view endEditing:YES];//强行关闭键盘
    if (self.myContent.text.length == 0) {
        [MBProgressHUD showError:@"请输入评价内容" toView:weakSelf.view];
        return;
    }
    if (myCurrentScore == 0) {
        [MBProgressHUD showError:@"请选择评价星级" toView:weakSelf.view];
        return;
    }
    
    //sysno：系统编号，usercomment：评价内容，usercommentstar：用户评价星级，
    // sysno：系统编号，tousercomment：评价内容，tousercommentstar：用户评价星级，//车主互帮评价（接收者）
    
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    parm[@"sysno"] = [HSHString toString:self.userInfoList.SysNo];
    
    NSString * url = @"";
    if (_isSend) {
        parm[@"usercomment"] = self.myContent.text;
        parm[@"usercommentstar"] = [HSHString toString:myCurrentScore];
        url = DriverhelpDriverhelpinfousercomment;
    }else{
        parm[@"tousercomment"] = self.myContent.text;
        parm[@"tousercommentstar"] = [HSHString toString:myCurrentScore];
        url = DriverhelpDriverhelpinfotousercomment;
    }
    
    [YBRequest postWithURL:url MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        //        UserInfoList *model = [UserInfoList yy_modelWithJSON:dataArray];
        
        [MBProgressHUD showError:@"评价成功" toView:weakSelf.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
