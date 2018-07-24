//
//  UIImageView+sdWebImage.h
//  yijianjieqian
//
//  Created by zhph on 2018/3/27.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownloadImageSuccessBlock)(UIImage *image);
typedef void(^DownloadImageFailedBlock)(NSError *error);
typedef void(^DownloadImageProgressBlock)(CGFloat progress);

@interface UIImageView (sdWebImage)
/*加载图片*/
- (void)downloadImage:(NSString *)url placeholder:(NSString *)imageName;

/*加载图片 有进度显示*/
- (void)downloadImage:(NSString *)url
          placeholder:(NSString *)imageName
              success:(DownloadImageSuccessBlock)success
               failed:(DownloadImageFailedBlock)failed
             progress:(DownloadImageProgressBlock)progress;

/**
 加载网络图片

 @param url 图片链接
 @param imageName 水印名字
 @param success 成功
 @param failed 失败
 */
- (void)downloadImageWithProgress:(NSString *)url
                      placeholder:(NSString *)imageName
                          success:(DownloadImageSuccessBlock)success
                           failed:(DownloadImageFailedBlock)failed;
@end
