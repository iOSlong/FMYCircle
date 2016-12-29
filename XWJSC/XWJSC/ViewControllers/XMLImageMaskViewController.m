//
//  XMLImageMaskViewController.m
//  XWJSC
//
//  Created by xuewu.long on 16/12/29.
//  Copyright © 2016年 fmylove. All rights reserved.
//
/*
 图片滤镜效果处理：
 https://www.raywenderlich.com/76285/beginning-core-image-swift
 http://blog.csdn.net/u011369424/article/details/52862560
 
*/

#import "XMLImageMaskViewController.h"

@interface XMLImageMaskViewController ()

@property (nonatomic, strong) UIImageView *testImage;

@end

@implementation XMLImageMaskViewController

- (UIImageView *)testImage {
    if (!_testImage) {
        _testImage = [[UIImageView alloc] initWithFrame:CGRectMake(k_SpanLeft, k_SpanLeft, SCREENW - 2 * k_SpanLeft, SCREENW*0.6)];
        
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.frame = _testImage.frame;
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint   = CGPointMake(_testImage.width, _testImage.height);
//        gradientLayer.colors = @[[UIColor lightGrayColor],[UIColor purpleColor]];
//        //添加渐变层到view图层上
//        //将原来的图标图层或者文字图层添加到渐变层上
//        [gradientLayer addSublayer:_testImage.layer];
//        //由于imageView.layer从self.view.layer中移动到渐变层gradientLayer中，所以坐标改变了需要重新调整。
//        _testImage.layer.frame = _testImage.layer.bounds;
//        
//        [self.view.layer addSublayer:gradientLayer];


    }
    return _testImage;
}

- (void)testCodeCIImage {
    NSString *filterName = @"CIGaussianBlur";
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithData:UIImagePNGRepresentation([UIImage imageNamed:@"moonStarNight"])];
    CIFilter *filter = [CIFilter filterWithName:@"CICircularWrap"];
    [filter setValue:image forKey:kCIInputImageKey];
//    NSString *inputRadius = [NSString stringWithFormat:@"%.2u",arc4random()%2];
//    [filter setValue:@1.5f forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    
    self.testImage.image = blurImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
//    [self.view addSubview:self.testImage];
//    self.testImage.image = [UIImage imageNamed:@"moonStarNight"];
    
    UIImage *image = [self maskImage:[UIImage imageNamed:@"moonStarNight"] withMask:[UIImage imageNamed:@"moonStarNight"]];
    self.testImage.image = image;
    [self.view addSubview:self.testImage];
    
    [self performSelector:@selector(testCodeCIImage) withObject:self afterDelay:5];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self performSelector:@selector(testCodeCIImage) withObject:self afterDelay:1];
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
}






@end
