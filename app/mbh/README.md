# MBH Enterprise Flutter Scaffold

企业级 Flutter 脚手架，面向长期迭代、多人协作、组件化开发与 AI 辅助生成。

适用场景：
- 企业级 App
- 多模块中大型项目
- 需要长期维护的 Flutter 项目
- 希望用 Cursor / AI 持续生成页面和模块的团队

---

# 1. 项目简介

本项目基于以下技术栈：

- Flutter 3.x
- GetX
- MVVM
- Dio
- GetStorage
- Hive
- SQLite
- ScreenUtil
- 国际化
- 深色模式
- 企业级日志系统
- 崩溃监控预留
- WebSocket
- 权限管理
- 文件上传
- CI/CD 预留
- AI 代码生成规范

本脚手架的目标：

- 高扩展性
- 高可维护性
- 低耦合
- 清晰目录结构
- 适合多人协作
- 适合长期迭代
- 适合 AI 辅助开发

---

# 2. 新手快速开始

## 2.1 环境要求

建议环境：

- Flutter 3.x
- Dart 3.x
- FVM
- Android Studio / VS Code / Cursor
- Xcode（如果开发 iOS / macOS）

建议先确认：

```bash
fvm flutter doctor
```

---

## 2.2 安装依赖

进入项目目录：

```bash
cd app/mbh
```

执行：

```bash
fvm flutter pub get
```

如果你在中国大陆遇到 Gradle Maven 网络问题，本项目已经配置了阿里云镜像。

如果仍失败，可尝试：

```bash
fvm flutter clean
fvm flutter pub get
```

---

## 2.3 运行项目

### 开发环境运行

```bash
fvm flutter run -t lib/main.dart
```

### 测试环境运行

```bash
fvm flutter run -t lib/main_test.dart
```

### 预发环境运行

```bash
fvm flutter run -t lib/main_staging.dart
```

### 生产环境运行

```bash
fvm flutter run -t lib/main_prod.dart
```

---

# 3. 多环境说明

项目内置 4 个入口文件：

- `lib/main.dart` -> dev
- `lib/main_test.dart` -> test
- `lib/main_staging.dart` -> staging
- `lib/main_prod.dart` -> prod

环境定义在：

- `lib/app/config/flavor/app_flavor.dart`
- `lib/app/config/flavor/flavor_config.dart`

环境变量文件预留在：

- `configs/env/.env.dev`
- `configs/env/.env.prod`

当前项目使用 `FlavorConfig` 提供：

- appName
- baseUrl
- enableLogging
- enableCrashReporting

后续如果你要接入真实 `.env` 解析，也可以在 `bootstrap/app_initializer.dart` 中统一扩展。

---

# 4. 项目目录结构

```text
lib/
├── main.dart
├── main_test.dart
├── main_staging.dart
├── main_prod.dart
└── app/
    ├── app.dart
    ├── bootstrap/
    ├── config/
    ├── core/
    ├── modules/
    └── shared/
```

---

## 4.1 `bootstrap/`

应用启动装配层。

核心职责：
- 初始化全局服务
- 初始化日志、存储、网络
- 初始化崩溃监控
- 配置应用启动顺序

关键文件：
- `app_initializer.dart`
- `app_runner.dart`

---

## 4.2 `config/`

环境配置层。

核心职责：
- 定义 flavor
- 配置不同环境的 baseUrl、日志开关、崩溃开关

关键文件：
- `env/env.dart`
- `flavor/app_flavor.dart`
- `flavor/flavor_config.dart`

---

## 4.3 `core/`

全局核心基础设施。

包含：
- 基类
- 常量
- 错误体系
- 国际化
- 日志系统
- 崩溃监控
- 网络层
- 路由系统
- 存储层
- 主题系统
- 权限管理
- 上传服务
- AI 规范

这是整个脚手架最重要的一层。

---

## 4.4 `modules/`

业务模块目录。

每个模块都应该独立组织，彼此低耦合。

当前已有模块：
- `splash`
- `onboarding`
- `auth`
- `home`
- `settings`
- `profile`

---

## 4.5 `shared/`

共享组件层。

存放：
- Button
- Input
- Dialog
- Toast
- Loading
- AppBar
- Empty
- Error
- BaseStatePage

所有业务页面都优先复用这里的组件，禁止重复造轮子。

---

# 5. 核心架构说明

