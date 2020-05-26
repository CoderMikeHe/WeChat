//
//  WPFPinYinTools.m
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WPFPinYinTools.h"
#import "WPFPerson.h"

@implementation WPFSearchResultModel

@end

@implementation WPFPinYinTools

#pragma mark - Public Method
+ (BOOL)isChinese:(NSString *)string {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)includeChinese:(NSString *)string {
    for (int i=0; i< [string length];i++) {
        int a =[string characterAtIndex:i];
        if ( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

+ (NSString *)firstCharactor:(NSString *)aString withFormat:(HanyuPinyinOutputFormat *)pinyinFormat {
    NSString *pinYin = [PinyinHelper toHanyuPinyinStringWithNSString:aString withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
    return [pinYin substringToIndex:1];
}

// 获取格式化器
+ (HanyuPinyinOutputFormat *)getOutputFormat {
    HanyuPinyinOutputFormat *pinyinFormat = [[HanyuPinyinOutputFormat alloc] init];
    /** 设置大小写
     *  CaseTypeLowercase : 小写
     *  CaseTypeUppercase : 大写
     */
    [pinyinFormat setCaseType:CaseTypeLowercase];
    /** 声调格式 ：如 王鹏飞
     * ToneTypeWithToneNumber : 用数字表示声调 wang2 peng2 fei1
     * ToneTypeWithoutTone    : 无声调表示 wang peng fei
     * ToneTypeWithToneMark   : 用字符表示声调 wáng péng fēi
     */
    [pinyinFormat setToneType:ToneTypeWithoutTone];
    /** 设置特殊拼音ü的显示格式：
     * VCharTypeWithUAndColon : 以U和一个冒号表示该拼音，例如：lu:
     * VCharTypeWithV         : 以V表示该字符，例如：lv
     * VCharTypeWithUUnicode  : 以ü表示
     */
    [pinyinFormat setVCharType:VCharTypeWithV];
    return pinyinFormat;
}

+ (NSArray *)sortingRules {
    // 按照 matchType 顺序排列，即优先展示 中文，其次是全拼匹配，最后是拼音首字母匹配
    NSSortDescriptor *desType = [NSSortDescriptor sortDescriptorWithKey:@"matchType" ascending:YES];
    // 优先显示 高亮位置索引靠前的搜索结果
    NSSortDescriptor *desLocation = [NSSortDescriptor sortDescriptorWithKey:@"highlightLoaction" ascending:YES];
    return @[desType,desLocation];
}

+ (WPFSearchResultModel *)searchEffectiveResultWithSearchString:(NSString *)searchStrLower
                                                         Person:(WPFPerson *)person {
    WPFSearchResultModel *resultModel = [self
                                         _searchEffectiveResultWithSearchString:searchStrLower
                                         nameString:person.name
                                         completeSpelling:person.completeSpelling
                                         initialString:person.initialString
                                         pinyinLocationString:person.pinyinLocationString
                                         initialLocationString:person.initialLocationString];
    
    if (resultModel.highlightedRange.length) {
        return resultModel;

    } else if (person.isContainPolyPhone) {
        // 如果正常匹配没有对应结果，且该model存在多音字，则尝试多音字匹配
        resultModel = [WPFPinYinTools
                       _searchEffectiveResultWithSearchString:searchStrLower
                       nameString:person.name
                       completeSpelling:person.polyPhoneCompleteSpelling
                       initialString:person.polyPhoneInitialString
                       pinyinLocationString:person.polyPhonePinyinLocationString
                       initialLocationString:person.initialLocationString];
        if (resultModel.highlightedRange.length) {
            return resultModel;
        }
    }
    return nil;
}

#pragma mark - Private Method
+ (WPFSearchResultModel *)_searchEffectiveResultWithSearchString:(NSString *)searchStrLower
                                                     nameString:(NSString *)nameStrLower
                                               completeSpelling:(NSString *)completeSpelling
                                                  initialString:(NSString *)initialString
                                           pinyinLocationString:(NSString *)pinyinLocationString
                                          initialLocationString:(NSString *)initialLocationString {
    
    WPFSearchResultModel *searchModel = [[WPFSearchResultModel alloc] init];
    
    NSArray *completeSpellingArray = [pinyinLocationString componentsSeparatedByString:@","];
    NSArray *pinyinFirstLetterLocationArray = [initialLocationString componentsSeparatedByString:@","];
    
    // 完全中文匹配范围
    NSRange chineseRange = [nameStrLower rangeOfString:searchStrLower];
    // 拼音全拼匹配范围
    NSRange complateRange = [completeSpelling rangeOfString:searchStrLower];
    // 拼音首字母匹配范围
    NSRange initialRange = [initialString rangeOfString:searchStrLower];
    
    // 汉字直接匹配
    if (chineseRange.length!=0) {
        searchModel.highlightedRange = chineseRange;
        searchModel.matchType = MatchTypeChinese;
        return searchModel;
    }
    
    NSRange highlightedRange = NSMakeRange(0, 0);
    
    // MARK: 拼音全拼匹配
    if (complateRange.length != 0) {
        if (complateRange.location == 0) {
            // 拼音首字母匹配从0开始，即搜索的关键字与该数据源第一个汉字匹配到，所以高亮范围从0开始
            highlightedRange = NSMakeRange(0, [completeSpellingArray[complateRange.length-1] integerValue] +1);
            
        } else {
            /** 如果该拼音字符是一个汉字的首个字符，如搜索“g”，
             *  就要匹配出“gai”、“ge”等“g”开头的拼音对应的字符，
             *  而不应该匹配到“wang”、“feng”等非”g“开头的拼音对应的字符
             */
            NSInteger currentLocation = [completeSpellingArray[complateRange.location] integerValue];
            NSInteger lastLocation = [completeSpellingArray[complateRange.location-1] integerValue];
            if (currentLocation != lastLocation) {
                // 高亮范围从匹配到的第一个关键字开始
                highlightedRange = NSMakeRange(currentLocation, [completeSpellingArray[complateRange.length+complateRange.location -1] integerValue] - currentLocation +1);
            }
        }
        searchModel.highlightedRange = highlightedRange;
        searchModel.matchType = MatchTypeComplate;
        if (highlightedRange.length!=0) {
            return searchModel;
        }
    }
    
    // MARK: 拼音首字母匹配
    if (initialRange.length!=0) {
        NSInteger currentLocation = [pinyinFirstLetterLocationArray[initialRange.location] integerValue];
        NSInteger highlightedLength;
        if (initialRange.location ==0) {
            highlightedLength = [pinyinFirstLetterLocationArray[initialRange.length-1] integerValue]-currentLocation +1;
            // 拼音首字母匹配从0开始，即搜索的关键字与该数据源第一个汉字匹配到，所以高亮范围从0开始
            highlightedRange = NSMakeRange(0, highlightedLength);
        } else {
            highlightedLength = [pinyinFirstLetterLocationArray[initialRange.length+initialRange.location-1] integerValue]-currentLocation +1;
            // 高亮范围从匹配到的第一个关键字开始
            highlightedRange = NSMakeRange(currentLocation, highlightedLength);
        }
        searchModel.highlightedRange = highlightedRange;
        searchModel.matchType = MatchTypeInitial;
        if (highlightedRange.length!=0) {
            return searchModel;
        }
    }
    
    searchModel.highlightedRange = NSMakeRange(0, 0);
    searchModel.matchType = NSIntegerMax;
    return searchModel;
}



@end
