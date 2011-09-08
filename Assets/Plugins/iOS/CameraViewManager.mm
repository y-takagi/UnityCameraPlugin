
#import "CameraViewManager.h"

@implementation CameraViewManager
@synthesize captureSessionManager;

- (id)init
{
    self = [super init];
    if (self) {
        captureSessionManager = [[CaptureSessionManager alloc] init];
        
        window = [[UIApplication sharedApplication] keyWindow];
        
        NSArray *layers = window.layer.sublayers;
        CAEAGLLayer *glLayer = nil;
        
        for (int i = 0; i < [layers count]; i++) {
            CALayer *layer = [layers objectAtIndex:i];
            if ([layer isKindOfClass:[CAEAGLLayer class]]) {
                glLayer = (CAEAGLLayer *)layer;
                NSLog(@"layer %d is GLLayer", i);
            }
        }
        
        glLayer.opaque = NO;
        glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE],
                                      kEAGLDrawablePropertyRetainedBacking,
                                      kEAGLColorFormatRGBA8,
                                      kEAGLDrawablePropertyColorFormat,
                                      nil];
        EAGLContext *glContext = [EAGLContext currentContext];
        [glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
    }    
    return self;
}

- (void)openFrontCamera {
    // create preview and start capture front camera session
    CGRect rect = CGRectMake(0, 0, 320, 460);
    [window.layer insertSublayer:[captureSessionManager getFrontCameraView:rect] atIndex:0];
    [captureSessionManager startCapture];
}

- (void)dealloc {
    [captureSessionManager release];
    [super dealloc];
}

@end

static CameraViewManager *cameraViewManager = nil;

extern "C" {
    void _StartFrontPreview() {
        cameraViewManager = [[CameraViewManager alloc] init];
        [cameraViewManager openFrontCamera];
    }    
}
