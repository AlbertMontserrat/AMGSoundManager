//
//  AMGViewController.m
//  AMGSoundManager
//
//  Created by Albert M on 05/06/2015.
//  Copyright (c) 2014 Albert M. All rights reserved.
//

#import "AMGViewController.h"
#import <AMGSoundManager/AMGSoundManager.h>

@interface AMGViewController ()<AMGSoundManagerDelegate>{
    float volume;
}

@end

@implementation AMGViewController



-(IBAction)playBackgroundMusic:(id)sender{
    if(![[AMGSoundManager sharedManager] isAudioPlayingInLine:@"background"]){
        [[AMGSoundManager sharedManager] playAudio:[[NSBundle mainBundle] pathForResource:@"background_music" ofType:@"mp3"]
                                          withName:@"ambient"
                                            inLine:@"background"
                                        withVolume:volume_slider.value
                                    andRepeatCount:-1
                                      fadeDuration:1.0
                           withCompletitionHandler:^(BOOL success, BOOL stopped) {
                               NSLog(@"Audio has ended!");
                           }];
    }
}

-(IBAction)stopBackgroundMusic:(id)sender{
    [[AMGSoundManager sharedManager] stopAllAudiosForLine:@"background" withFadeDuration:1.0];
}

-(IBAction)volumeSliderChanged:(id)sender{
    [[AMGSoundManager sharedManager] setVolume:volume_slider.value forLine:@"background" withFadeDuration:2.0];
}

-(IBAction)playSound1:(id)sender{
    [[AMGSoundManager sharedManager] playAudio:[[NSBundle mainBundle] pathForResource:@"sound1" ofType:@"mp3"] withName:@"sound1" withCompletitionHandler:^(BOOL success, BOOL stopped) {
        NSLog(@"Audio has ended!");
    }];
}

-(IBAction)playSound2:(id)sender{
    [[AMGSoundManager sharedManager] playAudio:[[NSBundle mainBundle] pathForResource:@"sound2" ofType:@"mp3"] withName:@"sound2" withCompletitionHandler:^(BOOL success, BOOL stopped) {
        NSLog(@"Audio has ended!");
    }];
}



//Use this to play a sequense of different audios
-(void)audioDidFinish:(NSString *)name inLine:(NSString *)line{
    NSLog(@"Audio %@ did finish in line %@",name,line);
}

-(void)audioErrorOcurred:(NSString *)name inLine:(NSString *)line{
    NSLog(@"Audio %@ did error in line %@",name,line);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    volume_slider.maximumValue = 2.0;
    volume_slider.minimumValue = 0.0;
    volume_slider.value = 0.3;
    
    [[AMGSoundManager sharedManager] setDelegate:self];
    
}

@end
