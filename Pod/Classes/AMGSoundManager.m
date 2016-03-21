//
//  EfectosSound.m
//  AMGSoundManager
//
//  Created by Albert Montserrat on 09/05/13.
//  Copyright (c) 2013 Albert Montserrat. All rights reserved.
//

#import "AMGSoundManager.h"
#import "AMGAudioPlayer.h"

#define kAMGVolumeChangesPerSecond 15

#define kAMGSoundManagerKeyName @"name"
#define kAMGSoundManagerKeyPath @"path"
#define kAMGSoundManagerKeyPlayer @"player"
#define kAMGSoundManagerKeyHandler @"handler"

#define kAMGSoundManagerDefaultLine @"default"


static AMGSoundManager *_sharedManager;

@implementation AMGSoundManager


+(AMGSoundManager*)sharedManager{
    
    if(!_sharedManager){
        _sharedManager = [[AMGSoundManager alloc] init];
        _sharedManager.sounds = [NSMutableDictionary dictionary];
    }
    
    return _sharedManager;
    
}



-(BOOL)playAudio:(id)audioPathOrData withCompletitionHandler:(void (^)(BOOL success, BOOL stopped))handler{
    return [self playAudio:audioPathOrData withName:nil inLine:kAMGSoundManagerDefaultLine withVolume:1.0 andRepeatCount:0 fadeDuration:0.0 withCompletitionHandler:handler];
}

-(BOOL)playAudio:(id)audioPathOrData withName:(NSString *)name withCompletitionHandler:(void (^)(BOOL success, BOOL stopped))handler{
    return [self playAudio:audioPathOrData withName:name inLine:kAMGSoundManagerDefaultLine withVolume:1.0 andRepeatCount:0 fadeDuration:0.0 withCompletitionHandler:handler];
}

-(BOOL)playAudio:(id)audioPathOrData withName:(NSString *)name inLine:(NSString *)line withCompletitionHandler:(void (^)(BOOL success, BOOL stopped))handler{
    return [self playAudio:audioPathOrData withName:name inLine:line withVolume:1.0 andRepeatCount:0 fadeDuration:0.0 withCompletitionHandler:handler];
}

-(BOOL)playAudio:(id)audioPathOrData withName:(NSString *)name inLine:(NSString *)line withVolume:(float)volume andRepeatCount:(int)repeatCount fadeDuration:(CGFloat)fadeDuration withCompletitionHandler:(void (^)(BOOL success, BOOL stopped))handler{
    if(!audioPathOrData)
        return NO;
    if(!line)
        line = kAMGSoundManagerDefaultLine;
    
    AMGAudioPlayer *music;
    NSMutableDictionary *dictSound;
    if([audioPathOrData isKindOfClass:[NSString class]]){
        music = [[AMGAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPathOrData] error:NULL];
        
        dictSound = [NSMutableDictionary dictionaryWithDictionary:@{kAMGSoundManagerKeyName:name?:audioPathOrData,
                                                                                         kAMGSoundManagerKeyPath:audioPathOrData,
                                                                                         kAMGSoundManagerKeyPlayer:music}];
    }else if([audioPathOrData isKindOfClass:[NSData class]]){
        music = [[AMGAudioPlayer alloc] initWithData:audioPathOrData error:nil];
        
        dictSound = [NSMutableDictionary dictionaryWithDictionary:@{kAMGSoundManagerKeyName:name?:@"data",
                                                                                         kAMGSoundManagerKeyPath:@"data",
                                                                                         kAMGSoundManagerKeyPlayer:music}];
    }else{
        NSLog(@"NSData or NSString path is required to play audio with AMGSoundManager");
        return NO;
    }
    
    if(![self.sounds objectForKey:line]){
        [self.sounds setObject:[NSArray array] forKey:line];
    }
    
    NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:line]];
    
    music.volume = ((fadeDuration == 0.0) ? volume : 0.0);
    music.delegate = self;
    music.numberOfLoops = repeatCount;
    [music play];
    
    if(!music)
        return NO;
    
    if(handler!=nil){
        [dictSound setObject:[handler copy] forKey:kAMGSoundManagerKeyHandler];
    }
    [mut addObject:dictSound];
    [self.sounds setObject:mut forKey:line];
    
    if(fadeDuration != 0.0){
        [music setVolume:volume withFadeDuration:fadeDuration];
    }
    
    return YES;
}

-(void)stopAllAudiosWithFadeDuration:(CGFloat)fadeDuration{
    [self stopAudiosInLine:nil andAlsoWithName:nil andAlsoWithPath:nil withFadeDuration:fadeDuration];
}

-(void)stopAllAudiosForLine:(NSString *)line withFadeDuration:(CGFloat)fadeDuration{
    [self stopAudiosInLine:line andAlsoWithName:nil andAlsoWithPath:nil withFadeDuration:fadeDuration];
}

-(void)stopAllAudiosWithoutLineWithFadeDuration:(CGFloat)fadeDuration{
    [self stopAudiosInLine:kAMGSoundManagerDefaultLine andAlsoWithName:nil andAlsoWithPath:nil withFadeDuration:fadeDuration];
}

-(void)stopAudioWithName:(NSString *)name withFadeDuration:(CGFloat)fadeDuration{
    [self stopAudiosInLine:nil andAlsoWithName:name andAlsoWithPath:nil withFadeDuration:fadeDuration];
}

