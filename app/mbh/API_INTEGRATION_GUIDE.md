# 接口接入规范文档（MBH Enterprise Flutter Scaffold）

本规范用于指导团队成员在当前 Flutter 企业级脚手架中，以统一、可维护、可扩展的方式接入后端接口。

适用目标：
- 新手快速上手接口接入
- 保持团队接口层风格统一
- 降低后期维护成本
- 保证与当前脚手架架构完全一致

---

# 1. 接口接入总原则

在本项目中，接口接入必须遵守以下原则：

1. 页面层不能直接发请求
2. Controller 不能直接依赖 Dio
3. 所有接口必须经由 Repository 调用
4. 所有接口结果统一返回 `Result<T>`
5. 所有异常统一转换成 `FailureResult<T>`
6. 所有后端响应统一通过 `ApiClient` + `ResponseParser` 解析
7. 所有需要登录的接口必须依赖统一 token 注入机制
8. 所有用户可见错误提示必须在 Controller 层或更上层统一处理
9. Model 必须与页面展示逻辑解耦
10. 不允许在接口接入时写硬编码业务 UI

---

# 2. 当前项目接口层结构

接口接入相关核心文件：

```text
lib/app/core/network/
├── client/
│   ├── api_client.dart
│   └── dio_factory.dart
├── interceptors/
│   ├── auth_interceptor.dart
│   ├── token_refresh_interceptor.dart
│   ├── retry_interceptor.dart
│   ├── logging_interceptor.dart
│   ├── header_interceptor.dart
│   └── error_interceptor.dart
├── models/
│   └── api_response.dart
├── parser/
│   └── response_parser.dart
└── network_service.dart
```

业务模块中的接口接入位置：

```text
lib/app/modules/<module>/
├── models/
├── repositories/
└── controllers/
```

---

# 3. 标准数据流

接口接入的数据流必须是：

```text
View
  -> Controller
    -> Repository
      -> NetworkService
        -> ApiClient
          -> Dio
            -> Interceptors
              -> Server
```

返回流程：

```text
Server
  -> Dio Response
    -> ResponseParser
      -> ApiResponse<T>
        -> Repository
          -> Result<T>
            -> Controller
              -> UI State
```

---

# 4. 接一个新接口的标准步骤

假设你要接入一个“订单列表”接口。

---

## 第一步：定义 Model

目录：

```text
lib/app/modules/order/models/
```

例如：

- `order_item.dart`
- `order_list_request.dart`

### 要求

1. 一个文件一个模型
2. 使用 `factory fromJson` 解析响应
3. 请求体用 `toJson()` 输出
4. Model 只处理数据结构，不处理 UI

### 示例

```dart
class OrderItem {
  const OrderItem({
    required this.id,
    required this.title,
    required this.status,
  });

  final String id;
  final String title;
  final String status;

  factory OrderItem.fromJson(Object? json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return OrderItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      status: map['status'] as String? ?? '',
    );
  }
}
```

---

## 第二步：在 Repository 中接入接口

目录：

```text
lib/app/modules/order/repositories/order_repository.dart
```

### 要求

1. Repository 继承 `BaseRepository`
2. 通过 `Get.find<NetworkService>()` 获取网络服务
3. 返回值必须是 `Result<T>`
4. 成功返回 `Success<T>`
5. 异常返回 `FailureResult<T>`

### 示例

```dart
import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_repository.dart';
import 'package:mbh/app/core/base/result.dart';
import 'package:mbh/app/core/errors/error_handler.dart';
import 'package:mbh/app/core/network/network_service.dart';
import 'package:mbh/app/modules/order/models/order_item.dart';

class OrderRepository extends BaseRepository {
  OrderRepository() : _networkService = Get.find<NetworkService>();

  final NetworkService _networkService;

  Future<Result<List<OrderItem>>> fetchOrderList() async {
    try {
      final response = await _networkService.apiClient.get<List<dynamic>>(
        '/orders',
        fromJsonT: (Object? json) => json as List<dynamic>,
      );

      if (response.success && response.data != null) {
        final items = response.data!
            .map((dynamic e) => OrderItem.fromJson(e))
            .toList();
        return Success<List<OrderItem>>(items);
      }

      return FailureResult<List<OrderItem>>(
        ErrorHandler.handle(Exception(response.message)),
      );
    } catch (e, s) {
      return FailureResult<List<OrderItem>>(ErrorHandler.handle(e, s));
    }
  }
}
```

---

## 第三步：在 Controller 中消费 Repository

目录：

```text
lib/app/modules/order/controllers/order_controller.dart
```

### 要求

1. Controller 继承 `BaseController`
2. Controller 只负责状态管理和业务编排
3. 不直接处理底层网络异常
4. 不直接解析 JSON

### 示例

