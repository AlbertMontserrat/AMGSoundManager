//
//  AMGAudioPlayer.m
//  Pods
//
//  Created by iBoo Mobile on 21/3/16.
//
//

#import "AMGAudioPlayer.h"

#define kAMGVolumeChangesPerSecond 15.0

@interface AMGAudioPlayer (){
    CGFloat targetVolume;
    CGFloat intervals;
}

@end

@implementation AMGAudioPlayer

-(void)setVolume:(float)volume withFadeDuration:(CGFloat)fadeDuration{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(iterateChangeVolume) object:nil];
    
    if(fadeDuration == 0.0){
        [self setVolume:volume];
    }else{
        targetVolume = volume;
        intervals = (targetVolume - self.volume) / (fadeDuration / (1 / kAMGVolumeChangesPerSecond));
        [self iterateChangeVolume];
    }
}

-(void)iterateChangeVolume{
    
    if(targetVolume == self.volume){
        return;
    }
    
    self.volume += intervals;
    NSLog(@"Volume: %.2f", self.volume);
    
    if((intervals < 0 && self.volume < targetVolume) || (intervals > 0 && self.volume > targetVolume)){
        self.volume = targetVolume;
    }
    
    [self performSelector:@selector(iterateChangeVolume) withObject:nil afterDelay:(1 / kAMGVolumeChangesPerSecond)];
    
}

@end
