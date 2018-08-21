//
//  JWFamilyNameTool.h
//  JWExtractString
//
//  Created by JessieWu on 2018/8/20.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FindNameType){
    FindFamilyName,
    FindLastName
};

@interface JWFamilyNameTool : NSObject

+ (instancetype)share;

- (NSString *)findName:(NSString * _Nonnull)name type:(FindNameType)type;

@end
