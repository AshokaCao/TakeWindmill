//
//  TimeTool.m
//  TimePicker
//
//  Created by App on 1/14/16.
//  Copyright © 2016 App. All rights reserved.
//

#import "MyTimeTool.h"
#define MAXCOUNTDAYS 100

@implementation MyTimeTool

+ (NSArray *)daysFromNowToDeadLine{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd-EEE"];
    
    NSDate *startDate = [f dateFromString:[self summaryTimeUsingDate:[NSDate date]]];
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:+(24 * 60 * 60 * 6)];
    NSDate *endDate = [f dateFromString:[self summaryTimeUsingDate:yesterday]];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    int diffDays = ABS((int)components.day);;
    if(diffDays==0) return @[[self summaryTimeUsingDate:[NSDate date]]];
    NSMutableArray *dayArray = [NSMutableArray array];
    
    if(diffDays > MAXCOUNTDAYS) diffDays = MAXCOUNTDAYS;
    for (int i = 0; i <= diffDays; i++) {
        NSTimeInterval  iDay = 24 * 60 * 60 * i;  //1天的长度
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:iDay];
        [dayArray addObject:[self summaryTimeUsingDate:date]];
    }
    return dayArray;
}

+ (NSInteger)currentDateHour{
//    NSLog(@"hour is: %d", [self dateComponents].hour);
    return [self dateComponents].hour;
}

+ (NSInteger)currentDateMinute{
//    NSLog(@"minute is: %d", [self dateComponents].minute);
    return [self dateComponents].minute;
}

+ (NSDateComponents *)dateComponents{
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    return dateComponent;
}

+ (NSString *)summaryTimeUsingDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-EEE"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)summaryTimeUsingDate1:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddEEE"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)displayedSummaryTimeUsingString:(NSString *)string
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:[string substringWithRange:NSMakeRange(0, 2)]];
    [result appendString:@"月"];
    [result appendString:[string substringWithRange:NSMakeRange(2, 2)]];
    [result appendString:@"日"];
    [result appendString:[string substringWithRange:NSMakeRange(4, 2)]];
    return result;
}

@end
