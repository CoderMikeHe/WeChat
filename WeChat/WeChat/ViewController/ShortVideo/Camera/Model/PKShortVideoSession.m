//
//  PKAssetWriter.m
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/17.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import "PKShortVideoSession.h"

typedef NS_ENUM(NSInteger, PKSessionStatus){
    PKSessionStatusIdle = 0,
    PKSessionStatusPreparingToRecord,
    PKSessionStatusRecording,
    PKSessionStatusFinishingRecordingPart1, // waiting for inflight buffers to be appended
    PKSessionStatusFinishingRecordingPart2, // calling finish writing on the asset writer
    PKSessionStatusFinished,
    PKSessionStatusFailed
};

@interface PKShortVideoSession ()

@property (nonatomic, assign) PKSessionStatus status;

@property (nonatomic) dispatch_queue_t writingQueue;
@property (nonatomic) dispatch_queue_t delegateCallbackQueue;

@property (nonatomic) NSString *tempFilePath;

@property (nonatomic) AVAssetWriter *assetWriter;
@property (nonatomic) BOOL haveStartedSession;

@property (nonatomic) CMFormatDescriptionRef audioTrackSourceFormatDescription;
@property (nonatomic) CMFormatDescriptionRef videoTrackSourceFormatDescription;

@property (nonatomic) NSDictionary *audioTrackSettings;
@property (nonatomic) NSDictionary *videoTrackSettings;

@property (nonatomic) AVAssetWriterInput *audioInput;
@property (nonatomic) AVAssetWriterInput *videoInput;

@property (nonatomic) CGAffineTransform videoTrackTransform;

@end

@implementation PKShortVideoSession


- (instancetype)initWithTempFilePath:(NSString *)tempFilePath {
    if (!tempFilePath) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _delegateCallbackQueue = dispatch_queue_create("com.PKShortVideoWriter.writerDelegateCallback", DISPATCH_QUEUE_SERIAL );
        _writingQueue = dispatch_queue_create("com.PKShortVideoWriter.assetwriter", DISPATCH_QUEUE_SERIAL );
        
        _videoTrackTransform = CGAffineTransformMakeRotation(M_PI_2);//人像方向
        _tempFilePath = tempFilePath;
    }
    return self;
}

- (void)dealloc {
    [_assetWriter cancelWriting];
}


#pragma mark - Public

- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)videoSettings {
    @synchronized(self) {
        self.videoTrackSourceFormatDescription = (CMFormatDescriptionRef)CFRetain(formatDescription);
        self.videoTrackSettings = [videoSettings copy];
    }
}

- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings {
    @synchronized(self) {
        self.audioTrackSourceFormatDescription = (CMFormatDescriptionRef)CFRetain(formatDescription);
        self.audioTrackSettings = [audioSettings copy];
    }
}

- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
}

- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
}

- (void)prepareToRecord {
    @synchronized(self) {
        if (self.status != PKSessionStatusIdle){
            NSLog(@"已经开始准备不需要再准备");
            return;
        }
        [self transitionToStatus:PKSessionStatusPreparingToRecord error:nil];
    }
            
    NSError *error = nil;
    //确保当前url文件不存在
    [[NSFileManager defaultManager] removeItemAtPath:self.tempFilePath error:&error];
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:self.tempFilePath] fileType:AVFileTypeMPEG4 error:&error];
    
    //创建添加输入
    if (!error && _videoTrackSourceFormatDescription) {
        [self setupAssetWriterVideoInputWithSourceFormatDescription:self.videoTrackSourceFormatDescription transform:self.videoTrackTransform settings:self.videoTrackSettings error:&error];
    }
    if (!error && _audioTrackSourceFormatDescription) {
        [self setupAssetWriterAudioInputWithSourceFormatDescription:self.audioTrackSourceFormatDescription settings:self.audioTrackSettings error:&error];
    }
    //开始
    if (!error) {
        BOOL success = [self.assetWriter startWriting];
        if (!success) {
            error = self.assetWriter.error;
        }
    }
    
    @synchronized(self) {
        if (error) {
            [self transitionToStatus:PKSessionStatusFailed error:error];
        } else {
            [self transitionToStatus:PKSessionStatusRecording error:nil];
        }
    }
}

- (void)finishRecording {
    @synchronized(self) {
        BOOL shouldFinishRecording = NO;
        switch (self.status) {
            case PKSessionStatusIdle:
            case PKSessionStatusPreparingToRecord:
            case PKSessionStatusFinishingRecordingPart1:
            case PKSessionStatusFinishingRecordingPart2:
            case PKSessionStatusFinished:
                NSLog(@"还没有开始记录");
                return;
                break;
            case PKSessionStatusFailed:
                NSLog( @"记录失败" );
                break;
            case PKSessionStatusRecording:
                shouldFinishRecording = YES;
                break;
        }
        
        if (shouldFinishRecording){
            [self transitionToStatus:PKSessionStatusFinishingRecordingPart1 error:nil];
        } else {
            return;
        }
    }
    
    dispatch_async(_writingQueue, ^{
        @autoreleasepool {
            @synchronized(self) {
                if (self.status != PKSessionStatusFinishingRecordingPart1) {
                    return;
                }
                
                [self transitionToStatus:PKSessionStatusFinishingRecordingPart2 error:nil];
            }
            [self.assetWriter finishWritingWithCompletionHandler:^{
                @synchronized(self) {
                    NSError *error = self.assetWriter.error;
                    if (error) {
                        [self transitionToStatus:PKSessionStatusFailed error:error];
                    } else {
                        [self transitionToStatus:PKSessionStatusFinished error:nil];
                    }
                }
            }];
        }
    } );
}


