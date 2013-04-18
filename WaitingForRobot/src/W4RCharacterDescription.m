//
//  W4RCharacterDescription.m
//  WaitingForRobot
//
//  Created by g j hilton on 16/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RCharacterDescription.h"

@implementation W4RCharacterDescription

- (id) initWithName:(NSString *)name
			  voice:(NSString *)preferredVoice
   fallbackCriteria:(W4RVoiceTypeCriteria)criteria
		  performer:(BOOL)isPerformer
{
	if (self = [super init]) {
		_name = name;
		_voice = [W4RVoiceRepertoire getVoiceAndUse:preferredVoice fallbackCriteria:criteria];
		_isPerformer = isPerformer;
	}
    return self;
}

- (NSString *) voiceName{
	return [W4RVoiceRepertoire shortVoiceName:self.voice];
}

@end
