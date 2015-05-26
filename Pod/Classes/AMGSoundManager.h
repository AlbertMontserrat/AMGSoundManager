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

#define kAMGSoundManagerDefaultLine @"default"

#define kAMGSoundManagerKeyName @"name"
#define kAMGSoundManagerKeyPath @"path"
#define kAMGSoundManagerKeyPlayer @"player"


@protocol AMGSoundManagerDelegate;

@interface AMGSoundManager : NSObject <AVAudioPlayerDelegate> 

@property(nonatomic,retain) NSMutableDictionary *sounds;
@property(nonatomic,weak) id<AMGSoundManagerDelegate> delegate;

+(AMGSoundManager*)sharedManager;

-(BOOL)playAudioAtPath:(NSString *)audioPath;
-(BOOL)playAudioAtPath:(NSString *)audioPath withName:(NSString *)name;
-(BOOL)playAudioAtPath:(NSString *)audioPath withName:(NSString *)name inLine:(NSString *)line;
-(BOOL)playAudioAtPath:(NSString *)audioPath withName:(NSString *)name inLine:(NSString *)line withVolum:(float)volum;
-(BOOL)playAudioAtPath:(NSString *)audioPath withName:(NSString *)name inLine:(NSString *)line withVolum:(float)volum andRepeatCount:(int)repeatCount;

-(BOOL)playAudioWithData:(NSData *)data;
-(BOOL)playAudioWithData:(NSData *)data withName:(NSString *)name;
-(BOOL)playAudioWithData:(NSData *)data withName:(NSString *)name inLine:(NSString *)line;
-(BOOL)playAudioWithData:(NSData *)data withName:(NSString *)name inLine:(NSString *)line withVolum:(float)volum;
-(BOOL)playAudioWithData:(NSData *)data withName:(NSString *)name inLine:(NSString *)line withVolum:(float)volum andRepeatCount:(int)repeatCount;

-(void)stopAllAudios;
-(void)stopAllAudiosForLine:(NSString *)line;
-(void)stopAllAudiosWithoutLine;
-(void)stopAudioWithName:(NSString *)name;
-(void)stopAudioWithPath:(NSString *)path;

-(void)setVolume:(float)volum forLine:(NSString*)line;
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