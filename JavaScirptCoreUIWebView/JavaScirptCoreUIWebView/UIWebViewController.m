//
//  UIWebViewController.m
//  JavaScirptCoreUIWebView
//
//  Created by benlinhuo on 15/9/11.
//  Copyright (c) 2015年 benlinhuo. All rights reserved.
//

#import "UIWebViewController.h"
#import "Person.h"
@import JavaScriptCore;

#define SCREEN_HEIGTH [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface UIWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    if (self.webTitle.length > 0) {
        self.title = self.webTitle;
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];//48
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    //配置各类基本参数
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // alertFn 是在 js 中定义的方法
    [context evaluateScript:@"alertFn()"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 这是用 block 的方式给 JS 传递。如果在 webViewDidStartLoad 中插入如下代码，是因为我们在html加载的过程中就需要如下oc定义的方法。该方法是在页面开始渲染前调用。如果是页面的一个点击事件啥的，不及时需要如下的方法，则可以在 webViewDidFinishLoad 中添加如下代码。
    
    // context 获取的是跟当前 webview 相关
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"threeNumByBlock"] = ^(NSInteger num) {
        return (num * 3);
    };
    
    // JSExport 。该 Person 类必须要要实现 JSExport 协议，否则 JS 是不能正常调用该类的方法的。
    // 其实很简单，只需要 Person 类实现 JSExport 协议或者它的子协议，然后在此处传给 JSRuntime 即可。JS 那边就可以随心所欲的调用该类的任何公开方法了
    context[@"Person"] = [Person class];

}

@end
