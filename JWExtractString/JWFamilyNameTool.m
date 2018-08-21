//
//  JWFamilyNameTool.m
//  JWExtractString
//
//  Created by JessieWu on 2018/8/20.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "JWFamilyNameTool.h"

@implementation JWFamilyNameTool

+ (instancetype)share {
    static JWFamilyNameTool *tool = nil;
    if (!tool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tool = [JWFamilyNameTool new];
        });
    }
    return tool;
}

- (NSString *)findName:(NSString * _Nonnull)name type:(FindNameType)type {
    switch (type) {
        case FindLastName:{
            return [self getLastName:name];
        }
            break;
        case FindFamilyName:{
            return [self getFamilyName:name];
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - private methods
- (NSString *)getFamilyName:(NSString *)name {
    NSString *familyName = nil;
    familyName = [name substringWithRange:NSMakeRange(0, 1)];
    if ([self matchZhString:name]) {
        if (name.length >= 3) {
            if ([self matchDoubleSurname:name]) {
                NSString *surname = [name substringWithRange:NSMakeRange(0, 2)];
                familyName = surname;
            }
        }
    } else if ([self matchEnString:name]) {
        //提取规则待定
        [familyName uppercaseString];
    }
    return familyName;
}

- (NSString *)getLastName:(NSString *)name {
    NSString *lastName = name;
    NSInteger length = name.length;
    if (length > 1) {
        lastName = [name substringWithRange:NSMakeRange(length - 2, 2)];
        if (length == 3 && [self matchZhString:name] && [self matchDoubleSurname:name]) {
            lastName = [name substringFromIndex:length - 1];
        }
        if ([self matchEnString:name]) {
            //提取规则待定
        }
    }
    return lastName;
}

- (BOOL)matchZhString:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\u4e00-\u9fa5]+$"];
    return [predicate evaluateWithObject:string];
}

- (BOOL)matchEnString:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z]+(\\s)*[a-zA-Z]+$"];
    return [predicate evaluateWithObject:string];
}

- (BOOL)matchDoubleSurname:(NSString *)name {
    NSSet *doubleSurnameSet = [self doubleSurnames];
    NSString *surname = [name substringWithRange:NSMakeRange(0, 2)];
    return [doubleSurnameSet containsObject:surname];
}
//复姓81个 来源百度
- (NSSet <NSString *> *)doubleSurnames {
    NSString *allDoubleSurname = @"欧阳、太史、端木、上官、司马、东方、独孤、南宫、万俟、闻人、夏侯、诸葛、尉迟、公羊、赫连、澹台、皇甫、宗政、濮阳、公冶、太叔、申屠、公孙、慕容、仲孙、钟离、长孙、宇文、司徒、鲜于、司空、闾丘、子车、亓官、司寇、巫马、公西、颛孙、壤驷、公良、漆雕、乐正、宰父、谷梁、拓跋、夹谷、轩辕、令狐、段干、百里、呼延、东郭、南门、羊舌、微生、公户、公玉、公仪、梁丘、公仲、公上、公门、公山、公坚、左丘、公伯、西门、公祖、第五、公乘、贯丘、公皙、南荣、东里、东宫、仲长、子书、子桑、即墨、达奚、褚师、吴铭";
    NSArray *names = [allDoubleSurname componentsSeparatedByString:@"、"];
    NSSet *nameSet = [NSSet setWithArray:names];
    
    return nameSet;
}

@end
