# Extensions of UITextField to forbid input
几个UITextField扩展，用来限制输入
---
eg: forbid emoji, only money decimal , limit length.<br>
如：禁止表情符， 限制金额格式， 限制长度。<br>

说明文档：[《探索之旅：扩展属性》](http://www.swifthumb.com/thread-14875-1-1.html)

Usage:
---
You can use these extensions with code:<br>
可以纯代码使用：<br>

```
textField.isMoney = true
```

Or in IB:<br>
或者简单地在IB里设置：<br>
![InputLimit](https://github.com/DingHub/ScreenShots/blob/master/UITextField%20(InputLimit)/tl2.png)


You can find an objective-C version here:<br>
在这里可以找到一个objective-C版本：[UITextField+InputLimit](https://github.com/DingHub/UITextField-InputLimit-)
