//
//  NPMediaFetcher.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPMediaFetcher.h"

@implementation NPMediaAsset
#pragma mark - NPMediaAsset
-(void)setAsset:(PHAsset *)asset {
    _asset = [asset isKindOfClass:[PHAsset class]]?asset:nil;
}

- (void)fetchThumbnailImageSynchronous:(BOOL)synchronous handler:(void (^)(UIImage *image))handler {
    [NPMediaFetcher fetchThumbnailWithAsset:_asset  synchronous:synchronous handler:^(UIImage *thumbnail) {
        self->_imageThumbnail = thumbnail;
        if (handler) {handler(thumbnail);};
    }];
}

- (void)fetchOrigionImageSynchronous:(BOOL)synchronous handler:(void (^)(UIImage *image))handler {
    [NPMediaFetcher fetchOrigionWith:_asset synchronous:synchronous handler:^(UIImage *origion) {
        if (handler) {handler(origion);};
    }];
}

@end

#pragma mark - NPMediaAssetCollection
@implementation NPMediaAssetCollection

- (void)customCoverWithMediaAsset:(NPMediaAsset *)mediaAsset withCoverHandler:(void(^)(UIImage *image))handler {
    if ([mediaAsset isKindOfClass:[NPMediaAsset class]]) {
        _coverAssset = mediaAsset;
        if (handler) {
            [NPMediaFetcher fetchThumbnailWithAsset:mediaAsset.asset synchronous:false handler:^(UIImage *thumbnail) {
                handler(thumbnail);
            }];
        }
    }
}

- (void)coverHandler:(void(^)(UIImage *image))handler {
    [self customCoverWithMediaAsset:self.coverAssset withCoverHandler:handler];
}

#pragma mark - Accessor
- (NSArray <NPMediaAsset *>*)mediaAssetArray {
    if (!_mediaAssetArray) {
        _mediaAssetArray = [NSArray array];
    }
    return _mediaAssetArray;
}

- (NPMediaAsset *)coverAssset {
    if (!_coverAssset) {
        if (self.mediaAssetArray.count > 0) {
            _coverAssset = self.mediaAssetArray[0];
        }
    }
    return _coverAssset;
}

@end

#pragma mark - NPMediaPicker
@implementation NPMediaFetcher

#pragma mark - Fetch Picture
+ (NSMutableArray <NPMediaAssetCollection *> *)fetchAssetCollection {
    //智能相册
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    //按照 PHAssetCollection 的startDate 升序排序
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:true]];
    
    /*
     PHAssetCollectionTypeAlbum PHAssetCollectionSubtypeAlbumRegular  :qq 微博  我的相簿（自定义的相簿）
     PHAssetCollectionTypeSmartAlbum PHAssetCollectionSubtypeSmartAlbumUserLibrary 胶卷中的图（包含video）
     PHAssetCollectionTypeSmartAlbum PHAssetCollectionSubtypeAlbumRegular 智能相簿（包含image video audio类型 ）
     */
    
    PHFetchResult *result_smartAlbums = [PHAssetCollection
                                         fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                         subtype:PHAssetCollectionSubtypeAlbumRegular
                                         options:fetchOptions];
    
    NSMutableArray <NPMediaAssetCollection *>* mmediaAssetArrayCollection = [[self class] universalMediaAssetCollectionWith:result_smartAlbums];
    return mmediaAssetArrayCollection;
}