项目采用：

- GetX
- MVVM
- Repository
- Service
- Module 化目录

推荐理解为：

```text
View -> Controller -> Repository -> Network/Storage
```

## 5.1 各层职责

### View
负责：
- 页面展示
- 响应状态
- 调用 Controller 方法

不要在 View 里做：
- 网络请求
- 复杂业务逻辑
- 数据解析

### Controller
负责：
- 管理页面状态
- 响应交互
- 调用 Repository
- 状态切换（loading / success / error）

### Repository
负责：
- 数据来源整合
- 请求接口
- 读取缓存
- 返回 `Result<T>`

### Service
负责：
- 跨模块公共能力
- 全局能力封装

例如：
- `AuthService`
- `ThemeService`
- `LocaleService`
- `PermissionService`
- `UploadService`

---

# 6. 开发一个新模块的标准流程

新手开发最推荐按下面步骤来。

---

## 6.1 用脚本生成模块

```bash
./scripts/gen_module.sh order
```

生成后会得到：

```text
lib/app/modules/order/
├── bindings/order_binding.dart
├── controllers/order_controller.dart
├── models/
├── repositories/order_repository.dart
├── views/order_page.dart
└── widgets/
```

---

## 6.2 注册路由

### 第一步：在 `app_routes.dart` 增加常量

例如：

```dart
static const String order = '/order';
```

### 第二步：在 `app_pages.dart` 注册页面

需要注册：
- route name
- page
- binding
- middleware（如果需要登录）

---

## 6.3 写 Model

放在：

```text
lib/app/modules/order/models/
```

示例规范：
- 一个文件一个 model
- 使用 `factory fromJson`
- 不要把 UI 逻辑写进 model

---

## 6.4 写 Repository

放在：

```text
lib/app/modules/order/repositories/order_repository.dart
```

规范：
- Repository 调用 `NetworkService`
- 返回 `Result<T>`
- 不直接把异常抛到页面层

---

## 6.5 写 Controller

放在：

```text
lib/app/modules/order/controllers/order_controller.dart
```

规范：
- 用 `Rx` 管理状态
- 调用 Repository
- 管理 loading / error / data

---

## 6.6 写页面

放在：

```text
lib/app/modules/order/views/order_page.dart
```

规范：
- 优先使用 `shared/` 中的通用组件
- 文案必须走国际化
- 颜色、间距、圆角必须走 token

---

# 7. 页面开发规范

这是新手最容易踩坑的部分。

## 7.1 禁止这样写

- 直接在页面里写 Dio 请求
- 直接写 `Colors.blue`
- 直接写 `EdgeInsets.all(16)`
- 直接写中文文案
- 直接写裸 `TextField`
- 直接写裸 `ElevatedButton`

## 7.2 必须这样写

- 使用 `AppButton`
- 使用 `AppInput`
- 使用 `AppAppBar`
- 使用 `AppDialog`
- 使用 `AppToast`
- 使用 `AppLoading`
- 使用 `AppEmpty`
- 使用 `AppErrorView`
- 使用 `Spacing` / `AppRadius`
- 使用 `LocaleKeys.xxx.tr`
- 使用 `context.appTheme` / `context.appTextTheme`

---

# 8. 通用组件怎么用

共享导出入口：

```text
lib/app/shared/shared.dart
```

你可以直接：

```dart
import 'package:mbh/app/shared/shared.dart';
```

---

## 8.1 AppButton

适合主要按钮、次要按钮、文字按钮。

支持：
- loading
- primary / secondary / text

---

## 8.2 AppInput

统一输入框组件。

支持：
- label
- hint
- 密码输入
- 键盘类型
- onChanged

---

## 8.3 AppDialog

统一确认弹窗。

示例：

```dart
final confirmed = await AppDialog.confirm(
  title: 'Title',
  message: 'Message',
);
```

---

## 8.4 AppToast

统一轻提示。

```dart
AppToast.show('保存成功');
```

---

## 8.5 BaseStatePage

用于页面级 loading 遮罩。

适合表单提交、页面刷新等场景。

---

# 9. 网络请求怎么写

网络入口：

- `NetworkService`
- `ApiClient`
- `DioFactory`

拦截器已内置：
- HeaderInterceptor
- AuthInterceptor
- TokenRefreshInterceptor
- RetryInterceptor
- LoggingInterceptor
- ErrorInterceptor

