//
//  W4RVoiceRepertoire.m
//  WaitingForRobot
//
//  Created by g j hilton on 14/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RVoiceRepertoire.h"

static NSMutableDictionary *_repertoire = nil;

NSString *const kVoicesAll			= @"all";
NSString *const kVoicesNotInUse		= @"notinuse";
NSString *const kVoicesGenderMale	= @"male";
NSString *const kVoicesGenderFemale	= @"female";
NSString *const kVoicesGenderNeuter	= @"neuter";
NSString *const kVoicesLangEN		= @"en";
NSString *const kVoicesLangGB		= @"gb";
NSString *const kVoicesLangUS		= @"us";
NSString *const kVoicesLangOther	= @"otherlang";
NSString *const kVoicesPremium		= @"premium";
NSString *const kVoicesNonPremium	= @"nonpremium";

@implementation W4RVoiceRepertoire

#pragma mark
#pragma mark public

+ (NSString *)shortVoiceName:(NSString *)fullVoiceName{
	NSString *voicename = @"";
	NSArray *parts = [fullVoiceName componentsSeparatedByString:@"."];
	unsigned long idx = [parts indexOfObject:@"voice"]+1;
	if (idx < [parts count]) voicename = parts[idx];
	return voicename;
}

+ (NSString *)getVoice:(NSString *)preferredVoice fallbackCriteria:(W4RVoiceTypeCriteria)criteria{
	// best case: can use requested voice
	if ([(NSSet *)[self voices][kVoicesNotInUse] containsObject:preferredVoice]) return preferredVoice;

	// next best case - fall back
	// NSLog(@"-> falling back to criteria");
	NSSet *candidates = [self availableVoiceSetMatchingAllOf:criteria];
	if ([candidates count] > 0) return [self randomMemberOf:candidates];

	// bad case - any available voice in English
	// NSLog(@"--> falling back to english");
	NSSet *english = [self availableVoiceSetMatchingAllOf:W4RVoiceTypeLangEN];
	if ([english count] > 0) return [self randomMemberOf:english];

	// worst case - any available voice
	//NSLog(@"---> falling back to any old voice");
	return [self randomMemberOf:[self voices][kVoicesNotInUse]];
	
}
+ (NSString *)getVoiceAndUse:(NSString *)preferredVoice fallbackCriteria:(W4RVoiceTypeCriteria)criteria{
	NSString *voice = [self getVoice:preferredVoice fallbackCriteria:criteria];
	[self use:voice];
	return voice;
}
+ (void)use:(NSString *)voice{
	NSMutableSet *notInUseVoices = [[self voices][kVoicesNotInUse] mutableCopy];
	[notInUseVoices removeObject:voice];
	if ([notInUseVoices count] == 0){
		NSLog(@"All voices used. Enabling reuse.");
		notInUseVoices = [[self voices][kVoicesAll] mutableCopy];
	}
	[self voices][kVoicesNotInUse] = notInUseVoices;
}

+(id)randomMemberOf:(NSSet *)inputSet{
	NSArray *members = [inputSet allObjects];
	return members[arc4random_uniform([members count])];
}

+ (NSSet *)availableVoiceSetMatchingAllOf:(W4RVoiceTypeCriteria)criteria {
	return [self voicesMatchingAllOf:criteria inSet:[[self voices][kVoicesNotInUse] mutableCopy]];
}
+ (NSSet *)availableVoiceSetMatchingAnyOf:(W4RVoiceTypeCriteria)criteria{
	NSMutableSet *resultSet = [[self voicesMatchingAnyOf:criteria inSet:[[NSSet alloc]init]] mutableCopy];
	[resultSet intersectSet:[self voices][kVoicesNotInUse]];
	return resultSet;
}
+ (NSSet *)availableVoiceSetExcluding:(W4RVoiceTypeCriteria)criteria{
	return [self voicesExcluding:criteria inSet:[[self voices][kVoicesNotInUse] mutableCopy]];
}

+ (NSSet *)voiceSetMatchingAllOf:(W4RVoiceTypeCriteria)criteria {
	return [self voicesMatchingAllOf:criteria inSet:[[self voices][kVoicesAll] mutableCopy]];
}
+ (NSSet *)voiceSetMatchingAnyOf:(W4RVoiceTypeCriteria)criteria{
	return [self voicesMatchingAnyOf:criteria inSet:[[NSSet alloc]init]];
}
+ (NSSet *)voiceSetExcluding:(W4RVoiceTypeCriteria)criteria{
	return [self voicesExcluding:criteria inSet:[[self voices][kVoicesAll] mutableCopy]];
}

