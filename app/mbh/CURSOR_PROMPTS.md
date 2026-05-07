# Cursor Prompt 模板大全（适用于 MBH Enterprise Flutter Scaffold）

本文件用于指导团队成员如何在当前 Flutter 企业级脚手架中，正确、稳定地使用 Cursor / AI 生成代码。

目标：
- 提高生成成功率
- 减少无效大改
- 保持架构一致
- 保持代码风格统一
- 适合新手直接复制使用

---

# 1. 使用 Cursor 生成代码的总原则

在这个项目里，使用 Cursor 时必须遵守以下规则：

1. 不要一次性让 AI 生成一个完整超大模块
2. 优先按“模型 -> 仓储 -> 控制器 -> 页面 -> 路由”顺序拆分任务
3. 所有页面必须使用项目已有组件
4. 所有文案必须接入国际化
5. 所有颜色、间距、圆角必须走 Design Token
6. 所有业务请求必须走 Repository
7. 所有页面必须通过 Binding 注册依赖
8. 所有路由必须注册到 `AppRoutes` 和 `AppPages`
9. 需要登录的页面必须加 `AuthMiddleware`
10. 禁止在 View 里直接写网络请求和复杂逻辑

---

# 2. 推荐的提问方式

## 2.1 正确示例

### 小任务、边界清晰

- 帮我在 `order` 模块下生成 `order_list` 页面，使用现有脚手架规范。
- 帮我为 `auth` 模块补一个 `forgot_password` 页面，并注册路由。
- 帮我给 `profile` 模块增加 `ProfileRepository.fetchProfileDetail()` 方法。
- 帮我把 `settings` 模块的退出登录文案接入国际化。

### 指定约束

- 请严格使用当前项目的 `AppButton`、`AppInput`、`AppAppBar`，不要使用原生 `ElevatedButton`。
- 请严格遵循当前项目的 MVVM + Repository 结构。
- 请不要修改无关文件，只改这个模块所需内容。
- 请接入 `LocaleKeys`，不要写硬编码文案。

---

## 2.2 不推荐示例

- 帮我把整个订单系统都做完
- 帮我做一个商城 APP
- 帮我优化整个项目
- 帮我把所有页面都换掉

这些请求问题在于：
- 范围太大
- 容易失控
- 改动面过宽
- AI 难以保持结构一致

---

# 3. 通用 Prompt 模板

下面的模板可以直接复制使用。

---

## 模板 1：生成一个新模块

```text
你是一名资深 Flutter 企业级架构师。

请基于当前项目脚手架，为我生成一个新模块：`order`。

要求：
1. 严格遵循当前项目的目录结构
2. 使用 GetX + MVVM + Repository
3. 生成以下内容：
   - bindings/order_binding.dart
   - controllers/order_controller.dart
   - repositories/order_repository.dart
   - views/order_page.dart
4. 页面使用现有共享组件：AppAppBar / AppButton / AppLoading / AppEmpty
5. 不要写硬编码颜色和间距
6. 不要写硬编码文案
7. 不要修改无关模块
8. 如果需要路由，请同时更新 `AppRoutes` 和 `AppPages`
```

---

## 模板 2：为某个模块增加页面

```text
请基于当前项目脚手架，在 `order` 模块下新增页面：`order_detail_page.dart`。

要求：
1. 使用现有项目风格
2. 页面必须使用 `AppAppBar`
3. 文案必须接入 `LocaleKeys`
4. 样式必须使用 `Spacing` 和 `context.appTextTheme`
5. 不要写业务请求
6. 只生成页面 UI 和必要的路由注册
```

---

## 模板 3：生成一个 Repository 请求方法

```text
请在 `lib/app/modules/order/repositories/order_repository.dart` 中新增接口方法：`fetchOrderList()`。

要求：
1. 使用当前项目的 `NetworkService` 和 `ApiClient`
2. 返回类型必须是 `Result<List<OrderItem>>`
3. 错误必须统一用 `FailureResult`
4. 不要把异常直接抛给 Controller
5. 如果缺少 model，请同时补齐 `OrderItem`
6. 不要修改无关页面
```

