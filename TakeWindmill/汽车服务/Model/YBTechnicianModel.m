//
//  YBTechnicianModel.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/17.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTechnicianModel.h"

@implementation YBTechnicianModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    
    YBTechnicianModel *model = [[YBTechnicianModel alloc] init];
    model.WorkerName = dic[@"WorkerName"];
    model.Experience = dic[@"Experience"];
    model.PhoneNum = dic[@"PhoneNum"];
    model.JobIntrduction = dic[@"JobIntrduction"];
    model.WorkerPhotoUrl = dic[@"WorkerPhotoUrl"];
    model.isUnfolded = 0;
    
    model.introductionArray = [NSMutableArray array];
//    NSArray *array = dic[@"WorkerInfoList"];
    
        YBTechnicianModel *moo = [YBTechnicianModel introductionWithDic:dic];
        moo.technicianMode = model;
        [model.introductionArray addObject:moo];
    
    
    return model;
}

+ (YBTechnicianModel *)introductionWithDic:(NSDictionary *)dic
{
    YBTechnicianModel *model = [[YBTechnicianModel alloc] init];
    model.JobIntrduction = dic[@"JobIntrduction"];
    model.PhoneNum = dic[@"PhoneNum"];
    model.isUnfolded = 1;

    return model;
}

- (NSArray *)open {
    NSArray *submodels = self.introductionArray;
    self.introductionArray = nil;
    self.isUnfolded = submodels.count;
    return submodels;
}

- (void)closeWithSubmodels:(NSArray *)submodels {
    self.introductionArray = [NSMutableArray arrayWithArray:submodels];
    self.isUnfolded = 0;
}

- (void)setBelowCount:(NSUInteger)belowCount {
    self.technicianMode.isUnfolded += (belowCount - _isUnfolded);
    _isUnfolded = belowCount;
}

@end