+ ( NSMutableArray <NPMediaAssetCollection *>*)universalMediaAssetCollectionWith:(PHFetchResult *)result_smartAlbums {
    NSMutableArray <NPMediaAssetCollection *>* mmediaAssetArrayCollection = [NSMutableArray array];
    
    for (PHAssetCollection *assetCollection in result_smartAlbums) {
        PHFetchResult<PHAsset *> *fetchResoult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[[self class] configImageOptions:PHAssetMediaTypeImage]];
        
        //过滤无图片的fetchResoult 配置数据源
        if (fetchResoult.count) {
            
            NPMediaAssetCollection *mediaAssetCollection = [[NPMediaAssetCollection alloc] init];
            mediaAssetCollection.assetCollection = assetCollection;
            mediaAssetCollection.title = assetCollection.localizedTitle;
            [mmediaAssetArrayCollection addObject:mediaAssetCollection];
            
            NSMutableArray <NPMediaAsset *>*mmediaAssetArray = [NSMutableArray array];
            for (PHAsset *asset in fetchResoult) {
                NPMediaAsset *object = [[NPMediaAsset alloc] init];
                object.asset = asset;
                [mmediaAssetArray addObject:object];
            }
            
            mediaAssetCollection.mediaAssetArray = [NSArray arrayWithArray:mmediaAssetArray];
        }
    }
    return mmediaAssetArrayCollection;
}

+ (NSArray <PHAsset *> *)allVideosAssets {
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
       //按照 PHAssetCollection 的startDate 升序排序
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:true]];
   
    PHFetchResult *result_smartAlbums = [PHAssetCollection
                                            fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                            subtype:PHAssetCollectionSubtypeSmartAlbumVideos
                                            options:fetchOptions];
    
     NSMutableArray <PHAsset *>*mmediaAssetArray = [NSMutableArray array];

       for (PHAssetCollection *assetCollection in result_smartAlbums) {
           PHFetchResult<PHAsset *> *fetchResoult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[[self class] configImageOptions:PHAssetMediaTypeVideo]];
           
           if (fetchResoult.count) {
               
               for (PHAsset *asset in fetchResoult) {
                   NSLog(@"时长：%f",asset.duration );
                   if (asset.duration < LimitVideoTime) {
                       [mmediaAssetArray addObject:asset];
                   }
               }
           }
       }
       return mmediaAssetArray;
}


//+ (NSArray <NPMediaAssetCollection *> *)customMediaAssetCollectionOnlyImageAsset {
//
//}
//+ (NSArray <NPMediaAssetCollection *> *)customMediaAssetCollectionOnlyVideoAsset {
//
//}
////获取个人创建的相册的集合<也有视频/图片类型>
//+ (NSArray <NPMediaAssetCollection *> *)customMediaAssetCollectionOnlyImageHybirdVideoAsset {
//    NSMutableArray <NPMediaAssetCollection *>* mmediaAssetArrayCollection = [NSMutableArray array];
//    PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    for (PHAssetCollection *assetCollection in customCollections) {
//        PHFetchResult<PHAsset *> *fetchResoult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[[self class] configImageOptions]];
//
//        //过滤无图片的fetchResoult 配置数据源
//        if (fetchResoult.count) {
//            NPMediaAssetCollection *mediaAssetCollection = [[NPMediaAssetCollection alloc] init];
//            mediaAssetCollection.assetCollection = assetCollection;
//            mediaAssetCollection.title = assetCollection.localizedTitle;
//            [mmediaAssetArrayCollection addObject:mediaAssetCollection];
//            NSMutableArray <NPMediaAsset *>*mmediaAssetArray = [NSMutableArray array];
//            for (PHAsset *asset in fetchResoult) {
//                NPMediaAsset *object = [[NPMediaAsset alloc] init];
//                object.asset = asset;
//                [mmediaAssetArray addObject:object];
//            }
//            mediaAssetCollection.mediaAssetArray = [NSArray arrayWithArray:mmediaAssetArray];
//        }
//    }
//    return mmediaAssetArrayCollection;
//}
//

/*
 //  用户自定义的资源
 PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
 for (PHAssetCollection *collection in customCollections) {
 PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
 [nameArr addObject:collection.localizedTitle];
 [assetArr addObject:assets];
 }
 */



