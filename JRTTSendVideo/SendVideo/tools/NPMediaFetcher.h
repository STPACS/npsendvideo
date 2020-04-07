//
//  NPMediaFetcher.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+NPMediaJurisdiction.h"
NS_ASSUME_NONNULL_BEGIN

#define NPMEDIAASSET_CUSTOMSIZE CGSizeMake(2000, 2000)  //大图限定的尺寸

#define NPMEDIAASSET_THUMBNAILSIZE CGSizeMake(250, 250)  //缩略图限定的尺寸

#define LimitVideoTime 115.0f  //获取指定时长范围的视频

#define MACRO_COLOR_HEX_ALPHA(hexValue, alpha) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha]
#define MACRO_COLOR_HEX(hexValue) MACRO_COLOR_HEX_ALPHA(hexValue, 1.0)

@class NPMediaAsset;
@protocol NPProtocolMediaAsset <NSObject>

@optional

/**
 *  选中图片的自定义资源集合的回调
 *
 *  @param assets 自定义资源集合
 */
- (void)fetchAssets:(NSArray <NPMediaAsset *> *)assets;

//同步获取图片数据 images + loading + end + callback
/**
 *  选中图片集合的回调
 *
 *  @param images 图片集合
 */
- (void)fetchImages:(NSArray <UIImage *> *)images;

@end

/**
 *  media类型枚举
 */
typedef NS_ENUM(NSUInteger, NPMediaType) {
    /**
     *  未知类型（默认）
     */
    NPMediaTypeUnknow = 0,
    /**
     *  图片类型
     */
    NPMediaTypePhoto = 1,
    /**
     *  视频类型
     */
    NPMediaTypeVideo = 2,
    /**
     *  音频类型
     */
    NPMediaTypeAudio = 3,
};

#pragma mark - NPMediaAsset
@interface NPMediaAsset : NSObject

@property (nonatomic, assign) BOOL selected;//是否已被选中
@property (nonatomic, assign) BOOL origion;//是否应显示原尺寸图片

@property (nonatomic, strong) PHAsset *asset;//元数据资源
@property (nonatomic, assign) NPMediaType mediaType;//meida 类型 video image 等

///大小由宏定义
@property (nonatomic, strong) UIImage *imageClear;//清晰图（原尺寸图片或者是大图{2000, 200s0}）
@property (nonatomic, strong) UIImage *imageThumbnail;//缩略图{250, 250}

@property (nonatomic, strong) NSURL *remoteMediaURL;//用于获取远程资源的URL
@property (nonatomic, strong) NSString *clearPath;//保存到本地的清晰图的路径

/**
 *  获取缩略图
 *
 *  @param synchronous 是否同步
 *  @param handler     图片回调
 */
- (void)fetchThumbnailImageSynchronous:(BOOL)synchronous handler:(void (^)(UIImage *image))handler;

/**
 *  获取原尺寸图
 *
 *  @param synchronous 是否同步
 *  @param handler     图片回调
 */
- (void)fetchOrigionImageSynchronous:(BOOL)synchronous handler:(void (^)(UIImage *image))handler;

@end

#pragma mark - NPMediaAssetCollection
@interface NPMediaAssetCollection : NSObject

@property (nonatomic, strong) NSArray <NPMediaAsset *>* mediaAssetArray;//数据载体
@property (nonatomic, strong) PHAssetCollection *assetCollection;//相册的载体
@property (nonatomic, strong) NSString *title;//相册的title
@property (nonatomic, strong) NPMediaAsset *coverAssset;//封面资源 默认是 assetMArray 首个元素

/**
 *  自定义封面资源
 *
 *  @param mediaAsset 自定义的封面资源
 *  @param handler    回调所得到的封面图
 */
- (void)customCoverWithMediaAsset:(NPMediaAsset *)mediaAsset withCoverHandler:(void(^)(UIImage *image))handler;

/**
 *  封面图的回调
 *
 *  @param handler 回调所得到的封面图
 */
- (void)coverHandler:(void(^)(UIImage *image))handler;

@end

@interface NPMediaFetcher : NSObject
//扩展  获取视频  以及  特定音频的资源组合
//获取所需要的资源集合的集合

//获取最普通的资源集合
+ (NSMutableArray <NPMediaAssetCollection *> *)fetchAssetCollection;

//获取拥有所有图片的胶卷集合
//+ (NSArray <PHAsset *> *)allImagesAssets;

//获取拥有所有视频的集合
+ (NSArray <PHAsset *> *)allVideosAssets;

//获取视频图片显示
+ (void)getVideoImage:(PHAsset *)asset handler:(void(^)(UIImage *origion))handler;

//获取视频URL、时长信息
+ (void)getVideoUrlWithTime:(PHAsset *)assat handler:(void(^)(NSURL *url,NSString *time))handler;

//获取视频第几帧截图
+ (UIImage *)getVideoPreViewImage:(NSURL *)url timeValue:(CMTime)timeValue;


#pragma mark - Fetch Picture

/**
 *  获取目标资源的缩略图 size为NPMEDIAASSET_THUMBNAILSIZE
 *
 *  @param mediaAsset  目标资源
 *  @param synchronous 是否同步获取
 *  @param handler     返回图片的block
 *
 *  @return 资源ID
 */
+ (int32_t)fetchThumbnailWithAsset:(PHAsset *)mediaAsset synchronous:(BOOL)synchronous handler:(void(^)(UIImage *thumbnail))handler ;

/**
 *  获取目标资源的原尺寸图
 *
 *  @param mediaAsset  目标资源
 *  @param synchronous 是否同步获取
 *  @param handler     返回图片的block
 *
 *  @return 资源ID
 */
+ (int32_t)fetchOrigionWith:(PHAsset *)mediaAsset synchronous:(BOOL)synchronous handler:(void(^)(UIImage *origion))handler;

/**
 *  获取目标资源的图 自定义size
 *
 *  @param mediaAsset  目标资源
 *  @param costumSize  自定义size
 *  @param synchronous 是否同步获取
 *  @param handler     返回图片的block
 *
 *  @return 资源ID
 */
+ (int32_t)fetchImageWithAsset:(PHAsset *)mediaAsset costumSize:(CGSize)customSize synchronous:(BOOL)synchronous handler:(void(^)(UIImage *origion))handler;

/**
 *  获取目标资源的原尺寸图
 *
 *  @param asset       目标资源
 *  @param synchronous 是否同步获取
 *  @param handler      data形式 图片方向 图片的详情info
 *
 *  @return 资源ID
 */
+ (int32_t)fetchImageWithAsset:(PHAsset *)asset synchronous:(BOOL)synchronous handler:(void (^)(NSData *  imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary *  info))handler;

#pragma mark - Fetch Video
//+ (int32_t)fetchVideoWith:(PHAsset *)asset


#pragma mark - Fetch Audio

@end

NS_ASSUME_NONNULL_END
