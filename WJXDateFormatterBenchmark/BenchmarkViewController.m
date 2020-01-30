//
//  BenchmarkViewController.m
//  WJXDateFormatterBenchmark
//
//  Created by Jiuxing Wang on 2020/1/30.
//  Copyright © 2020 Jiuxing Wang. All rights reserved.
//

#import "BenchmarkViewController.h"
#import <XLForm/XLForm.h>
#import "WJXDateFormatter.h"

#define kNSDateFormatterInitializationAlertView     @"kNSDateFormatterInitializationAlertView"
#define kNSDateFormatterSetDateFormatAlertView      @"kNSDateFormatterSetDateFormatAlertView"
#define kNSDateFormatterFormatDateStringAlertView   @"kNSDateFormatterFormatDateStringAlertView"

#define kNSDateFormatterWithoutCacheAlertView   @"kNSDateFormatterWithoutCacheAlertView"
#define kNSDateFormatterWithCacheAlertView      @"kNSDateFormatterWithCacheAlertView"
#define kWJXDateFormatterAlertView              @"kWJXDateFormatterAlertView"

#define TICK            CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#define TOCK(desc, x)   NSLog(@"%s line[%d]\n %@ calculated %ld times Cost: %lfms", __FUNCTION__, __LINE__, desc, (unsigned long)(x), (CFAbsoluteTimeGetCurrent() - startTime) * 1000);

#define kDateFormat @"yyyy年MM月dd日 HH:mm:ss"