+ (int32_t)fetchThumbnailWithAsset:(PHAsset *)mediaAsset synchronous:(BOOL)synchronous handler:(void(^)(UIImage *thumbnail))handler {
    CGSize targetSize = NPMEDIAASSET_THUMBNAILSIZE;
    PHImageRequestID imageRequestID = [self fetchImageWithAsset:mediaAsset targetSize:targetSize synchronous:synchronous handler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (handler) {
            handler(result);
        }
    }];
    
    ///数据信息 仅限于本地图片
    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
    [mediaAsset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        //        contentEditingInput.mediaType
        //        contentEditingInput.mediaSubtypes
        //        contentEditingInput.location
        //        contentEditingInput.creationDate
        if (contentEditingInput.creationDate) {
            //创建日期
            NSDateFormatter *dataFormer = [[NSDateFormatter alloc] init];
            [dataFormer setDateStyle:NSDateFormatterNoStyle];
            [dataFormer stringFromDate:contentEditingInput.creationDate];
        }
        
        if (contentEditingInput.location) {
            //经纬度
            
        }
        
        CIImage *fullImage = [CIImage imageWithContentsOfURL:contentEditingInput.fullSizeImageURL];
        NSDictionary *nsdic = fullImage.properties;
        NSDictionary *originExif = nsdic[@"{Exif}"];
        
        // 镜头信息
        NSString *lensModel = [NSString stringWithFormat:@"设备型号:%@",originExif[(NSString *)kCGImagePropertyExifLensModel]];
        // 光圈系数
        NSString *fNumber = [NSString stringWithFormat:@"光圈系数:f/%@",originExif[(NSString *)kCGImagePropertyExifFNumber]];
        // 曝光时间
        NSString *exposureTime = [NSString stringWithFormat:@"曝光时间:f/%@",originExif[(NSString *)kCGImagePropertyExifExposureTime]];
        // 镜头焦距
        NSString *focalLength = [NSString stringWithFormat:@"镜头焦距:%@mm",originExif[(NSString *)kCGImagePropertyExifFocalLength]];
        // 日期和时间
        NSString *dataTime = [NSString stringWithFormat:@"数字化时间:%@",originExif[(NSString *)kCGImagePropertyExifDateTimeDigitized]];
        // ISO
        NSString *isoSpeedRatings = [NSString stringWithFormat:@"ISO:%@",[originExif[(NSString *)kCGImagePropertyExifISOSpeedRatings] firstObject]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", lensModel);
            NSLog(@"%@", fNumber);
            NSLog(@"%@", exposureTime);
            NSLog(@"%@", focalLength);
            NSLog(@"%@", dataTime);
            NSLog(@"%@", isoSpeedRatings);
        });
    }];
    
    return imageRequestID;
}

+ (int32_t)fetchOrigionWith:(PHAsset *)mediaAsset synchronous:(BOOL)synchronous handler:(void(^)(UIImage *origion))handler {
    CGSize targetSize = CGSizeMake(mediaAsset.pixelWidth, mediaAsset.pixelHeight);
    PHImageRequestID imageRequestID = [self fetchImageWithAsset:mediaAsset targetSize:targetSize synchronous:synchronous handler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (handler) {
            handler(result);
        }
    }];
    
    return imageRequestID;
}

+ (int32_t)fetchImageWithAsset:(PHAsset *)mediaAsset costumSize:(CGSize)customSize synchronous:(BOOL)synchronous handler:(void(^)(UIImage *image))handler {
    PHImageRequestID imageRequestID = [self fetchImageWithAsset:mediaAsset targetSize:customSize synchronous:synchronous handler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (handler) {
            handler(result);
        }
    }];
    return imageRequestID;
}

+ (int32_t)fetchImageWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize synchronous:(BOOL)synchronous handler:(void (^)(UIImage * _Nullable result, NSDictionary * _Nullable info))handler {
    //图片请求选项配置 同步异步配置
    PHImageRequestOptions *imageRequestOption = [self configImageRequestOption];
    if (synchronous) {
        //增加同步配置
        imageRequestOption = [self configSynchronousImageRequestOptionWith:imageRequestOption];
    }
    
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:imageRequestOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (handler) {
            handler(result, info);
        }
    }];
    return imageRequestID;
}

