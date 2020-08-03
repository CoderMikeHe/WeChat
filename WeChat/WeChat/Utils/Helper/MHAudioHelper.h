//
//  MHAudioHelper.h
//  MascotAlarmClock-mobile
//
//  Created by senba on 2017/10/26.
//  音频播放工具类

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MHAudioHelper : NSObject

MHSingletonH(Instance)


/// 是否正在震动
@property (nonatomic, readonly, assign , getter = isVibration) BOOL vibration;


/// 播放震动
- (void)playVibration;
/// 停止震动
- (void)stopVibration;


/// 播放音频文件
+ (void)playSoundWithName:(NSString *)soundName;
/// 播放音乐文件
+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName;
/// 暂停音乐
+ (void)pauseMusicWithName:(NSString *)musicName;
/// 停止音乐
+ (void)stopMusicWithName:(NSString *)musicName;
@end
