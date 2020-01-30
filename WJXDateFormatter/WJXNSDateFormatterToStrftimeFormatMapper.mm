//
//  WJXNSDateFormatterToStrftimeFormatMapper.m
//  WJXDateFormatter
//
//  Created by Jiuxing Wang on 2020/1/30.
//  Copyright © 2020 Jiuxing Wang. All rights reserved.
//

#import "WJXNSDateFormatterToStrftimeFormatMapper.h"
#import <queue>
#import <stack>

struct _NSDateFormatMapToStrftimeFormatLUTEntry {
    NSString * const NSDateFormat;
    NSString * const strftimeFormat;
};

static const _NSDateFormatMapToStrftimeFormatLUTEntry *NSDateFormatMapToStrftimeFormatLUT(size_t *count)
{
    // Initialize this in a function (instead of at file level) to avoid startup initialization time.
    // see the formats supported by strftime via the command 'man strftime' in terminal or the apple's website:
    // https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/strftime.3.html
    static const _NSDateFormatMapToStrftimeFormatLUTEntry sNSDateFormatMapToStrftimeFormatLUT[] = {
        {@"yyyy-MM-dd HH:mm:ss", @"%F %T"},
        {@"yyyy-MM-dd HH:mm", @"%F %R"},
        {@"yyyy-MM-dd", @"%F"},
        {@"dd/MM/yyyy", @"%D"},
        {@"MM dd yyyy", @"%m %d %Y"},
        {@"yyyy年MM月dd日", @"%Y年%m月%d日"},
        {@"yyyy", @"%Y"},
        {@"YYYY", @"%G"},
        {@"yy", @"%y"},
        {@"MMMM", @"%B"},
        {@"MMM", @"%b"},
        {@"MM", @"%m"},
        {@"dd", @"%d"},
        {@"d", @"%e"},
        {@"HH:mm:ss", @"%T"},
        {@"HH:mm", @"%R"},
        {@"EEEE", @"%A"},
        {@"EEE", @"%a"},
        {@"aa", @"%p"},
        {@"HH", @"%H"},
        {@"K", @"%I"},
        {@"mm", @"%M"},
        {@"ss", @"%S"},
    };
    
    *count = sizeof(sNSDateFormatMapToStrftimeFormatLUT) / sizeof(sNSDateFormatMapToStrftimeFormatLUT[0]);
    return sNSDateFormatMapToStrftimeFormatLUT;
}

#if 1
static NSString *strftimeFormatFromNSDateFormat(NSString *NSDateFormat)
{
    struct _FormatNode {
        NSString *string;
        _FormatNode *left;
        _FormatNode *right;
    };
    
    size_t lutSize;
    const _NSDateFormatMapToStrftimeFormatLUTEntry *lut = NSDateFormatMapToStrftimeFormatLUT(&lutSize);
    
    _FormatNode * const root = (_FormatNode *)calloc(1, sizeof(_FormatNode));
    root->string = NSDateFormat;
    
    std::queue<_FormatNode *> queue;
    queue.push(root);
    
    while (!queue.empty()) {
        _FormatNode *currentNode = queue.front();
        queue.pop();
        
        BOOL find = NO;
        size_t i = 0;
        do {
            _NSDateFormatMapToStrftimeFormatLUTEntry entry = lut[i];
            
            NSRange targetRagne = [currentNode->string rangeOfString:entry.NSDateFormat options:NSBackwardsSearch];
            if ((find = (targetRagne.location != NSNotFound && targetRagne.length > 0))) {
                if (targetRagne.location > 0) {
                    _FormatNode *left = (_FormatNode *)calloc(1, sizeof(_FormatNode));
                    left->string = [currentNode->string substringToIndex:targetRagne.location];
                    currentNode->left = left;
                    
                    queue.push(left);
                }
                
                if (targetRagne.location + targetRagne.length < currentNode->string.length) {
                    _FormatNode *right = (_FormatNode *)calloc(1, sizeof(_FormatNode));
                    right->string = [currentNode->string substringFromIndex:targetRagne.location + targetRagne.length];
                    currentNode->right = right;
                    
                    queue.push(right);
                }
                
                currentNode->string = entry.strftimeFormat;
            }
        } while (!find && ++i < lutSize);
    }
    
    std::stack<_FormatNode *> stack;
    _FormatNode *currentNode = root;
    
    NSMutableString *format = [NSMutableString string];
    while (!stack.empty() || NULL != currentNode) {
        if (NULL == currentNode) {
            currentNode = stack.top();
            stack.pop();
            
            [format appendString:currentNode->string];
            
            _FormatNode *tmp = currentNode;
            currentNode = currentNode->right;
            free(tmp);
        } else {
            stack.push(currentNode);
            currentNode = currentNode->left;
        }
    }
    
    return format;
}
//#else
//NS_INLINE NSString *strftimeFormatFromNSDateFormat(__unsafe_unretained NSString *NSDateFormat)
//{
//    size_t lutSize;
//    const _NSDateFormatMapToStrftimeFormatLUTEntry *lut = NSDateFormatMapToStrftimeFormatLUT(&lutSize);
//    size_t normalLUTSize = lutSize - 1;
//
//    NSMutableString *format = [NSDateFormat mutableCopy];
//
//    NSRange searchRange = { .length = format.length };
//    for (size_t i = 0; i < normalLUTSize; ++i) {
//        struct _NSDateFormatMapToStrftimeFormatLUTEntry entry = lut[i];
//
//        NSRange targetRagne = [format rangeOfString:entry.NSDateFormat options:NSBackwardsSearch range:searchRange];
//        if (targetRagne.location != NSNotFound && targetRagne.length > 0) {
//            [format replaceCharactersInRange:targetRagne withString:entry.strftimeFormat];
//
//            searchRange.length = format.length;
//            --i;
//        }
//    }
//
//    BOOL hasSepicalEntryBeFound = NO;
//    do {
//        struct _NSDateFormatMapToStrftimeFormatLUTEntry specialEntry = lut[normalLUTSize]; // {@"d", @"%e"}
//        NSRange targetRagne = [format rangeOfString:specialEntry.NSDateFormat options:NSBackwardsSearch range:searchRange];
//        if (targetRagne.location != NSNotFound && targetRagne.length > 0) {
//            BOOL shouldReplace = YES;
//            if (targetRagne.location > 0 && [format characterAtIndex:targetRagne.location - 1] == '%') {
//                shouldReplace = NO;
//            }
//
//            if (shouldReplace) {
//                [format replaceCharactersInRange:targetRagne withString:specialEntry.strftimeFormat];
//                searchRange.length = format.length;
//                hasSepicalEntryBeFound = YES;
//            }
//        }
//    } while (hasSepicalEntryBeFound);
//
//    return format;
//}
//
//NS_INLINE NSString *strftimeFormatFromNSDateFormat(__unsafe_unretained NSString *NSDateFormat)
//{
//    size_t lutSize;
//    const _NSDateFormatMapToStrftimeFormatLUTEntry *lut = NSDateFormatMapToStrftimeFormatLUT(&lutSize);
//
//    NSMutableString *format = [NSDateFormat mutableCopy];
//
//    NSRange searchRange = { .length = format.length };
//    for (size_t i = 0; i < lutSize; ++i) {
//        struct _NSDateFormatMapToStrftimeFormatLUTEntry entry = lut[i];
//
//        NSRange targetRagne = [format rangeOfString:entry.NSDateFormat options:NSBackwardsSearch range:searchRange];
//        if (targetRagne.location != NSNotFound && targetRagne.length > 0) {
//            [format replaceCharactersInRange:targetRagne withString:entry.strftimeFormat];
//
//            searchRange.length = targetRagne.location;
//            --i;
//        }
//    }
//
//    return format;
//}
#endif