## 9.1 在 Repository 中发请求

推荐模式：

```dart
final response = await _networkService.apiClient.get<T>(
  '/path',
  fromJsonT: T.fromJson,
);
```

然后统一返回：

- `Success<T>`
- `FailureResult<T>`

## 9.2 为什么不让页面直接发请求

因为这样会导致：
- 逻辑分散
- 错误处理不统一
- 难以测试
- AI 生成越来越混乱

---

# 10. 本地存储怎么用

项目内置四类存储。

## 10.1 GetStorage

适合：
- 首启标记
- 当前语言
- 当前主题
- 轻量配置

入口：
- `AppStorage`

## 10.2 Secure Storage

适合：
- access token
- refresh token
- 敏感信息

入口：
- `SecureStorageService`

## 10.3 Hive

适合：
- 本地对象缓存
- 轻量缓存

入口：
- `HiveService`
- `HiveBoxes`

## 10.4 SQLite

适合：
- 更复杂数据结构
- 离线记录
- 历史列表
- 本地业务表

入口：
- `AppDatabase`
- `AppKvDao`

---

# 11. 路由怎么写

路由定义在：

- `app_routes.dart`
- `app_pages.dart`

项目使用 GetX 路由。

## 11.1 路由注册步骤

1. 在 `AppRoutes` 增加路由常量
2. 在 `AppPages.pages` 中注册 `GetPage`
3. 添加 Binding
4. 需要登录的页面挂 `AuthMiddleware`

## 11.2 已内置中间件

- `AuthMiddleware`：未登录拦截
- `GuestMiddleware`：已登录不允许进登录页
- `OnboardingMiddleware`：首启引导

---

# 12. 主题系统怎么扩展

主题文件在：

- `app_theme.dart`
- `app_theme_extension.dart`
- `app_colors.dart`
- `app_text_styles.dart`
- `tokens/`

## 12.1 如果要增加颜色

在 `AppColors` 增加语义化颜色，不要直接写十六进制到页面里。

## 12.2 如果要增加间距

在 `Spacing` 增加，不要页面里乱写 `8 / 12 / 16 / 20`。

## 12.3 页面中如何拿主题

```dart
context.appTheme
context.appTextTheme
context.appColorScheme
```

---

# 13. 国际化怎么扩展

语言文件：

- `zh_cn.dart`
- `en_us.dart`
- `ru_ru.dart`

key 定义：
- `locale_keys.dart`

## 13.1 增加一个新文案

步骤：

1. 在 `LocaleKeys` 增加 key
2. 在三份翻译文件都补上
3. 页面中使用：

```dart
LocaleKeys.xxx.tr
```

## 13.2 命名规范

推荐：

```text
auth.login.title
home.dashboard.empty
settings.language.title
common.confirm
```

---

# 14. 日志系统怎么用

入口：
- `AppLogger`

支持级别：
- debug
- info
- warn
- error
- fatal

示例：

```dart
final logger = Get.find<AppLogger>();
logger.debug('debug');
logger.info('info');
logger.warn('warn');
logger.error('error');
logger.fatal('fatal');
```

日志输出到：
- 控制台
- 本地文件

---

# 15. 崩溃监控怎么接入

接口：
- `CrashReporter`

当前实现：
- `SentryReporter`
- `NoopCrashReporter`

你需要做的：
- 把 `YOUR_SENTRY_DSN` 替换成真实 DSN
- 在生产环境启用崩溃上报

---

# 16. WebSocket 怎么用

入口：
- `WsClient`

功能：
- connect
- disconnect
- send
- 自动重连
- 心跳
- 消息流

适合：
- IM
- 实时通知
- 看板刷新
- 实时状态更新

---

# 17. 权限怎么申请

统一入口：
- `PermissionService`

支持：
- 相机
- 相册
- 定位
- 通知
- 存储
- 麦克风

不要在页面里直接依赖 `permission_handler`，一律走 `PermissionService`。

---

# 18. 文件上传怎么用

统一入口：
- `UploadService`

支持：
- 文件路径上传
- bytes 上传
- 进度回调

适合：
- 图片上传
- 视频上传
- 文档上传
- 后续扩展分片上传

---

# 19. AI / Cursor 使用建议

项目已经内置 AI 规则文件：

