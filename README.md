<p align="center">
  <a href="https://apps.apple.com/cn/app/v2exos/id6443544914?mt=12">
    <img src="/V2exOS/Assets.xcassets/AppIcon.appiconset/icon_256.png" alt="V2exOS" title="V2exOS" width="100" />
  </a>
  <h1 align="center">V2exOS</h1>
  <div align="center">一个用 SwiftUI 编写的 V2ex macOS/iOS/tvOS 客户端</div>
</p>

![macOS screenshot](https://user-images.githubusercontent.com/2088605/192312063-def16466-052b-457a-9b4c-856b2afb3a42.png#gh-dark-mode-only)
![macOS screenshot](https://user-images.githubusercontent.com/2088605/192312051-9ec1e43d-4aee-46fb-a61f-fd865e35fca4.png#gh-light-mode-only)

<div style="display: flex">
  <img src="https://user-images.githubusercontent.com/2088605/219903872-311b54cb-59fd-4568-b057-469cd6ebee93.png" width="70%" alt="tvOS screenshot" />
  <img src="https://user-images.githubusercontent.com/2088605/219903934-8fddee2e-51d5-493a-b01d-38a4a55970a1.png#gh-dark-mode-only" width="25%" alt="tvOS screenshot" />
  <img src="https://user-images.githubusercontent.com/2088605/219903581-ce11de4b-c0d9-4843-844a-afd21d3f6993.png#gh-light-mode-only" width="25%" alt="iOS screenshot" />
</div>




## 下载

V2exOS 已经发布到 App Store，可以通过下面的链接直接下载；当然你也可以从 [Release](https://github.com/isaced/V2exOS/releases) 页面下载构建好的 `.app` 包，或者自己根据源代码构建。

<a href="https://apps.apple.com/cn/app/v2exos/id6443544914?mt=12">
  <img src="https://tools.applemediaservices.com/api/badges/download-on-the-mac-app-store/white/en-US" alt="Download V2exOS on App Store" height="40" />
</a>

## 关于

- 目标打造一个 macOS/iOS/tvOS 三平台原生极致体验的 V2ex 客户端
- 使用 SwiftUI 开发，尽量利用系统和语言新特性，最低适配 macOS 12+ / iOS 16+ / tvOS 15+
- 开发过程中抽象出可复用的 V2ex API 网络层为 Swift Package - [V2exAPI](https://github.com/isaced/V2exAPI)

## 功能

**基本功能**

- [x] Personal Access Token 授权登录
- [x] 主题列表
- [x] 评论列表
- [x] 通知列表
- [x] 深色模式
- [x] 节点搜索/Google搜索
- [x] 热门列表
- [ ] 收藏节点
- [ ] 发表主题/评论（暂无 API 支持 [#4](https://github.com/isaced/V2exOS/issues/4)）

**高级功能**

- [x] Proxy 代理

## 帮助

**如何设置代理？**

菜单： V2exOS -> Preferences （快捷键：<kbd>Command</kbd> + <kbd>,</kbd>）

<img src="https://user-images.githubusercontent.com/2088605/193294617-e027d1da-8bd7-44f4-9ade-11f2cf807d81.png" width="450">

> 数据加载不出来有可能是需要挂代理，你懂的

**如何登录 V2exOS？**

在 V2ex 登录你的账号，进入 [[设置 -> Tokens]](https://v2ex.com/settings/tokens) 页面生成 Personal Access Token（建议有效期长一些），填入 V2exOS 即可，V2exOS 会将你的 Personal Access Token 保存到本地的 Keychain 钥匙串中，在需要访问 [V2ex API](https://v2ex.com/help/api) 时进行使用。

> 当然部分不需要鉴权的功能不登陆也是可以直接使用的

## 贡献

- 欢迎大家添砖加瓦，需要某个功能可以先提交 [issue](https://github.com/isaced/V2exOS/issues) 讨论，当然也可以直接 [fork](https://github.com/isaced/V2exOS/fork) 仓库，修改代码提交 PR。

直接通过 Xcode 打开本项目即可，如果遇到 SPM 依赖拉取不下来，可以尝试通过 `xcodebuild` 命令更新：

```shell
xcodebuild -resolvePackageDependencies -scmProvider system
```

## 感谢

本项目建立在以下开源库之上，感谢这些优秀的项目：

- [V2exAPI](https://github.com/isaced/V2exAPI) - V2ex Open API 的 Swift 封装
- [Kingfisher](https://github.com/onevcat/Kingfisher) - 网络图片加载和缓存
- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) - Keychain 便捷访问存储 Personal Access Token
- [MarkdownUI](https://github.com/gonzalezreal/MarkdownUI) - SwiftUI Markdown 渲染
- [RedditOS](https://github.com/Dimillian/RedditOS) - 一个 SwiftUI 写的 Reddit macOS 客户端，灵感来源之一

## LICENSE

MIT