@interface WJXNSDateFormatterToStrftimeFormatMapper ()

@property (nonatomic, strong) NSCache *compiledFormatsCache;

@end

@implementation WJXNSDateFormatterToStrftimeFormatMapper

+ (instancetype _Nonnull)sharedMapper;
{
    static WJXNSDateFormatterToStrftimeFormatMapper *mapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapper = [[WJXNSDateFormatterToStrftimeFormatMapper alloc] init];
    });
    return mapper;
}

- (void)mapNSDateFormat:(NSString *_Nonnull)NSDateFormat toStrftimeFormat:(NSString *_Nonnull)strftimeFormat;
{
    NSAssert2(strftimeFormat, @"%s, line[%d]: invalid strftimeFormat", __FUNCTION__, __LINE__);
    NSAssert2(NSDateFormat, @"%s, line[%d]: invalid NSDateFormat", __FUNCTION__, __LINE__);
    
    [self.compiledFormatsCache setObject:strftimeFormat forKey:NSDateFormat];
}

- (nullable NSString *)strftimeFormatForNSDateFormat:(NSString *_Nonnull)NSDateFormat;
{
    NSString *strftimeFormat = [self.compiledFormatsCache objectForKey:NSDateFormat];
    if (nil == strftimeFormat) {
        strftimeFormat = strftimeFormatFromNSDateFormat(NSDateFormat);
        if (nil != strftimeFormat && strftimeFormat.length > 0) {
            [self mapNSDateFormat:NSDateFormat toStrftimeFormat:strftimeFormat];
        }
    }
    
    return strftimeFormat;
}


#pragma mark -
#pragma mark Getters

- (NSCache *)compiledFormatsCache
{
    if (nil == _compiledFormatsCache) {
        _compiledFormatsCache = [[NSCache alloc] init];
        [_compiledFormatsCache setObject:@"%F %T" forKey:@"yyyy-MM-dd HH:mm:ss"];
        [_compiledFormatsCache setObject:@"%F %R" forKey:@"yyyy-MM-dd HH:mm"];
        [_compiledFormatsCache setObject:@"%F" forKey:@"yyyy-MM-dd"];
        [_compiledFormatsCache setObject:@"%D" forKey:@"dd/MM/yyyy"];
        [_compiledFormatsCache setObject:@"%m %d %Y" forKey:@"MM dd yyyy"];
        [_compiledFormatsCache setObject:@"%Y年%m月%d日" forKey:@"yyyy年MM月dd日"];
        [_compiledFormatsCache setObject:@"%Y%m%d%H%M%S" forKey:@"yyyyMMddHHmmss"];
        [_compiledFormatsCache setObject:@"%Y%m%d%H%M" forKey:@"yyyyMMddHHmm"];
        [_compiledFormatsCache setObject:@"%Y%m%d" forKey:@"yyyyMMdd"];
        [_compiledFormatsCache setObject:@"%T" forKey:@"HH:mm:ss"];
        [_compiledFormatsCache setObject:@"%H时%M分%S秒" forKey:@"HH时mm分ss秒"];
        [_compiledFormatsCache setObject:@"%R" forKey:@"HH:mm"];
        [_compiledFormatsCache setObject:@"%M:%S" forKey:@"mm:ss"];
    }
    return _compiledFormatsCache;
}

@end
