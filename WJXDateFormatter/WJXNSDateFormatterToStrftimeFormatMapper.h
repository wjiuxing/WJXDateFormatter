//
//  WJXNSDateFormatterToStrftimeFormatMapper.h
//  WJXDateFormatter
//
//  Created by Jiuxing Wang on 2020/1/30.
//  Copyright © 2020 Jiuxing Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJXNSDateFormatterToStrftimeFormatMapper : NSObject

+ (instancetype _Nonnull)sharedMapper;

- (void)mapNSDateFormat:(NSString *_Nonnull)NSDateFormat toStrftimeFormat:(NSString *_Nonnull)strftimeFormat;

- (NSString *_Nullable)strftimeFormatForNSDateFormat:(NSString *_Nonnull)NSDateFormat;

@end
