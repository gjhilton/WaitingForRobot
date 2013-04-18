//
//  W4RPerformer.m
//  WaitingForRobot
//
//  Created by g j hilton on 16/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RPerformer.h"
#import "Random.h"

// #define PERFORMANCE_DEBUG_PLACEHOLDERS_ONLY // should be undefined in production - useful for debugging decorateWithPerformaceCommands:
#define MIN_VOLUME 0.2
#define MIN_PAUSE_MS 100
#define MOMENTARY_PAUSE_MS 250
#define BRIEF_PAUSE_MS 2000
#define LONG_PAUSE_MS 4000
#define DEFAULT_HESITATION 0.4
#define DEFAULT_DYNAMICS 0
#define DEFAULT_INFLECTION 0.1

@implementation W4RPerformer

- (id)initWithVoice:(NSString *)voice scene:(W4RPlayController *)scene name:(NSString *)name{
	if (self = [super initWithVoice:voice scene:scene name:name]) {
		self.hesitation = DEFAULT_HESITATION;
		self.inflection = DEFAULT_INFLECTION;
		self.dynamics = DEFAULT_DYNAMICS;
    }
    return self;
}

- (void)say:(NSString *)line{
	line = [self decorateWithPerformaceCommands:line];
	[super say:line];
}

#pragma mark
#pragma mark setters

- (void)setHesitation:(float)hesitation{
	_hesitation = [self clamp:hesitation];
}
- (void)setDynamics:(float)dynamics{
	_dynamics = [self clamp:dynamics];
}
- (void)setInflection:(float)inflection{
	_inflection = [self clamp:inflection];

}
- (float)clamp:(float) f{
	if (f > 1) f = 1;
	if (f < 0) f = 0;
	return f;
}

#pragma mark
#pragma mark generative performance hints

- (NSString *)decorateWithPerformaceCommands:(NSString *)inString{
	NSCharacterSet *toTrim = [NSCharacterSet whitespaceAndNewlineCharacterSet];

	NSMutableArray *lines = [[[inString stringByTrimmingCharactersInSet:toTrim] componentsSeparatedByString:@"."] mutableCopy];
	[lines removeLastObject];
	for (int lineNum=0; lineNum< [lines count]; lineNum++){
		NSString *line = lines[lineNum];
		NSMutableArray *words = [[[line stringByTrimmingCharactersInSet:toTrim] componentsSeparatedByString:@" "] mutableCopy];
		for (int wordNum=0; wordNum < [words count];wordNum++){
			NSString *word = words[wordNum];

			// each word preceded by possible inflection
			word = [[self possibleInflection] stringByAppendingString:word];
			// each word preceded by possible pause
			NSString *pause;
			if (wordNum==0){
				if (lineNum==0){
					pause = [self possibleLinePause];
				} else {
					pause = [self possibleSentencePause];
				}
			} else {
				pause = [self possibleWordPause];
			}
			word = [pause stringByAppendingString:word];
			words[wordNum] = word;
		}
		// each line preceded by potential dynamics
		line = [[self possibleDynamics] stringByAppendingString:[words componentsJoinedByString:@" "]];
# if defined PERFORMANCE_DEBUG_PLACEHOLDERS_ONLY
		line = [@"\n" stringByAppendingString:line];
# endif
		lines[lineNum] = line;
	}
	return [[lines componentsJoinedByString:@". "] stringByAppendingString:@"."];
}

- (NSString *)possibleHesitation:(int)maxLength{
	return self.hesitation > 0 ? [self speechCommandSilence:arc4random_uniform(maxLength * self.hesitation)] : @"";
}

# if defined PERFORMANCE_DEBUG_PLACEHOLDERS_ONLY
- (NSString *)possibleInflection{
	return @"[inflection]";
}
- (NSString *)possibleDynamics{
	return @"[dynamics]";
}
- (NSString *)possibleWordPause{
	return @"[pause word]";
}
- (NSString *)possibleSentencePause{
	return @"[pause sentence]";
}
- (NSString *)possibleLinePause{
	return @"[pause line]";
}
# else
- (NSString *)possibleInflection{
	return [Random withProbability:self.inflection] ? [self speechCommandStress:[Random evenly] ? @"+": @"-"] : @"";
}
- (NSString *)possibleDynamics{
	return [Random withProbability:self.dynamics] ? [self speechCommandAbsoluteVolume:[Random f]] : @"";
}
- (NSString *)possibleWordPause{
	return [self possibleHesitation:MOMENTARY_PAUSE_MS];
}
- (NSString *)possibleSentencePause{
	return [self possibleHesitation:BRIEF_PAUSE_MS];
}
- (NSString *)possibleLinePause{
	return [self possibleHesitation:LONG_PAUSE_MS];
}
# endif

- (NSString *)speechCommandStress:(NSString *)plusOrMinus{
	return [NSString stringWithFormat:@"[[emph %@]]", plusOrMinus];
}
- (NSString *)speechCommandAbsoluteVolume:(float)vol{
	if (vol > 1) vol = 1;
	if (vol < MIN_VOLUME) vol = MIN_VOLUME;
	return [NSString stringWithFormat:@"[[volm %f]]", vol];
}
- (NSString *)speechCommandSilence:(int)milliseconds{
	return(milliseconds < MIN_PAUSE_MS) ? @"" : [NSString stringWithFormat:@"[[slnc %d]]", milliseconds];
}


@end
