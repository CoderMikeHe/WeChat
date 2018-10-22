//
//  MHPhotoManager.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHPhotoManager.h"
#import "MHControllerHelper.h"
#import "TZImageManager.h"
#import "TZLocationManager.h"

/// 位置，use to record the location for photo
static CLLocation * st_location = nil;

/// 是否选中了原图
static BOOL st_isSelectOriginalPhoto = NO;

/// 允许最大选中照片数
static CGFloat const MHMaxImagesCount = 8;

@implementation MHPhotoManager
#pragma mark - PhotoBrowser

+ (void)showPhotoBrowser:(UIViewController *)viewController photoURLs:(NSArray<NSURL *> *)photoURLsArray initialPageIndex:(NSUInteger)initialPageIndex delegate:(id<IDMPhotoBrowserDelegate>)delegate{
    [self showPhotoBrowser:viewController photoURLs:photoURLsArray initialPageIndex:initialPageIndex animatedFromView:nil scaleImage:nil delegate:delegate];
}
+ (void)showPhotoBrowser:(UIViewController *)viewController photoURLs:(NSArray<NSURL *> *)photoURLsArray initialPageIndex:(NSUInteger)initialPageIndex animatedFromView:(UIView *)animatedFromView scaleImage:(UIImage *)scaleImage delegate:(id<IDMPhotoBrowserDelegate>)delegate{
    NSArray *photos = [IDMPhoto photosWithURLs:photoURLsArray];
    [self showPhotoBrowser:viewController photos:photos initialPageIndex:initialPageIndex animatedFromView:animatedFromView scaleImage:scaleImage delegate:delegate];
}

+ (void)showPhotoBrowser:(UIViewController *)viewController photos:(NSArray<IDMPhoto *> *)photosArray initialPageIndex:(NSUInteger)initialPageIndex delegate:(id<IDMPhotoBrowserDelegate>)delegate{
    [self showPhotoBrowser:viewController photos:photosArray initialPageIndex:initialPageIndex animatedFromView:nil scaleImage:nil delegate:delegate];
}
+ (void)showPhotoBrowser:(UIViewController *)viewController photos:(NSArray<IDMPhoto *> *)photosArray initialPageIndex:(NSUInteger)initialPageIndex animatedFromView:(UIView *)animatedFromView scaleImage:(UIImage *)scaleImage delegate:(id<IDMPhotoBrowserDelegate>)delegate{
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photosArray animatedFromView:animatedFromView];
    browser.delegate = delegate;
    browser.displayActionButton = NO;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
    browser.usePopAnimation = YES;
    browser.scaleImage = scaleImage;
    browser.autoHideInterface = NO;
    browser.forceHideStatusBar = NO;
    browser.disableVerticalSwipe = NO;
    browser.dismissOnTouch = YES;
    browser.displayDoneButton = NO;
    if (initialPageIndex>0) [browser setInitialPageIndex:initialPageIndex];
    if (viewController==nil) viewController = [MHControllerHelper topViewController];
    [viewController presentViewController:browser animated:YES completion:nil];
}


#pragma mark - ImagePicker
+ (void)fetchPhotosFromCamera:(UIViewController *)viewController allowCrop:(BOOL)allowCrop completion:(void (^)(UIImage *, id))completion{
    viewController = (viewController == nil)?[MHControllerHelper topViewController]:viewController;
    /// 检查授权
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示 ，这个只是针对 iOS8+
        [NSObject mh_showAlertViewWithTitle:@"无法访问你的相机" message:@"请在iPhone的“设置-隐私-相机”选项中，允许轻空访问你相机" confirmTitle:@"设置" cancelTitle:@"取消" confirmAction:^{
            [self accessApplicationSetting:NO];
        } cancelAction:NULL];
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self fetchPhotosFromCamera:viewController allowCrop:allowCrop completion:completion];
                    });
                }
            }];
        } else {
            [self fetchPhotosFromCamera:viewController allowCrop:allowCrop completion:completion];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) {
        // 已被拒绝，没有相册权限，将无法保存拍的照片 这个只是针对 iOS8+
        [NSObject mh_showAlertViewWithTitle:@"无法访问你的相册" message:@"请在iPhone的“设置-隐私-相册”选项中，允许轻空访问你相册" confirmTitle:@"设置" cancelTitle:@"取消" confirmAction:^{
            [self accessApplicationSetting:YES];
        } cancelAction:NULL];
    } else if ([TZImageManager authorizationStatus] == 0) {
        // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self fetchPhotosFromCamera:viewController allowCrop:allowCrop completion:completion];
        }];
    } else {
        /// 访问相机
        // 提前定位
        [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
            st_location = location;
        } failureBlock:^(NSError *error) {
            st_location = nil;
        }];
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            // set appearance / 改变相册选择页的导航栏外观
            imagePicker.navigationBar.barTintColor = viewController.navigationController.navigationBar.barTintColor;
            imagePicker.navigationBar.tintColor = viewController.navigationController.navigationBar.tintColor;
            UIBarButtonItem *tzBarItem, *BarItem;
            if (iOS9Later) {
                tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
                BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
            } else {
                tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
                BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
            }
            NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
            [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];

            imagePicker.sourceType = sourceType;
            imagePicker.allowsEditing = allowCrop;
            if(iOS8Later) imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [viewController presentViewController:imagePicker animated:YES completion:nil];
        
            /// 要监听图片完成的代理
            [imagePicker setBk_didFinishPickingMediaBlock:^(UIImagePickerController *picker, NSDictionary *info) {
                [picker dismissViewControllerAnimated:YES completion:NULL];
                /// 获取到的图片
                UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
                if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
                /// 保存图片，获取到asset
                [[TZImageManager manager] savePhotoWithImage:image location:st_location completion:^(NSError *error){
                    if (!error) !completion?:completion(image,nil); /// 回调图片
                }];
            }];
            /// 监听用户取消的代理
            [imagePicker setBk_didCancelBlock:^(UIImagePickerController *picker){
                if ([picker isKindOfClass:[UIImagePickerController class]]) [picker dismissViewControllerAnimated:YES completion:NULL];
            }];
        } else {
            NSString *title = nil;
#if TARGET_IPHONE_SIMULATOR
            /// 模拟器
            title = @"模拟器中无法打开照相机,请在真机中使用";
#else
            /// 真机
            title = @"无法打开你的相机！";
#endif
            [NSObject mh_showAlertViewWithTitle:title message:nil confirmTitle:@"我知道了"];
        }
    }
}


