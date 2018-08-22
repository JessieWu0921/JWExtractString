//
//  ViewController.m
//  JWExtractString
//
//  Created by JessieWu on 2018/8/13.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Empty.h"
#import "UIView+CornerRaduis.h"
#import "JWFamilyNameTool.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UIView *redView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self btnConfig];
    [self resetUpBtn:@"" name:@"司马懿"];
    
    self.headerImageView.radius = 6.0f;
    [self.headerImageView setupCornerRadius];
    
    self.redView.radius = 10.0f;
    [self.redView setupCornerRadius];
}

#pragma mark - UI
- (void)btnConfig {
    self.headerBtn.userInteractionEnabled = NO;
  
    /*** 避免圆角带来的离屏渲染 ***/
    
    //1. 修改图层遮罩mask 但依然无法规避掉离屏渲染
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.headerBtn.bounds cornerRadius:30.0f];
//    maskLayer.path = path.CGPath;
//    self.headerBtn.layer.mask = maskLayer; //mask设置并不会消除离屏渲染
    
    //2. 组合图层 (不会引起离屏渲染）
    self.headerBtn.radius = 30.0f;
    [self.headerBtn setupCornerRadius];
    
    //3. ios9.0及以上
//    self.headerBtn.layer.backgroundColor = [UIColor blueColor].CGColor;
//    self.headerBtn.layer.cornerRadius = 30.0f;
//
//    self.headerBtn.imageView.layer.cornerRadius = 30.0f;
}

- (void)setupImgView {
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)resetImage:(UIImage *)image {
    [self.headerBtn setBackgroundColor:[UIColor clearColor]];
    CGRect rect = self.headerBtn.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:30.0f];
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [image drawInRect:rect]; //这里会消耗CPU 并不是很推荐这个方法
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.headerBtn setImage:img forState:UIControlStateNormal];
}

- (void)resetUpBtn:(NSString *)url name:(NSString *)name {
    if (!url.isEmpty) {
//        NSURL *urlImage = [NSURL URLWithString:url];
//        NSData *imgData = [NSData dataWithContentsOfURL:urlImage];
//        UIImage *img = [UIImage imageWithData:imgData];
//        [self.headerBtn setImage:img forState:UIControlStateNormal];
        //test
        [self.headerBtn setImage:[UIImage imageNamed:@"hats"] forState:UIControlStateNormal];
    } else if (![name isEmpty]) {
//        NSString *familyName = [self extractNameString:name];
        NSString *familyName = [[JWFamilyNameTool share] findName:name type:FindLastName];
        [self.headerBtn setTitle:familyName forState:UIControlStateNormal];
    }
}

#pragma mark - private methods
- (void)testExtractString {
//    NSString *extractString = [self extractNameString:@" "];
//    NSLog(@"extract string: %@", extractString);
}

- (BOOL)checkiOS9Version {
    NSString *version = [UIDevice currentDevice].systemVersion;
    NSString *string = [version substringWithRange:NSMakeRange(0, 1)];
    if ([string integerValue] >= 9) {
        return YES;
    }
    return NO;
}

@end
