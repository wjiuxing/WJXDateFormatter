//
//  WJXDateFormatter.m
//  WJXDateFormatter
//
//  Created by Jiuxing Wang on 2020/1/30.
//  Copyright © 2020 Jiuxing Wang. All rights reserved.
//

#import "WJXDateFormatter.h"
#import <time.h>

NSString *NSStringFromTimeIntervalSince1970InStrftime(long timeInterval, const char *strftimeFormat)
{
    char buffer[80];
    strftime(buffer, sizeof(buffer), strftimeFormat, localtime(&timeInterval));
    NSString *string = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    return string;
}

NSString *NSStringFromNSDate(NSDate *date, NSString *format)
{
    return NSStringFromTimeIntervalSince1970([date timeIntervalSince1970], format);
}

NSString *NSStringFromTimeIntervalSince1970(long timeInterval, NSString *format)
{
    WJXNSDateFormatterToStrftimeFormatMapper *mapper = [WJXNSDateFormatterToStrftimeFormatMapper sharedMapper];
    NSString *strftimeFormat = [mapper strftimeFormatForNSDateFormat:format];
    
    return NSStringFromTimeIntervalSince1970InStrftime(timeInterval, strftimeFormat.UTF8String);
}
