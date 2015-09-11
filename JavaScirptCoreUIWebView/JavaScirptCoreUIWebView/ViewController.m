//
//  ViewController.m
//  JavaScirptCoreUIWebView
//
//  Created by benlinhuo on 15/8/11.
//  Copyright (c) 2015年 benlinhuo. All rights reserved.
//

#import "ViewController.h"
#import "UIWebViewController.h"
#import "Person.h"
@import JavaScriptCore;
@import ObjectiveC;


@interface ViewController ()

@property (nonatomic, strong) JSContext *context;

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;

@end


// JavascriptCore 相关介绍（优先级从高到低）：
//http://nshipster.cn/javascriptcore/
//https://www.bignerdranch.com/blog/javascriptcore-example/
//http://blog.impathic.com/post/64171814244/true-javascript-uiwebview-integration-in-ios7
//https://www.bignerdranch.com/blog/javascriptcore-and-ios-7/

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.context = [[JSContext alloc] init];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 400, 20)];
    label1.text = @"测试JS调用OC";
    [self.view addSubview:label1];
    
    self.button1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 100, 250, 30)];
    self.button1.layer.borderColor = [UIColor redColor].CGColor;
    self.button1.layer.borderWidth = 1.0f;
    
    [self.button1 setTitle:@"testJSCallOCByBlocks" forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(testJSCallOCByBlocks) forControlEvents:UIControlEventTouchUpInside];
    
    self.button2 = [[UIButton alloc] initWithFrame:CGRectMake(15, 150, 250, 30)];
    self.button2.layer.borderColor = [UIColor redColor].CGColor;
    self.button2.layer.borderWidth = 1.0f;
    [self.button2 setTitle:@"testJSCallOCByJSExport" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(testJSCallOCByJSExport) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 270, 400, 20)];
    label2.text = @"测试OC调用JS";
    [self.view addSubview:label2];
    
    self.button3 = [[UIButton alloc] initWithFrame:CGRectMake(15, 300, 250, 30)];
    self.button3.layer.borderColor = [UIColor redColor].CGColor;
    self.button3.layer.borderWidth = 1.0f;
    [self.button3 setTitle:@"testJSContextAndJSValue" forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button3 addTarget:self action:@selector(testJSContextAndJSValue) forControlEvents:UIControlEventTouchUpInside];
    
    self.button4 = [[UIButton alloc] initWithFrame:CGRectMake(15, 350, 250, 30)];
    self.button4.layer.borderColor = [UIColor redColor].CGColor;
    self.button4.layer.borderWidth = 1.0f;
    [self.button4 setTitle:@"dealError" forState:UIControlStateNormal];
    [self.button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button4 addTarget:self action:@selector(dealError) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    [self.view addSubview:self.button4];
}

// js 调用 oc，两种方式：block 和 JSExport 协议
// JSExport
- (void)testJSCallOCByJSExport
{
    // 另一种在 JavaScript 代码中使用我们的自定义对象的方法是添加 JSExport 协议。无论我们在 JSExport 里声明的属性，实例方法还是类方法，继承的协议都会自动的提供给任何 JavaScript 代码。
    UIWebViewController *webVC = [[UIWebViewController alloc] init];
    webVC.title = @"测试页面：JSExport";
    webVC.url = @"http://192.168.164.38/jscore";// 加载的页面内容就是 core.blade.php 文件内容
    [self.navigationController pushViewController:webVC animated:YES];
}

// block 方式
- (void)testJSCallOCByBlocks
{
    self.context[@"simplifyString"] = ^(NSString *input) {
        NSMutableString *mutableString = [input mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        return mutableString;
    };
    
    NSLog(@"%@", [self.context evaluateScript:@"simplifyString('안녕하새요!')"]);
    
    self.context[@"doubleNumByBlock"] = ^(NSInteger num) {
        return (num * 2);
    };
    NSLog(@"doubleNum: %@", [self.context evaluateScript:@"doubleNumByBlock(3)"]);
    
    UIWebViewController *webVC = [[UIWebViewController alloc] init];
    webVC.title = @"测试页面: Block";
    webVC.url = @"http://192.168.164.38/jscore";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)testJSContextAndJSValue
{
    
    // JSContext 相当于 js 中的window 。 因为像js 这样的动态语言需要一个动态类型，所以 JSValue 就包装了每一个可能的 JS 值：字符串、数组等等
    
    // evaluateScript 方法的参数就表示能在 web 页面中直接通过window被调用的方法
    
    [self.context evaluateScript:@"var num = 5 + 5"];
    [self.context evaluateScript:@"var names = ['Grace', 'Ada', 'Margaret']"];
    [self.context evaluateScript:@"var triple = function(value) {return value * 3}"];
    JSValue *tripleNum = [self.context evaluateScript:@"triple(num)"];
    NSLog(@"Three tripled: %d", [tripleNum toInt32]);
    
    JSValue *tripleFunction = self.context[@"triple"];
    JSValue *result = [tripleFunction callWithArguments:@[@5]];
    NSLog(@"Five tripled: %d", [result toInt32]);
    
    JSValue *value = [self.context evaluateScript:@"Math.floor(5.4)"];
    NSLog(@"value: %@",value);
}

- (void)dealError
{
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JS Error: %@", exception);
    };
    
    [self.context evaluateScript:@"functio multiply(value1, value2) {return value1 * value2}"];
}

@end