+ (NSArray *)voiceArrayMatchingAllOf:(W4RVoiceTypeCriteria)criteria{
	return [[self voiceSetMatchingAllOf:criteria] allObjects];
}
+ (NSArray *)voiceArrayMatchingAnyOf:(W4RVoiceTypeCriteria)criteria{
	return [[self voiceSetMatchingAnyOf:criteria] allObjects];
}
+ (NSArray *)voiceArrayExcluding:(W4RVoiceTypeCriteria)criteria{
	return [[self voiceSetExcluding:criteria] allObjects];
}

+ (NSSet *)voicesMatchingAllOf:(W4RVoiceTypeCriteria)criteria inSet:(NSSet *)inputSet{
	NSMutableSet *resultSet = [inputSet mutableCopy];
	if (criteria & W4RVoiceTypeGenderMale)		[resultSet intersectSet:[self voices][kVoicesGenderMale]];
	if (criteria & W4RVoiceTypeGenderFemale)	[resultSet intersectSet:[self voices][kVoicesGenderFemale]];
	if (criteria & W4RVoiceTypeGenderNeuter)	[resultSet intersectSet:[self voices][kVoicesGenderNeuter]];
	if (criteria & W4RVoiceTypeLangEN)			[resultSet intersectSet:[self voices][kVoicesLangEN]];
	if (criteria & W4RVoiceTypeLangGB)			[resultSet intersectSet:[self voices][kVoicesLangGB]];
	if (criteria & W4RVoiceTypeLangUS)			[resultSet intersectSet:[self voices][kVoicesLangUS]];
	if (criteria & W4RVoiceTypeLangOther)		[resultSet intersectSet:[self voices][kVoicesLangOther]];
	if (criteria & W4RVoiceTypePremium)			[resultSet intersectSet:[self voices][kVoicesPremium]];
	if (criteria & W4RVoiceTypeNonPremium)		[resultSet intersectSet:[self voices][kVoicesNonPremium]];
	return resultSet;
}
+ (NSSet *)voicesMatchingAnyOf:(W4RVoiceTypeCriteria)criteria inSet:(NSSet *)inputSet{
	NSMutableSet *resultSet = [inputSet mutableCopy];
	if (criteria & W4RVoiceTypeGenderMale)		[resultSet unionSet:[self voices][kVoicesGenderMale]];
	if (criteria & W4RVoiceTypeGenderFemale)	[resultSet unionSet:[self voices][kVoicesGenderFemale]];
	if (criteria & W4RVoiceTypeGenderNeuter)	[resultSet unionSet:[self voices][kVoicesGenderNeuter]];
	if (criteria & W4RVoiceTypeLangEN)			[resultSet unionSet:[self voices][kVoicesLangEN]];
	if (criteria & W4RVoiceTypeLangGB)			[resultSet unionSet:[self voices][kVoicesLangGB]];
	if (criteria & W4RVoiceTypeLangUS)			[resultSet unionSet:[self voices][kVoicesLangUS]];
	if (criteria & W4RVoiceTypeLangOther)		[resultSet unionSet:[self voices][kVoicesLangOther]];
	if (criteria & W4RVoiceTypePremium)			[resultSet unionSet:[self voices][kVoicesPremium]];
	if (criteria & W4RVoiceTypeNonPremium)		[resultSet unionSet:[self voices][kVoicesNonPremium]];
	return resultSet;
}
+ (NSSet *)voicesExcluding:(W4RVoiceTypeCriteria)criteria inSet:(NSSet *)inputSet{
	NSMutableSet *resultSet = [inputSet mutableCopy];
	if (criteria & W4RVoiceTypeGenderMale)		[resultSet minusSet:[self voices][kVoicesGenderMale]];
	if (criteria & W4RVoiceTypeGenderFemale)	[resultSet minusSet:[self voices][kVoicesGenderFemale]];
	if (criteria & W4RVoiceTypeGenderNeuter)	[resultSet minusSet:[self voices][kVoicesGenderNeuter]];
	if (criteria & W4RVoiceTypeLangEN)			[resultSet minusSet:[self voices][kVoicesLangEN]];
	if (criteria & W4RVoiceTypeLangGB)			[resultSet minusSet:[self voices][kVoicesLangGB]];
	if (criteria & W4RVoiceTypeLangUS)			[resultSet minusSet:[self voices][kVoicesLangUS]];
	if (criteria & W4RVoiceTypeLangOther)		[resultSet minusSet:[self voices][kVoicesLangOther]];
	if (criteria & W4RVoiceTypePremium)			[resultSet minusSet:[self voices][kVoicesPremium]];
	if (criteria & W4RVoiceTypeNonPremium)		[resultSet minusSet:[self voices][kVoicesNonPremium]];
	return resultSet;
}

