/**
 * Copyright Bambuser AB 2018
 */

#import "BambuserBroadcasterView.h"
#import <BambuserBroadcaster/BambuserBroadcaster.h>

@interface BambuserBroadcasterView() <BambuserViewDelegate>
@end

@implementation BambuserBroadcasterView {
  BambuserView *bambuserView;
  UIInterfaceOrientation broadcastingOrientation;
  BOOL isBroadcasting;
  NSDictionary *audioPresets;
  BOOL firstLayout;
}

@synthesize applicatonId, audioQuality, author, title, customData, aspect, localCopy, localCopyFilename, sendPosition, saveOnServer, zoom, talkback, startBroadcast, stopBroadcast, startUplinkTest, takePicture, acceptTalkback, declineTalkback, endTalkback, switchCamera;

-(instancetype)init {
  self = [super init];
  if (self) {
    isBroadcasting = NO;
    bambuserView = [[BambuserView alloc] initWithPreset:kSessionPresetAuto];
    bambuserView.delegate = self;
    [bambuserView setOrientation:[UIApplication sharedApplication].statusBarOrientation previewOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [self addSubview:bambuserView.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification object:nil];
    [self orientationChanged:nil];
    self.localCopy = NO;
    self.sendPosition = NO;
    self.saveOnServer = YES;
    self.talkback = NO;
    audioPresets = [[NSDictionary alloc] initWithObjectsAndKeys:@"audioQualityHigh", [NSNumber numberWithInteger:0], @"audioQualityLow", [NSNumber numberWithInteger:1], @"audioQualityMute", [NSNumber numberWithInteger:-1], nil];
  }
  return self;
}

-(void)setApplicatonId:(NSString *)_applicatonId {
  applicatonId = _applicatonId;
  bambuserView.applicationId = _applicatonId;
}

-(void)setAudioQuality:(NSString *)_audioQuality {
  audioQuality = _audioQuality;
  if ([audioPresets objectForKey:_audioQuality] != nil) {
    bambuserView.audioQualityPreset = [[audioPresets objectForKey:_audioQuality] intValue];
  }
}

-(void)setAuthor:(NSString *)_author {
  author = _author;
  bambuserView.author = _author;
}

-(void)setTitle:(NSString *)_title {
  title = _title;
  bambuserView.broadcastTitle = _title;
}

-(void)setCustomData:(NSString *)_customData {
  customData = _customData;
  bambuserView.customData = _customData;
}

-(void)setAspect:(NSDictionary *)_aspect {
  aspect = _aspect;
  [self orientationChanged:nil];
}

-(void)setLocalCopy:(BOOL)_localCopy {
  localCopy = _localCopy;
  bambuserView.saveLocally = _localCopy;
}

-(void)setLocalCopyFilename:(NSString *)_localCopyFilename {
  localCopyFilename = _localCopyFilename;
  bambuserView.localFilename = _localCopyFilename;
}

-(void)setSendPosition:(BOOL)_sendPosition {
  sendPosition = _sendPosition;
  bambuserView.sendPosition = _sendPosition;
}

-(void)setSaveOnServer:(BOOL)_saveOnServer {
  saveOnServer = _saveOnServer;
  bambuserView.saveOnServer = _saveOnServer;
}

-(void)setZoom:(float)_zoom {
  float calcZoom = ((bambuserView.maxZoom - 1) * _zoom) + 1;
  zoom = calcZoom;
  if (zoom > bambuserView.maxZoom) {
    zoom = bambuserView.maxZoom;
  } else if (zoom < 1) {
    zoom = 1;
  }
  bambuserView.zoom = zoom;
}

-(void)setTalkback:(BOOL)_talkback {
  talkback = _talkback;
  bambuserView.talkback = _talkback;
}

-(void)bambuserError:(enum BambuserError)errorCode message:(NSString *)errorMessage {
  if (self.onBroadcastError) {
    NSString *errorCodeString = [NSString stringWithFormat:@"%d", errorCode];
    self.onBroadcastError(@{@"errorCode": errorCodeString, @"errorMessage": errorMessage});
  }
}

-(void)chatMessageReceived:(NSString *)message {
  if (self.onMessageReceived) {
    self.onMessageReceived(@{@"message": message});
  }
}

-(void)broadcastStarted {
  if (self.onBroadcastStarted) {
    self.onBroadcastStarted(nil);
  }
  isBroadcasting = YES;
}

-(void)broadcastStopped {
  if (self.onBroadcastStopped) {
    self.onBroadcastStopped(nil);
  }
  isBroadcasting = NO;
  [self orientationChanged:nil];
}

-(void)recordingComplete:(NSString *)filename {
  if (self.onLocalCopySaved) {
    self.onLocalCopySaved(@{@"filePath": filename});
  }
}

-(void)healthUpdated:(int)health {
  if (self.onStreamHealthUpdate) {
    NSString *healthString = [NSString stringWithFormat:@"%d", health];
    self.onStreamHealthUpdate(@{@"health": healthString});
  }
}

-(void)currentViewerCountUpdated:(int)viewers {
  if (self.onCurrentViewerCountUpdate) {
    NSString *viewersString = [NSString stringWithFormat:@"%d", viewers];
    self.onCurrentViewerCountUpdate(@{@"viewers": viewersString});
  }
}

-(void)totalViewerCountUpdated:(int)viewers {
  if (self.onTotalViewerCountUpdate) {
    NSString *viewersString = [NSString stringWithFormat:@"%d", viewers];
    self.onTotalViewerCountUpdate(@{@"viewers": viewersString});
  }
}

-(void)talkbackStateChanged:(enum TalkbackState)state {
  switch (state) {
    case kTalkbackIdle:
      if (self.onTalkbackIdle) {
        self.onTalkbackIdle(nil);
      }
      break;
    case kTalkbackPlaying:
      if (self.onTalkbackPlaying) {
        self.onTalkbackPlaying(nil);
      }
      break;
    case kTalkbackAccepted:
      if (self.onTalkbackAccepted) {
        self.onTalkbackAccepted(nil);
      }
      break;
    case kTalkbackNeedsAccept:
      if (self.onTalkbackNeedsAccept) {
        self.onTalkbackNeedsAccept(nil);
      }
      break;
  }
}

-(void)talkbackRequest:(NSString *)request caller:(NSString *)caller talkbackID:(int)talkbackID {
  if (self.onIncomingTalkbackRequest) {
    NSString *talkbackIdString = [NSString stringWithFormat:@"%d", talkbackID];
    self.onIncomingTalkbackRequest(@{@"request": request, @"caller": caller, @"talkbackId": talkbackIdString});
  }
}

-(void)broadcastIdReceived:(NSString *)broadcastId {
  if (self.onBroadcastIdReceived) {
    self.onBroadcastIdReceived(@{@"broadcastId": broadcastId});
  }
}

-(void)snapshotTaken:(UIImage *)image {
  if (self.onPictureSaved) {
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    NSString *imgPath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"img%f.jpg", [[NSDate date] timeIntervalSince1970]]];
    if ([imgData writeToFile:imgPath atomically:YES]) {
      NSURL *fileURL = [NSURL fileURLWithPath:imgPath];
      self.onPictureSaved(@{@"filePath": [fileURL absoluteString]});
    }
  }
}

