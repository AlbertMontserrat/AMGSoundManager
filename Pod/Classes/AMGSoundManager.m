//
//  EfectosSound.m
//  AMGSoundManager
//
//  Created by Albert Montserrat on 09/05/13.
//  Copyright (c) 2013 Albert Montserrat. All rights reserved.
//

#import "AMGSoundManager.h"

static AMGSoundManager *_sharedManager;

@implementation AMGSoundManager


+(AMGSoundManager*)sharedManager{
    
    if(!_sharedManager){
        _sharedManager = [[AMGSoundManager alloc] init];
        _sharedManager.sounds = [NSMutableDictionary dictionary];
    }
    
    return _sharedManager;
    
}



-(BOOL)playAudioAtPath:(NSString *)audioPath{
    return [self playAudioAtPath:audioPath withName:nil inLine:kAMGSoundManagerDefaultLine withVolum:1.0 andRepeatCount:0];
}

-(BOOL)playAudioAtPath:(NSString *)audioPath withName:(NSString *)name{
    return [self playAudioAtPath:audioPath withName:name inLine:kAMGSoundManagerDefaultLine withVolum:1.0 andRepeatCount:0];
}

-(BOOL)playAudioAtPath:(NSString *)audioPath withName:(NSString *)name inLine:(NSString *)line{
    return [self playAudioAtPath:audioPath withName:name inLine:line withVolum:1.0 andRepeatCount:0];
}

-(BOOL)playAudioAtPath:(NSString *)audioPath withName:(NSString *)name inLine:(NSString *)line withVolum:(float)volum{
    return [self playAudioAtPath:audioPath withName:name inLine:line withVolum:volum andRepeatCount:0];
}

-(BOOL)playAudioAtPath:(NSString *)audioPath withName:(NSString *)name inLine:(NSString *)line withVolum:(float)volum andRepeatCount:(int)repeatCount{
    if(!audioPath || [audioPath compare:@""]==NSOrderedSame)
        return NO;
    if(!line)
        line = kAMGSoundManagerDefaultLine;
    
    if(![self.sounds objectForKey:line]){
        [self.sounds setObject:[NSArray array] forKey:line];
    }
    
    NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:line]];
    
    AVAudioPlayer *music=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:NULL];
    music.volume = volum;
    music.delegate = self;
    music.numberOfLoops = repeatCount;
    [music play];
    
    if(!music)
        return NO;
    
    NSDictionary *dictSound = @{kAMGSoundManagerKeyName:name?:audioPath,
                                kAMGSoundManagerKeyPath:audioPath,
                                kAMGSoundManagerKeyPlayer:music};
    [mut addObject:dictSound];
    [self.sounds setObject:mut forKey:line];
    
    return YES;
}

-(BOOL)playAudioWithData:(NSData *)data{
    return [self playAudioWithData:data withName:nil inLine:@"default" withVolum:1.0 andRepeatCount:0];
}

-(BOOL)playAudioWithData:(NSData *)data withName:(NSString *)name{
    return [self playAudioWithData:data withName:name inLine:@"default" withVolum:1.0 andRepeatCount:0];
}

-(BOOL)playAudioWithData:(NSData *)data withName:(NSString *)name inLine:(NSString *)line{
    return [self playAudioWithData:data withName:name inLine:line withVolum:1.0 andRepeatCount:0];
}

-(BOOL)playAudioWithData:(NSData *)data withName:(NSString *)name inLine:(NSString *)line withVolum:(float)volum{
    return [self playAudioWithData:data withName:name inLine:line withVolum:volum andRepeatCount:0];
}

-(BOOL)playAudioWithData:(NSData *)data withName:(NSString *)name inLine:(NSString *)line withVolum:(float)volum andRepeatCount:(int)repeatCount{
    if(!data || data.length == 0)
        return NO;
    if(!line)
        line = @"default";
    
    if(![self.sounds objectForKey:line]){
        [self.sounds setObject:[NSArray array] forKey:line];
    }
    
    NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:line]];
    
    AVAudioPlayer *music=[[AVAudioPlayer alloc] initWithData:data error:nil];
    music.volume = volum;
    music.delegate = self;
    music.numberOfLoops = repeatCount;
    [music play];
    
    if(!music)
        return NO;
    
    NSDictionary *dictSound = @{kAMGSoundManagerKeyName:name?:@"data",
                                kAMGSoundManagerKeyPath:@"data",
                                kAMGSoundManagerKeyPlayer:music};
    [mut addObject:dictSound];
    [self.sounds setObject:mut forKey:line];
    
    return YES;
}

