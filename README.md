# ADo_AvatarBrowser

#应产品经理要求自己封装了一个浏览头像的下框架
![ADo_AvatarBrowser](http://ww2.sinaimg.cn/mw690/8e4407e9jw1eukz6ldwqng20ac0igkjn.gif)
#特点
<br>双击图片放大或缩小  根据手势放大缩小  放大后拖动浏览细节 缩小后还原 长按手势保存图片到本地  单击后消失

#使用:
ADo_AvatarBrowser *browser = [[ADo_AvatarBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds image:btn.imageView.image view:btn];
<br>[browser show];