-(void)setStartUplinkTest:(BOOL)_startUplinkTest {
  [bambuserView startLinktest];
}

-(void)uplinkTestComplete:(float)speed recommendation:(BOOL)shouldBroadcast {
  if (self.onUplinkTestComplete) {
    NSString *speedString = [NSString stringWithFormat:@"%f", speed];
    NSString *shouldBroadcastString = [NSString stringWithFormat:@"%d", shouldBroadcast];
    self.onUplinkTestComplete(@{@"speed": speedString, @"recommendation": shouldBroadcastString});
  }
}

-(void)setStartBroadcast:(BOOL)_startBroadcast {
  if ([bambuserView canStart]) {
    bambuserView.applicationId = self.applicatonId;
    if ([audioPresets objectForKey:self.audioQuality] != nil) {
      bambuserView.audioQualityPreset = [[audioPresets objectForKey:self.audioQuality] intValue];
    }
    bambuserView.author = self.author;
    bambuserView.broadcastTitle = self.title;
    bambuserView.customData = self.customData;
    bambuserView.saveLocally = self.localCopy;
    if (self.localCopyFilename) {
      bambuserView.localFilename = self.localCopyFilename;
    } else if (self.localCopyFilename == nil && bambuserView.localFilename != nil) {
      bambuserView.localFilename = nil;
    }
    bambuserView.sendPosition = self.sendPosition;
    bambuserView.saveOnServer = self.saveOnServer;
    bambuserView.talkback = self.talkback;
    [bambuserView startBroadcasting];
  } else {
    self.onStartBroadcastNotReady(nil);
  }
}

