//
//  YZBackgroundTaskManager.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/5.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@interface YZBackgroundTaskManager : NSObject
+ (instancetype)sharedBackgroundTaskManager;

- (UIBackgroundTaskIdentifier)beginNewBackgroundTask;
- (void)endAllBackgroundTasks;
@end
