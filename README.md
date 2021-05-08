# flutter_openvidu_demo
### 仓库包含 openvidu的flutter SDK 源码与演示demo

sdk包名为```kooboo_openvidu``` 版本不低于0.3.0

地址:```https://pub.dev/packages/kooboo_openvidu```

## 注意项⚠️

将sdk集成到正式项目时请遵循依赖包对项目的修改,依赖包对环境有特殊的需求,例如安卓最低版本等,以下是需要配置的依赖包
* flutter_webrtc 

## SDK API

https://pub.dev/packages/kooboo_openvidu

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