-(void)setStopBroadcast:(BOOL)_setStopBroadcast {
  [bambuserView stopBroadcasting];
}

-(void)setTakePicture:(BOOL)_takePicture {
  [bambuserView takeSnapshot];
}

-(void)setAcceptTalkback:(int)_acceptTalkback {
  [bambuserView acceptTalkbackRequest:_acceptTalkback];
}

-(void)setDeclineTalkback:(int)_declineTalkback {
  [bambuserView declineTalkbackRequest:_declineTalkback];
}

-(void)setEndTalkback:(BOOL)_endTalkback {
  [bambuserView endTalkback];
}

-(void)setSwitchCamera:(BOOL)_switchCamera {
  [bambuserView swapCamera];
  [self cameraReady];
}

-(BOOL)hasAspectValues {
  if (aspect) {
    NSString *aspectWidth = [aspect valueForKey:@"width"];
    NSString *aspectHeight = [aspect valueForKey:@"height"];
    if (aspectWidth && aspectHeight) {
      return YES;
    }
  }
  return NO;
}

-(void)layoutSubviews {
  [super layoutSubviews];
  if (!firstLayout) {
    firstLayout = true;
    [self cameraReady];
  }
  if ([self hasAspectValues]) {
    float aspectWidth = [[aspect valueForKey:@"width"] floatValue];
    float aspectHeight = [[aspect valueForKey:@"height"] floatValue];
    float aspect = aspectWidth / aspectHeight;
    float height = self.bounds.size.height;
    float width = height * aspect;
    if (width > self.bounds.size.width) {
      float shrinkPercentage = self.bounds.size.width / width;
      height = height * shrinkPercentage;
      width = self.bounds.size.width;
    }
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
      width = self.bounds.size.width;
      height = width / aspect;
      if (height > self.bounds.size.height) {
        float shrinkPercentage = self.bounds.size.height / height;
        height = self.bounds.size.height;
        width = width * shrinkPercentage;
      }
    }
    float x = (self.bounds.size.width / 2) - (width / 2);
    float y = (self.bounds.size.height / 2) - (height / 2);
    [bambuserView setPreviewFrame:CGRectMake(x, y, width, height)];
  } else {
    [bambuserView setPreviewFrame:self.bounds];
  }
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)orientationChanged:(NSNotification *)notification {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
  if (!isBroadcasting) {
    broadcastingOrientation = interfaceOrientation;
  } else {
    interfaceOrientation = broadcastingOrientation;
  }
  if ([self hasAspectValues]) {
    int aspectWidth = [[aspect valueForKey:@"width"] intValue];
    int aspectHeight = [[aspect valueForKey:@"height"] intValue];
    [bambuserView setOrientation:interfaceOrientation previewOrientation:interfaceOrientation withAspect:aspectWidth by:aspectHeight];
    return;
  }
  [bambuserView setOrientation:interfaceOrientation previewOrientation:interfaceOrientation];
  [self setNeedsLayout];
}

-(void)cameraReady {
  BOOL hasZoom = (bambuserView.maxZoom > 1);
  BOOL hasTorch = bambuserView.hasLedTorch;
  BOOL canSwitchCamera = bambuserView.hasFrontCamera;
  self.onCameraReady(@{@"hasZoom": [NSNumber numberWithBool:hasZoom], @"hasTorch": [NSNumber numberWithBool:hasTorch], @"canSwitchCamera": [NSNumber numberWithBool:canSwitchCamera]});
}

@end
