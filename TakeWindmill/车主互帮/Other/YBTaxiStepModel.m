//
//  YBTaxiStepModel.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTaxiStepModel.h"

@implementation YBTaxiStepModel

/////初始化
+(instancetype)messageWithContent:(NSString *)content {
    YBTaxiStepModel *msg = [[YBTaxiStepModel alloc] init];
    if (msg) {
        msg.content = content;
        msg.op = @"op";
    }
    return msg;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //告诉系统归档的属性是哪些
    unsigned int count = 0;//表示对象的属性个数
    Ivar *ivars = class_copyIvarList([YBTaxiStepModel class], &count);
    for (int i = 0; i<count; i++) {
        //拿到Ivar
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);//获取到属性的C字符串名称
        NSString *key = [NSString stringWithUTF8String:name];//转成对应的OC名称
        //归档 -- 利用KVC
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //解档
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([YBTaxiStepModel class], &count);
        for (int i = 0; i<count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

#pragma mark – RCMessageCoding delegate methods
///将消息内容编码成json
-(NSData *)encode {
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    
    NSLog(@"dataDict == %@",dataDict);
    [dataDict setObject:self.content forKey:@"content"];
//    if (self.extra) {
//        [dataDict setObject:self.extra forKey:@"extra"];
//    }
    
    [dataDict setObject:self.travelinfo forKey:@"travelinfo"];
    [dataDict setObject:self.op forKey:@"op"];
   
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    //NSDictionary* dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.content, @"content", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}
///将json解码生成消息内容
-(void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        dictionary = [NSDictionary changeType:dictionary];
         NSLog(@"dictionary==%@",dictionary);
        if (dictionary) {
            self.content = dictionary[@"content"];
            //self.extra = dictionary[@"extra"];

            self.travelinfo = dictionary[@"travelinfo"];
            self.op = dictionary[@"op"];
        }
    }
}

///消息是否存储，是否计入未读数
+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}
/// 会话列表中显示的摘要
- (NSString *)conversationDigest
{
    return @"行程";
}
///消息的类型名
+(NSString *)getObjectName {
    
    return RCDTaxiMessageTypeIdentifier;
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)
@end


@implementation Travelinfo
- (void)encodeWithCoder:(NSCoder *)coder
{
    //告诉系统归档的属性是哪些
    unsigned int count = 0;//表示对象的属性个数
    Ivar *ivars = class_copyIvarList([DriverInfo class], &count);
    for (int i = 0; i<count; i++) {
        //拿到Ivar
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);//获取到属性的C字符串名称
        NSString *key = [NSString stringWithUTF8String:name];//转成对应的OC名称
        //归档 -- 利用KVC
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //解档
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([DriverInfo class], &count);
        for (int i = 0; i<count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}
@end

