# com.cordova.SnipImage
### Cordova SnipImage plugin(只适用于iOS端的Cordova截图插件)
####将iOS原生代码对Cordova插件的简单封装
![](https://github.com/polvae/SnipImage/blob/master/PlayerRecord.gif) <br>
js端代码(调用iOS原生代码)
```js
function begin(){

    cordova.exec(alertSuccess,alertFail,"PhotoSnipPlugin","coolMethod",["camera","1"]);

}
```
调用成功的回调函数
```
function alertSuccess(msg) {
    alert(msg);
}
```


调用失败的回调函数
```
function alertFail(msg) {
    alert('调用OC失败: ' + msg);
}
```
感谢[作者3tinkers/TKImageView](https://github.com/3tinkers/TKImageView)，我只是代码的搬运工...