@implementation BenchmarkViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Date Format Benchmark"];
        XLFormSectionDescriptor *section;
        XLFormRowDescriptor *row;
        
        NSArray *selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"1 time"],
                                     [XLFormOptionsObject formOptionsObjectWithValue:@(10) displayText:@"10 times"],
                                     [XLFormOptionsObject formOptionsObjectWithValue:@(100) displayText:@"100 times"],
                                     [XLFormOptionsObject formOptionsObjectWithValue:@(1000) displayText:@"1,000 times"],
                                     [XLFormOptionsObject formOptionsObjectWithValue:@(10000) displayText:@"10,000 times"],
                                     [XLFormOptionsObject formOptionsObjectWithValue:@(100000) displayText:@"100,000 times"],
                                     [XLFormOptionsObject formOptionsObjectWithValue:@(1000000) displayText:@"1,000,000 times"]];
        XLFormOptionsObject *defaultValue = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"choose"];
        
        // NSDateFormatter process
        section = [XLFormSectionDescriptor formSectionWithTitle:@"NSDateFormatter Process"];
        [form addFormSection:section];
        
        // NSDateFormatter Initialization
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kNSDateFormatterInitializationAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"[NSDateFormatter init]"];
        row.selectorOptions = selectorOptions;
        row.value = defaultValue;
        row.height = 60;
        
        __weak __typeof(self) weakSelf = self;
        row.onChangeBlock = ^(XLFormOptionsObject * _Nullable oldValue, XLFormOptionsObject * _Nullable newValue, XLFormRowDescriptor * _Nonnull row) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (nil == strongSelf) {
                return;
            }
            
            NSUInteger times = [newValue.formValue integerValue];
            if (times > 0) {
                [strongSelf p_testNSDateFormatterProcessInitializationWithTimes:times];
            }
        };
        [section addFormRow:row];

        // NSDateFormatter.dateFormat
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kNSDateFormatterSetDateFormatAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"NSDateFormatter.dateFormat"];
        row.selectorOptions = selectorOptions;
        row.value = defaultValue;
        row.height = 60;
        
        row.onChangeBlock = ^(XLFormOptionsObject * _Nullable oldValue, XLFormOptionsObject * _Nullable newValue, XLFormRowDescriptor * _Nonnull row) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (nil == strongSelf) {
                return;
            }
            
            NSUInteger times = [newValue.formValue integerValue];
            if (times > 0) {
                [strongSelf p_testNSDateFormatterProcessSetDateFormatWithTimes:times];
            }
        };
        [section addFormRow:row];

        // NSDateFormatter format date string
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kNSDateFormatterFormatDateStringAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"NSDateFormatter format date"];
        row.selectorOptions = selectorOptions;
        row.value = defaultValue;
        row.height = 60;
        
        row.onChangeBlock = ^(XLFormOptionsObject * _Nullable oldValue, XLFormOptionsObject * _Nullable newValue, XLFormRowDescriptor * _Nonnull row) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (nil == strongSelf) {
                return;
            }
            
            NSUInteger times = [newValue.formValue integerValue];
            if (times > 0) {
                [strongSelf p_testNSDateFormatterProcessFormatDateStringWithTimes:times];
            }
        };
        [section addFormRow:row];
        
        // Formating
        section = [XLFormSectionDescriptor formSectionWithTitle:@"NSDate  >>  Format String"];
        [form addFormSection:section];

        // NSDateFormatter without cache
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kNSDateFormatterWithoutCacheAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"NSDateFormatter without cache"];
        row.selectorOptions = selectorOptions;
        row.value = defaultValue;
        row.height = 60;
        row.onChangeBlock = ^(XLFormOptionsObject * _Nullable oldValue, XLFormOptionsObject * _Nullable newValue, XLFormRowDescriptor * _Nonnull row) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (nil == strongSelf) {
                return;
            }

            NSUInteger times = [newValue.formValue integerValue];
            if (times > 0) {
                [strongSelf p_testNSDateFormatterWithoutCacheTimes:times];
            }
        };
        [section addFormRow:row];

        // NSDateFormatter with cache
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kNSDateFormatterWithCacheAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"NSDateFormatter with cache"];
        row.selectorOptions = selectorOptions;
        row.value = defaultValue;
        row.height = 60;
        row.onChangeBlock = ^(XLFormOptionsObject * _Nullable oldValue, XLFormOptionsObject * _Nullable newValue, XLFormRowDescriptor * _Nonnull row) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (nil == strongSelf) {
                return;
            }

            NSUInteger times = [newValue.formValue integerValue];
            if (times > 0) {
                [strongSelf p_testNSDateFormatterWithCacheTimes:times];
            }
        };

        [section addFormRow:row];

        // Strftime DateFormatter
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kWJXDateFormatterAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"strftime"];
        row.selectorOptions = selectorOptions;
        row.value = defaultValue;
        row.height = 60;
        row.onChangeBlock = ^(XLFormOptionsObject * _Nullable oldValue, XLFormOptionsObject * _Nullable newValue, XLFormRowDescriptor * _Nonnull row) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (nil == strongSelf) {
                return;
            }

            NSUInteger times = [newValue.formValue integerValue];
            if (times > 0) {
                [strongSelf p_testStrftimeFormatterTimes:times];
            }
        };

        [section addFormRow:row];
        
        // NSStringFromTimeIntervalSince1970InStrftime
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kWJXDateFormatterAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"FromTimeIntervalSince1970InStrftime"];
        row.selectorOptions = selectorOptions;
        row.value = defaultValue;
        row.height = 60;
        row.onChangeBlock = ^(XLFormOptionsObject * _Nullable oldValue, XLFormOptionsObject * _Nullable newValue, XLFormRowDescriptor * _Nonnull row) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (nil == strongSelf) {
                return;
            }
            
            NSUInteger times = [newValue.formValue integerValue];
            if (times > 0) {
                [strongSelf p_testNSStringFromTimeIntervalSince1970InStrftimeWithTimes:times];
            }
        };
        
        [section addFormRow:row];
        
        // NSStringFromNSDate
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kWJXDateFormatterAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"NSStringFromNSDate"];
        row.selectorOptions = selectorOptions;
        row.value = defaultValue;
        row.height = 60;
        row.onChangeBlock = ^(XLFormOptionsObject * _Nullable oldValue, XLFormOptionsObject * _Nullable newValue, XLFormRowDescriptor * _Nonnull row) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (nil == strongSelf) {
                return;
            }
            
            NSUInteger times = [newValue.formValue integerValue];
            if (times > 0) {
                [strongSelf p_testNSStringFromNSDateWithTimes:times];
            }
        };
        
        [section addFormRow:row];
        
        self.form = form;
    }
    return self;
}

