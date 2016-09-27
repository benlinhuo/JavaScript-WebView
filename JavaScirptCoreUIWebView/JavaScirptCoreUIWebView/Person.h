//
//  Person.h
//  JavaScirptCoreUIWebView
//
//  Created by benlinhuo on 15/9/11.
//  Copyright (c) 2015年 benlinhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JavaScriptCore;
//@import ObjectiveC;

@protocol PersonJSExports <JSExport>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property NSInteger ageToday;

- (NSString *)getFullName;

// 如果是这种方式，则JS调用的方法名为：createWithFirstNameLastName
//+ (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;

// 因为JS调用OC方法太长，所以可以使用 JSExportAs 指定一个方法名替代，否则的话就只能
JSExportAs(createName,  + (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
);

@end

@interface Person : NSObject <PersonJSExports>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property NSInteger ageToday;

@end
