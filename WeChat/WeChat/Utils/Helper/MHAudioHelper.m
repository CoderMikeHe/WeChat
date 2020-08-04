//
//  MHAudioHelper.m
//  MascotAlarmClock-mobile
//
//  Created by senba on 2017/10/26.
//  

#import "MHAudioHelper.h"

/**
 *  系统铃声播放完成后的回调
 */
void SBSystemSoundFinishedPlayingCallback(SystemSoundID sound_id, void* user_data){
    /// 执行方法
    [[MHAudioHelper sharedInstance] performSelector:@selector(playVibration) withObject:nil afterDelay:.5];
}


@interface MHAudioHelper ()

/// 是否正在震动
@property (nonatomic, readwrite, assign , getter = isVibration) BOOL vibration;

@end


@implementation MHAudioHelper
static NSMutableDictionary *_soundDict;
static NSMutableDictionary *_musicDict;

+ (void)initialize{
    _soundDict = [NSMutableDictionary dictionary];
    _musicDict = [NSMutableDictionary dictionary];
}


MHSingletonM(Instance)


// 播放震动
- (void)playVibration{
//    /// 播放震动 (PS 解决震动太过于连续的的用户体验)
//    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
//       /// 整理搞个递归
//        /// CoderMikeHe Fixed: 这里必须要延迟一段时间，否则不起作用
////        [self performSelector:@selector(playVibration) withObject:nil afterDelay:.5];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self performSelector:@selector(playVibration) withObject:nil afterDelay:.4];
//        });
//    });
    
    
    
    /// 播放
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          NULL, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    self.vibration = YES;
}

/// 停止震动
- (void)stopVibration{
    /// 取消掉
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playVibration) object:nil];
    /// remove
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    /// dispose
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    
    self.vibration = NO;
}






+ (void)playSoundWithName:(NSString *)soundName{
    // 1.从字典中取出对应的声音文件的SoundID
    SystemSoundID soundId = [_soundDict[soundName] unsignedIntValue];
    
    // 2.如果取出为空,则创建对应的音效文件
    if (soundId == 0) {
        // 2.1.获取对应音频的URL
        CFURLRef urlRef = (__bridge CFURLRef)([[NSBundle mainBundle] URLForResource:soundName withExtension:nil]);
        
        // 2.2.创建对应的音效文件
        AudioServicesCreateSystemSoundID(urlRef, &soundId);
        
        // 2.3.存到字典中
        [_soundDict setObject:@(soundId) forKey:soundName];
    }
    
    // 3.播放音效
    AudioServicesPlaySystemSound(soundId);
}

+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName{
    // 0.判断传入的字符串是否为空
    assert(musicName);
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = _musicDict[musicName];
    
    // 2.如果取出为空,则创建对应的播放器
    if (player == nil) {
        // 2.1.获取音乐对应的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:@"mp3"];
        
        // 2.2.创建对应的播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.3 循环播放
        player.numberOfLoops = -1;
        
        // 2.4将播放器存到字典中
        [_musicDict setObject:player forKey:musicName];
    }
    
    // 3.播放音乐
    [player prepareToPlay];
    [player play];
    
    return player;
}

+ (void)pauseMusicWithName:(NSString *)musicName{
    // 0.判断传入的字符串是否为空
    assert(musicName);
    
    // 1.取出对应的播放器
    AVAudioPlayer *player = _musicDict[musicName];
    
    // 2.暂停歌曲
    if (player && player.isPlaying) {
        [player pause];
    }
}

+ (void)stopMusicWithName:(NSString *)musicName{
    // 0.判断传入的字符串是否为空
    assert(musicName);
    
    // 1.取出对应的播放器
    AVAudioPlayer *player = _musicDict[musicName];
    
    // 2.停止播放
    if (player) {
        [player stop];
        [_musicDict removeObjectForKey:musicName];
        player = nil;
    }
}

@end
