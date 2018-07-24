
//
//  UIImageView+sdWebImage.m
//  yijianjieqian
//
//  Created by zhph on 2018/3/27.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import "UIImageView+sdWebImage.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

@implementation UIImageView (sdWebImage)

- (void)downloadImage:(NSString *)url placeholder:(NSString *)imageName {
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageRefreshCached];
}

- (void)downloadImage:(NSString *)url
          placeholder:(NSString *)imageName
              success:(DownloadImageSuccessBlock)success
               failed:(DownloadImageFailedBlock)failed
             progress:(DownloadImageProgressBlock)progress {
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        progress(receivedSize * 1.0 / expectedSize);
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            failed(error);
        } else {
            self.image = image;
            success(image);
        }
    }];
}

- (void)downloadImageWithProgress:(NSString *)url
          placeholder:(NSString *)imageName
              success:(DownloadImageSuccessBlock)success
               failed:(DownloadImageFailedBlock)failed{
    
    __block UIActivityIndicatorView * pv;
    __weak UIImageView * weakImageView = self;
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRefreshCached|SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (!pv) {
                    [weakImageView addSubview:pv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)]];
                    pv.size=CGSizeMake(20, 20);
                    pv.left= (weakImageView.width-pv.width)/2;
                    pv.top= (weakImageView.height-pv.height)/2;
                    __strong UIActivityIndicatorView *  IndicatorView = pv;
                    [IndicatorView startAnimating];
                }
            });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (error) {
            if (failed) {
                failed(error);
            }
        } else {
            self.image = image;
            if (success) {
                success(image);
            }
        }
        if (pv) {
            [pv stopAnimating];
            [pv removeFromSuperview];
        }
    }];
}

@end
