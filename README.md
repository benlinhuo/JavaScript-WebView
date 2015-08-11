# JavaScript-WebView
### web页面与原生APP之间的交互

#### WKWebView的新特性与使用

    在WWDC2014中，苹果推出了最新的iOS8系统，其中也伴随着很多控件的更新与升级。其中全新的WebKit库让人很是兴奋。本文也将讲解到WebKit中更新的WKWebView控件的新特性与使用方法，它很好的解决了UIWebView存在的内存、加载速度等诸多问题。
    它要求 Mac OS X 系统为10.10.1，Xcode 版本为6.1.1，iOS 系统为8.1以上。

一、 WKWebView 新特性
   * 在性能、稳定性、功能方面有很大提升（最直观的体现就是加载网页是占用的内存，模拟器加载百度与开源中国网站时，WKWebView占用23M，而UIWebView占用85M）；
   * 允许JavaScript的Nitro库加载并使用（UIWebView中限制）；
   * 支持了更多的HTML5特性；
   * 高达60fps的滚动刷新率以及内置手势；
   * 将UIWebViewDelegate与UIWebView重构成了14类与3个协议

二、 初始化

2.1 首先需要引入WebKit库

#import <WebKit/WebKit.h>

2.2 初始化方法分为以下两种
```javascript
// 默认初始化
- (instancetype)initWithFrame:(CGRect)frame;
// 根据对webview的相关配置，进行初始化
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration NS_DESIGNATED_INITIALIZER;
```

2.3 加载网页与HTML代码的方式与UIWebView相同，代码如下：
```javascript
WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
[self.view addSubview:webView];
```

三、WKWebView的代理方法

3.1 WKNavigationDelegate

该代理提供的方法，可以用来追踪加载过程（页面开始加载、加载完成、加载失败）、决定是否执行跳转。

```javascript
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;
```

页面跳转的代理方法有三种，分为（收到跳转与决定是否跳转两种）

```javascript
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation;

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
```

3.2 WKUIDelegate

```javascirpt
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;
```

剩下三个代理方法全都是与界面弹出提示框相关的，针对于web界面的三种提示框（警告框、确认框、输入框）分别对应三种代理方法。下面只举了警告框的例子。

```javascript
/** 
 *  web界面中有弹出警告框时调用 
 *
 *  @param webView           实现该代理的webview 
 *  @param message           警告框中的内容 
 *  @param frame             主窗口 
 *  @param completionHandler 警告框消失调用 
 */
 - (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler;
```

3.3 WKScriptMessageHandler

这个协议中包含一个必须实现的方法，这个方法是提高App与web端交互的关键，它可以直接将接收到的JS脚本转为OC或Swift对象。（当然，在UIWebView也可以通过“曲线救国”的方式与web进行交互，著名的Cordova框架就是这种机制）

```javascript
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
```

四、WKWebView加载JS

```javascript
// 图片缩放的js代码
NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('找到' + count + '张图');";

// 根据JS字符串初始化WKUserScript对象
WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

// 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
[config.userContentController addUserScript:script];
_webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
[_webView loadHTMLString:@"<head></head><img src='http://www.nsu.edu.cn/v/2014v3/img/background/3.jpg' />"baseURL:nil];
[self.view addSubview:_webView];
```

具体的代码见 2015-01-31-WKWebViewDemo 工程目录。该工程使用了 Main.storyboard，所以也可以用来学习 Main.storyboard 进行场景的切换。另外备注的是：WKViewController是用来测试 js 和 WKWebView 之间进行互调的，其中用到的该链接：@"http://www.learnlaravel.com/wkwebview"，需要能正确访问才行。



