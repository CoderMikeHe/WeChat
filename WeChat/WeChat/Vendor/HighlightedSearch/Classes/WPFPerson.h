//
//  WPFPerson.h
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPFPinYinTools.h"

@interface WPFPerson : NSObject

/** 唯一标识符 */
@property (nonatomic, copy) NSString *personId;
/** 人物名称，如：王鹏飞 */
@property (nonatomic, copy) NSString *name;
/// model
@property (nonatomic, readonly, strong) id model;

/** 拼音全拼（小写）如：@"wangpengfei" */
@property (nonatomic, copy) NSString *completeSpelling;
/** 拼音首字母（小写）如：@"wpf" */
@property (nonatomic, copy) NSString *initialString;
/**
 拼音全拼（小写）位置，如：@"0,0,0,0,1,1,1,1,2,2,2"
                        w a n g p e n g f e i
 */
@property (nonatomic, copy) NSString *pinyinLocationString;
/** 拼音首字母拼音（小写）数组字符串位置，如@"0,1,2" */
@property (nonatomic, copy) NSString *initialLocationString;
/** 高亮位置 */
@property (nonatomic, assign) NSInteger highlightLoaction;
/** 关键字范围 */
@property (nonatomic, assign) NSRange textRange;
/** 匹配类型 */
@property (nonatomic, assign) NSInteger matchType;

// 以下四个属性为多音字的适配，暂时只支持双多音字
/** 是否包含多音字 */
@property (nonatomic, assign) BOOL isContainPolyPhone;
/** 第二个多音字 拼音全拼（小写） */
@property (nonatomic, copy) NSString *polyPhoneCompleteSpelling;
/** 第二个多音字 拼音首字母（小写）*/
@property (nonatomic, copy) NSString *polyPhoneInitialString;
/** 第二个多音字 拼音全拼（小写）位置 */
@property (nonatomic, copy) NSString *polyPhonePinyinLocationString;
/** 第二个多音字 拼音首字母拼音（小写）数组字符串位置 */
// 可以忽略掉，因为即使是多音字，简拼的定位是一定一样的
//@property (nonatomic, copy) NSString *polyPhoneInitialLocationString;


/**
 快速构建方法

 @param name 姓名
 @return 构建完毕的person
 */
+ (instancetype)personWithId:(NSString *)personId name:(NSString *)name hanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)pinyinFormat;



/**
 快速构建方法 加强版

 @param name 姓名
 @param model 原始数据
 @return 构建完毕的person
 */
+ (instancetype)personWithId:(NSString *)personId name:(NSString *)name hanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)pinyinFormat model:(id)model;
@end
