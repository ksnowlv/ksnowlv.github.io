---
title: "swift-UI-控件初体验"
date: 2014-09-08
lastmod: 2014-09-08
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

### 现在我们体验**swift**下UI控件的使用   
>  * **UIButton** 
>  * **UIImageView**
>  * **UILabel** 
>  * **UITableView**

#### 1.**ViewController**继承`UITableViewDataSource`，`UITableViewDelegate`，重写相应方法。#### 2.声明`UIButton`/`UIImageView`/`UILabel`/UITableView四种控件和列表数据数组，定义按钮事件。#### 3.控件及事件在IB连好。![image](/images/post/2014-09-08-swift-ui-kong-jian-chu-ti-yan/swift_ui_overviw_ib.png)

#### 完整代码
``` objective-c

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var tableView:UITableView!
    var list:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var image : UIImage = UIImage(named:"qq_icon.jpg");
        self.list = ["kair","ksnowlv","snow","air","rain","krain","cloud","kcloud"];
        self.imageView.image = image;
        self.label.text = "ksnowlv";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        // The tag for each color was set in the storyboard for each button based
        // on the type of color.
        var alertView:UIAlertView = UIAlertView(title: "swift UIAlertView", message: "按钮被按下", delegate: nil, cancelButtonTitle: "ok");
        
        //title: String?, message: String?, delegate: AnyObject?, cancelButtonTitle: String?
        alertView.show();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.list.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let KTableViewCellIdentifier = "tableViewCellIdentifier";
        
        var cell = tableView.dequeueReusableCellWithIdentifier(KTableViewCellIdentifier) as UITableViewCell!
        
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier: KTableViewCellIdentifier)
        }
        
        var rowIndex = indexPath.row;
        
        if rowIndex < self.list.count{    
            cell.textLabel?.text = self.list.objectAtIndex(rowIndex) as NSString;
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        if self.tableView == tableView{
            return 50;
        }
        
        return 40;
    }   
    
}

```

#### 效果图
![image](/images/post/2014-09-08-swift-ui-kong-jian-chu-ti-yan/swift_run_overview.png)

#### 小结
    和objective-c下使用方法类似，优化方法大体相同，你原来的开发经验依然是很有用的。

