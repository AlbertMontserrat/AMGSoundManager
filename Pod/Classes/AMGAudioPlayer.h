//
//  AMGAudioPlayer.h
//  Pods
//
//  Created by iBoo Mobile on 21/3/16.
//
//

#import <AVFoundation/AVFoundation.h>

@interface AMGAudioPlayer : AVAudioPlayer

-(void)setVolume:(float)volume withFadeDuration:(CGFloat)fadeDuration;

@end
