//
//  CLPContainer.m
//  Clappr
//
//  Created by Gustavo Barbosa on 12/11/14.
//  Copyright (c) 2014 globo.com. All rights reserved.
//

#import "CLPContainer.h"

#import "CLPPlayback.h"


@implementation CLPContainer

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Use initWithPlayback: instead"
                                 userInfo:nil];
}

- (instancetype)initWithPlayback:(CLPPlayback *)playback
{
    self = [super init];
    if (self) {
        self.playback = playback;
    }

    return self;
}

- (void)bindEventListeners
{
    __weak typeof(self) weakSelf = self;
    [self listenTo:_playback
         eventName:CLPPlaybackEventProgress
          callback:^(NSDictionary *userInfo) {

        CGFloat startPosition = [userInfo[@"startPosition"] floatValue];
        CGFloat endPosition = [userInfo[@"endPosition"] floatValue];
        NSTimeInterval duration = [userInfo[@"duration"] doubleValue];
        [weakSelf progressWithStartPosition:startPosition endPosition:endPosition duration:duration];
    }];
    
    [self listenTo:_playback
         eventName:CLPPlaybackEventTimeUpdated
          callback:^(NSDictionary *userInfo) {

        CGFloat position = [userInfo[@"position"] floatValue];
        NSTimeInterval duration = [userInfo[@"duration"] doubleValue];
        [weakSelf timeUpdatedWithPosition:position duration:duration];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventReady
          callback:^(NSDictionary *userInfo) {

        [weakSelf ready];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventBuffering
          callback:^(NSDictionary *userInfo) {

        [weakSelf buffering];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventBufferFull
          callback:^(NSDictionary *userInfo) {

        [weakSelf bufferFull];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventSettingsUdpdated
          callback:^(NSDictionary *userInfo) {

        [weakSelf settingsUpdated];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventLoadedMetadata
          callback:^(NSDictionary *userInfo) {

        NSTimeInterval duration = [userInfo[@"duration"] doubleValue];
        [weakSelf loadedMetadataWithDuration:duration];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventHighDefinitionUpdate
          callback:^(NSDictionary *userInfo) {

        [weakSelf highDefinitionUpdated];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventBitRate
          callback:^(NSDictionary *userInfo) {

        float bitRate = [userInfo[@"bit_rate"] floatValue];
        [weakSelf updateBitrate:bitRate];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventStateChanged
          callback:^(NSDictionary *userInfo) {

        [weakSelf stateChanged];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventDVRStateChanged
          callback:^(NSDictionary *userInfo) {

        BOOL dvrInUse = [userInfo[@"dvr_in_use"] boolValue];
        [weakSelf dvrStateChanged:dvrInUse];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventMediaControlDisabled
          callback:^(NSDictionary *userInfo) {

        [weakSelf disableMediaControl];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventMediaControlEnabled
          callback:^(NSDictionary *userInfo) {

        [weakSelf enableMediaControl];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventEnded
          callback:^(NSDictionary *userInfo) {

        [weakSelf ended];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventPlay
          callback:^(NSDictionary *userInfo) {

        [weakSelf playing];
    }];

    [self listenTo:_playback
         eventName:CLPPlaybackEventError
          callback:^(NSDictionary *userInfo) {

        NSError *errorObj = userInfo[@"error"];
        [weakSelf error:errorObj];
    }];
}

#pragma mark - Event Callbacks

- (void)progressWithStartPosition:(CGFloat)startPosition
                      endPosition:(CGFloat)endPosition
                         duration:(NSTimeInterval)duration
{}

- (void)timeUpdatedWithPosition:(CGFloat)position
                       duration:(NSTimeInterval)duration
{}

- (void)ready
{
    _ready = YES;
}

- (void)buffering
{}

- (void)bufferFull
{}

- (void)settingsUpdated
{
    _settings = _playback.settings;
}

- (void)loadedMetadataWithDuration:(NSTimeInterval)duration
{}

- (void)highDefinitionUpdated
{}

- (void)updateBitrate:(float)bitRate
{}

- (void)stateChanged
{}

- (void)dvrStateChanged:(BOOL)dvrInUse
{
    _dvrInUse = dvrInUse;
}

- (void)disableMediaControl
{
    _mediaControlDisabled = YES;
}

- (void)enableMediaControl
{
    _mediaControlDisabled = NO;
}

- (void)ended
{}

- (void)playing
{}

- (void)error:(NSError *)errorObj
{}

#pragma mark - Accessors

- (NSString *)name
{
    return @"Container";
}

- (void)setPlayback:(CLPPlayback *)playback
{
    _playback = playback;

    [self stopListening];
    [self bindEventListeners];
}

@end