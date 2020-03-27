SwiftJSONModeler是一个Xcode插件，可以将json 转为模型
* 支持struct, class 
* 支持标准单json和YApi RAW（自动为你添加注释）
* 支持自定义遵循 和 import
* 支持自定义模型前缀和后缀
* 可设置是否类型可选，是否使用显示可选`?`(不使用则为隐式可选`!`)
* YApi RWA支持按照路径解析模型，自动解析子类型

## 效果图

### 标准json 解析

复制单json, 一步转为模型。

![运行效果](./Sources/example.gif)
如果无法预览查看Sources/example.gif

### YApi RAW解析

复制YApi接口RAW数据，一步解析模型。如果配置为继承和引入HandyJSON， 添加JD模型前缀和Model后缀，解析效果如下：

![解析YApi](./Sources/YApiRAW.gif)

如果无法预览查看Source/YApiRAW.gif

## 安装
1.你可以选择[Release](https://github.com/yumengqing/SwiftJSONModeler/releases) 直接下载应用安装

2.你也可以选择下载源代码编译为应用
下载项目工程，修改为自己的bundleId

运行主项目SwiftJSONModeler For Xcode

再运行SwiftJSONModeler

确保没有报错的情况下，选择Products下的运行主项目SwiftJSONModeler For Xcode.app点击右键， 选择show in finder如下图

![](./Sources/showfinder.png)

再将应用移动到应用程序, 重启Xcode即可使用。

> Tip:如果重启Xcode之后在Editor中还没看见插件选项，请选择系统设置-> 扩展->Xcode Source Editor中对应插件是否导入

### 设置快捷键

可以给插件设置快捷键，快速转换模型

在Xcode -> Preference -> Key Bindings -> Editor Menu For Source Code【或者搜索】就可以找到，如下图

![](./Sources/keybinding.png)

记得双击key下面那个区域才可以编辑，这里我使用的是alt + s 和alt + c 避免与系统的冲突
### Model设置
模型设置提供一些自定义控制，具体如下图：
![Alt](./Sources/config.png)
### 自定义操作confrom 和import

可以通过点击应用或者选择扩展的config选项，自定义填写import模块和继承

比如我需要继承HandyJSON

![自定义遵循](./Sources/customConfig.png)

## 标准JSON转模

使用的使用，首先要选中需要转换的json,注意不标准的json会报错的哟。仅限单层json，多层json子json需要单独转换

示例json

```javascript
{
  "orderName": "擦护理洗车",
  "decription": "退还到原支付账户",
  "refund": 58,
  "total": 18.2,
  "name": null,
  "detail": {
    "id": 1387329,
    "date": "2018-08-08"
  },
  "tag": [
    "美容洗车",
    "活动",
    "护理"
  ]
}
```

转模结果

```swift
struct <#Model#>: HandyJSON {
    var name: <#NSNull#>?  // 字典为null 需要手动指定类型
    var decription: String?
    var orderName: String?
    var refund: Int?
    var tag: [String]?  // 自动识别数组（如果是基本类型）
    var detail: <#SubModel#>? // 需要再次转子json 模型
    var total: Double?
}
```

![效果图](./Sources/result.png)

## YApi 接口平台转模

如果你使用YApi接口平台，可以通过复制接口返回的 RAW数据，自动转为模型，并且自动根据YApi为模型添加注释。

### RAW数据

**RAW数据**：即YApi接口平台提供的带有接口字段及注释的json数据，查看方式：选择接口 -> 编辑 -> 返回数据设置 -> RAW 如下图

![Alt](./Sources/YApiRAWData.png)

示例RAW数据：

```swift
{"type":"object","title":"empty object","properties":{"person":{"type":"object","properties":{"name":{"type":"string","description":"姓名","mock":{"mock":"小明"}},"age":{"type":"integer","description":"年龄","mock":{"mock":"12"}},"school":{"type":"object","properties":{"address":{"type":"string","mock":{"mock":"xx街道xx号"},"description":"学校地址"},"schoolName":{"type":"string","description":"学校名字"}},"required":["address","schoolName"],"description":"学校"},"likes":{"type":"array","items":{"type":"string"},"description":"好友"},"teachers":{"type":"array","items":{"type":"object","properties":{"name":{"type":"string","description":"老师名字"},"subject":{"type":"string","description":"科目","mock":{"mock":"语文"}},"isMale":{"type":"boolean","description":"是否为男"}},"required":["name","subject","isMale"]}}},"required":["name","age","school","likes","teachers"],"description":"个人信息详情"}},"required":["person"]}
```

> 完整示例可下载打开SwiftJSONModelerDemo查看

### 解析指定路径模型

如果你数据有多层json, 可以在设置中指定解析路线path 比如想解析json data属性下的，则在path中添加`data`,也可以解析多层路径比如`data.person` 

## 待优化

* 直接解析出子json 或者 数组内子json
