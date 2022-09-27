# <img width="50" src="/V2exOS/Assets.xcassets/AppIcon.appiconset/icon_256.png" /> V2exOS <a href="https://apps.apple.com/cn/app/v2exos/id6443544914?mt=12"><img align="right" src="https://user-images.githubusercontent.com/2088605/192413562-5e123118-bd2c-4710-9b68-872ffe61ae4d.png" height="50"></a>


一个用 SwiftUI 编写的 V2ex macOS 客户端。

![screenshot](https://user-images.githubusercontent.com/2088605/192312063-def16466-052b-457a-9b4c-856b2afb3a42.png#gh-dark-mode-only)
![screenshot](https://user-images.githubusercontent.com/2088605/192312051-9ec1e43d-4aee-46fb-a61f-fd865e35fca4.png##gh-light-mode-only)

## 关于

- 目标打造一个 macOS 平台原生极致体验的 V2ex 客户端
- 使用 SwiftUI 开发，尽量利用系统和语言新特性，最低适配 macOS 12+
- 开发过程中抽象出可复用的 V2ex API 网络层为 Swift Package - [V2exAPI](https://github.com/isaced/V2exAPI) 

## 功能

- [x] 主题列表
- [x] 评论列表
- [x] 通知列表
- [x] 深色模式
- [x] Personal Access Token 授权
- [ ] 发表评论
- [ ] 发表主题


## 贡献

- 欢迎大家添砖加瓦，需要某个功能可以先提交 [issue](https://github.com/isaced/V2exOS/issues) 讨论，当然也可以直接 [fork](https://github.com/isaced/V2exOS/fork) 仓库，修改代码提交 PR。

## 感谢

本项目建立在以下开源库之上，感谢这些优秀的项目：

- [Kingfisher](https://github.com/onevcat/Kingfisher) - 网络图片加载和缓存
- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) - Keychain 便捷访问存储 Personal Access Token
- [MarkdownUI](https://github.com/gonzalezreal/AttributedText) - SwiftUI Markdown 渲染

## LICENSE

MIT
