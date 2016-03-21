//
//  EfectosSound.h
//  AMGSoundManager
//
//  Created by Albert Montserrat on 09/05/13.
//  Copyright (c) 2013 Albert Montserrat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVAudioPlayer.h"

#define kSoundManagerAudioEnded @"SoundManagerAudioEnded"

@protocol AMGSoundManagerDelegate;

@interface AMGSoundManager : NSObject <AVAudioPlayerDelegate> 

@property(nonatomic,retain) NSMutableDictionary *sounds;
@property(nonatomic,weak) id<AMGSoundManagerDelegate> delegate;

+(AMGSoundManager*)sharedManager;

-(BOOL)playAudio:(id)audioPathOrData withCompletitionHandler:(void (^)(BOOL success, BOOL stopped))handler;
-(BOOL)playAudio:(id)audioPathOrData withName:(NSString *)name withCompletitionHandler:(void (^)(BOOL success, BOOL stopped))handler;
-(BOOL)playAudio:(id)audioPathOrData withName:(NSString *)name inLine:(NSString *)line withCompletitionHandler:(void (^)(BOOL success, BOOL stopped))handler;
-(BOOL)playAudio:(id)audioPathOrData withName:(NSString *)name inLine:(NSString *)line withVolume:(float)volume andRepeatCount:(int)repeatCount fadeDuration:(CGFloat)fadeDuration withCompletitionHandler:(void (^)(BOOL success, BOOL stopped))handler;

-(void)stopAllAudiosWithFadeDuration:(CGFloat)fadeDuration;
-(void)stopAllAudiosForLine:(NSString *)line withFadeDuration:(CGFloat)fadeDuration;
-(void)stopAllAudiosWithoutLineWithFadeDuration:(CGFloat)fadeDuration;
-(void)stopAudioWithName:(NSString *)name withFadeDuration:(CGFloat)fadeDuration;
-(void)stopAudioWithPath:(NSString *)path withFadeDuration:(CGFloat)fadeDuration;

-(void)setVolume:(float)volum forLine:(NSString*)line withFadeDuration:(CGFloat)fadeDuration;
-(BOOL)isAudioPlayingInLine:(NSString *)line;
-(BOOL)isAudioPlayingInLine:(NSString *)line withName:(NSString *)name;
-(void)pauseAudiosInLine:(NSString *)line;
-(void)resumeAudiosInLine:(NSString *)line;

@end




@protocol AMGSoundManagerDelegate <NSObject>

@optional
-(void)audioDidFinish:(NSString *)name inLine:(NSString *)line;
-(void)audioErrorOcurred:(NSString *)name inLine:(NSString *)line;

@end