+ (int32_t)fetchImageWithAsset:(PHAsset *)asset synchronous:(BOOL)synchronous handler:(void (^)(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info))handler {
    //图片请求选项配置
    //图片请求选项配置 同步异步配置
    PHImageRequestOptions *imageRequestOption = [self configImageRequestOption];
    if (synchronous) {
        //同步配置
        imageRequestOption = [self configSynchronousImageRequestOptionWith:imageRequestOption];
    }
    
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageRequestOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (handler) {
            handler(imageData, dataUTI, orientation, info);
        }
    }];
    return imageRequestID;
}

#pragma mark - 配置
//过滤出image类型的资源
+ (PHFetchOptions *)configImageOptions:(PHAssetMediaType)mediaType {
    PHFetchOptions *fetchResoultOption = [[PHFetchOptions alloc] init];
    fetchResoultOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];//按照日期降序排序
    fetchResoultOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",mediaType];//过滤剩下照片类型
    return fetchResoultOption;
}

+ (PHImageRequestOptions *)configImageRequestOption {
    //图片请求选项配置
    PHImageRequestOptions *imageRequestOption = [[PHImageRequestOptions alloc] init];
    //图片版本:最新
    imageRequestOption.version = PHImageRequestOptionsVersionCurrent;
    //非同步
    imageRequestOption.synchronous = false;
    //图片交付模式:高质量格式
    imageRequestOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //图片请求模式:精确的
    imageRequestOption.resizeMode = PHImageRequestOptionsResizeModeExact;
    //用于对原始尺寸的图像进行裁剪，基于比例坐标。resizeMode 为 Exact 时有效。
    //  imageRequestOption.normalizedCropRect = CGRectMake(0, 0, 100, 100);
    return imageRequestOption;
}

//同步配置
+ (PHImageRequestOptions *)configSynchronousImageRequestOptionWith:(PHImageRequestOptions *)imageRequestOption {
    imageRequestOption.synchronous = true;
    return imageRequestOption;
}


//+ (void)fetchOrigionWith:(PHAsset *)mediaAsset handler:(void(^)(UIImage *origion, NSString *origionPath))handler {
//    CGSize targetSize = CGSizeMake(mediaAsset.pixelWidth, mediaAsset.pixelHeight);
////    if (targetSize.height <= 300 || targetSize.width <= 300) {
////        NSLog(@"< 300");
////    }
//    [self fetchImageWithAsset:mediaAsset targetSize:targetSize handler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        //写进file中
//        NSString *path = nil;
//        if ([info[@"PHImageFileURLKey"] isKindOfClass:[NSURL class]]) {
//            NSURL * fileUrl = info[@"PHImageFileURLKey"];
//
//            //存放在tmp中 可随时更换目录
//            path = [NSString stringWithFormat:@"%@/%@", [[self class] NP_filePath:NPSearchPathDirectoryTemporary fileName:@"NPFileStorage"], fileUrl.lastPathComponent];
//
//            //保存所在文件
//            if ([[self class] NP_fileExistsAtPath:path]) {
//                //文件已经存在
//                NSLog(@"文件已经存在");
//            } else {
//                if ([[self class] NP_createFolder:NPSearchPathDirectoryTemporary folderName:@"NPFileStorage"]) {
//                    @autoreleasepool {
//                        NSData *resultData = UIImagePNGRepresentation(result);
//                        if (![resultData writeToFile:path atomically:true]) {
//                            path = nil;
//                        } else {
//                            NSLog(@"创建成功");
//                        }
//                    }
//                } else {
//                    //创建失败 path 不存在
//                    path = nil;
//                }
//            }
//        }
//
//        UIImage *targetImage = nil;
//        if (!path) {
//            targetImage = result;
//        }
//
//        //二保存其一 因为:原图的缓存太大了,不能每次都加上原图
//        if (handler) {
//            handler(targetImage, path);
//        }
//    }];
//}


