## iOS 玩转微信——下拉小程序
## ⭐️ 概述

- 本文笔者将手把手带领大家**像素级**还原`微信下拉小程序`的实现过程。尽量通过简单易懂的言语，以及配合关键代码，详细讲述该功能实现过程中所运用到的技术和实现细节，以及遇到问题后如何解决的心得体会。希望正有此功能需要的小伙伴们，能够通过阅读本文后，能快速将此功能真正运用到实际项目开发中去。

- 当然，笔者的实现方案不一定是微信官方的实现，毕竟`一千个观众眼中有一千个潘金莲`，但是，`不管黑猫白猫，能捉老鼠的就是好猫`，若能够实现此功能，相信也是一个不错的方案。希望该篇文章能为大家提供一点思路，少走一些弯路，填补一些细坑。文章仅供大家参考，若有不妥之处，还望不吝赐教，欢迎批评指正。

- 源码地址：[WeChat](https://github.com/CoderMikeHe/WeChat)

## 🌈 预览


## 🔎 分析

### 📦 模块

- **三个球指示模块：** 微信主页下拉时，用于指示用户的下拉处于哪个阶段。(MHBouncyBallsView.h/m)
- **小程序模块：** 展示`我的小程序`和`最近使用`的小程序，以及`搜索小程序`的功能。(MHPulldownAppletViewController.h/m)
- **云层模块：** 背景云层展示。(WHWeatherView.h/m) 
- **小程序容器模块：** 承载`小程序模块`和`云层模块`，以及处理`上拉`滚动逻辑。(MHPulldownAppletWrapperViewController.h/m)
- **微信首页模块：** 承载`小程序容器模块`，展示首页内容，以及处理`下拉`滚动逻辑。(MHMainFrameViewController.h/m)

### 🚩 阶段

本功能主要涵盖两大阶段：`下拉显示小程序阶段` 和 `上拉隐藏小程序阶段`；当然，用户手指`上拉或下拉`阶段都涉及到以下三种状态：

- **MHRefreshStateIdle：** 普通闲置状态（默认）
- **MHRefreshStatePulling：** 松开就可以进行刷新的状态
- **MHRefreshStateRefreshing：** 正在刷新中的状态

这里简要讲讲微信`上拉或下拉`进入`MHRefreshStatePulling`状态的条件：

- **下拉阶段：** 下拉超过临界点，且保证必须是下拉状态，即: 当前下拉偏移量 > 上一次的下拉偏移量。
- **上拉阶段：** 保证必须是上拉状态，即: 当前上拉偏移量 > 上一次的上拉偏移量，或者 偏移量为零且下拉。

松手检测：

- **下拉阶段：** 可以利用`scrollView.isDragging`来检测即可。
- **上拉阶段：** `scrollView.isDragging` 这个属性不好使，后面会给出替代方案。

### 📌 方案

### 
## 🚀 实现




























## ♥️ 期待
1. 文章若对您有些许帮助，请给个喜欢♥️ ，毕竟码字不易；若对您没啥帮助，请给点建议💗，切记学无止境。
2. 针对文章所述内容，阅读期间任何疑问；请在文章底部评论指出，我会火速解决和修正问题。
3. GitHub地址：[https://github.com/CoderMikeHe](https://github.com/CoderMikeHe)
4. 源码地址：[WeChat](https://github.com/CoderMikeHe/WeChat)

## ☎️ 主页
|GitHub | 掘金 | CSDN | 知乎 |
|:-----: | :-------: | :------: |:------:|
[点击进入](https://github.com/CoderMikeHe) | [点击进入](https://juejin.im/user/59128ee21b69e6006868d639) | [点击进入](https://blog.csdn.net/u011581932) | [点击进入](https://www.zhihu.com/people/codermikehe) |

