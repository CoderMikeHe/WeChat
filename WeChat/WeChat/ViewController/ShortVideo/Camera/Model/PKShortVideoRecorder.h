//
//  PKShortVideoWriter.h
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/14.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PKShortVideoRecorder;

@protocol PKShortVideoRecorderDelegate <NSObject>

@required

- (void)recorderDidBeginRecording:(PKShortVideoRecorder *)recorder;
- (void)recorderDidEndRecording:(PKShortVideoRecorder *)recorder;
- (void)recorder:(PKShortVideoRecorder *)recorder didFinishRecordingToOutputFilePath:(nullable NSString *)outputFilePath error:(nullable NSError *)error;
@end



@class AVCaptureVideoPreviewLayer;

@interface PKShortVideoRecorder : NSObject

/// 代理
@property (nonatomic, weak) id<PKShortVideoRecorderDelegate> delegate;

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize;

@property (nonatomic , readonly, strong) AVCaptureSession *captureSession;

- (void)startRunning;
- (void)stopRunning;

- (void)startRecording;
- (void)stopRecording;

/**
 Capture a photo from the camera
 @param completionHandler called on the main queue with the image taken or an error in case of a problem
 */
- (void)capturePhoto:(void(^ __nonnull)(NSError *__nullable error, UIImage *__nullable image))completionHandler;

- (void)swapFrontAndBackCameras;

- (AVCaptureVideoPreviewLayer *)previewLayer;

@end

NS_ASSUME_NONNULL_END