-(void)stopAllAudios{
    [self stopAudiosInLine:nil andAlsoWithName:nil andAlsoWithPath:nil];
}

-(void)stopAllAudiosForLine:(NSString *)line{
    [self stopAudiosInLine:line andAlsoWithName:nil andAlsoWithPath:nil];
}

-(void)stopAllAudiosWithoutLine{
    [self stopAudiosInLine:kAMGSoundManagerDefaultLine andAlsoWithName:nil andAlsoWithPath:nil];
}

-(void)stopAudioWithName:(NSString *)name{
    [self stopAudiosInLine:nil andAlsoWithName:name andAlsoWithPath:nil];
}

-(void)stopAudioWithPath:(NSString *)path{
    [self stopAudiosInLine:nil andAlsoWithName:nil andAlsoWithPath:path];
}

-(void)stopAudiosInLine:(NSString *)line andAlsoWithName:(NSString *)name andAlsoWithPath:(NSString *)path{
    for(NSString *key in self.sounds.allKeys){
        if(line && [line compare:key]!=NSOrderedSame)
            continue;
        
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AVAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            NSString *audio = [dict objectForKey:kAMGSoundManagerKeyName];
            NSString *audioPath = [dict objectForKey:kAMGSoundManagerKeyPath];
            
            if(name && [name compare:audio]!=NSOrderedSame)
                continue;
            
            if(path && [path compare:audioPath]!=NSOrderedSame)
                continue;
            
            [self stopAudio:player];
            
            NSMutableArray *mut2 = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
            [mut2 removeObject:dict];
            [self.sounds setObject:mut2 forKey:key];
        }
    }
}

-(void)stopAudio:(AVAudioPlayer *)player{
    player.delegate = nil;
    [player stop];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    for(NSString *key in self.sounds.allKeys){
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AVAudioPlayer *playerToCheck = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            NSString *audio = [dict objectForKey:kAMGSoundManagerKeyName];
            if(player == playerToCheck){
                
                NSMutableArray *mut2 = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
                [mut2 removeObject:dict];
                [self.sounds setObject:mut2 forKey:key];
                
                if(self.delegate && [self.delegate respondsToSelector:@selector(audioDidFinish:inLine:)]){
                    [self.delegate audioDidFinish:audio inLine:key];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kSoundManagerAudioEnded object:self userInfo:@{@"info":dict,@"line":key}];
                
            }
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    for(NSString *key in self.sounds.allKeys){
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AVAudioPlayer *playerToCheck = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            NSString *audio = [dict objectForKey:kAMGSoundManagerKeyName];
            if(player == playerToCheck){
                
                NSMutableArray *mut2 = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
                [mut2 removeObject:dict];
                [self.sounds setObject:mut2 forKey:key];
                
                if(self.delegate && [self.delegate respondsToSelector:@selector(audioErrorOcurred:inLine:)]){
                    [self.delegate audioErrorOcurred:audio inLine:key];
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
            AVAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            NSString *audio = [dict objectForKey:kAMGSoundManagerKeyName];
            
            if(name && [name compare:audio]!=NSOrderedSame)
                continue;
            
            if([player isPlaying])
                return YES;
        }
    }
    return NO;
}


-(void)setVolume:(float)volum forLine:(NSString*)line{
    for(NSString *key in self.sounds.allKeys){
        if(line && [line compare:key]!=NSOrderedSame)
            continue;
        
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AVAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            
            [player setVolume:volum];
        }
    }
}

-(void)pauseAudiosInLine:(NSString *)line{
    for(NSString *key in self.sounds.allKeys){
        if(line && [line compare:key]!=NSOrderedSame)
            continue;
        
        NSMutableArray *mut = [NSMutableArray arrayWithArray:[self.sounds objectForKey:key]];
        for(NSDictionary *dict in mut){
            AVAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            
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
            AVAudioPlayer *player = [dict objectForKey:kAMGSoundManagerKeyPlayer];
            
            if(![player isPlaying])
                [player play];
        }
    }
}


@end