//
//  PKAssetWriter.h
//  DevelopWriterDemo
//
//  Created by jiangxincai on 16/1/17.
//  Copyright © 2016年 pepsikirk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PKShortVideoSessionDelegate;

@interface PKShortVideoSession : NSObject

@property (nonatomic, readonly) BOOL videoInitialized;
@property (nonatomic, readonly) BOOL audioInitialized;

@property (nonatomic, weak) id<PKShortVideoSessionDelegate> delegate;

- (instancetype)initWithTempFilePath:(NSString *)tempFilePath;

- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)videoSettings;
- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings;

- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)prepareToRecord;
- (void)finishRecording;

@end


@protocol PKShortVideoSessionDelegate <NSObject>

- (void)sessionDidFinishPreparing:(PKShortVideoSession *)session;
- (void)session:(PKShortVideoSession *)session didFailWithError:(NSError *)error;
- (void)sessionDidFinishRecording:(PKShortVideoSession *)session;

@end

NS_ASSUME_NONNULL_END


