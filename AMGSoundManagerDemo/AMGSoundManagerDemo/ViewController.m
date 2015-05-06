//
//  ViewController.m
//  AMGSoundManagerDemo
//
//  Created by iBoo Mobile on 5/5/15.
//  Copyright (c) 2015 Albert Montserrat. All rights reserved.
//

#import "ViewController.h"
#import "AMGSoundManager.h"

@interface ViewController ()<AMGSoundManagerDelegate>{
    float volume;
}

@end

@implementation ViewController



-(IBAction)playBackgroundMusic:(id)sender{
    if(![[AMGSoundManager sharedManager] isAudioPlayingInLine:@"background"]){
        [[AMGSoundManager sharedManager] playAudioAtPath:[[NSBundle mainBundle] pathForResource:@"background_music" ofType:@"mp3"]
                                                withName:@"ambient"
                                                  inLine:@"background"
                                               withVolum:volume_slider.value
                                          andRepeatCount:-1];
    }
}

-(IBAction)stopBackgroundMusic:(id)sender{
    [[AMGSoundManager sharedManager] stopAllAudiosForLine:@"background"];
}

-(IBAction)volumeSliderChanged:(id)sender{
    [[AMGSoundManager sharedManager] setVolume:volume_slider.value forLine:@"background"];
}

-(IBAction)playSound1:(id)sender{
    [[AMGSoundManager sharedManager] playAudioAtPath:[[NSBundle mainBundle] pathForResource:@"sound1" ofType:@"mp3"] withName:@"sound1"];
}

-(IBAction)playSound2:(id)sender{
    [[AMGSoundManager sharedManager] playAudioAtPath:[[NSBundle mainBundle] pathForResource:@"sound2" ofType:@"mp3"] withName:@"sound2"];
}



//Use this to play a sequense of different audios
-(void)audioDidFinish:(NSString *)audio inLine:(NSString *)line{
    NSLog(@"Audio %@ did finish in line %@",audio,line);
}

-(void)audioErrorOcurred:(NSString *)audio inLine:(NSString *)line{
    NSLog(@"Audio %@ did error in line %@",audio,line);
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
