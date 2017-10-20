//
//  NSString+SBExtension.h
//  WeChat
//
//  Created by senba on 2017/8/4.
//  Copyright © 2017年 Senba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SBExtension)
/// 消除收尾空格
- (NSString *)sb_removeBothEndsWhitespace;
/// 消除收尾空格+换行符
- (NSString *)sb_removeBothEndsWhitespaceAndNewline;
// 消除收尾空格
- (NSString *)sb_trimWhitespace;
/// 编码
- (NSString *)sb_URLEncoding;
// 消除所有空格
- (NSString *)sb_trimAllWhitespace;
@end
