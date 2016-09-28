//
//  Person.m
//  JavaScirptCoreUIWebView
//
//  Created by benlinhuo on 15/9/11.
//  Copyright (c) 2015年 benlinhuo. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation Person

- (NSString *)getFullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

+ (instancetype) createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    Person *person = [[Person alloc] init];
//    person.firstName = firstName;
    person.lastName = lastName;
    return person;
}

@end
