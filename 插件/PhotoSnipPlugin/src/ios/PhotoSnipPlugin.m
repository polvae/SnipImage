/********* PhotoSnipPlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "CropImageViewController.h"

typedef NS_ENUM(NSInteger, pickImageType) {
    PhotoLibrarySource,//默认从0开始
    CameraSource,
    PhotosAlbumSource,
};

@interface PhotoSnipPlugin : CDVPlugin <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    // Member variables go here.
}
/**
 *  在此数组中选取图片
 *  proportionArr = @[@0, @1, @(4.0/3.0), @(3.0/4.0), @(16.0/9.0), @(9.0/16.0)]
 */
@property (nonatomic, assign)NSInteger aspectRatioIndex;//宽高比

@property (nonatomic, strong)CDVInvokedUrlCommand* command;
@property (nonatomic, copy)NSString *echo;

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end

@implementation PhotoSnipPlugin

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    _command = command;
    CDVPluginResult* pluginResult = nil;
    _echo = [command.arguments objectAtIndex:0];
    
    if (_echo != nil && [_echo length] > 0) {
        _aspectRatioIndex = [[command.arguments lastObject] integerValue];
        if ([_echo isEqualToString:@"camera"]) {
            [self pickImageFromCameraWithSouceType:CameraSource];
        }else if([_echo isEqualToString:@"photo"]){
            [self pickImageFromCameraWithSouceType:PhotoLibrarySource];
        }
        
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

-(void)pickImageFromCameraWithSouceType:(pickImageType)type{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    if (type == CameraSource) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    picker.delegate = self;
    [self.viewController presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *toCropImage = info[UIImagePickerControllerOriginalImage];
//    [picker dismissViewControllerAnimated: YES completion: NULL];
    [self cropImage: toCropImage andController:picker];
}

- (void)cropImage: (UIImage *)image  andController:(UIViewController *)pickerCtl{
    
    CropImageViewController *cropImageViewController = [[CropImageViewController alloc]initWithNibName:@"CropImageViewController" bundle:nil];
    cropImageViewController.image = image;
    cropImageViewController.aspectRatioIndex = _aspectRatioIndex;
    cropImageViewController.imageInfoBlock = ^(UIImage *cropImage){
        NSLog(@"%@",cropImage);
        [self storeSnipImage:cropImage];
    };
    [pickerCtl presentViewController:cropImageViewController animated:YES completion:nil];
    //    [self.navigationController pushViewController: cropImageViewController animated: YES];
    
}

//当获取图片后进行回调方法
- (void)exChangeInfoWithWebWith:(NSString *)storeImagePath{
    __weak __typeof(&*self)weakSelf =self;
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:storeImagePath];
    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:weakSelf.command.callbackId];
    [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
}
//将图片进行本地存储
- (void)storeSnipImage:(UIImage *)snipImage{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/SnipImageCache", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![fileManager fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //先删除此SnipImageCache文件夹下面的所有内容
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:createPath error:NULL];
    NSEnumerator *enumerator = [contents objectEnumerator];
    
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        //        if ([[filename pathExtension] isEqualToString:@"png"]) {
        [fileManager removeItemAtPath:[createPath stringByAppendingPathComponent:filename] error:NULL];
        //        }
    }
    //把图片直接保存到指定的路径(不能同样名称直接覆盖，不然网页端有问题，必须不同名称)
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];//转为字符型
    
    NSString *imageName = [NSString stringWithFormat:@"/%@.png",timeString];
    NSString *imagePath = [createPath stringByAppendingString:imageName];
    NSLog(@"%@",imageName);
    [UIImagePNGRepresentation(snipImage) writeToFile:imagePath atomically:YES];
    [self exChangeInfoWithWebWith:imagePath];
    
}

@end

