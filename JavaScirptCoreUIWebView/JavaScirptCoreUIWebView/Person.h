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

// create and return a new Person instance with `firstName` and `lastName`
+ (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;

@end

@interface Person : NSObject <PersonJSExports>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property NSInteger ageToday;

@end