-(void)stopAudioWithPath:(NSString *)path withFadeDuration:(CGFloat)fadeDuration{
    [self stopAudiosInLine:nil andAlsoWithName:nil andAlsoWithPath:path withFadeDuration:fadeDuration];
}

-(void)stopAudiosInLine:(NSString *)line andAlsoWithName:(NSString *)name andAlsoWithPath:(NSString *)path withFadeDuration:(CGFloat)fadeDuration{
    for(NSString *key in self.sounds.allKeys){
        if(line && [line compare:key]!=NSOrderedSame)
            continue;
        
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AMGAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            NSString *audio = [dict objectForKey:kAMGSoundManagerKeyName];
            NSString *audioPath = [dict objectForKey:kAMGSoundManagerKeyPath];
            void (^handler)(BOOL success, BOOL stopped) = [dict objectForKey:kAMGSoundManagerKeyHandler];
            
            if(name && [name compare:audio]!=NSOrderedSame)
                continue;
            
            if(path && [path compare:audioPath]!=NSOrderedSame)
                continue;
            
            player.delegate = nil;
            
            if(fadeDuration == 0.0){
                [player stop];
                
                if(handler!=nil){
                    handler(YES,YES);
                }
                
                NSMutableArray *mut2 = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
                [mut2 removeObject:dict];
                [self.sounds setObject:mut2 forKey:key];
            }else{
                [player setVolume:0.0 withFadeDuration:fadeDuration];
                [self performSelector:@selector(stopAudioFaded:) withObject:player afterDelay:fadeDuration];
                
                if(handler!=nil){
                    handler(YES,YES);
                }
                
                NSMutableArray *mut2 = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
                [mut2 removeObject:dict];
                [self.sounds setObject:mut2 forKey:key];
            }
            
        }
    }
}

-(void)stopAudioFaded:(AMGAudioPlayer *)player{
    [player stop];
}


- (void)audioPlayerDidFinishPlaying:(AMGAudioPlayer *)player successfully:(BOOL)flag{
    for(NSString *key in self.sounds.allKeys){
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AMGAudioPlayer *playerToCheck = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            NSString *audio = [dict objectForKey:kAMGSoundManagerKeyName];
            void (^handler)(BOOL success, BOOL stopped) = [dict objectForKey:kAMGSoundManagerKeyHandler];
            if(player == playerToCheck){
                
                NSMutableArray *mut2 = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
                [mut2 removeObject:dict];
                [self.sounds setObject:mut2 forKey:key];
                
                if(self.delegate && [self.delegate respondsToSelector:@selector(audioDidFinish:inLine:)]){
                    [self.delegate audioDidFinish:audio inLine:key];
                }
                if(handler!=nil){
                    handler(YES,NO);
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kSoundManagerAudioEnded object:self userInfo:@{@"info":dict,@"line":key}];
                
            }
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AMGAudioPlayer *)player error:(NSError *)error{
    for(NSString *key in self.sounds.allKeys){
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AMGAudioPlayer *playerToCheck = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            NSString *audio = [dict objectForKey:kAMGSoundManagerKeyName];
            void (^handler)(BOOL success, BOOL stopped) = [dict objectForKey:kAMGSoundManagerKeyHandler];
            if(player == playerToCheck){
                
                NSMutableArray *mut2 = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
                [mut2 removeObject:dict];
                [self.sounds setObject:mut2 forKey:key];
                
                if(self.delegate && [self.delegate respondsToSelector:@selector(audioErrorOcurred:inLine:)]){
                    [self.delegate audioErrorOcurred:audio inLine:key];
                }
                if(handler!=nil){
                    handler(NO,NO);
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kSoundManagerAudioEnded object:self userInfo:@{@"info":dict,@"line":key}];
                
            }
        }
    }
}

-(BOOL)isAudioPlayingInLine:(NSString *)line{
    return [self isAudioPlayingInLine:line withName:nil];
}

-(BOOL)isAudioPlayingInLine:(NSString *)line withName:(NSString *)name{
    for(NSString *key in self.sounds.allKeys){
        if(line && [line compare:key]!=NSOrderedSame)
            continue;
        
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AMGAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            NSString *audio = [dict objectForKey:kAMGSoundManagerKeyName];
            
            if(name && [name compare:audio]!=NSOrderedSame)
                continue;
            
            if([player isPlaying])
                return YES;
        }
    }
    return NO;
}


-(void)setVolume:(float)volume forLine:(NSString*)line withFadeDuration:(CGFloat)fadeDuration{
    for(NSString *key in self.sounds.allKeys){
        if(line && [line compare:key]!=NSOrderedSame)
            continue;
        
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AMGAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            [player setVolume:volume withFadeDuration:fadeDuration];
        }
    }
}

-(void)pauseAudiosInLine:(NSString *)line{
    for(NSString *key in self.sounds.allKeys){
        if(line && [line compare:key]!=NSOrderedSame)
            continue;
        
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AMGAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            
            if([player isPlaying])
                [player pause];
        }
    }
}

-(void)resumeAudiosInLine:(NSString *)line{
    for(NSString *key in self.sounds.allKeys){
        if(line && [line compare:key]!=NSOrderedSame)
            continue;
        
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AMGAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            
            if(![player isPlaying])
                [player play];
        }
    }
}


@end