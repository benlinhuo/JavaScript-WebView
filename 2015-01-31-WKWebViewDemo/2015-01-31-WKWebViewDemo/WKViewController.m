//
//  TestWKViewController.m
//  Angejia
//
//  Created by benlinhuo on 15/8/10.
//  Copyright (c) 2015年 Plan B Inc. All rights reserved.
//
//该类用于测试 Javascript 和 原生APP之间互相平滑的调用

#import "WKViewController.h"
#import <WebKit/WebKit.h>

@interface WKViewController () <WKScriptMessageHandler>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:@"redHeader()"
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                   forMainFrameOnly:true];
    [contentController addUserScript:userScript];
    [contentController addScriptMessageHandler:self name:@"callbackHandler"];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = contentController;
    self.webView = [[WKWebView alloc] initWithFrame:self.containerView.bounds
                                      configuration:config];
    self.view = self.webView;
    
    
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.learnlaravel.com/wkwebview"];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:req];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqual: @"callbackHandler"]) {
        NSLog(@"JavaScript is Sending a message \(message.body)");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