---

## 模板 4：生成 Controller 状态逻辑

```text
请在 `order_controller.dart` 中增加列表加载逻辑。

要求：
1. 使用 `BaseController`
2. 增加：
   - loading 状态
   - error 状态
   - list 状态
3. 调用 `OrderRepository.fetchOrderList()`
4. 成功后更新列表
5. 失败后调用 `AppToast.show()`
6. 保持 Controller 简洁，不要写 UI 代码
```

---

## 模板 5：生成列表页面 UI

```text
请为 `order` 模块生成一个订单列表页 UI。

要求：
1. 使用 `GetView<OrderController>`
2. 使用 `AppAppBar`
3. 使用 `Obx` 响应状态
4. loading 时显示 `AppLoading`
5. 错误时显示 `AppErrorView`
6. 空数据时显示 `AppEmpty`
7. 列表项拆到 `widgets/order_list_item.dart`
8. 文案走国际化
9. 样式走 `Spacing`、`context.appTextTheme`、`context.appTheme`
```

---

## 模板 6：注册路由

```text
请把 `order` 模块接入当前项目路由系统。

要求：
1. 在 `AppRoutes` 中增加常量
2. 在 `AppPages.pages` 中注册 `GetPage`
3. 接入对应 Binding
4. 如果是登录后页面，请添加 `AuthMiddleware`
5. 不要修改无关路由
```

---

## 模板 7：接入国际化

```text
请为 `order` 模块接入国际化。

要求：
1. 在 `locale_keys.dart` 中增加 key
2. 同时更新：
   - zh_cn.dart
   - en_us.dart
   - ru_ru.dart
3. key 命名遵循：`order.list.title` 这种格式
4. 页面中改为 `LocaleKeys.xxx.tr`
5. 不要保留硬编码文案
```

---

## 模板 8：重构现有页面为脚手架风格

```text
请把当前页面重构为符合本项目脚手架规范的写法。

要求：
1. 使用现有共享组件，不使用原生 `AppBar` / `ElevatedButton` / `TextField`
2. 所有间距改为 `Spacing`
3. 所有文案改为国际化
4. 所有样式改为 `context.appTextTheme` / `context.appTheme`
5. 不改变现有业务逻辑
6. 不做无关重构
```

---

## 模板 9：生成设置项

```text
请为 `settings` 模块新增一个设置项：通知设置。

要求：
1. 使用现有 `SettingsTile`
2. 文案走国际化
3. 点击后跳转到新的通知设置页面
4. 通知设置页面也要注册路由
5. 路由需要 `AuthMiddleware`
```

---

## 模板 10：生成上传功能页面

```text
请基于当前脚手架，生成一个图片上传页面。

要求：
1. 使用 `UploadService`
2. 页面使用 `GetView<UploadController>`
3. 显示上传进度
4. 上传失败时使用 `AppToast.show()`
5. 页面 UI 使用现有组件和 Design Token
6. 不要直接在页面里写 Dio 上传逻辑
```

---

# 4. 场景化 Prompt 模板

---

## 4.1 登录模块开发 Prompt

```text
请完善当前项目中的 `auth` 模块登录流程。

要求：
1. 保持现有脚手架架构
2. `LoginController` 通过 `AuthRepository` 调用登录接口
3. 登录成功后调用 `AuthService.saveSession()`
4. 登录失败后使用 `AppToast.show()`
5. 页面继续使用 `AppInput` 和 `AppButton`
6. 文案全部接入 `LocaleKeys`
7. 不要修改无关模块
```

---

## 4.2 列表 + 详情页 Prompt

```text
请在 `product` 模块中实现列表页和详情页骨架。

要求：
1. 模块结构遵循当前项目规范
2. 列表页：
   - AppAppBar
   - AppLoading / AppErrorView / AppEmpty
   - List item 拆到 widgets
3. 详情页：
   - AppAppBar
   - 信息卡片使用 `AppCard`
4. Repository 统一处理数据请求
5. 路由统一注册
6. 所有页面都不要写硬编码 UI 参数
```

