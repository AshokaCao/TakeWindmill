//
//  YBCancelTraveView.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/20.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCancelTraveView.h"

@implementation YBCancelTraveView



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"YBCancelTraveView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}



- (void)showDetailWith:(NSDictionary *)diction
{
    self.cancelBtn.hidden = NO;
    self.wechatPayBtn.hidden = self.aliPayBtn.hidden = YES;
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:diction[@"HeadImgUrl"]] placeholderImage:[UIImage imageNamed:@""]];
    self.userNameLabel.text = diction[@"UserName"];
    self.starLabel.text = diction[@"StartAddress"];
    self.endLabel.text = diction[@"EndAddress"];
    NSString *time = [diction[@"SetoutTimeStr"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    self.timeLabel.text = time;
    self.moneyLabel.text = [NSString stringWithFormat:@"拼成价%@元",diction[@"TravelCostJoin"]];
}

- (void)userNeedToPayWith:(NSString *)orderNum andMoney:(NSString *)money
{
    self.cancelBtn.hidden = YES;
    self.wechatPayBtn.hidden = self.aliPayBtn.hidden = NO;
    self.orderNum = orderNum;
    self.needPayNum = money;
}

- (IBAction)cancelTrovleAction:(UIButton *)sender {
    self.cancelBlock(@"yes");
}

- (IBAction)wechatPayAction:(UIButton *)sender {
    [self wechatPay];
}


- (IBAction)aliPayAction:(UIButton *)sender {
    [self aliPay];
}


- (void)wechatPay{
//    WEAK_SELF;
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    parm[@"orderno"] = self.orderNum;//传订单号
    [YBRequest postWithURL:WeixinPay MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        YBPayconfigModel *paymodel = [YBPayconfigModel yy_modelWithJSON:dataArray];
        
        PayReq* req = [[PayReq alloc] init];
        req.partnerId = paymodel.partnerid;
        req.prepayId = paymodel.prepayid;
        req.package = paymodel.packagevalue;
        req.nonceStr = paymodel.noncestr;
        req.timeStamp = paymodel.timestamp.intValue;
        req.sign = paymodel.Sign;//paymodel.sign;
        [FLPAYMANAGER fl_payWithOrderMessage:req callBack:^(FLErrCode errCode, NSString *errStr) {
            NSLog(@"errCode = %zd,errStr = %@",errCode,errStr);
        }];
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
//        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
}

-(void)aliPay{
//    WEAK_SELF;
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    parm[@"configtype"] =@"alipay";
    
    //YBLog(@"url==%@",Apiconfig);
    //YBLog(@"parm==%@",parm);
    
    [YBRequest postWithURL:Apiconfig MutableDict:parm success:^(id dataArray) {
        YBLog(@"dataArray==%@",dataArray);
        YBPayconfigModel *payModel = [YBPayconfigModel yy_modelWithJSON:dataArray];
        // 重要说明
        // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
        // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
        // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
        
        NSString *appID = payModel.APPID;
        
        // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
        // 如果商户两个都设置了，优先使用 rsa2PrivateKey
        // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
        // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
        // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
        NSString *rsa2PrivateKey = payModel.PrivateKeyIOS;
        NSString *rsaPrivateKey = @"";
        
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        APOrderInfo *order = [[APOrderInfo alloc]init];
        
        // NOTE: app_id设置
        order.app_id =appID;
        
        order.notify_url = payModel.NotifyUrl;
        
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        
        // NOTE: 支付版本
        order.version = @"1.0";
        
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
        
        // NOTE: 商品数据
        order.biz_content = [[APBizContent alloc] init];
        order.biz_content.body = self.orderNum;
        order.biz_content.subject = @"皕夶打车扣费";
        order.biz_content.out_trade_no = self.orderNum; //订单ID（由商家自行制定）
        order.biz_content.timeout_express = @"30m"; //超时时间设置
        order.biz_content.total_amount = [NSString stringWithFormat:@"%@", self.needPayNum]; //商品价格
        
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        NSString *signedString = nil;
        APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
        
        if (orderInfo.length) {
            if ((rsa2PrivateKey.length > 1)) {
                signedString = [signer signString:orderInfo withRSA2:YES];
            } else {
                signedString = [signer signString:orderInfo withRSA2:NO];
            }
        }
        //NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            [FLPAYMANAGER fl_payWithOrderMessage:orderString callBack:^(FLErrCode errCode, NSString *errStr) {
                NSLog(@"errCode = %zd,errStr = %@",errCode,errStr);
            }];
        }
        
    } failure:^(id dataArray) {
        YBLog(@"failureDataArray==%@",dataArray);
//        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
}


- (IBAction)packUPAction:(UIButton *)sender {
}

@end