#pragma mark
#pragma mark private

+ (NSMutableDictionary *)voices {
	if (_repertoire == nil){
		_repertoire = [[self indexVoices] mutableCopy];
	}
	return _repertoire;
}

+ (NSDictionary *)indexVoices {

	NSSet *allVoices		= [[NSSet alloc] initWithArray:[NSSpeechSynthesizer availableVoices]];
	NSSet *notInUseVoices	= [NSSet setWithSet:allVoices];
	NSSet *maleVoices		= [[NSSet alloc] init];
	NSSet *femaleVoices		= [[NSSet alloc] init];
	NSSet *neuterVoices		= [[NSSet alloc] init];
	NSSet *enVoices			= [[NSSet alloc] init];
	NSSet *usVoices			= [[NSSet alloc] init];
	NSSet *gbVoices			= [[NSSet alloc] init];
	NSSet *nonenglishVoices	= [[NSSet alloc] init];
	NSSet *premiumVoices	= [[NSSet alloc] init];
	NSSet *nonpremiumVoices	= [[NSSet alloc] init];

	for (NSString *voice in allVoices){
		NSDictionary *attrs = [NSSpeechSynthesizer attributesForVoice:voice];

		// classify by language
		NSArray *language = [attrs[NSVoiceLocaleIdentifier] componentsSeparatedByString:@"_"];
		if ([language[0] isEqualToString:@"en"]){
			enVoices = [enVoices setByAddingObject:voice];
			if([language[1] isEqualToString:@"GB"]){
				gbVoices = [gbVoices setByAddingObject:voice];
			} else {
				usVoices = [usVoices setByAddingObject:voice];
			}
		} else {
			nonenglishVoices = [nonenglishVoices setByAddingObject:voice];
		}

		// classify by gender
		NSString *gender = attrs[NSVoiceGender];
		if ([gender isEqualToString:NSVoiceGenderMale]) maleVoices = [maleVoices setByAddingObject:voice];
		if ([gender isEqualToString:NSVoiceGenderFemale]) femaleVoices = [femaleVoices setByAddingObject:voice];
		if ([gender isEqualToString:NSVoiceGenderNeuter]) neuterVoices = [neuterVoices setByAddingObject:voice];

		// classify by premium
		if ([voice rangeOfString:@".premium"].location == NSNotFound){
			nonpremiumVoices = [nonpremiumVoices setByAddingObject:voice];
		} else {
			premiumVoices = [premiumVoices setByAddingObject:voice];
		}

	}

	NSDictionary *d = @{
		kVoicesAll:allVoices,
		kVoicesNotInUse:notInUseVoices,
		kVoicesGenderMale:maleVoices,
		kVoicesGenderFemale:femaleVoices,
		kVoicesGenderNeuter:neuterVoices,
		kVoicesLangEN:enVoices,
		kVoicesLangGB:gbVoices,
		kVoicesLangUS:usVoices,
		kVoicesLangOther:nonenglishVoices,
		kVoicesPremium:premiumVoices,
		kVoicesNonPremium:nonpremiumVoices
	};
	return d;
}

/*
+(void)test{

	// test combinations
	int criteria = W4RVoiceTypeGenderMale | W4RVoiceTypeLangGB;
	NSLog(@"ALL: %@",[W4RSpeechVoiceRepetoire voiceSetMatchingAllOf:criteria]);
	NSLog(@"ANY: %@",[W4RSpeechVoiceRepetoire voiceSetMatchingAnyOf:criteria]);
	NSLog(@"NOT: %@",[W4RSpeechVoiceRepetoire voiceSetExcluding:criteria]);

	// test getting
	NSString *target = @"com.apple.speech.synthesis.voice.emily.premium";
	int fbc = W4RVoiceTypeGenderFemale | W4RVoiceTypeLangEN;
	NSLog(@"###### Emily");
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"###### Women");
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"###### English");
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"######Foreign");
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
	NSLog(@"######Emily");
	NSLog(@"%@",[W4RSpeechVoiceRepetoire getVoiceAndUse:target fallbackCriteria:fbc]);
}
*/

@end