---

## 4.3 表单页 Prompt

```text
请生成一个新增地址页面 `address_form_page.dart`。

要求：
1. 使用 `AppInput`
2. 使用 `AppButton`
3. 使用 `BaseStatePage` 处理提交 loading
4. Controller 中管理表单字段状态
5. 提交逻辑调用 Repository
6. 成功后提示并返回
7. 所有文案接入国际化
```

---

# 5. 约束型 Prompt 模板

如果你担心 Cursor 改太多，可以加下面这些约束。

---

## 模板 11：限制改动范围

```text
请只修改以下文件：
- lib/app/modules/order/controllers/order_controller.dart
- lib/app/modules/order/repositories/order_repository.dart

不要修改其他文件。
```

---

## 模板 12：禁止大范围重构

```text
请不要做大范围重构。
只补齐当前需求所需代码。
不要调整无关文件的命名、结构和导入。
```

---

## 模板 13：要求最小改动

```text
请以最小改动方式完成。
优先复用已有基础设施，不要重新实现已有能力。
```

---

## 模板 14：要求使用现有组件

```text
请必须使用项目中已有组件：
- AppAppBar
- AppButton
- AppInput
- AppDialog
- AppToast
- AppLoading
- AppEmpty
- AppErrorView
```

---

# 6. 调试类 Prompt 模板

---

## 模板 15：修复编译错误

```text
请帮我修复当前 Flutter 编译错误。

要求：
1. 先分析报错原因
2. 只修复和当前报错直接相关的问题
3. 不做无关重构
4. 修复后确保符合当前项目脚手架规范
```

---

## 模板 16：修复路由问题

```text
请帮我检查当前页面无法跳转的原因。

优先排查：
1. AppRoutes 是否定义
2. AppPages 是否注册
3. Binding 是否接入
4. Middleware 是否错误拦截
5. 控制器是否正确注入
```

---

## 模板 17：修复国际化问题

```text
请帮我检查当前页面国际化失效的原因。

优先排查：
1. LocaleKeys 是否定义
2. zh/en/ru 是否都补齐
3. 页面是否使用 `LocaleKeys.xxx.tr`
4. 是否存在硬编码文案
```

---

# 7. 高质量 Prompt 写法公式

推荐你以后按这个公式提问：

```text
任务目标
+ 改动范围
+ 架构约束
+ UI 约束
+ 路由约束
+ 国际化约束
+ 不要做什么
```

例如：

```text
请在 `profile` 模块新增编辑资料页面。
只修改 profile 模块和路由文件。
严格使用当前脚手架的 GetX + MVVM + Repository。
页面必须使用 AppAppBar、AppInput、AppButton。
文案必须接入国际化。
路由必须注册到 AppRoutes 和 AppPages，并加 AuthMiddleware。
不要修改无关模块，不要做大范围重构。
```

---

# 8. 新手最推荐的 10 个 Cursor Prompt

如果你刚开始上手，可以从下面 10 个开始。

1. 生成一个新模块
2. 为某个模块新增一个页面
3. 给某个模块补一个 Repository 请求
4. 为页面增加 loading / error / empty 三态
5. 给页面接入国际化
6. 把旧页面重构为共享组件风格
7. 注册一个新路由
8. 新增一个设置项
9. 新增一个表单页
10. 修复一个具体编译错误

---

# 9. 最后建议

如果你希望 Cursor 更稳定：

- 一次只提一个小任务
- 明确文件范围
- 明确架构限制
- 明确 UI 限制
- 明确“不允许做什么”

这样生成质量会非常高。

---

如果你愿意，我下一步还可以继续帮你生成：

1. `团队协作规范文档`
2. `接口接入规范文档`
3. `新人开发任务清单`

回复数字即可。