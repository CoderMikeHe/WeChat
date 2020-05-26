
//
//  IFlyVoiceWakeuperDel.h
//  wakeup
//
//  Created by admin on 14-3-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//



#import <Foundation/Foundation.h>

@class IFlySpeechError;

@protocol IFlyVoiceWakeuperDelegate <NSObject>

@optional

/*!
 * 录音开始
 */
-(void) onBeginOfSpeech;

/*!
 * 录音结束
 */
-(void) onEndOfSpeech;

/*!
 * 会话错误
 *
 * @param errorCode 错误描述类，
 */
- (void) onCompleted:(IFlySpeechError *) error;

/*!
 * 唤醒结果
 *
 * @param resultDic 唤醒结果字典
 */
-(void) onResult:(NSMutableDictionary *)resultDic;

/*!
 * 音量反馈，返回频率与录音数据返回回调频率一致
 *
 * @param volume 音量值
 */
- (void) onVolumeChanged: (int)volume;

/*!
 * 扩展事件回调<br>
 * 根据事件类型返回额外的数据
 *
 @param eventType 事件类型，具体参见IFlySpeechEvent枚举。
 */
- (void) onEvent:(int)eventType isLast:(BOOL)isLast arg1:(int)arg1 data:(NSMutableDictionary *)eventData;

@end

