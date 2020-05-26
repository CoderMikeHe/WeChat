//
//  IFlyVoiceWakeuper.h
//  wakeup
//
//  Created by admin on 14-3-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "IFlyVoiceWakeuperDelegate.h"

#define IFLY_AUDIO_SOURCE_MIC    @"1"
#define IFLY_AUDIO_SOURCE_STREAM @"-1"

/*!
 *  语音唤醒
 */
@interface IFlyVoiceWakeuper : NSObject

/*!
 * 代理
 */
@property (nonatomic, assign) id<IFlyVoiceWakeuperDelegate> delegate;

/*!
 * 是否正在唤醒
 */
@property (nonatomic, readonly) BOOL isListening;

/*!
 * 创建唤醒实例，采用单例模式
 */
+ (instancetype) sharedInstance;


/*!
 * 启动唤醒
 * 返回值:YES 成功，NO：失败
 */
-(BOOL) startListening;

/*!
 * 停止录音
 */
-(BOOL) stopListening;

/*!
 * 取消唤醒会话
 */
-(BOOL) cancel;

/*!
 * 获取工作参数
 */
-(NSString*) getParameter:(NSString *)key;

/*!
 * 设置工作参数<br>
 * 注意服务正在运行中，不能设置参数
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

@end

/*!
 *  音频流唤醒<br>
 *  音频流唤醒可以将文件分段写入
 */
@interface IFlyVoiceWakeuper(IFlyStreamVoiceWakeuper)

/*!
 *  写入音频流
 *
 *  @param audioData 音频数据
 *
 *  @return 写入成功返回YES，写入失败返回NO
 */
- (BOOL) writeAudio:(NSData *) audioData;

@end


