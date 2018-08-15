# JWExtractString

## 对于圆角的离屏渲染的一些尝试替代方案

1.遮罩mask（并不能规避掉离屏渲染）   

2.对image利用贝塞尔曲线和UIGraphicsBeginImageRef重新画image 因为用到了drawInRect:带来了CPU上的“离屏渲染”

3.利用组合图层方式 （能比较好的规避掉离屏渲染）但依然还是要视情况而定（比如圆角轨迹比较复杂的视图）   
   个人意见觉得是比较值得推荐的（如果视图非常复杂还是需要再做考虑）    
   
4.得益于苹果开发团队，iOS9以后 UIButton UIImageView控件在存在contents的情况下设置cornradius不需要maskToBounds开启，避免了离屏渲染问题    

    self.headerBtn.layer.backgroundColor = [UIColor blueColor].CGColor;
    self.headerBtn.layer.cornerRadius = 30.0f;

    self.headerBtn.imageView.layer.cornerRadius = 30.0f;
    

## 满足有头像显示头像 无头像显示姓氏   

 对于组合图层方式可以比较好的呃解决圆角带来的离屏渲染问题，但因为此需求里 无image时显示姓氏    
    
 涉及到字符串的汉字 复姓 英文大写等问题
 
 
 
## 最后说一句😂     

这只是个demo 为了验证和显示 并没有抽取出来 可能后面会把这个抽离出来做个组件