- `core/ai/ai_codegen_rules.dart`
- `core/ai/ai_page_contract.dart`
- `core/ai/ai_module_contract.dart`

## 19.1 推荐给 Cursor 的任务粒度

不要一次说：
- “帮我做完整订单模块”

建议拆成：
1. 生成 `order` 模块目录
2. 生成 `order` 的 model
3. 生成 `order_repository`
4. 生成 `order_controller`
5. 生成 `order_page`
6. 注册路由
7. 接入国际化

这样生成质量最高。

## 19.2 生成代码时必须遵守

- 不要硬编码颜色
- 不要硬编码间距
- 不要硬编码文案
- 不要在 View 里发请求
- 不要跳过 Repository
- 不要不注册 Binding

---

# 20. 常见开发流程（新手推荐）

## 场景 1：新增一个功能页面

1. 运行脚本生成模块或页面
2. 写 model
3. 写 repository
4. 写 controller
5. 写 view
6. 注册 route
7. 增加国际化 key
8. 本地运行测试

## 场景 2：接后端接口

1. 确认接口路径
2. 定义 request / response model
3. 在 repository 调用 `apiClient`
4. Controller 调用 repository
5. 页面只消费状态

## 场景 3：加设置项

1. 在 settings 模块增加 tile
2. 如需全局能力，优先放到 service
3. 文案走 i18n

---

# 21. 常见问题 FAQ

## Q1：为什么我不能在页面直接发请求？
因为页面应该只负责显示和交互，网络和数据逻辑必须由 Repository 统一处理。

## Q2：为什么要把主题、间距、颜色 token 化？
因为企业项目会长期演进，token 化可以保证统一、可改、可维护。

## Q3：为什么要统一组件？
因为通用组件让 UI 一致、研发效率更高、AI 生成更稳定。

## Q4：我想增加新语言怎么办？
新增一份 translation 文件，并在 `AppTranslations` 中注册。

## Q5：我想把某个模块拆成 package 可以吗？
可以。这个脚手架已经按模块化组织，后期很适合拆包。

---

# 22. 推荐新人第一周开发路线

## 第 1 天
- 跑通项目
- 阅读 `README.md`
- 阅读 `app.dart`
- 阅读 `app_initializer.dart`
- 阅读 `app_pages.dart`

## 第 2 天
- 阅读 `auth` 模块
- 阅读 `home` 模块
- 理解 Controller / Repository / View 的关系

## 第 3 天
- 新建一个练习模块，如 `demo_feature`
- 自己注册路由
- 自己增加国际化 key

## 第 4~5 天
- 接一个简单接口
- 写一个列表页面
- 用 `AppLoading` / `AppErrorView` / `AppEmpty` 统一处理状态

## 第 6~7 天
- 学会使用脚本生成页面和模块
- 学会扩展主题、国际化、路由
- 学会提规范的 Cursor Prompt

---

# 23. 推荐命令汇总

## 安装依赖

```bash
fvm flutter pub get
```

## 运行开发环境

```bash
fvm flutter run -t lib/main.dart
```

## 运行生产环境

```bash
fvm flutter run -t lib/main_prod.dart
```

## 分析代码

```bash
fvm flutter analyze
```

## 运行测试

```bash
fvm flutter test
```

## 生成新模块

```bash
./scripts/gen_module.sh order
```

## 生成新页面

```bash
./scripts/gen_page.sh order order_detail
```

## 构建开发包

```bash
./scripts/build_dev.sh
```

## 构建生产包

```bash
./scripts/build_prod.sh
```

---

# 24. 你接下来最应该做什么

如果你是新手，建议你按这个顺序继续：

1. 先把项目跑起来
2. 看懂 `auth`、`home`、`settings` 三个模块
3. 自己新建一个小模块练手
4. 再接真实后端接口
5. 最后再开始生成复杂业务模块

---

# 25. 后续建议

接下来建议优先补充：

- 真实登录 API 协议
- 真实 Dashboard API
- 真实 Profile API
- 版本检测服务
- 分片上传实现
- 埋点系统
- 自动化测试
- Drift 替代复杂 SQLite 场景

---

如果你愿意，我下一步还可以继续帮你生成：

1. `新手开发任务清单` 版文档
2. `团队协作规范文档`
3. `适合 Cursor 的 Prompt 模板大全`
4. `接口接入规范文档`

你只要回复一个数字，我就继续给你。