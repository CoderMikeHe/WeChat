## 微信（WeChat）开发

### 求职
笔者最近刚刚离职，正准备寻求iOS开发工程师一职，如果各位小伙伴公司正缺该职位，还请各位小伙伴踊跃推荐哦，虽然笔者在技术上算不上非常牛逼，但是在为人处事方面却可以说十分靠谱。坐标：**深圳**。
如果正有需要，还请私信或联系我，期待与您共事，谢谢~
- 电话：13265873384
- 微信：491273090


### 概述
本工程主要是利用`MVVM + RAC + ViewModel-Based Navigation`的方式来搭建微信（WeChat）的整体架构，希望能够以点带面，为`MVVM + RAC + ViewModel-Based Navigation`的这种设计架构提供多一种的实践参考，也为大家在学习`MVVM`提供一个学习的Demo。抛砖引玉，取长补短，希望能够提供一点思路，少走一些弯路，填补一些细坑。


### 使用
- [Cocoapods 安装教程](https://www.cnblogs.com/chuancheng/p/8443677.html)

- 本`Demo`利用`Cocoapods`管理第三方框架，若第一次使用本项目，请使用终端`cd`到`Podfile`所在的文件夹中，如下图所示，然后执行下面两条命令即可，（PS：若你已经更新了本地仓库了，那么`pod repo update`不用执行，直接`pod install`即可）。

	![Usage.png](https://github.com/CoderMikeHe/WeChat/blob/master/WeChat/SnapShot/CocopodsUsage.png)
	
	```
	1. pod repo update : 更新本地仓库 
	2. pod install : 下载新的库
	```
- 如果你升级了Mac的系统时，并且当你的Mac系统升级为` high sierra `的时候，别忘记更新`cocoapods`。执行命令为：

	```
	$ sudo gem update --system
	$ sudo gem install cocoapods -n/usr/local/bin
	```
- 本项目登录或注册，只支持`QQ账号`和`手机号`的登录或注册，必须保证`QQ`或`手机号`的有效性。密码或者验证码可以随便输入，但必须是：密码长度需要保证在`8~16`位，手机验证码必须保证是`6位有效数字`。
- 若`pod install`很漫长或有问题，请戳百度网盘链接:https://pan.baidu.com/s/1JNgKnnNQz5NBK7VSLtiPVA  密码:cax6  <PS：不定期更新！！！> 

### 期待
- 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的代码看看BUG修复没有）。
- 如果在使用过程中有任何地方不理解，希望你能Issues我，我非常乐意促使项目的理解和使用，谢谢。
- 如果通过该工程的使用和说明文档的阅读，对您在开发中有一点帮助，码字不易，还请点击右上角`star`按钮，谢谢；
- 简书地址：<http://www.jianshu.com/u/126498da7523>

### 文档
- [iOS 基于MVVM + RAC + ViewModel-Based Navigation的微信开发（一）](http://www.jianshu.com/p/fd407a4ecb8e)
- [iOS 基于MVVM + RAC + ViewModel-Based Navigation的微信开发（二）](http://www.jianshu.com/p/8c35fc02f47b)
- [iOS 基于MVVM设计模式的微信朋友圈开发](https://www.jianshu.com/p/2f161f6a310f)
- [iOS 实现微信朋友圈的最优方案参照](https://www.jianshu.com/p/395bac3648a7)