#pragma mark - Private methods

- (BOOL)setupAssetWriterAudioInputWithSourceFormatDescription:(CMFormatDescriptionRef)audioFormatDescription settings:(NSDictionary *)audioSettings error:(NSError **)errorOut {
    if ([self.assetWriter canApplyOutputSettings:audioSettings forMediaType:AVMediaTypeAudio]){
        self.audioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:audioSettings sourceFormatHint:audioFormatDescription];
        self.audioInput.expectsMediaDataInRealTime = YES;
        
        if ([self.assetWriter canAddInput:self.audioInput]){
            [self.assetWriter addInput:self.audioInput];
        } else {
            if (errorOut) {
                *errorOut = [self cannotSetupInputError];
            }
            return NO;
        }
    }
    else {
        if (errorOut) {
            *errorOut = [self cannotSetupInputError];
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)setupAssetWriterVideoInputWithSourceFormatDescription:(CMFormatDescriptionRef)videoFormatDescription transform:(CGAffineTransform)transform settings:(NSDictionary *)videoSettings error:(NSError **)errorOut {
    if ([self.assetWriter canApplyOutputSettings:videoSettings forMediaType:AVMediaTypeVideo]){
        self.videoInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:videoSettings sourceFormatHint:videoFormatDescription];
        self.videoInput.expectsMediaDataInRealTime = YES;
        self.videoInput.transform = transform;
        
        if ([self.assetWriter canAddInput:self.videoInput]){
            [self.assetWriter addInput:self.videoInput];
        } else {
            if (errorOut) {
                *errorOut = [self cannotSetupInputError];
            }
            return NO;
        }
    } else {
        if (errorOut) {
            *errorOut = [self cannotSetupInputError];
        }
        return NO;
    }
    return YES;
}

- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType {
    if (sampleBuffer == NULL){
        NSLog(@"不存在sampleBuffer");
        return;
    }
    
    @synchronized(self){
        if (self.status < PKSessionStatusRecording){
            NSLog(@"还没准备好记录");
            return;
        }
    }
    
    CFRetain(sampleBuffer);
    dispatch_async(self.writingQueue, ^{
        @autoreleasepool {
            @synchronized(self) {
                if (self.status > PKSessionStatusFinishingRecordingPart1){
                    CFRelease(sampleBuffer);
                    return;
                }
            }
            
            if (!self.haveStartedSession && mediaType == AVMediaTypeVideo) {
                [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
                self.haveStartedSession = YES;
            }
            
            AVAssetWriterInput *input = (mediaType == AVMediaTypeVideo) ? self.videoInput : self.audioInput;
            
            if (input.readyForMoreMediaData){
                BOOL success = [input appendSampleBuffer:sampleBuffer];
                if (!success){
                    NSError *error = self.assetWriter.error;
                    @synchronized(self){
                        [self transitionToStatus:PKSessionStatusFailed error:error];
                    }
                }
            } else {
                NSLog( @"%@ 输入不能添加更多数据了，抛弃 buffer", mediaType );
            }
            CFRelease(sampleBuffer);
        }
    } );
}

- (void)transitionToStatus:(PKSessionStatus)newStatus error:(NSError *)error {
    BOOL shouldNotifyDelegate = NO;
    
    if (newStatus != self.status){
        if ((newStatus == PKSessionStatusFinished) || (newStatus == PKSessionStatusFailed)){
            shouldNotifyDelegate = YES;
            
            dispatch_async(self.writingQueue, ^{
                self.assetWriter = nil;
                self.videoInput = nil;
                self.audioInput = nil;
                if (newStatus == PKSessionStatusFailed) {//失败删除
                    [[NSFileManager defaultManager] removeItemAtPath:self.tempFilePath error:NULL];
                }
            } );
        } else if (newStatus == PKSessionStatusRecording){
            shouldNotifyDelegate = YES;
        }
        self.status = newStatus;
    }
    
    if (shouldNotifyDelegate && self.delegate){
        dispatch_async(self.delegateCallbackQueue, ^{
            
            @autoreleasepool {
                switch(newStatus){
                    case PKSessionStatusRecording:
                        [self.delegate sessionDidFinishPreparing:self];
                        break;
                    case PKSessionStatusFinished:
                        [self.delegate sessionDidFinishRecording:self];
                        break;
                    case PKSessionStatusFailed:
                        [self.delegate session:self didFailWithError:error];
                        break;
                    default:
                        break;
                }
            }
        });
    }
}

- (NSError *)cannotSetupInputError {
    NSDictionary *errorDict = @{ NSLocalizedDescriptionKey : @"记录不能开始",
                                 NSLocalizedFailureReasonErrorKey : @"不能初始化writer" };
    return [NSError errorWithDomain:@"com.PKShortVideoWriter" code:0 userInfo:errorDict];
}


#pragma mark - Getter 

- (BOOL)videoInitialized {
    return _videoInput != nil;
}

- (BOOL)audioInitialized {
    return _audioInput != nil;
}

@end