```dart
class OrderController extends BaseController {
  OrderController(this._repository);

  final OrderRepository _repository;

  final RxList<OrderItem> orderList = <OrderItem>[].obs;
  final RxBool hasError = false.obs;

  Future<void> loadOrders() async {
    showLoading();
    hasError.value = false;

    final result = await _repository.fetchOrderList();

    hideLoading();

    result.when(
      success: (data) {
        orderList.assignAll(data);
      },
      failure: (failure) {
        hasError.value = true;
        AppToast.show(failure.message);
      },
    );
  }
}
```

---

## 第四步：页面消费状态

页面只关心：
- loading
- error
- empty
- success

不要在页面里调用 `ApiClient` 或直接写 try-catch。

---

# 5. GET / POST / PUT / DELETE 标准写法

当前项目已在 `ApiClient` 中封装：

- `get<T>()`
- `post<T>()`
- `put<T>()`
- `delete<T>()`

---

## 5.1 GET

```dart
final response = await _networkService.apiClient.get<UserProfile>(
  '/user/profile',
  fromJsonT: UserProfile.fromJson,
);
```

---

## 5.2 POST

```dart
final response = await _networkService.apiClient.post<LoginResponse>(
  '/auth/login',
  data: request.toJson(),
  fromJsonT: LoginResponse.fromJson,
);
```

---

## 5.3 PUT

```dart
final response = await _networkService.apiClient.put<UserProfile>(
  '/user/profile',
  data: request.toJson(),
  fromJsonT: UserProfile.fromJson,
);
```

注意：如果当前 `ApiClient.put()` 没有 `fromJsonT` 参数以外的复杂需求，请在仓储中统一处理。

---

## 5.4 DELETE

```dart
final response = await _networkService.apiClient.delete<void>(
  '/orders/123',
  fromJsonT: (_) => null,
);
```

---

# 6. 关于后端响应格式

当前脚手架默认后端返回结构类似：

```json
{
  "code": 0,
  "message": "success",
  "success": true,
  "data": {}
}
```

对应模型：
- `ApiResponse<T>`

如果你的后端实际格式不同，例如：

```json
{
  "status": 200,
  "msg": "ok",
  "result": {}
}
```

那么你必须同步调整：

- `lib/app/core/network/models/api_response.dart`
- `lib/app/core/network/parser/response_parser.dart`

不要在业务模块里“各自兼容”，必须全局统一。

---

# 7. 错误处理规范

项目已经内置：

- `AppException`
- `Failure`
- `ErrorCode`
- `ErrorMapper`
- `ErrorHandler`
- `Result<T>`

## 7.1 Repository 层必须统一 catch

不要写成：

```dart
throw e;
```

必须写成：

```dart
return FailureResult<T>(ErrorHandler.handle(e, s));
```

---

## 7.2 Controller 层统一处理失败

Controller 中只做：
- 改状态
- 弹提示
- 页面跳转

例如：

```dart
result.when(
  success: (data) {
    // 更新状态
  },
  failure: (failure) {
    AppToast.show(failure.message);
  },
);
```

---

## 7.3 页面层不要处理底层错误

页面层不能直接：
- try/catch 接口异常
- 解析 DioException
- 识别错误码

这些都应该已经在 Repository 层被统一处理掉。

---

# 8. Token 接入规范

当前脚手架已内置：

- `SecureStorageService`
- `AuthService`
- `AuthInterceptor`
- `TokenRefreshInterceptor`

## 8.1 登录成功后

必须通过：

```dart
_authService.saveSession(
  accessToken: data.accessToken,
  refreshToken: data.refreshToken,
);
```

不要自己直接写 SecureStorage。

## 8.2 需要登录的接口

不要手动在 Repository 里拼接 `Authorization`。

因为：
- `AuthInterceptor` 已经负责加 token
- `TokenRefreshInterceptor` 已经负责处理刷新逻辑

## 8.3 退出登录

必须通过：

```dart
await _authService.clearSession();
```

不要在各个模块里自己删 token。

---

# 9. 文件上传接口规范

统一走：
- `UploadService`

不要在页面里直接用 Dio 上传文件。

## 9.1 文件路径上传

```dart
await uploadService.uploadFile(
  path: '/upload/image',
  filePath: file.path,
  onProgress: (progress) {
    // 更新进度
  },
);
```

## 9.2 字节流上传

```dart
await uploadService.uploadBytes(
  path: '/upload/file',
  bytes: bytes,
  fileName: 'avatar.png',
);
```

---

# 10. 分页接口接入建议

当前脚手架还没有单独抽 `PageResponse<T>`，但推荐按下面模式处理。

后端返回：

```json
{
  "code": 0,
  "message": "success",
  "success": true,
  "data": {
    "list": [],
    "page": 1,
    "pageSize": 20,
    "total": 100
  }
}
```

建议定义：

- `page_result.dart`
- `page_query.dart`

Repository 返回：

- `Result<PageResult<OrderItem>>`

Controller 管理：
- 当前页
- 是否还有更多
- 是否首次加载
- 是否上拉加载中

如果你后续要做分页模块，我建议专门抽一套分页基类。

---

# 11. 缓存接口接入建议

如果某个接口需要缓存，推荐：

