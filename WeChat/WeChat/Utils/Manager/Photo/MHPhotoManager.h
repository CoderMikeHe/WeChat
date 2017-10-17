//
//  MHPhotoManager.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//
//  图片浏览器+图片选择器

#import <Foundation/Foundation.h>
#import "IDMPhotoBrowser.h"
#import "TZImagePickerController.h"

@interface MHPhotoManager : NSObject

#pragma mark - PhotoBrowser

/**
 图片浏览器

 @param viewController presentingViewController (用于presentViewController:browser)，可以传nil
 @param photosArray 图片模型数组 (NSArray <IDMPhoto *> *)
 @param initialPageIndex Set page that photo browser starts on
 @param delegate browser.delegate 如果不想使用 传nil
 */
+ (void)showPhotoBrowser:(UIViewController *)viewController photos:(NSArray <IDMPhoto *> *)photosArray initialPageIndex:(NSUInteger)initialPageIndex delegate:(id<IDMPhotoBrowserDelegate>)delegate;


/**
 图片浏览器

 @param viewController presentingViewController (用于presentViewController:browser)，可以传nil
 @param photosArray 图片模型数组 (NSArray <IDMPhoto *> *)
 @param initialPageIndex Set page that photo browser starts on
 @param animatedFromView 从哪个View开始缩放，一般是你 initialPageIndex 对应的view
 @param scaleImage 缩放过程中的图片 （UIImage），若不需要 传nil
 @param delegate browser.delegate 如果不想使用 传nil
 */
+ (void)showPhotoBrowser:(UIViewController *)viewController photos:(NSArray <IDMPhoto *> *)photosArray initialPageIndex:(NSUInteger)initialPageIndex animatedFromView:(UIView*)animatedFromView scaleImage:(UIImage *)scaleImage delegate:(id<IDMPhotoBrowserDelegate>)delegate;

/**
 图片浏览器

 @param viewController presentingViewController (用于presentViewController:browser)，可以传nil
 @param photoURLsArray 图片URL数组 (NSArray <NSURL *> *)
 @param initialPageIndex Set page that photo browser starts on
 @param delegate browser.delegate 如果不想使用 传nil
 */
+ (void)showPhotoBrowser:(UIViewController *)viewController photoURLs:(NSArray <NSURL *> *)photoURLsArray initialPageIndex:(NSUInteger)initialPageIndex delegate:(id<IDMPhotoBrowserDelegate>)delegate;


/**
 图片浏览器

 @param viewController presentingViewController (用于presentViewController:browser)，可以传nil
 @param photoURLsArray 图片URL数组 (NSArray <NSURL *> *)
 @param initialPageIndex Set page that photo browser starts on
 @param animatedFromView 从哪个View开始缩放，一般是你 initialPageIndex 对应的view
 @param scaleImage 缩放过程中的图片 （UIImage），若不需要 传nil
 @param delegate browser.delegate 如果不想使用 传nil
 */
+ (void)showPhotoBrowser:(UIViewController *)viewController photoURLs:(NSArray <NSURL *> *)photoURLsArray initialPageIndex:(NSUInteger)initialPageIndex animatedFromView:(UIView*)animatedFromView scaleImage:(UIImage *)scaleImage delegate:(id<IDMPhotoBrowserDelegate>)delegate;



#pragma mark - ImagePicker

/**
 拍照

 @param viewController presentingViewController (用于presentViewController:browser)，可以传nil，但是能传尽量传
 @param allowCrop 是否允许裁剪
 @param completion 拍照获取的图片 注意 image就是原图
 */
+ (void)fetchPhotosFromCamera:(UIViewController *)viewController allowCrop:(BOOL)allowCrop completion:(void (^)(UIImage *image , id asset))completion;


/**
 从相册里面获取图片 （PS:其内部也内嵌了 照相机的功能）

 @param viewController presentingViewController (用于presentViewController:browser)，可以传nil，但是能传尽量传
 @param maxImagesCount 允许选中的最大值
 @param allowCrop 是否允许裁剪 多选情况下，无效
 @param selecatedAssets 已经选中的照片
 @param completion 完成回调 注意 photos装的都是缩略图 若想得到原图，请使用 [MHPhotoManager fetchOriginalPhotoWithAsset:completion]
 @param cancel 取消回调  一般传 NULL
 */
+ (void)fetchPhotosFromAlbum:(UIViewController *)viewController
              maxImagesCount:(NSInteger)maxImagesCount
                   allowCrop:(BOOL)allowCrop
              selectedAssets:(NSArray *)selecatedAssets
                  completion:(void(^)(NSArray<UIImage *> *photos , NSArray *assets , BOOL isSelectOriginalPhoto ,NSArray<NSDictionary *> *infos))completion
                      cancel:(void(^)())cancel;



/**
 * 预览图片 （PS：一般用于，通过从相册或者照相机，获取到的本地图片的数据，不适合网络图片）

 @param viewController presentingViewController (用于presentViewController:browser)，可以传nil，但是能传尽量传
 @param maxImagesCount 允许选中的最大值
 @param selecatedAssets 选中的assets
 @param selectedPhotos 选中的photos
 @param currentIndex 当前预览的索引
 @param completion 完成回调
 @param cancel 取消回调 一般 NULL
 */
+ (void)previewPhotos:(UIViewController *)viewController
       maxImagesCount:(NSInteger)maxImagesCount
       selectedAssets:(NSArray *)selecatedAssets
       selectedPhotos:(NSMutableArray *)selectedPhotos
         currentIndex:(NSInteger)currentIndex
           completion:(void(^)(NSArray<UIImage *> *photos , NSArray *assets , BOOL isSelectOriginalPhoto ,NSArray<NSDictionary *> *infos))completion
               cancel:(void(^)())cancel;
/**
 获取原图

 @param asset asset
 @param completion 完成回调 isDegraded = NO 代表photo是原图  否则photo是缩略图
 /// 方法completion一般会调多次，一般会先返回缩略图，再返回原图(详见方法内部使用的系统API的说明)，如果info[PHImageResultIsDegradedKey] 为 YES，则表明当前返回的是缩略图，否则是原图。
 */
+ (void)fetchOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo , NSDictionary *info , BOOL isDegraded))completion;



/// 允许最大选择
+ (NSInteger)maxImagesCount;


/// 细节处理 (开发者请不必关注)，控制器必须是 SBViewController 的子类
+ (BOOL)isSelectOriginalPhoto; /// 是否选中了原图
+ (void)configureSelectOriginalPhoto:(BOOL)selected; /// 配置选中了原图


@end
