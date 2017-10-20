//
//  RACSubscriber+AFProgressCallbacks.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#ifdef RAFN_EXPERIMENTAL_PROGRESS_SUPPORT

#import "RACSubscriber+AFProgressCallbacks.h"
#import <objc/runtime.h>

static char RAFNProgress_Block_Key;

@interface RACSubscriber (AFInternalProgressCallbacks)

@property (nonatomic, copy) void (^_progress)(float progress);

@end

@implementation RACSubscriber (AFProgressCallbacks)

+ (instancetype)subscriberWithNext:(void (^)(id x))next progress:(void (^)(float progress))progress error:(void (^)(NSError *error))error completed:(void (^)(void))completed {
	RACSubscriber *subscriber = [self subscriberWithNext:next error:error completed:completed];
	subscriber._progress = progress;
	
	return subscriber;
}

- (void)set_progress:(void (^)(float))_progress {
	objc_setAssociatedObject(self, &RAFNProgress_Block_Key, _progress, OBJC_ASSOCIATION_COPY);
}

- (void (^)(float))_progress {
	return objc_getAssociatedObject(self, &RAFNProgress_Block_Key);
}

- (void)sendProgress:(float)p {
	[[self performSelector:@selector(disposable)] dispose];
	if (self._progress != NULL) self._progress(p);
}

@end

@implementation RACSignal (RAFNProgressSubscriptions)

- (RACDisposable *)subscribeProgress:(void (^)(float progress))progress next:(void (^)(id x))nextBlock {
	NSParameterAssert(progress != NULL);
	NSParameterAssert(nextBlock != NULL);
	
	RACSubscriber *o = [RACSubscriber subscriberWithNext:nextBlock progress:progress error:NULL completed:NULL];

	return [self subscribe:o];
}

- (RACDisposable *)subscribeProgress:(void (^)(float progress))progress next:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock {
	NSParameterAssert(progress != NULL);
	NSParameterAssert(nextBlock != NULL);
	NSParameterAssert(completedBlock != NULL);

	RACSubscriber *o = [RACSubscriber subscriberWithNext:nextBlock progress:progress error:NULL completed:completedBlock];
	
	return [self subscribe:o];
}

- (RACDisposable *)subscribeProgress:(void (^)(float progress))progress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock {
	NSParameterAssert(progress != NULL);
	NSParameterAssert(nextBlock != NULL);
	NSParameterAssert(errorBlock != NULL);
	NSParameterAssert(completedBlock != NULL);
	
	RACSubscriber *o = [RACSubscriber subscriberWithNext:nextBlock progress:progress error:errorBlock completed:completedBlock];
	
	return [self subscribe:o];
}

- (RACDisposable *)subscribeProgress:(void (^)(float progress))progress completed:(void (^)(void))completedBlock {
	NSParameterAssert(progress != NULL);
	NSParameterAssert(completedBlock != NULL);
	
	RACSubscriber *o = [RACSubscriber subscriberWithNext:NULL progress:progress error:NULL completed:completedBlock];
	
	return [self subscribe:o];
}

- (RACDisposable *)subscribeProgress:(void (^)(float progress))progress next:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock {
	NSParameterAssert(progress != NULL);
	NSParameterAssert(nextBlock != NULL);
	NSParameterAssert(errorBlock != NULL);

	RACSubscriber *o = [RACSubscriber subscriberWithNext:nextBlock progress:progress error:errorBlock completed:NULL];
	
	return [self subscribe:o];
}

- (RACDisposable *)subscribeProgress:(void (^)(float progress))progress error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock {
	NSParameterAssert(progress != NULL);
	NSParameterAssert(errorBlock != NULL);
	NSParameterAssert(completedBlock != NULL);
	
	RACSubscriber *o = [RACSubscriber subscriberWithNext:NULL progress:progress error:errorBlock completed:completedBlock];
	
	return [self subscribe:o];
}

@end

@implementation RACSubject (RAFNProgressSending)

- (void)sendProgress:(float)value {
	void (^subscriberBlock)(id<RACSubscriber> subscriber) = ^(id<RACSubscriber> subscriber){
		[(RACSubscriber*)subscriber sendProgress:value];
	};
	
	[self performSelector:@selector(performBlockOnEachSubscriber:) withObject:subscriberBlock];
}

@end

#endif