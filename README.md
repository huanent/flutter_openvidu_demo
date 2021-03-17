# flutter_openvidu_demo
### 仓库包含 openvidu的flutter SDK 源码与演示demo

sdk包名为```kooboo_openvidu```

地址:```xxx```

## 注意项⚠️

将sdk集成到正式项目时请遵循依赖包对项目的修改,依赖包对环境有特殊的需求,例如安卓最低版本等,以下是需要配置的依赖包
* flutter_webrtc 

## SDK API

### Session
-----------
#### 构造函数
|参数名|说明|
|-----|-----|
|url|由后端提供,用户进入直播间的token|

------------
#### connect
说明:与服务器建立连接
|参数名|说明|
|-----|-----|
|userName|用户名,不可重复|
------------
#### disconnect
说明:与服务器断开连接,并清理资源
|参数名|说明|
|-----|-----|
------------
#### startLocalPreview
说明:开启本地视频预览(无需与服务器建立连接)
|参数名|说明|
|-----|-----|
|mode|frontCamera:前置摄像头,backCamera:后置摄像头,srceen:屏幕,audio:语音通话|
|videoParams|视频参数,预置了VideoParams.low,VideoParams.middle,VideoParams.high,也可自定义创建|
------------
#### stopLocalPreview
说明:关闭本地视频预览
|参数名|说明|
|-----|-----|
------------

#### publishLocalStream
说明:发布本地流到服务器(stopLocalPreview之后调用)
|参数名|说明|
|-----|-----|
|video|是否开启视频|
|audio|是否开启音频|
------------

#### publishVideo
说明:改变发布视频状态
|参数名|说明|
|-----|-----|
|enable|true为发布视频,false为停止发送视频|
------------

#### publishAudio
说明:改变发布音频状态
|参数名|说明|
|-----|-----|
|enable|true为发布音频,false为停止发送音频|
------------

#### subscribeRemoteStream
说明:订阅远端用户流
|参数名|说明|
|-----|-----|
|id|对方id|
|video|是否开启视频|
|audio|是否开启视音频|
|speakerphone|是否开启扬声器播放声音,默认是听筒|
------------

#### setRemoteVideo
说明:设置是否开启远端流的视频(目前ios13以上的无效,等待flutter_webrtc官方修复)
|参数名|说明|
|-----|-----|
|id|对方id|
|enable|是否开启视频|
------------

#### setRemoteAudio
说明:设置是否开启远端流的音频(目前ios13以上的无效,等待flutter_webrtc官方修复)
|参数名|说明|
|-----|-----|
|id|对方id|
|enable|是否开启音频|
------------

#### setRemoteSpeakerphone
说明:设置是否开启远端流的扬声器播放
|参数名|说明|
|-----|-----|
|id|对方id|
|enable|是否开启扬声器|
------------

#### on
说明:设置事件回调
|参数名|说明|
|-----|-----|
|event|事件名,可参阅Event枚举|
|handler|回调|
------------

### 开始通话示例
```
    _session = Session(token);

    _session.on(Event.userPublished, (params) {
      _session.subscribeRemoteStream(params["id"]);
    });

    _session.on(Event.addStream, (params) {
      oppositeStream = params["stream"];
      _oppositeId = params["id"];
    });

    _session.on(Event.removeStream, (params) {
      if (params["id"] == _oppositeId) {
        oppositeStream = null;
      }
    });

    _session.on(Event.error, (params) {
      if (params.containsKey("error")) {
        openViduError = params["error"];
      } else {
        openViduError = OtherError();
      }
    });

    try {
      await _session.connect(userName);
      localStream = await _session.startLocalPreview(StreamMode.frontCamera);
      _session.publishLocalStream();
    } catch (e) {
      // TODO
    }

```

### 结束通话示例

```
_session?.disconnect();
```