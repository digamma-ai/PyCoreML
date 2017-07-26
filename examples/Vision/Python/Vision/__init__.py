
import objc as _objc

__bundle__ = _objc.initFrameworkWrapper("Vision",
    frameworkIdentifier="com.apple.vision",
    frameworkPath=_objc.pathForFramework(
        "/System/Library/Frameworks/Vision.framework"),
    globals=globals())

