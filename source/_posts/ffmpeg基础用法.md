---
title: ffmpeg基础用法
date: 2024-10-15 21:34:01
tags: ffmpeg
categories: tools
---

<!-- toc -->

```sh
ffmpeg -i input.mp4 -ss 00:05:00 -t 00:05:00 -s 1280x720 -c copy output.mp4
```

`-ss`表示起始时间，`-t`表示**截取的时长**（注意不是结束时间）。

`-s`参数调整输出视频的分辨率。

`-c copy`参数表示复制原始视频和音频流，不进行重新编码，这样可以更快地处理视频。如果你需要重新编码视频或音频，可以移除`-c copy`并指定相应的编解码器。
