//
//  ViewController.m
//  JWExtractString
//
//  Created by JessieWu on 2018/8/13.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Empty.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self testExtractString];
//    [self setupImgView];
    [self uiConfig];
    [self resetUpBtn:@" " name:@"欧阳振华"];
}

#pragma mark - UI
- (void)uiConfig {
    self.headerBtn.userInteractionEnabled = NO;
    self.headerBtn.backgroundColor = [UIColor clearColor];
  
    /*** 避免圆角带来的离屏渲染 ***/
    
    //1. 修改图层遮罩mask 但依然无法规避掉离屏渲染
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.headerBtn.bounds cornerRadius:30.0f];
//    maskLayer.path = path.CGPath;
//    self.headerBtn.layer.mask = maskLayer; //mask设置并不会消除离屏渲染
    
    //2. 组合图层 (不会引起离屏渲染）
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.headerBtn.bounds;
    layer.fillColor = self.headerBtn.superview.backgroundColor.CGColor;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.headerBtn.bounds cornerRadius:30.0f];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:self.headerBtn.bounds];
    
    [toPath appendPath:path];
    layer.fillRule = kCAFillRuleEvenOdd;
    
    layer.path = toPath.CGPath;
    
    self.headerBtn.layer.backgroundColor = [UIColor blueColor].CGColor;
    [self.headerBtn.layer addSublayer:layer];
    
    //3. ios9.0及以上
    self.headerBtn.layer.backgroundColor = [UIColor blueColor].CGColor;
    self.headerBtn.layer.cornerRadius = 30.0f;

    self.headerBtn.imageView.layer.cornerRadius = 30.0f;
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
        NSString *familyName = [self extractNameString:name];
        [self.headerBtn setTitle:familyName forState:UIControlStateNormal];
    }
}

#pragma mark - private methods
- (void)testExtractString {
    NSString *extractString = [self extractNameString:@" "];
    NSLog(@"extract string: %@", extractString);
}

- (NSString *)extractNameString:(NSString *)string {
    NSString *nameString = nil;
    
    if (string.length > 0) {
        
        nameString = [string substringWithRange:NSMakeRange(0, 1)];
        NSString *matchString = @"^[\u4e00-\u9fa5]+$";
        NSString *matchEnString = @"^[a-zA-Z]+";
        NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchString];
        NSPredicate *matchEnPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchEnString];
        BOOL isMatch = [matchPredicate evaluateWithObject:string];
        BOOL matchEn = [matchEnPredicate evaluateWithObject:string];
        
        if (isMatch) {
            if (string.length < 3) {
                nameString = [string substringWithRange:NSMakeRange(0, 1)];
            } else {
                NSString *familyString = [string substringWithRange:NSMakeRange(0, 2)];
                NSSet *twoCharactors = [self twoCharactorFamilyName];
                if ([twoCharactors containsObject:familyString]) {
                    nameString = familyString;
                }
            }
        } else if (matchEn) {
            nameString = [nameString uppercaseString];
        }
    }
    
    return nameString;
}

- (NSSet<NSString *> *)twoCharactorFamilyName {
    
    NSString *string = @"欧阳、太史、端木、上官、司马、东方、独孤、南宫、万俟、闻人、夏侯、诸葛、尉迟、公羊、赫连、澹台、皇甫、宗政、濮阳、公冶、太叔、申屠、公孙、慕容、仲孙、钟离、长孙、宇文、司徒、鲜于、司空、闾丘、子车、亓官、司寇、巫马、公西、颛孙、壤驷、公良、漆雕、乐正、宰父、谷梁、拓跋、夹谷、轩辕、令狐、段干、百里、呼延、东郭、南门、羊舌、微生、公户、公玉、公仪、梁丘、公仲、公上、公门、公山、公坚、左丘、公伯、西门、公祖、第五、公乘、贯丘、公皙、南荣、东里、东宫、仲长、子书、子桑、即墨、达奚、褚师、吴铭";
    NSArray *familyNames = [string componentsSeparatedByString:@"、"];
    NSSet *familySet = [[NSSet alloc] initWithArray:familyNames];
    
    return familySet;
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
