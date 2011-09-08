
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>

#import "CaptureSessionManager.h"

@interface CameraViewManager : NSObject {
    UIWindow *window;
    CaptureSessionManager *captureSessionManager;
}

- (void)openFrontCamera;

@property (nonatomic, retain) CaptureSessionManager *captureSessionManager;

@end
