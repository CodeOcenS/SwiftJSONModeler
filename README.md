SwiftJSONModeler是一个Xcode插件，一键转换json字符串Swfit模型，一键转化 YApi 平台接口为模型，并且自动引入注释。
* 支持struct, class 
* 支持单json转模， 多层嵌套 json
* 支持YApi RAW或接口id解析转模，并且自动引入 YApi 平台注释和兼容数据类型
* 支持自定义遵循 和 import
* 支持自定义模型前缀和后缀
* 可设置隐式和显示可选类型，默认显示可选`?`(不使用则为隐式可选`!`)
* YApi 支持按照自定义路径解析模型，自动解析子类型


## json 转Swfit模型

复制单json, 一步转为模型。

![运行效果](./Sources/example.gif)

如果无法预览查看[传输门](https://github.com/yumengqing/SwiftJSONModeler/blob/master/Sources/example.gif)或者[Sources/example.gif](./Sources/example_hight.gif)

示例 json 数据：
```javaScript
{
            "title": "第一层 json",
            "stringValue": "字符串值",
            "intValue": 58,
            "doubleValue": 18.2,
            "nullValue": null,
            "boolValue": true,
            "subJson": {
                "title": "第二层 json",
                "stringValue": "字符串值"
            },
            "arrayValue1": [
                "value1",
                "value2",
                "value3"
            ],
            "arrayValue2": [{
                "title": "数组包含子 json",
                "intValue": 12,
                "boolValue": false
            }]
        }
```
Swift模型
```swift
///
struct HKModel: HandyJSON {
    
    var arrayValue2: [HKArrayValue2Model] = []
    
    var nullValue: NSNull?
    
    var intValue: Int?
    
    var arrayValue1: [String] = []
    
    var title: String?
    
    var stringValue: String?
    ///
    var subJson: HKSubJsonModel?
    
    var doubleValue: Double?
    
    var boolValue: Int?
}

///
struct HKArrayValue2Model: HandyJSON {
    
    var title: String?
    
    var boolValue: Int?
    
    var intValue: Int?
}

///
struct HKSubJsonModel: HandyJSON {
    
    var title: String?
    
    var stringValue: String?
}

```
支持多层嵌套 josn， 高亮提示 json 中 `null`类型， 类型自动判断。

## YApi 接口平台转模支持

什么是 YApi，YApi 是一个可本地部署的、打通前后端及QA的、可视化的接口管理平台，[github 地址](https://github.com/YMFE/yapi)

复制YApi接口RAW数据，一步解析带有注释的模型。
解析效果如下()：

![解析YApi](./Sources/YApiRAW.gif)

如果无法预览查看[Source/YApiRAW.gif](./Sources/YApiRAW.gif)

如果你使用YApi接口平台，我们支持两种方式，通过接口 Id）和 Raw 数据转模。一键转为模型，并且自动根据YApi为模型引入注释。

### 通过Id转模

在配置了项目token和host基础下,简单复制Id即可实现转模和添加注释.

**如何查看YApi接口中的id？**在YApi对应的接口中，查看浏览器网址，最后的数字就是Id。如下图：

![接口Id](./Sources/yapiHostId.png)

具体配置参考下面设置部分。

### RAW数据

**RAW数据**：即YApi接口平台提供的带有接口字段及注释的json数据，查看方式：选择接口 -> 编辑 -> 返回数据设置 -> RAW 如下图

![Alt](./Sources/YApiRAWData.png)

示例RAW数据：

```javascript
{"type":"object","title":"empty object","properties":{"message":{"type":"string"},"code":{"type":"string"},"response":{"type":"object","properties":{"teachers":{"type":"array","items":{"type":"object","properties":{"name":{"type":"string","mock":{"mock":"Mrs Yang"},"description":"名字"},"subject":{"type":"string","mock":{"mock":"语文"},"description":"科目"},"phone":{"type":"string","mock":{"mock":"13459923098"},"description":"联系电话"}},"required":["name","subject","phone"]},"description":"老师"},"name":{"type":"string","description":"姓名"},"age":{"type":"integer","mock":{"mock":"18"},"description":"年龄"},"score":{"type":"number","mock":{"mock":"89.8"},"description":"综合成绩"},"likes":{"type":"array","items":{"type":"string","mock":{"mock":"英雄联盟"}},"description":"爱好"},"emergercyContact":{"type":"object","properties":{"name":{"type":"string"},"phone":{"type":"string","description":"联系电话"},"address":{"type":"string","description":"联系地址","mock":{"mock":"xx街道xx栋xx单元"}}},"description":"紧急联系人","required":["name","phone","address"]},"isBoy":{"type":"boolean","description":"是否为男孩"}},"required":["teachers","name","age","score","likes","emergercyContact","isBoy"]}},"required":["message","code","response"]}
```

> 完整示例可下载打开SwiftJSONModelerDemo查看

### 解析指定路径模型

如果你数据有多层json, 可以在设置中指定解析路线path来获取指定模型。比如我的目标数据在response字段下，则可以配置path为`response`.则直接解析response下的json模型。多路径使用 `.`


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

## 设置
SwiftJSONModeler提供多种自定义可选设置，可通过插件的Config选项进行设置。

设置选项如下图：

![可选设置](./Sources/config.png)

**YApi模型路径指定**：当对象含有多层json,或者有基本json包裹时，可以指定path解析模型。

**YApi项目token**： 每个YApi项目都有唯一一个token,在YApi项目接口的设置中可以查看对应的token,如下图：

![token](./Sources/yapiToken.png)

**YApi项目host**：host就是部署YApi的地址

![host](./Sources/yapiHostId.png)

## 设置快捷键

可以给插件设置快捷键，快速转换模型

在Xcode -> Preference -> Key Bindings -> Editor Menu For Source Code【或者搜索】就可以找到，如下图

![](./Sources/keybinding.png)

记得双击key下面那个区域才可以编辑，这里我使用的是alt + s 和alt + c 避免与系统的冲突

