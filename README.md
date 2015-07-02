# HaidoraCommonWrapperSwift

常用代码的封装.

##How to use

###HDAlertViewManager(再也不用XXXAlertView)

```
Objective-C

+ (void)alertWithMessage:(NSString *)message;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle;
// Swift兼容Objective-C版本,多个参数用数组代替
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message clickAction:(void (^)(id view, NSInteger index))clickAction cancelTitle:(NSString *)cancelTitle moreButtonTitles:(NSArray *)moreButtonTitles;
+ (void)alertWithError:(NSError *)error;

Swift

class func alertWithMessage(message: String)
class func alertWithTitle(title: String, message: String)
class func alertWithTitle(title: String, message: String, cancelTitle: String, okTitle: String?)
class func alertWithTitle(title: String, message: String, clickAction: ((AnyObject, Int) -> Void)?, cancelTitle: String, _ moreButtonTitles: String...)
class func alertWithError(error: NSError)
```

###NSError,弹出自定义错误提示

```
Objective-C

NSError *error = [[NSError alloc]initWithTitle:@"Custom Title" message:@"Custom Message"];

Swift

var error = NSError(title: "Custom Title", message: "Custom Message")
```

###自定义弹出框

```
//实现HDAlertDelegate
class XXXAlertView: HDAlertDelegate {
}
//配置HDAlertViewManager参数
HDAlertViewManager.shareInstance().alertDelegate = XXXAlertView()

```

##Installation

###Manually

[Download the latest tag](https://github.com/Haidora/HaidoraCommonWrapperSwift/tags) and drag the sources into your Xcode project.

###Git Submodule

```
git submodule add https://github.com/Haidora/HaidoraCommonWrapperSwift.git
git submodule update --init
```

###CocoaPods

可以通过[HaidoraPods](https://github.com/Haidora/HaidoraPods)来安装。Podfile如下:

```ruby
pod "HaidoraCommonWrapperSwift"
//or
pod 'HaidoraCommonWrapperSwift', :git => 'https://github.com/Haidora/HaidoraCommonWrapperSwift.git', :branch => 'developer'
```

###CocoaSeeds
可以通过[CocoaSeeds](https://github.com/devxoul/CocoaSeeds)来安装。Seedfile如下:
```
github "Haidora/HaidoraCommonWrapperSwift", "0.1.1", :files => "Pod/Classes/AlertView/*.{swift,h}"
```

## Requirements

* iOS 7.0+
* Xcode 6.3.2

## Contact

[Mrdaios](mailto:mrdaios@gmail.com)

## License

HaidoraCommonWrapperSwift is available under the MIT license. See the LICENSE file for more info.
