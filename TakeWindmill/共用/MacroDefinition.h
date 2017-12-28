//
//  MacroDefinition.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

//百度地图apk
#define BMMapKey @"GRLxwuup0DkvSAeg8Ab3cawpcB5RPNSc"
//记录状态
#define YBUserDefaults [NSUserDefaults standardUserDefaults] 
//用户账号
#define accountNumber @"accountNumber"
//用户登录状态
#define isLogin @"isLogin"
//用户id
#define _userId @"userid"
//通知
#define kPushRC @"PushRC"
//个人中心
#define kPersonreloadData @"PersonreloadData"



//接口地址(临时)
#define ServerPath @"http://121.40.76.10:88/Service/"
//接口地址(正式)
//#define ServerPath @"http://www.bibizl.com/Service/"

//用户检测验证
#define CheckuserPath (ServerPath@"user/checkuser?")
//用户发送验证码
#define SendverifymessagePath (ServerPath@"user/sendverifymessage?")
//用户短信有效性验证
#define CheckregisterverifyPath (ServerPath@"user/checkregisterverify?")
//用户注册
#define RegisterPath (ServerPath@"user/register?")
//重置密码手机号校验
#define updatepwdcheckuserPath (ServerPath@"user/updatepwdcheckuser?")
//重置密码
#define userpwdresetPath (ServerPath@"user/userpwdreset?")
//用户登录
#define LoginPath (ServerPath@"user/login?")
//客户端设备Id校验
#define UserclientidCheckPath (ServerPath@"user/userclientidcheck?")
//顺风车打车费用计算
#define travelcostdownwindcalcPath (ServerPath@"travel/travelcostdownwindcalc?")
//区域信息列表（地级市）
#define baseareainfolistPath (ServerPath@"base/baseareainfolist?")
//热门城市
#define baseareahotinfolistPath (ServerPath@"base/baseareahotinfolist?")
//保存行程信息
#define travelinfosavePath (ServerPath@"travel/travelinfosave?")
//取消行程（顺风车）
#define travelinfocancelPath (ServerPath@"travel/travelinfocancel?")
//乘客行程起点附近司机检索
#define passengerstartpointPath (ServerPath@"travel/passengerstartpointnearbydirverlist?")
//乘客行程匹配司机行程
#define passengertravelPath (ServerPath@"travel/passengertravelmatchdirverlist?")
//乘客最新进行中有效行程
#define travelinfodetailinprogressPath (ServerPath@"travel/travelinfodetailinprogress?")
//司机行程详细
#define travelinfodriverdetailPath (ServerPath@"travel/travelinfodriverdetail?")
//根据SysNo查询乘客行程
#define travelinfodetailbysysnoPath (ServerPath@"travel/travelinfodetailbysysno?")
//司机行程信息保存
#define travelinfodriversavePath (ServerPath@"travel/travelinfodriversave?")
//司机行程起点附近乘客检索
#define driverstartpointnearbypassengerlistPath (ServerPath@"travel/driverstartpointnearbypassengerlist?")
//司机行程匹配乘客行程
#define dirvertravelmatchpassengerlistPath (ServerPath@"travel/dirvertravelmatchpassengerlist?")
//司机最新进行中有效行程
#define travelinfodriverdetailinprogressPath (ServerPath@"travel/travelinfodriverdetailinprogress?")
//司机取消行程
#define travelinfodrivercancelPath (ServerPath@"travel/travelinfodrivercancel?")
//司机常用路线
#define commonaddressdriverlistPath (ServerPath@"travel/commonaddressdriverlist?")
//司机常用线路删除
#define commonaddressdriverdeletePath (ServerPath@"travel/commonaddressdriverdelete?")
//司机常用路线保存
#define commonaddressdriversavePath (ServerPath@"travel/commonaddressdriversave?")
//乘客行程起点附近乘客检索（可拼座）
#define passengerstartpointnearbypassengerlistPath (ServerPath@"travel/passengerstartpointnearbypassengerlist?")
//司机_我的订单
#define passengertravelinfolistbydriverPath (ServerPath@"travel/passengertravelinfolistbydriver?")

//司机_确认同行
#define drivertravelbindpassengerPath (ServerPath@"travel/drivertravelbindpassenger?")


//路况直播列表
#define RoadListPath (ServerPath@"roadcondition/roadconditionlist?")
//百度地图关键字建议检索
#define suggestionSearchPath (ServerPath@"baidumap/suggestionsearch?")
//获取家和公司
#define commonaddresslistPath (ServerPath@"travel/commonaddresslist?")
//乘客上传家和公司
#define commonaddresssavePath (ServerPath@"travel/commonaddresssave?")
//删除家和公司
#define commonaddressdeletePath (ServerPath@"travel/commonaddressdelete?")
//增加感谢费
#define travelcostaddgratitudefeePath (ServerPath@"travel/travelcostaddgratitudefee?")
//投诉信息保存
#define complaininfosavePath (ServerPath@"user/complaininfosave?")
//基础信息列表（通用）
#define baseinfocommonlistPath (ServerPath@"base/baseinfocommonlist?")
//乘客到达终点
#define passangerarrivetoendPath (ServerPath@"travel/passangerarrivetoend?")
//行程评论保存
#define travelcommentsavePath (ServerPath@"travel/travelcommentsave?")
//司机附近乘客检索（按路或街道统计）
#define passengernearbystatlistPath (ServerPath@"travel/passengernearbystatlist?")
//司机附近乘客检索列表（市内）
#define passengernearbydriverlistPath (ServerPath@"travel/passengernearbydriverlist")
//司机跨域乘客检索（按城市统计）
#define passengeroverareastatlistPath (ServerPath@"travel/passengeroverareastatlist?")
//司机跨域乘客检索列表
#define passengeroverareadriverlistPath (ServerPath@"travel/passengeroverareadriverlist?")


