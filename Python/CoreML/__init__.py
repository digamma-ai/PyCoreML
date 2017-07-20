
import objc as _objc

__bundle__ = _objc.initFrameworkWrapper("CoreML",
    frameworkIdentifier="com.apple.coreml",
    frameworkPath=_objc.pathForFramework(
        "/System/Library/Frameworks/CoreML.framework"),
    globals=globals())

