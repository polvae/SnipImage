//
//  CropImageViewController.m
//  ImageTailor
//
//  Created by yinyu on 15/10/10.
//  Copyright © 2015年 yinyu. All rights reserved.
//

#import "CropImageViewController.h"
#import "TKImageView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define CROP_PROPORTION_IMAGE_WIDTH 30.0f
#define CROP_PROPORTION_IMAGE_SPACE 48.0f
#define CROP_PROPORTION_IMAGE_PADDING 20.0f

@interface CropImageViewController () {
    
    NSArray *proportionImageNameArr;
    NSArray *proportionImageNameHLArr;
    NSArray *proportionArr;
    NSMutableArray *proportionBtnArr;
    CGFloat currentProportion;

}
@property (weak, nonatomic) IBOutlet TKImageView *tkImageView;

@end

@implementation CropImageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpTKImageView];
    currentProportion = 0;
    _tkImageView.scaleFactor = 0.6;
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}
- (void)setUpTKImageView {
    
    _tkImageView.toCropImage = _image;
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = NO;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor redColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 3;
    _tkImageView.cropAreaBorderLineWidth = 2;
    _tkImageView.cropAreaMidLineWidth = 40;
    _tkImageView.showMidLines = YES;
    _tkImageView.cropAreaMidLineHeight = 3;
    _tkImageView.cropAreaMidLineColor = [UIColor redColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 2;

    
    proportionArr = @[@0, @1, @(4.0/3.0), @(3.0/4.0), @(16.0/9.0), @(9.0/16.0)];
    
    //不晓得为啥要这么写
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(proportionArr.count >_aspectRatioIndex){
            currentProportion = [proportionArr[_aspectRatioIndex] floatValue];
            _tkImageView.cropAspectRatio = currentProportion;
        }
    });
    
    

}

- (void)setUpCropProportionViewWithIndex:(NSInteger)index {
    proportionBtnArr = [NSMutableArray array];
    proportionArr = @[@0, @1, @(4.0/3.0), @(3.0/4.0), @(16.0/9.0), @(9.0/16.0)];
    
    currentProportion = [proportionArr[index] floatValue];
    _tkImageView.cropAspectRatio = currentProportion;
}

#pragma mark - IBActions
- (IBAction)clickCancelBtn:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated: YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)clickOkBtn:(id)sender {
    UIImage *cropImage =  [_tkImageView currentCroppedImage];
    if (_imageInfoBlock) {
        _imageInfoBlock(cropImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 是否支持自动转屏
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