//长传图片
#define UploadPhoto @"http://img.bibizl.com/UploadService.ashx"

//下载图片
#define DownloadPhoto(name)      [NSString stringWithFormat:@"http://img.bibizl.com/images/driver/%@.png",name]
//上传路况信息
#define UploadContent (ServerPath@"roadcondition/roadconditionsave")

//钱包信息获取接口
#define LastMoney (ServerPath@"user/getpacketinfo")

//通过userID获取用户信息
#define UserList (ServerPath@"user/userinfodetailbyuserid")

//根据用户Id查询收入明细列表（最新）
#define IncomeListNew (ServerPath@"packetinfo/incomeinfolisttopbyuserid")

//根据用户Id查询收入明细列表
#define IncomeList (ServerPath@"packetinfo/incomeinfolistbyuserid")

//
#define BankCard (ServerPath@"packetinfo/bankcardinfolistbyuserid")

//提现申请保存
#define CheckOutMoney (ServerPath@"packetinfo/withdrawinfosave")

//银行列表
#define TestUrl (ServerPath@"base/basebankinfolist")

//提现银行卡信息保存
#define BankData (ServerPath@"packetinfo/bankcardinfosave")

//周边汽车服务店铺检索
#define CarService (ServerPath@"vehicleshop/vehicleshopinfonearbylist")

//店铺详细（根据SysNo）
#define ShopList (ServerPath@"vehicleshop/vehicleshopinfodetailbysysno")

//店铺相关技师信息
#define ShopTecherList (ServerPath@"vehicleshop/workerinfolistbyshop")

//司机成为顺风车车主
#define UserTobeowner (ServerPath@"user/driverbeowersave")

//汽车品牌列表
#define MemberVehiclebrandlist (ServerPath@"member/vehiclebrandlist")

//汽车型号列表（根据汽车品牌SysNo）
#define MemberVehicleserieslistbybrandsysno (ServerPath@"member/vehicleserieslistbybrandsysno")

//公益信息列表
#define PublicServiceTable (ServerPath@"publicwelfare/publicwelfarelist")

//公益信息详细（By SysNo）
#define PublicList (ServerPath@"publicwelfare/publicwelfaredetailbysysno")

//根据用户Id查询捐赠信息列表
#define UserPublic (ServerPath@"publicwelfare/contributeinfolistbyuserid")

//捐赠评论列表
#define DonationCommTable (ServerPath@"publicwelfare/contributecommentlistbymastersysno")

//出租车司机认证信息保存
#define UserTaxidriverinfosave (ServerPath@"user/taxidriverinfosave")

//根据UserId获取用户信息
#define UserUserinfodetailbyuserid (ServerPath@"user/userinfodetailbyuserid")

#define Alipay (ServerPath@"apiconfig")

//融云获取Token
#define RongcloudGettoken (ServerPath@"rongcloud/gettoken")

//司机附近其他司机检索
#define DriverhelpDriverhelpnearbydriverlist (ServerPath@"driverhelp/driverhelpnearbydriverlist")

//车主互帮信息保存
#define DriverhelpDriverhelpinfosave (ServerPath@"driverhelp/driverhelpinfosave")

//根据用户Id查询车主互帮信息列表（发送者）
#define DriverhelpDriverhelpinfolistbyuserid (ServerPath@"driverhelp/driverhelpinfolistbyuserid")

//根据用户Id查询车主互帮信息列表（接收者）
#define DriverhelpDriverhelpinfolistbytouserid (ServerPath@"driverhelp/driverhelpinfolistbytouserid")

//车主互帮信息回复
#define DriverhelpDriverhelpinfreply (ServerPath@"driverhelp/driverhelpinfreply")

//根据车牌号获取用户信息
#define UserUserinfodetailbyvehiclenumber (ServerPath@"user/userinfodetailbyvehiclenumber")

//车主互帮评论（发送者）
#define DriverhelpDriverhelpinfousercomment (ServerPath@"driverhelp/driverhelpinfousercomment")

//车主互帮评论（接收者）
#define DriverhelpDriverhelpinfotousercomment (ServerPath@"driverhelp/driverhelpinfotousercomment")

//捐赠信息保存 (PublicWelfareSysNo)
#define DonationSave (ServerPath@"publicwelfare/contributeinfosave")

//公益行动顶部信息
#define PublicTop (ServerPath@"publicwelfare/publicwelfaretopinfo")

//我的公益行动列表
#define MyPublicTable (ServerPath@"publicwelfare/mypublicwelfarelist")

//司机绑定乘客行程列表（出租车）
#define TaxiStrokeTable (ServerPath@"travel/drivertaxibindpassengertravellist")

//店铺评论列表
#define ShopCommentDetail (ServerPath@"vehicleshop/shopcommentinfolist")

//用户拨打电话信息保存
#define CallShop (ServerPath@"user/userdialinfosave")

//店铺评论保存（先拨打电话）
#define CommentUpload (ServerPath@"vehicleshop/shopcommentsave")

//apiconfig
#define Apiconfig (ServerPath@"apiconfig")

//
#define WeixinPay (ServerPath@"pay/travelweixinorderunifyapp")

#define TaxiMoney (ServerPath@"travel/traveltaxicostcalc")

