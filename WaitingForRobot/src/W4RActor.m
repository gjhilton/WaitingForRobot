//
//  W4RActor.m
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RActor.h"
#import "W4RPlayController.h"

@interface W4RActor()

@property (nonatomic, strong) NSSpeechSynthesizer *speechSynth;

@end

@implementation W4RActor

- (id)initWithVoice:(NSString *)voice scene:(W4RPlayController *)scene name:(NSString *)name{
	if (self = [super init]) {
		self.name = name;
		self.voice = voice;
		[self.speechSynth setDelegate:scene];
    }
    return self;
}

- (void)setVoice:(NSString *)fullVoiceName{
	_voice = fullVoiceName;
}

- (void)setSpeechSpeed:(int)speed{
	[self.speechSynth setRate:speed];
}

- (NSSpeechSynthesizer *)speechSynth{
	if (!_speechSynth){
		if (self.voice){
			_speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:self.voice];
		} else {
			_speechSynth = [[NSSpeechSynthesizer alloc] init];
		}
	}
	return _speechSynth;
}

- (void)say:(NSString *)line{
	[self.speechSynth startSpeakingString:line];
}

- (void)pause{
	[self.speechSynth pauseSpeakingAtBoundary:NSSpeechImmediateBoundary];
}

- (void)resume{
	[self.speechSynth continueSpeaking];
}

- (void)shush{
	[self.speechSynth stopSpeaking];
}

- (BOOL)canResume{
	// the end event won't be fired if we resume with 0 characters left
	NSNumber *n = [[self.speechSynth objectForProperty:NSSpeechStatusProperty error:NULL] objectForKey:NSSpeechStatusNumberOfCharactersLeft];
	BOOL result = [n integerValue] > 0;
	// if (!result) NSLog(@"Caught a resume error");
	return result;
}

@end
