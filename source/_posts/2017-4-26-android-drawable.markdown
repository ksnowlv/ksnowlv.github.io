---
layout: post
title: "Android drawable"
date: 2017-4-26 11:55
comments: true
categories: Android绘图。 
---

###Drawable分几种类型呢？

<!--more-->



```objective-c
public static Drawable createFromXmlInner(Resources r, XmlPullParser parser, AttributeSet attrs,
            Theme theme) throws XmlPullParserException, IOException {
        final Drawable drawable;

        final String name = parser.getName();
        switch (name) {
            case "selector":
                drawable = new StateListDrawable();
                break;
            case "animated-selector":
                drawable = new AnimatedStateListDrawable();
                break;
            case "level-list":
                drawable = new LevelListDrawable();
                break;
            case "layer-list":
                drawable = new LayerDrawable();
                break;
            case "transition":
                drawable = new TransitionDrawable();
                break;
            case "ripple":
                drawable = new RippleDrawable();
                break;
            case "color":
                drawable = new ColorDrawable();
                break;
            case "shape":
                drawable = new GradientDrawable();
                break;
            case "vector":
                drawable = new VectorDrawable();
                break;
            case "animated-vector":
                drawable = new AnimatedVectorDrawable();
                break;
            case "scale":
                drawable = new ScaleDrawable();
                break;
            case "clip":
                drawable = new ClipDrawable();
                break;
            case "rotate":
                drawable = new RotateDrawable();
                break;
            case "animated-rotate":
                drawable = new AnimatedRotateDrawable();
                break;
            case "animation-list":
                drawable = new AnimationDrawable();
                break;
            case "inset":
                drawable = new InsetDrawable();
                break;
            case "bitmap":
                drawable = new BitmapDrawable(r);
                if (r != null) {
                    ((BitmapDrawable) drawable).setTargetDensity(r.getDisplayMetrics());
                }
                break;
            case "nine-patch":
                drawable = new NinePatchDrawable();
                if (r != null) {
                    ((NinePatchDrawable) drawable).setTargetDensity(r.getDisplayMetrics());
                }
                break;
            default:
                throw new XmlPullParserException(parser.getPositionDescription() +
                        ": invalid drawable tag " + name);

        }
        drawable.inflate(r, parser, attrs, theme);
        return drawable;
    }


```
####1.StateListDrawable
####2.AnimatedStateListDrawable
####3.LevelListDrawable
####4.LayerDrawable
####5.TransitionDrawable
####6.RippleDrawable
####7.ColorDrawable
####8.GradientDrawable
####9.VectorDrawable

* 1.vector图像可以自动进行适配，不需要通过分辨率来设置不同的图片Vector图像可以大幅度减少图像的体积。
* 2.svg图像导出工具方便，从而转换成Vector图像功能强大，前端已经广泛使用。
* 3.android5.0开始支持矢量图，它非常适合图标，是独立于屏幕密度的，一个文件适合所有屏幕。当缩放的时候还可以保存所有的图片质量，通常文件所占用的空间也非常小使用VectorDrawable 可以大幅度的减少apk大小。最新的AppCompat23.2库通过使用VectorDrawableCompat可以支持在android api7+版本上使用矢量图

####10.AnimatedVectorDrawable
####11.ScaleDrawable
####12.ClipDrawable
####13.RotateDrawable
####14.AnimatedRotateDrawable
####15.AnimationDrawable
####16.InsetDrawable
####17.BitmapDrawable
####18.NinePatchDrawable

![image](/images/post/2017-4-22-iOS-xia-shi-yong-ffmpeg/buildscript.png) 

编译成功后：

![image](/images/post/2017-4-22-iOS-xia-shi-yong-ffmpeg/buildscriptresult.png) 


####3.iOS工程集成。
#####1.头文件路径设置。

![image](/images/post/2017-4-22-iOS-xia-shi-yong-ffmpeg/libs.png) 

#####1.依赖库设置。
![image](/images/post/2017-4-22-iOS-xia-shi-yong-ffmpeg/pathsetting.png) 

####4.编译成功。