+ (void)fetchPhotosFromAlbum:(UIViewController *)viewController maxImagesCount:(NSInteger)maxImagesCount allowCrop:(BOOL)allowCrop selectedAssets:(NSArray *)selecatedAssets completion:(void (^)(NSArray<UIImage *> *, NSArray *, BOOL, NSArray<NSDictionary *> *))completion cancel:(void (^)())cancel{
    
    /// show
    if (viewController==nil) viewController = [MHControllerHelper topViewController];
    
    /// imagePicker
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(maxImagesCount==0)?[self maxImagesCount]:maxImagesCount columnNumber:[self colunmNumber] delegate:nil];
    
    /// 多选才行
    if (maxImagesCount>1) {
        imagePicker.allowCrop = NO;
        if (selecatedAssets) imagePicker.selectedAssets = [NSMutableArray arrayWithArray:selecatedAssets];
    }else{
        imagePicker.allowCrop = allowCrop;
    }
    
    /// 配置configure
    [self configureImagePicker:imagePicker];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    imagePicker.didFinishPickingPhotosWithInfosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        /// 记录一下选择原图的状态
        [self configureSelectOriginalPhoto:isSelectOriginalPhoto];
        
        /// 回调出去
        !completion?:completion(photos,assets,isSelectOriginalPhoto,infos);
        
    };
    
    // viewController.presentingViewController
    [viewController presentViewController:imagePicker animated:YES completion:nil];
}

+ (void)previewPhotos:(UIViewController *)viewController maxImagesCount:(NSInteger)maxImagesCount selectedAssets:(NSArray *)selecatedAssets selectedPhotos:(NSMutableArray *)selectedPhotos currentIndex:(NSInteger)currentIndex completion:(void (^)(NSArray<UIImage *> *, NSArray *, BOOL, NSArray<NSDictionary *> *))completion cancel:(void (^)(void))cancel
{
    /// show
    if (viewController==nil) viewController = [MHControllerHelper topViewController];
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithSelectedAssets:selecatedAssets.mutableCopy selectedPhotos:selectedPhotos.mutableCopy index:currentIndex];
    imagePicker.maxImagesCount = (maxImagesCount<=0)?[self maxImagesCount]:maxImagesCount;
    imagePicker.allowCrop = NO;
    /// 配置configure
    [self configureImagePicker:imagePicker];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto){
        /// 记录一下选择原图的状态
        [self configureSelectOriginalPhoto:isSelectOriginalPhoto];
        /// 回调出去
        !completion?:completion(photos,assets,isSelectOriginalPhoto,nil);
    }];
    
    // viewController.presentingViewController
    [viewController presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - ImagePicker Helper
+ (void)configureImagePicker:(TZImagePickerController *)imagePicker
{
    imagePicker.minImagesCount = 0;
    imagePicker.allowPreview = YES;
    /// 完成按钮可点击
    imagePicker.alwaysEnableDoneBtn = YES;
    /// 这里需要判断一下
    if (imagePicker.allowCrop) {
        imagePicker.allowPickingOriginalPhoto = NO;
    }else{
        imagePicker.allowPickingOriginalPhoto = YES;
    }

    /// system defalut configure
    imagePicker.isSelectOriginalPhoto = [self isSelectOriginalPhoto];
    
    /// 不能选择视频
    imagePicker.allowPickingVideo = NO;
    //// 是否需要圆形裁剪
    imagePicker.needCircleCrop = NO;
    /// 圆形裁剪size
    imagePicker.circleCropRadius = (MH_SCREEN_MIN_LENGTH - 60);
    /// 配置cropView
    imagePicker.cropViewSettingBlock = ^(UIView *cropView) {
        cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        cropView.layer.borderWidth = .5;
    };
    NSInteger left = 0;
    NSInteger widthHeight = MH_SCREEN_WIDTH - 2 * left;
    NSInteger top = (MH_SCREEN_HEIGHT - widthHeight) / 2;
    /// 裁剪尺寸
    imagePicker.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
}

+ (void)fetchOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion{
    /// 获取原图
    [[TZImageManager manager] getOriginalPhotoWithAsset:asset newCompletion:completion];
}


//// 访问设置 isAblum 相册Or相机
+ (void) accessApplicationSetting:(BOOL)isAblum{
    if (iOS8Later) {
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            [NSObject mh_showAlertViewWithTitle:@"十分抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" confirmTitle:@"确定"];
        }
    }
}

+ (BOOL)isSelectOriginalPhoto{
    return st_isSelectOriginalPhoto;
}

+ (void)configureSelectOriginalPhoto:(BOOL)selected{
    st_isSelectOriginalPhoto = selected;
}

/// 多少列
+ (NSInteger)colunmNumber{
    return (MH_IS_IPHONE_5||MH_IS_IPHONE_4_OR_LESS)?3:4;
}

/// 允许最大选择
+ (NSInteger)maxImagesCount{
    return MHMaxImagesCount;
}

@end