- (void)p_testNSDateFormatterProcessInitializationWithTimes:(NSUInteger)times
{
    TICK;
    
    NSDateFormatter *formatter = nil;
    for (NSUInteger i = 0; i < times; ++i) {
        formatter = [[NSDateFormatter alloc] init];
    }
    
    TOCK(@"NSDateFormatter Initialization", times);
}

- (void)p_testNSDateFormatterProcessSetDateFormatWithTimes:(NSUInteger)times
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *formats = @[kDateFormat, @"yyyy-MM-dd", @"yyyyMMdd HHmmss", @"HH:mm:ss"];
    
    TICK;
    for (NSUInteger i = 0; i < times; ++i) {
        formatter.dateFormat = formats[i % 4];
    }
    
    TOCK(@"NSDateFormatter.dateFormatter", times);
}

- (void)p_testNSDateFormatterProcessFormatDateStringWithTimes:(NSUInteger)times
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kDateFormat;
    NSDate *date = [NSDate date];
    NSString *dateString = nil;
    
    TICK;
    for (NSUInteger i = 0; i < times; ++i) {
        dateString = [formatter stringFromDate:date];
    }
    
    TOCK(@"NSDateFormatter Format Date String", times);
}

- (void)p_testNSDateFormatterWithoutCacheTimes:(NSUInteger)times
{
    NSString *dateString = nil;
    NSDate *date = nil;
    
    TICK;
    
    for (NSUInteger i = 0; i < times; ++i) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = kDateFormat;
        date = [NSDate dateWithTimeIntervalSince1970:(1556640000 + i)];
        dateString = [dateFormatter stringFromDate:date];
    }
    
    TOCK(@"NSDateFormatter without cache", times);
}

- (void)p_testNSDateFormatterWithCacheTimes:(NSUInteger)times
{
    static NSDateFormatter *dateFormatter = nil;
    if (nil == dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = kDateFormat;
    }
    
    NSString *dateString = nil;
    NSDate *date = nil;
    
    TICK;
    
    for (NSUInteger i = 0; i < times; ++i) {
        date = [NSDate dateWithTimeIntervalSince1970:(1556640000 + i)];
        dateString = [dateFormatter stringFromDate:date];
    }
    
    TOCK(@"NSDateFormatter with cache", times);
}

- (void)p_testStrftimeFormatterTimes:(NSUInteger)times
{
    NSString *dateString = nil;
    NSDate *date = nil;
    
    TICK;
    
    time_t timeInterval;
    char buffer[80];
    
    for (NSUInteger i = 0; i < times; ++i) {
        date = [NSDate dateWithTimeIntervalSince1970:(1556640000 + i)];
        timeInterval = [date timeIntervalSince1970];
        strftime(buffer, sizeof(buffer), "%Y年%月%d日 %H:%M:%S", localtime(&timeInterval));
        dateString = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    }
    
    TOCK(@"StrftimeFormatter", times);
}

- (void)p_testNSStringFromTimeIntervalSince1970InStrftimeWithTimes:(NSUInteger)times
{
    NSString *dateString = nil;
    NSDate *date = nil;
    
    TICK;
    for (NSUInteger i = 0; i < times; ++i) {
        date = [NSDate dateWithTimeIntervalSince1970:(1556640000 + i)];
        dateString = NSStringFromTimeIntervalSince1970InStrftime([date timeIntervalSince1970], "%Y年%月%d日 %H:%M:%S");
    }
    
    TOCK(@"NSStringFromTimeIntervalSince1970InStrftime", times);
}

- (void)p_testNSStringFromNSDateWithTimes:(NSUInteger)times
{
    NSString *dateString = nil;
    NSDate *date = nil;
    
    TICK;
    for (NSUInteger i = 0; i < times; ++i) {
        date = [NSDate dateWithTimeIntervalSince1970:(1556640000 + i)];
//        dateString = NSStringFromNSDate(date, kDateFormat);
        dateString = NSStringFromNSDate(date, @"我们在yyyy年MM月dd日的HH:mm:ss很开心。");
    }
    
    TOCK(@"NSStringFromNSDate", times);
}

@end
