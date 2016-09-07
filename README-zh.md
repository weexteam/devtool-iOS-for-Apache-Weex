[![GitHub release](https://img.shields.io/github/release/weexteam/wweex-devtool-iOS.svg)](https://github.com/weexteam/weex-devtool-iOS/releases)  [![GitHub issues](https://img.shields.io/github/issues/weexteam/weex-devtool-iOS.svg)](https://github.com/weexteam/weex-devtool-iOS/issues)

伴随Weex的开源，业务线接入Weex Devtools也在持续增加，本文详细解说Devtools在ios平台如何集成。

# 接入

### 方法一：cocoapods依赖

1. 集团内部：在工程目录的podfile添加如下代码

        ali_source 'alibaba-specs'  
        ali_source 'alibaba-specs-mirror'
        pod  'WXDevtool',   '0.6.1.14', :configurations => ['Debug']

   集团内部版本预览：

   0.6.1.14, 0.1.1,
   0.1.0, 0.0.5, 0.0.3.0, 0.0.2.2, 0.0.2.1, 0.0.2.0-SNAPSHOT, 0.0.1.1,
   0.0.1.1-SNAPSHOT, 0.0.1, 0.0.1.0-SNAPSHOT [alibaba-specs repo]  

2. 集团外部：在工程目录的podfile添加如下代码
 
        source https://github.com/CocoaPods/Specs.git，
        pod  'WXDevtool',   '0.7.0', :configurations => ['Debug']，

     集团外部版本预览：
     
     0.7.0, 0.6.1, 0.1.1, 0.1.0 [master repo]
     
     ---

     可以通过更新本地podspec repo，pod search来查询最新版本   
        
     在podfile文件添加依赖


    *** 推荐在DEBUG模式下依赖。 ***

### 方法二：github源码依赖


  1. [拉取](https://github.com/weexteam/weex-devtool-iOS)最新的WXDevtool代码。
  
  2. 按照如下图示：
   

    ![drag](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/def3b8c2d0379acb276a1880288c6d06)

     *直接拖动source目录源文件到目标工程中*

    ![_](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/68366d84dd9dbc3ecfd77e91f7284e12)

     *按照红框中配置勾选*

     在相对较大的互联网App研发中, framework静态库被广泛应用，所以推荐使用方法一接入。

     至此WXDevtool的接入大功告成。

# 使用

 1. 安装weex-devtool，
 
        $:npm install -g weex-toolkit
        $:weex debug        
     
   ![_](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/b649894ffc3f2f6d8bf233cd8e38d138)

   如果你能看到上面的结果，说明weex-devtool启动成功了。

   此命令安装之后会自动启动浏览器，打开调试主页面：

  ![_](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/4541aacaba2b706dcdeb46f02f97b941)
     
 2. 如果按照方法一接入：framework的方式，添加头文件包含
 
        #import <TBWXDevtool/WXDevtool.h>
        
    如果按照方法二接入：源码依赖的方式，添加头文件包含
    
        #import "WXDevtool.h"
        
     查看WXDevtool头文件如下：
     
     ```
        #import <Foundation/Foundation.h>

        @interface WXDevTool : NSObject
        /**
        *  set debug status
        *  @param isDebug  : YES:open debug model and inspect model;
        *                    default is NO,if isDebug is NO, open inspect only;
        * */
        + (void)setDebug:(BOOL)isDebug;


        /**
        *  get debug status
        * */  
      + (BOOL)isDebug;


        /**
        *  launch weex debug
        *  @param url  : ws://ip:port/debugProxy/native, ip and port is your devtool server address
        * eg:@"ws://30.30.29.242:8088/debugProxy/native"
        * */
        + (void)launchDevToolDebugWithUrl:(NSString *)url;

        @end
       
     ``` 
      setDebug:参数为YES时，直接开启debug模式，反之关闭，使用场景如下所述
      
      在你自己的程序中添加如下代码：
      
         [WXDevTool launchDevToolDebugWithUrl:@"ws://30.30.31.7:8088/debugProxy/native"];
         
     其中的ws地址正是weex debug控制台中出现的地址，直接copy到launchDevToolDebugWithUrl:接口中。
     
     如果程序一启动就开启weex调试，** 需要在WeexSDK引擎初始化之前 ** 添加代码：
     
        [WXDevTool setDebug:YES];
        [WXDevTool launchDevToolDebugWithUrl:@"ws://30.30.31.7:8088/debugProxy/native"];
        
        
       ![_](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/39cfc174cc78e4c7aadd1c2d0d074819)
    
    如果出现上面页面，恭喜你，WXDevtool集成完毕，so easy！
    
 3. 附加页面刷新功能  

  + 为什么需要页面刷新功能？

    如下图所示，当点击debug按钮时，js的运行环境会从手机端（JavaScriptCore）切换到chrome（V8），这时需要重新初始化weex环境，重新渲染页面。页面渲染是需要接入方在自己的页面添加。
         
       ![_debug](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/02b42b858ca117920983a8b5780f61c8)

  + 什么场景下需要添加页面刷新功能?  
       + 点击debug按钮调试
       + 切换RemoteDebug开关
       + 刷新chrome页面（command+R）
       
  + 如何添加刷新  

      在weex页面初始化或viewDidLoad方法时添加注册通知，举例如下	：
    
    ```
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationRefreshInstance: name:@"RefreshInstance" object:nil];
    
    ```
    
    最后**千万记得**在dealloc方法中取消通知，如下所示
    
    ```
    - (void)dealloc
	{
    	[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
    
    ```
页面刷新实现，先销毁当前instance，然后重新创建instance，举例如下:

   ```
   - (void)render
  {
     CGFloat width = self.view.frame.size.width;
     [_instance destroyInstance];
     _instance = [[WXSDKInstance alloc] init];
     _instance.viewController = self;
     _instance.frame = CGRectMake(self.view.frame.size.width-width, 0, width, _weexHeight);
    
     __weak typeof(self) weakSelf = self;
     _instance.onCreate = ^(UIView *view) {
         [weakSelf.weexView removeFromSuperview];
         weakSelf.weexView = view;
         [weakSelf.view addSubview:weakSelf.weexView];
         UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification,  weakSelf.weexView);
     };
     _instance.onFailed = ^(NSError *error) {
         
     };
    
     _instance.renderFinish = ^(UIView *view) {
         [weakSelf updateInstanceState:WeexInstanceAppear];
     };
    
     _instance.updateFinish = ^(UIView *view) {
     };
     if (!self.url) {
         return;
     }
     NSURL *URL = [self testURL: [self.url absoluteString]];
     NSString *randomURL = [NSString stringWithFormat:@"%@?random=%d",URL.absoluteString,arc4random()];
     [_instance renderWithURL:[NSURL URLWithString:randomURL] options:@{@"bundleUrl":URL.absoluteString} data:nil];
 }

   ```
具体实现可参考 [playground](https://github.com/weexteam/weex-devtool-iOS/blob/master/Devtools/playground/WeexDemo/WXDemoViewController.m) WXDemoViewController.m文件

    
    *说明：目前版本需要注册的通知名称为固定的“RefreshInstance”，下个版本会添加用户自定义name*
    
    
# 功能概览

   1. 日志级别控制

      ![_](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/c80d3a967ab48477a409fa0b2b7cf755)
     日志级别可以控制native端关于weex的日志。

     日记级别描述如下：
   
     ```
    Off       = 0, 
    Error     = Error
    Warning   = Error | Warning,
    Info      = Warning | Info,
    Log       = Log | Info,
    Debug     = Log | Debug,    
    All       = NSUIntegerMax

     ```
    
     解释：off关闭日志，Warning包含Error、Warning，Info包含Warning、Info，Log包含Info、Log，Debug包含Log、Debug，All包含所有。

   2. Vdom/Native tree选择

     <img src="http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/5b05cc670dcc868d9e68964d6fc74c38"  alt="替代文本" title="标题文本" width="200"  />  
     *图一*

     ![图二](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/f0d9f46055522ad0d755fc64524a75c2 "图二")  
    *图二*
    
   点击图一所示native选项会打开图二，方便查看native tree以及view property

   ![vdom](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/442a18bc1f19ca86064302cc294f03cb)
   *图三*

   ![vdom_tree](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/6950dc88e8c754dd1c95d9a9e40efcf4)  
   *图四*
   
   点击图三所示vdom选项会打开图四，方便查看vdom tree以及component property
   

   3. debug调试开关手动控制

    ![_debug](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/771275e139225bc50e4a37683a0c9eac)
    *图五*

    ![_debug](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/48adec9ad9e26eae2af65a1f0d0d6f0c)
    *图六*
    

   ![_debug_](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/f0e6547676678b206f7cc0fda3c77a93)
   *图七*
   
   OFF为关闭远程debug调试，反之ON为开启debug调试，点击打开debug时会自动打开图七所示页面，此时可以打开控制台调试js代码了
  
