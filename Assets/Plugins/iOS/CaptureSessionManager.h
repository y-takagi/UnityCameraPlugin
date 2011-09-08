
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface CaptureSessionManager : NSObject {
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *captureInput;
}

- (AVCaptureVideoPreviewLayer *)getFrontCameraView:(CGRect)rect;
- (AVCaptureVideoPreviewLayer *)getBackCameraView:(CGRect)rect;
- (AVCaptureDevicePosition)getCurrentDevicePosition;
- (void)switchCameraView;
- (void)startCapture;

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureDeviceInput *captureInput;

@end
