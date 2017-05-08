//
//  CropImageViewController.h
//  ImageTailor
//
//  Created by yinyu on 15/10/10.
//  Copyright © 2015年 yinyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^passImageBlock)(UIImage *cropImage);

@interface CropImageViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (nonatomic ,copy)passImageBlock  imageInfoBlock;




/**
 *  在此数组中选取图片
 *  proportionArr = @[@0, @1, @(4.0/3.0), @(3.0/4.0), @(16.0/9.0), @(9.0/16.0)]
 */
@property (nonatomic, assign)NSInteger aspectRatioIndex;//宽高比

@end
