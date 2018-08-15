//
//  NSString+Empty.h
//  JWExtractString
//
//  Created by JessieWu on 2018/8/14.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Empty)

@property (nonatomic, assign, readonly, getter=isEmpty) BOOL empty;

@end
