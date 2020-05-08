//
//  IFlyAudioSession.h
//  MSCDemo
//
//  Created by AlexHHC on 1/9/14.
//
//

#import <Foundation/Foundation.h>

/**
 *  音频环境初始化，设置AVAudioSession的Category属性。
 */
@interface IFlyAudioSession : NSObject

/**
 *  初始化播音环境，主要用于合成播放器。
 *
 *  此接口主要根据原来的音频环境，重新优化设置AVAudioSession的Category属性值。<br>
 *  若原来的Category属性值为AVAudioSessionCategoryPlayAndRecord，则添加AVAudioSessionCategoryOptionDefaultToSpeaker｜AVAudioSessionCategoryOptionAllowBluetooth选项；若为其他Category属性值且isMPCenter为NO，则设置Category属性值为AVAudioSessionCategoryPlayback，选项为AVAudioSessionCategoryOptionMixWithOthers；若为其他Category属性值且isMPCenter为YES，则保持原来的设置，不做任何更改。
 *
 *  @param isMPCenter 是否初始化MPPlayerCenter：0不初始化，1初始化。此参数只在AVAudioSession的Category属性值不为AVAudioSessionCategoryPlayAndRecord时设置有效。
 */
+(void) initPlayingAudioSession:(BOOL)isMPCenter;

/**
 *  初始化录音环境,主要用于识别录音器。
 *
 *  设置AVAudioSession的Category属性值为AVAudioSessionCategoryPlayAndRecord，选项为AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionAllowBluetooth。
 *
 *  @return 成功返回YES，失败返回NO
 */
+(BOOL) initRecordingAudioSession;

@end
