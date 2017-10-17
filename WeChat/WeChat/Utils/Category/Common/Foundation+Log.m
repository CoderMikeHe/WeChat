/**
 *  CoderMikeHe
 *  这个分类主要用来 打印NSLog....
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@implementation UIView(Log)
+ (NSString *)searchAllSubviews:(UIView *)superview
{
    NSMutableString *xml = [NSMutableString string];
    
    NSString *class = NSStringFromClass(superview.class);
    class = [class stringByReplacingOccurrencesOfString:@"_" withString:@""];
    [xml appendFormat:@"<%@ frame=\"%@\">\n", class, NSStringFromCGRect(superview.frame)];
    for (UIView *childView in superview.subviews) {
        NSString *subviewXml = [self searchAllSubviews:childView];
        [xml appendString:subviewXml];
    }
    [xml appendFormat:@"</%@>\n", class];
    return xml;
}

- (NSString *)description
{
    return [UIView searchAllSubviews:self];
}
@end

@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    
    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [str appendString:@"}"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end

@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"[\n"];
    
    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,\n", obj];
    }];
    
    [str appendString:@"]"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end
