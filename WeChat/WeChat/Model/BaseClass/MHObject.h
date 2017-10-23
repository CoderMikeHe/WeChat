//
//  MHObject.h
//  WeChat
//
//  Created by senba on 2017/7/19.
//  Copyright © 2017年 Senba. All rights reserved.
//  所有新建Model类的基类

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface MHObject : NSObject <YYModel,NSCopying,NSCoding>

/// YYModel - API
/// 将 Json (NSData，NSString，NSDictionary) 转换为 Model
+ (instancetype)modelWithJSON:(id)json;
/// 字典转模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
/// json-array 转换为 模型数组
+ (NSArray *)modelArrayWithJSON:(id)json;


/// 将 Model 转换为 JSON 对象
- (id)toJSONObject;
/// 将 Model 转换为 NSData
- (NSData *)toJSONData;
/// 将 Model 转换为 JSONString
- (NSString *)toJSONString;



// Returns the keys for all @property declarations, except for `readonly`
// properties without ivars, or properties on MHObject itself.
/// 返回所有@property声明的属性，除了只读属性，以及属性列表不包括成员变量
+ (NSSet *)propertyKeys;

// A dictionary representing the properties of the receiver.
//
// The default implementation combines the values corresponding to all
// +propertyKeys into a dictionary, with any nil values represented by NSNull.
// This property must never be nil.
@property (nonatomic, copy, readonly) NSDictionary *dictionaryValue;

// Merges the value of the given key on the receiver with the value of the same
// key from the given model object, giving precedence to the other model object.
//
// By default, this method looks for a `-merge<Key>FromModel:` method on the
// receiver, and invokes it if found. If not found, and `model` is not nil, the
// value for the given key is taken from `model`.
- (void)mergeValueForKey:(NSString *)key fromModel:(MHObject *)model;

// Merges the values of the given model object into the receiver, using
// -mergeValueForKey:fromModel: for each key in +propertyKeys.
//
// `model` must be an instance of the receiver's class or a subclass thereof.
- (void)mergeValuesForKeysFromModel:(MHObject *)model;
@end


// Implements validation logic for MHObject.
@interface MHObject (Validation)

// Validates the model.
//
// The default implementation simply invokes -validateValue:forKey:error: with
// all +propertyKeys and their current value. If -validateValue:forKey:error:
// returns a new value, the property is set to that new value.
//
// error - If not NULL, this may be set to any error that occurs during
//         validation
//
// Returns YES if the model is valid, or NO if the validation failed.
- (BOOL)validate:(NSError **)error;

@end
