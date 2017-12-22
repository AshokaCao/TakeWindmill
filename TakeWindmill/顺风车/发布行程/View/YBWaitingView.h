//
//  YBWaitingView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//***********************************************等待车主接单页等待View************************************************************//

/**
 * 等待车主接单等待试图
 */
@interface YBOrdersView : UIView

@end



//***********************************************司机详情View************************************************************//
//司机信息头部
typedef void(^iconImageViewBlock)(UITapGestureRecognizer *gest);

@interface YBOwnerInformationView : UIView

/**
 * 车主电话
 */
@property (weak, nonatomic) UIButton *phoneButton;

/**
 * 车主短信
 */
@property (weak, nonatomic) UIButton *SMSButton;

/**
 * 点击头像调用block
 */
@property (nonatomic, strong) iconImageViewBlock iconImageViewBlock;


/**
 * 乘客端_等待车主接单
 @param dict 本人信息
 */
- (void)WaitingTheOwnerOrders:(NSDictionary *)dict;

/**
 * 乘客端_邀请同行
 @param dict 司机信息
 */
- (void)pleaseTakeHimDict:(NSDictionary *)dict;

/**
 * 乘客端_评价司机
 @param dict 司机信息
 */
- (void)evaluationDriverDict:(NSDictionary *)dict;

/**
 * 司机端_正在寻找乘客
 * name 乘客昵称
 * image 乘客头像
 */
- (void)lookingForPassengersFrame:(NSString *)name ImageView:(NSString *)image;

/**
 * 附近乘客界面使用的View
 */
- (void)nearbyPassengersFrame;
- (void)dictWitihDataDict:(NSDictionary *)dict;

/**
 * 司机端_给乘客评价
 */
- (void)evaluatioOfPassengers;
- (void)evaluatioOfPassengersDict:(NSDictionary *)dict;

/**
 * 司机端_完成评价乘客
 */
- (void)completeTheEvaluationOfPassengers;
- (void)completeTheEvaluationOfPassengersDict:(NSDictionary *)dict;
@end













//***********************************************行程信息View************************************************************//

@interface YBOrderAddressDetails : UIView

/**
 * 乘客端_等待车主接单
 @param dict 行程信息
 */
- (void)passengerSide_WaitingTheOwnerOrders:(NSDictionary *)dict;

/**
 * 乘客端_邀请同行&&请他接我
 @param driverDict 乘客行程信息
 */
- (void)InvitePeersWithDict:(NSDictionary *)driverDict;

/**
 * 设置等待车主的frme
 */
- (void)basseView;
- (void)orderDetailsDictionary:(NSDictionary *)dict;

/**
 * 设置确认行程的frme
 */
- (void)confirmTheItinerary;
- (void)confirmTheItineraryDict:(NSDictionary *)dict;

/**
 * 司机端_正在寻找乘客
 @param dict 乘客行程详情
 */
- (void)LookingPassengersDict:(NSDictionary *)dict;

/**
 * 没有价格的frame
 */
- (void)noPriceItinerary:(BOOL)isHinde;
- (void)noPriceItineraryWithDict:(NSDictionary *)dict;

@end

//***********************************************等待车主************************************************************//
@class YBMoreBottomView;

typedef void(^clickTheButtonBlock)(UIButton *sender);

@interface YBWaitingView : UIView

/**
 * 车主信息
 */
@property (nonatomic, weak) YBOwnerInformationView *formationView;

/**
 * 多底部view
 */
@property (nonatomic, weak) YBMoreBottomView *moreBottomView;

/**
 * 点击请他接我按钮
 */
@property (nonatomic, strong) clickTheButtonBlock clickeBlock;

/**
 * 点击图片
 */
@property (nonatomic, strong) iconImageViewBlock iconImageViewBlock;

#pragma mark - 乘客
/**
 * 乘客端_等待车主接单
 */
- (void)waitingTheOwnerOrdersCell:(NSDictionary *)dict;
//请他接我
- (void)passenger_PleaseTakeHim;
//行程中
- (void)duringTheTrip;

/**
 * 乘客端_邀请同行
 @param dict 本人行程信息
 @param driver 司机xing'cheng
 */
- (void)passengerPriceWithDict:(NSDictionary *)dict driverDict:(NSDictionary *)driver;
//刷新价格
- (void)refreshThePriceDict:(NSDictionary *)dict;




#pragma mark - 司机
/**
 * 司机端_附近乘客页面
 */
- (void)nearbyPassengersAndOwners:(NSDictionary *)dict;

/**
 * 司机_乘客行程
 @param driverDict 乘客dict
 */
- (void)driverPassengerTravel:(NSDictionary *)driverDict;
- (void)passengerTravel_ConfirmPeer;

@end





typedef void(^selectButtonBlock)(UIButton *sender);

@interface YBMoreBottomView : UIView

/**
 * 点击按钮
 */
@property (nonatomic, strong) selectButtonBlock selectBtn;

/**
 * 一行几个button
 */
- (void)PassengerTravelButtonsArray:(NSArray *)array;

@end


@interface YBEvaluationButtonView : UIView

/**
 * 选中数组
 */
@property (nonatomic, strong) NSMutableArray *selectArray;

/**
 * 动态添加按钮
 @param array 
 */
- (void)evaluationButtonIsDisplayed:(NSArray *)array;
@end