```text
Repository
  -> 先查 CacheService
  -> 无缓存则请求网络
  -> 成功后写缓存
  -> 返回统一数据
```

例如：

```dart
final cached = _cacheService.readPersistentCache('home_dashboard');
if (cached != null) {
  // 先返回缓存，或作为兜底
}
```

## 11.1 缓存 key 命名建议

统一格式：

```text
module_name:resource_name[:id]
```

例如：
- `home:dashboard`
- `profile:detail:user_123`
- `order:list:page_1`

---

# 12. 新手最常见错误

## 错误 1：在页面里直接发请求

错误示例：

```dart
final dio = Dio();
await dio.get('/api');
```

正确做法：
- View -> Controller -> Repository -> NetworkService

---

## 错误 2：Repository 直接返回原始 Response

错误示例：

```dart
Future<Response> fetchUser() async {
  return dio.get('/user');
}
```

正确做法：
- Repository 返回 `Result<UserProfile>`

---

## 错误 3：Controller 里解析 JSON

错误示例：

```dart
final map = jsonDecode(response.data);
```

正确做法：
- JSON 解析应在 Model / Repository 中完成

---

## 错误 4：到处写 try-catch

错误示例：
- View catch
- Controller catch
- Repository catch
- Service catch

正确做法：
- 以 Repository 作为统一错误收口层

---

## 错误 5：后端格式变了就在页面里兼容

错误做法会导致：
- 业务层到处 if/else
- 项目后期极难维护

正确做法：
- 改 `ApiResponse<T>` 和 `ResponseParser`
- 全局统一

---

# 13. 接口命名规范

## Repository 方法命名建议

### 查询
- `fetchProfile()`
- `fetchOrderList()`
- `fetchOrderDetail()`

### 新增
- `createOrder()`
- `createAddress()`

### 更新
- `updateProfile()`
- `updatePassword()`

### 删除
- `deleteOrder()`
- `deleteAddress()`

### 特殊动作
- `login()`
- `logout()`
- `refreshToken()`
- `uploadAvatar()`

---

# 14. 请求参数组织建议

复杂请求不要直接传很多零散参数。

不推荐：

```dart
fetchOrderList(String keyword, int page, int pageSize, String status)
```

推荐：

```dart
fetchOrderList(OrderListQuery query)
```

这样更方便：
- 维护
- 扩展
- 测试
- AI 生成

---

# 15. 返回数据组织建议

当页面需要的数据很多时，不要直接返回原始后端 model 给页面。

可以在 Repository 中做轻度转换，输出更适合页面消费的数据结构。

但注意：
- 不要把 UI 逻辑塞进 model
- 不要把 widget 相关信息放入数据层

---

# 16. 推荐的接口接入检查清单

每次接一个新接口前，先确认：

- [ ] 是否已有对应模块
- [ ] 是否已有对应 Repository
- [ ] 是否需要新增 Model
- [ ] 是否需要登录态
- [ ] 是否需要缓存
- [ ] 是否需要分页
- [ ] 是否需要上传
- [ ] 是否需要权限
- [ ] 是否需要国际化错误提示

接完后再检查：

- [ ] 是否返回 `Result<T>`
- [ ] 是否统一错误处理
- [ ] 是否没有在页面里直接发请求
- [ ] 是否没有硬编码 token
- [ ] 是否没有把 Response 暴露给页面层

---

# 17. 给 Cursor 的接口接入 Prompt 模板

你可以直接复制下面的 Prompt 给 Cursor。

---

## 模板 1：新增接口

```text
请在 `order_repository.dart` 中新增订单列表接口接入。

要求：
1. 使用当前项目的 `NetworkService` + `ApiClient`
2. 返回 `Result<List<OrderItem>>`
3. 统一错误处理为 `FailureResult`
4. 如果缺少 model，请同时生成 `OrderItem`
5. 不要修改无关页面
```

---

## 模板 2：新增复杂请求体

```text
请为订单搜索接口补充请求参数模型，并在 Repository 中接入。

要求：
1. 新增 `order_search_query.dart`
2. 请求参数使用 `toJson()`
3. Repository 返回 `Result<List<OrderItem>>`
4. 不要在 Controller 里拼接 Map
```

---

## 模板 3：控制器消费接口

```text
请让 `OrderController` 调用 `OrderRepository.fetchOrderList()`。

要求：
1. 增加 loading / error / list 状态
2. 成功时更新列表
3. 失败时调用 `AppToast.show()`
4. 不要在 Controller 里解析 JSON
```

---

# 18. 总结

一句话记住本项目接口接入规范：

```text
页面不碰请求，控制器不碰 Dio，仓储统一收口，结果统一 Result。
```

如果你严格遵循这个原则：
- 代码会更干净
- 结构会更稳定
- 团队协作会更顺畅
- Cursor 生成代码也会更可靠

---

如果你愿意，我下一步还可以继续帮你生成：

1. `团队协作规范文档`
2. `新人开发任务清单`
3. `接口分页规范补充文档`

回复数字即可。