
#import "CaptureSessionManager.h"

// private method
@interface CaptureSessionManager()
- (AVCaptureVideoPreviewLayer *)initCapture:(AVCaptureDevicePosition)position viewSize:(CGRect)rect;
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position;
@end

@implementation CaptureSessionManager
@synthesize captureSession, captureInput;

/*
 * initialize
 */
- (id)init {
    self = [super init];
    if (self) {
        // Create CaptureSession
        captureSession = [[AVCaptureSession alloc] init];
        captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    }    
    return self;
}

/*
 * returns a front camera view layer
 * @param: 
 */
- (AVCaptureVideoPreviewLayer *)getFrontCameraView:(CGRect)rect {
    return [self initCapture:AVCaptureDevicePositionFront viewSize:rect];
}

/*
 * returns a back camera view layer
 *
 */
- (AVCaptureVideoPreviewLayer *)getBackCameraView:(CGRect)rect {
    return [self initCapture:AVCaptureDevicePositionBack viewSize:rect];
}

/*
 * switch camera
 */ 
- (void)switchCameraView {
    NSError *error = nil;
    [captureSession beginConfiguration];
    [captureSession removeInput:captureInput];
    [captureInput release];
    if ([self getCurrentDevicePosition] == AVCaptureDevicePositionBack) {
        captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront]
                                                             error:&error];
    } else if([self getCurrentDevicePosition] == AVCaptureDevicePositionFront) {
        captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack]
                                                             error:&error];
    }
    [captureSession addInput:captureInput];
    [captureSession commitConfiguration];
}

- (void)startCapture {
    [captureSession startRunning];
}

/*
 * Init a capture session and returns preview layer
 */
- (AVCaptureVideoPreviewLayer *)initCapture:(AVCaptureDevicePosition)position viewSize:(CGRect)rect {
    AVCaptureDevice *device = [self cameraWithPosition:position];
    // Create a capture input and add to capture session
    NSError *error = nil;
    captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!captureInput) {
        NSLog(@"input error");
    }
    if ([captureSession canAddInput:captureInput]) {
        [captureSession addInput:captureInput];
    }

    // Set up the preview layer to see the video
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = rect;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    return previewLayer;
}

/*
 * return device of selected position(front or back camera)
 */
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    // 指定したカメラがなかったらデフォルトのを返す
    return [devices objectAtIndex:0];
}

/*
 * return a current device position
 */
- (AVCaptureDevicePosition)getCurrentDevicePosition {
    return [[captureInput device] position];
}

- (void)dealloc {
    [self.captureSession stopRunning];
    [self.captureSession release];
    [self.captureInput release];
    [super dealloc];
}

@end
