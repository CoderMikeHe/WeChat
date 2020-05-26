//
//  IFlySetting.h
//  MSC
//
//  Created by iflytek on 13-4-12.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  日志打印等级
 */
typedef NS_OPTIONS(NSInteger, LOG_LEVEL){
    /*!
     *  全部打印
     */
    LVL_ALL                 = -1,
    /*!
     *  高，异常分析需要的级别
     */
    LVL_DETAIL              = 31,
    /*!
     *  中，打印基本日志信息
     */
    LVL_NORMAL              = 15,
    /*!
     *  低，只打印主要日志信息
     */
    LVL_LOW                 = 7,
    /*!
     *  不打印
     */
    LVL_NONE                = 0
};

/*!
 *   此接口为iflyMSC sdk 配置接口。<br>
 *   可以获取版本号，设置日志打印等级等
 */
@interface IFlySetting : NSObject

/*!
 *  获取版本号
 *
 *  @return  版本号
 */
+ (NSString *) getVersion;

/*!
 *  获取日志等级
 *
 *  @return 返回日志等级
 */
+ (LOG_LEVEL) logLvl;

/*!
 *  是否打印控制台log<br>
 *  在软件发布时，建议关闭此log。
 *
 *  @param showLog -[in] YES,打印log;NO,不打印
 */
+ (void) showLogcat:(BOOL) showLog;

/*!
 *  设置日志msc.log生成路径以及日志等级
 *
 *  | 日志打印等级             | 描述                               |
 *  |------------------------|-----------------------------------|
 *  | LVL_ALL                | 全部打印                           |
 *  | LVL_DETAIL             | 高，异常分析需要的级别                |
 *  | LVL_NORMAL             | 中，打印基本日志信息                  |
 *  | LVL_LOW                | 低，只打印主要日志信息                |
 *  | LVL_NONE               | 不打印                             |
 *
 *  @param level  -[in] 日志打印等级
 */
+ (void) setLogFile:(LOG_LEVEL) level;

/*!
 *  设置日志文件的路径<br>
 *  日志文件默认存放在Documents目录。
 *
 *  @param path  -[in] 日志文件的全路径
 */
+ (void) setLogFilePath:(NSString*) path;

@end