//    [[PHImageManager defaultManager] requestImageDataForAsset:mediaAsset.asset options:imageRequestOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//        UIImage *origion  = [UIImage imageWithData:imageData];
//
//        CGSize targetSize = [self size:origion.size adjustLargestUnit:150];
//        UIImage *thumbnail = [self image:origion byScalingToSize:targetSize];
////
//        mediaAsset.mediaType = NPMediaTypePhoto;
//        mediaAsset.thumbnail = thumbnail;
//        mediaAsset.origion = origion;
//        if (handler) {
//            handler(origion, origion);
//        }
//    }];


//+ (CGSize)size:(CGSize)size adjustLargestUnit:(CGFloat)largestUnit {
//    if (largestUnit == 0.0) {
//        return CGSizeZero;
//    } else if (size.height > 0) {
//        CGFloat scale = size.width / size.height;
//        CGFloat newWidth = 0.0;
//        CGFloat newHeight = 0.0;
//
//        if (scale > 1.0) {
//            //宽大于高
//            newWidth = largestUnit;
//            newHeight = largestUnit / scale;
//        } else {
//            //高大于宽
//            newWidth = largestUnit * scale;
//            newHeight = largestUnit;
//        }
//        return CGSizeMake(newWidth, newHeight);
//    }
//
//    return CGSizeZero;
//}

//+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
//    UIImage *sourceImage = image;
//    UIImage *newImage = nil;
//
//    UIGraphicsBeginImageContext(targetSize);
//
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.origin = CGPointZero;
//    thumbnailRect.size.width  = targetSize.width;
//    thumbnailRect.size.height = targetSize.height;
//
//    [sourceImage drawInRect:thumbnailRect];
//
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return newImage ;
//}

#pragma mark - Fetch Video
+ (int32_t)fetchVideoWith:(PHAsset *)asset synchronous:(BOOL)synchronous {
    PHVideoRequestOptions *videoRequsetOptions = [[PHVideoRequestOptions alloc] init];
    videoRequsetOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    videoRequsetOptions.networkAccessAllowed = false;
//  PHImageRequestID imageRequestID =
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequsetOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       
    }];
    
    if (synchronous) {
        //异步
        imageRequestID = [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequsetOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
        }];
    } else {
        //同步 使用信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        imageRequestID = [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequsetOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            dispatch_semaphore_signal(semaphore);
            
        }];
        //等待信号
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:videoRequsetOptions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        
    }];
    
    [[PHImageManager defaultManager] requestExportSessionForVideo:asset options:videoRequsetOptions exportPreset:@"" resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        
    }];
    
    return imageRequestID;
}

//获取视频图片显示
+ (void)getVideoImage:(PHAsset *)asset handler:(void (^)(UIImage * _Nonnull))handler {
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = NO;//YES 一定是同步    NO不一定是异步
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;//imageOptions.synchronous = NO的情况下最终决定是否是异步
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:NPMEDIAASSET_THUMBNAILSIZE contentMode:PHImageContentModeAspectFit options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        handler(result);
    }];
}

+ (void)getVideoUrlWithTime:(PHAsset *)assat handler:(void(^)(NSURL *url,NSString *time))handler {
    
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
           
            });
    };

    [[PHImageManager defaultManager] requestAVAssetForVideo:assat options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        NSURL *url = urlAsset.URL;
       
        dispatch_async(dispatch_get_main_queue(), ^{
            float videoDurationSeconds = CMTimeGetSeconds(urlAsset.duration);

            handler(url,[NSString stringWithFormat:@"%f",videoDurationSeconds]);
        });
    }];
}

//获取视频第一帧截图
//CMTimeMakeWithSeconds(0.0, 600)
+ (UIImage *)getVideoPreViewImage:(NSURL *)url timeValue:(CMTime)timeValue{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;

    gen.appliesPreferredTrackTransform = YES;
    CMTime time = timeValue;
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}
#pragma mark - Fetch Audio
@end
