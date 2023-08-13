---
title: "swift委托"
date: 2014-09-11
lastmod: 2014-09-11
categories:
  - "swift"
tags:
  - "swift"
comment: true
toc: true
autoCollapseToc: false
contentCopyright: false
reward: true
mathjax: false
---

swift中的委托和objective-c中的类似。

### 一.协议支持required/optional
如果协议是optional协议

#### 1.协议接口存在与否的判断,
 调用方法、属性、下标索引等前面需要加上一个?
 >1.如果是nil值，也就是Optional.None，会跳过后面的操作不执行;
  
 >2.如果有值，就是Optional.Some，就会拆包(unwrap)，然后对拆包后的值执行后面的操作，来保证执行这个操作的安全性.

#### 2.声明与必选协议的不同之处。可选协议需要@objc

### 二.示例
1.完整示例代码

```objective-c
/**
游戏状态
*/
enum QQGameState :Int{
    case QQGameStateNone = 0
    case QQGameStateStart = 1
    case QQGameStatePlaying = 2
    case QQGameStatePause = 3
    case QQGameStateGameOver = 4
}


/**
游戏Delegate
*/
@objc protocol QQGameDelegate{
    func notifyPlayerState()
    optional func notifyGameState(gameState: Int)
    optional func notifyGameNotification(gameNotification: String)
    
}

/**
游戏事件类
*/
class QQGameStateEvent:QQGameDelegate{
    
    func notifyPlayerState() {
        println("notifyPlayerState!!!")
    }
    
    func notifyGameNotification(gameNotification: String) {
        println("game notification : \(gameNotification)")
    }
}


/**
游戏类
*/
class QQGame{
    private var _gameState:QQGameState = QQGameState.QQGameStateNone
    
    private var _gameDelegate:QQGameDelegate
    
    private var gameDelegate:QQGameDelegate{
        get{
            return self._gameDelegate
        }
        set{
            self._gameDelegate = newValue
        }
    }
    
    init(){
        
        self._gameDelegate = QQGameStateEvent();
        self.gameRunning();
    }
    
    func gameRunning(){
        
        //game start
        _gameDelegate.notifyGameState?(QQGameState.QQGameStateStart.toRaw());
        //game playing
        _gameDelegate.notifyGameState?(QQGameState.QQGameStatePlaying.toRaw());
        
        //game pause
        _gameDelegate.notifyGameState?(QQGameState.QQGameStatePause.toRaw());
        _gameDelegate.notifyGameNotification?("游戏停服更新!!!");
        //Game Over
        _gameDelegate.notifyGameState?(QQGameState.QQGameStateGameOver.toRaw());
        _gameDelegate.notifyGameNotification?("系统检测到你使用外挂，封号七天!!!");
        
        _gameDelegate.notifyPlayerState();
        
    }
}

```

#### 2.调用```objective-c

var game =  QQGame();
```

#### 3.日志```objective-c

game notification : 游戏停服更新!!!
game notification : 系统检测到你使用外挂，封号七天!!!
notifyPlayerState

```


### 三.小结
#### 1.?的使用场景:* 1.声明Optional值变量
* 2.在对Optional值操作中，用来判断是否能响应后面的操作
* 3.用于安全调用protocol的optional方法
* 4.使用 as? 向下转型(Downcast)

#### 2.!使用场景1.强制对Optional值进行拆包(unwrap)
2.声明Implicitly Unwrapped Optionals值，一般用于类中的属性

```objective-c

@IBOutlet weak var tableView:UITableView!
@IBOutlet weak  var nameLabel: ImplicitlyUnwrappedOptional<UILabel>

```

#### 3.和objective-c协议用法类似，仅仅是细节上的差异。
