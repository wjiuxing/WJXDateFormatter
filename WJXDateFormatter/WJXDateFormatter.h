//
//  WJXDateFormatter.h
//  WJXDateFormatter
//
//  Created by Jiuxing Wang on 2020/1/30.
//  Copyright © 2020 Jiuxing Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJXNSDateFormatterToStrftimeFormatMapper.h"

NSString *NSStringFromTimeIntervalSince1970InStrftime(long timeInterval, const char *strftimeFormat);

NSString *NSStringFromNSDate(NSDate *date, NSString *format);

NSString *NSStringFromTimeIntervalSince1970(long timeInterval, NSString *format);
