---
title: "swift-设备信息类"
date: 2017-12-13
lastmod: 2017-12-13
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
reward: true
mathjax: false
---

设备信息类是iOS开发框架中必备工具类，通常包含哪些属性呢？

* UUID
* 广告标识idfa
* 机型
* 屏幕尺寸
* 屏幕类型。
* UI放大比例：做多屏幕适配，此处使用的是6PLUS作为基准。
* UI横向的放大比例：屏幕适配时使用，通常用于图片。
* 1像素线条比例

```swift
    /**
 *  设备屏幕尺寸类型
 */
@objc public enum YKDeviceScreenSizeType : Int {
    case none = 0
    /**
     *  4s设备的屏幕分辨率
     */
    case iPhone4S = 1
    /**
     *  5S设备的屏幕分辨率
     */
    case iPhone5S = 2
    /**
     *  6设备的屏幕分辨率
     */
    case iPhone6 = 3
    /**
     *  6Plus设备的屏幕分辨率
     */
    case iPhone6Plus = 4
    /**
     *  X设备的屏幕分辨率
     */
    case iPhoneX = 5
}

public class YKDevice : NSObject{
    
    private let KUUIDKey = "KUuidKey"
    private let YKDeviceScreenSize4S:CGSize = CGSize(width: 320, height: 480)
    private let YKDeviceScreenSize5S:CGSize = CGSize(width: 320, height: 568)
    private let YKDeviceScreenSize6:CGSize = CGSize(width: 375, height: 667)
    private let YKDeviceScreenSize6Plus:CGSize = CGSize(width: 414, height: 736)
    private let YKDeviceScreenSizeX:CGSize = CGSize(width: 375, height: 812)
    
    private static var sharedDevice = YKDevice()
    private var uuid:String!
    private var deviceScreenSize:CGSize!
    private var _deviceScreenSizeType:YKDeviceScreenSizeType!
    
    private var _horUIScale:CGFloat!
    private var _verUIScale:CGFloat!
    private var _uiScaleForSinglePx:CGFloat!
    
    /*
     uuid
     */
    public static func deviceUUID() ->String{
        return sharedDevice.uuid
    }
    
    /*
     获取机型
     */
    public static func deviceModel() ->String {
        return sharedDevice.model()
    }
    
    /*
     设备名称
     */
    public static func deviceName() ->String {
        return  UIDevice.current.name
    }
    
    /*
     系统版本号
     */
    public static func systemVersion() -> String {
        return UIDevice.current.systemName
    }
    
    /*
     idfa串
     */
    public static func idfaString() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    /*
     获取屏幕逻辑尺寸
     */
    public static func screenSize() -> CGSize {
        return sharedDevice.deviceScreenSize
    }
    
    /*
     获取屏幕尺寸类型
     */
    public static func deviceScreenSizeType() -> YKDeviceScreenSizeType {
        return sharedDevice._deviceScreenSizeType
    }
    
    /*
     水平方向的缩放比例，以6，7，8屏幕为基准。
     */
    public static func horUIScale() -> CGFloat {
        return sharedDevice._horUIScale
    }
    
    /*
     垂直方向的缩放比例，以6，7，8屏幕为基准。
     */
    public static func verUIScale() -> CGFloat {
        return sharedDevice._verUIScale
    }
    
    /*
     单像素在不同scale下的逻辑尺寸。
     */
    public static func uiScaleForSinglePx() -> CGFloat {
        return sharedDevice._uiScaleForSinglePx
    }
    
    /*
     获取屏幕的逻辑尺寸宽度。
     */
    public static func screenWidth() -> CGFloat {
        return sharedDevice.deviceScreenSize.width
    }
    
    /*
       获取屏幕的逻辑尺寸高度。
     */
    public static func screenHeight() -> CGFloat {
        return sharedDevice.deviceScreenSize.height
    }
    
    override init() {
        super.init()
        self.setUpDeviceUUID()
        self.setupDeviceInfo()
    }
    
    private func setUpDeviceUUID() {
        let userDefault = UserDefaults.standard
        let uuid:String? = userDefault.string(forKey:KUUIDKey)
        if uuid != nil && uuid!.count > 0 {
            self.uuid = uuid!
        }else{
            
            let uuidOjbect = CFUUIDCreate(nil)
            let uuidString = (String)(CFUUIDCreateString(nil, uuidOjbect))
            self.uuid = uuidString
            userDefault.set(uuidString, forKey: KUUIDKey)
            userDefault.synchronize()
        }
    }
    
    private func setupDeviceInfo() {
        self.deviceScreenSize = UIScreen.main.bounds.size
        
        if __CGSizeEqualToSize(self.deviceScreenSize, YKDeviceScreenSize4S) {
            _deviceScreenSizeType = YKDeviceScreenSizeType.iPhone4S
        }else if __CGSizeEqualToSize(self.deviceScreenSize, YKDeviceScreenSize5S) {
            _deviceScreenSizeType = YKDeviceScreenSizeType.iPhone5S
        }else if __CGSizeEqualToSize(self.deviceScreenSize, YKDeviceScreenSize6) {
            _deviceScreenSizeType = YKDeviceScreenSizeType.iPhone6
        }else if __CGSizeEqualToSize(self.deviceScreenSize, YKDeviceScreenSize6Plus) {
            _deviceScreenSizeType = YKDeviceScreenSizeType.iPhone6Plus
        }else if __CGSizeEqualToSize(self.deviceScreenSize, YKDeviceScreenSizeX) {
            _deviceScreenSizeType = YKDeviceScreenSizeType.iPhoneX
        }
        
        _horUIScale = deviceScreenSize.width/375.0
        _verUIScale = deviceScreenSize.height/667.0
    
        _uiScaleForSinglePx = 1.0/UIScreen.main.scale
    }
    
    
    private func model()->String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") {
            identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
}
    
```

注：没有考虑横竖屏切换时的情况。