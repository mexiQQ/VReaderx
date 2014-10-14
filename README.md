#VReader 基于Bomb的小型新闻资讯类iOS框架

（ps:小子倒是斗胆称它为框架了）

框架介绍：
 
- 四个新闻模块
- 我的收藏
- 两个富类模块
- 联系我们＋用户反馈
- 使用Bomb云服务
- 新闻数据持久化

界面展示：

![](http://mexiqq.qiniudn.com/VReader-1.png)
![](http://mexiqq.qiniudn.com/VReader-3.png)
![](http://mexiqq.qiniudn.com/VReader-2.png)

使用方法：

###(一)建立服务器：
- 注册Bomb账号(附链接：http://www.bmob.cn/activity/redirect/?sid=b2a3391014f40dd92252)
- 云端建立自己的APP
- 在数据浏览模块新建数据表，分别如下：

| 模块        | 数据库表           | 表中字段  |
| ------------- |:-------------:| -----:|
| 四个新闻模块    | module1,module2,module3,module4 | title(string) publishTime(string)  content(string) |
| 问题反馈      | Questions      |   question(string) reply(string |

建表完成后可添加几条虚拟数据，如下：

![](http://mexiqq.qiniudn.com/VReader%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202014-10-14%20%E4%B8%8B%E5%8D%882.02.30.png)

OK，到应用密钥页获取应用的 Application ID留作他用。

###(二)绑定应用与服务器

- 将框架源码下载，在本地xcode打开
- 打开 AppDelegate.m 文件，此处的密钥更换为上一步的Application ID

```
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
	    [Bmob registerWithAppKey:@"679e8e7efab9fcb83cdf2017b8f69fb5"];
	    // Override point for customization after application launch.
	    return YES;
	}
	
```
OK，准备完成，Command+B Command+R开始运行吧

###(三)自我定制

新闻模块可添加和删除，富类模块自己可以定义，只要你会使用MystoryBoard，完全可以自我定制界面。

编写时的一些想法：
http://www.mexiqq.com/2014/10/11/%E4%B8%80%E6%AC%BE%E6%96%B0%E9%97%BB%E7%B1%BBiOS-APP%E7%9A%84%E8%AF%9E%E7%94%9F%E8%BF%87%E7%A8%8B/