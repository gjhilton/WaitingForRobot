//
//  W4RVoiceRepertoire.h
//  WaitingForRobot
//
//  Created by g j hilton on 14/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum {
	W4RVoiceTypeGenderMale		= 1 << 0,
	W4RVoiceTypeGenderFemale	= 1 << 1,
	W4RVoiceTypeGenderNeuter	= 1 << 2,
	W4RVoiceTypeLangEN			= 1 << 3,
	W4RVoiceTypeLangGB			= 1 << 4,
	W4RVoiceTypeLangUS			= 1 << 5,
	W4RVoiceTypeLangOther		= 1 << 6,
	W4RVoiceTypePremium			= 1 << 7,
	W4RVoiceTypeNonPremium		= 1 << 8
};
typedef NSUInteger W4RVoiceTypeCriteria;

@interface W4RVoiceRepertoire : NSObject

+ (NSString *)shortVoiceName:(NSString *)fullVoiceName;

/*
 
 int criteria = W4RVoiceTypeGenderMale | W4RVoiceTypeLangGB;
 
 voiceSetMatchingAllOf:criteria ->
	"com.apple.speech.synthesis.voice.daniel.premium"

 voiceSetMatchingAnyOf:criteria ->
	"com.apple.speech.synthesis.voice.Fred",
	"com.apple.speech.synthesis.voice.serena.premium",
	"com.apple.speech.synthesis.voice.emily.premium",
	"com.apple.speech.synthesis.voice.Junior",
	"com.apple.speech.synthesis.voice.Alex",
	"com.apple.speech.synthesis.voice.Bruce",
	"com.apple.speech.synthesis.voice.Ralph",
	"com.apple.speech.synthesis.voice.daniel.premium"
 
 voiceSetExcluding:criteria ->
	"com.apple.speech.synthesis.voice.Hysterical",
	"com.apple.speech.synthesis.voice.Agnes",
	"com.apple.speech.synthesis.voice.Cellos",
	"com.apple.speech.synthesis.voice.steffi.premium",
	"com.apple.speech.synthesis.voice.Trinoids",
	"com.apple.speech.synthesis.voice.Boing",
	"com.apple.speech.synthesis.voice.Vicki",
	"com.apple.speech.synthesis.voice.Deranged",
	"com.apple.speech.synthesis.voice.Victoria",
	"com.apple.speech.synthesis.voice.Whisper",
	"com.apple.speech.synthesis.voice.samantha.premium",
	"com.apple.speech.synthesis.voice.Zarvox",
	"com.apple.speech.synthesis.voice.Princess",
	"com.apple.speech.synthesis.voice.GoodNews",
	"com.apple.speech.synthesis.voice.Albert",
	"com.apple.speech.synthesis.voice.Kathy",
	"com.apple.speech.synthesis.voice.Bells",
	"com.apple.speech.synthesis.voice.Bahh",
	"com.apple.speech.synthesis.voice.Organ",
	"com.apple.speech.synthesis.voice.virginie.premium",
	"com.apple.speech.synthesis.voice.Bubbles",
	"com.apple.speech.synthesis.voice.BadNews"

*/

+ (NSSet *)voiceSetMatchingAllOf:(W4RVoiceTypeCriteria)criteria;
+ (NSSet *)voiceSetMatchingAnyOf:(W4RVoiceTypeCriteria)criteria;
+ (NSSet *)voiceSetExcluding:(W4RVoiceTypeCriteria)criteria;

+ (NSArray *)voiceArrayMatchingAllOf:(W4RVoiceTypeCriteria)criteria;
+ (NSArray *)voiceArrayMatchingAnyOf:(W4RVoiceTypeCriteria)criteria;
+ (NSArray *)voiceArrayExcluding:(W4RVoiceTypeCriteria)criteria;

+ (NSSet *)availableVoiceSetMatchingAllOf:(W4RVoiceTypeCriteria)criteria;
+ (NSSet *)availableVoiceSetMatchingAnyOf:(W4RVoiceTypeCriteria)criteria;
+ (NSSet *)availableVoiceSetExcluding:(W4RVoiceTypeCriteria)criteria;

+ (void)use:(NSString *)voice;
+ (NSString *)getVoice:(NSString *)preferredVoice fallbackCriteria:(W4RVoiceTypeCriteria)criteria;
+ (NSString *)getVoiceAndUse:(NSString *)preferredVoice fallbackCriteria:(W4RVoiceTypeCriteria)criteria;

@end
