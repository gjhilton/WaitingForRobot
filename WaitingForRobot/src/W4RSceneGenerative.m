//
//  W4RSceneGenerative.m
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RSceneGenerative.h"
#import "W4RCorpusMarkov.h"
#import "W4RCharacterDescription.h"
#import "Random.h"

#define CHARACTER_NAME_PLACEHOLDER @"^CHARACTERNAME^"

@interface W4RSceneGenerative()

@property (nonatomic,strong) W4RCharacterDescription *lastSpeaker;
@property (nonatomic,strong) W4RCorpusAbstract *corpus;

@end

@implementation W4RSceneGenerative

- (id)initWithNCharacters:(int)nCharacters
		  preferredVoices:(NSArray *)preferredVoices
			voiceCriteria:(W4RVoiceTypeCriteria)criteria
				  rawFile:(NSString *)rawFile
			   corpusFile:(NSString *)corpusFile
		  withNGramLength:(int)ngl
	  maxSentencesPerLine:(int)maxSentencesPerLine
			nextSceneName:(NSString *)nextSceneName
	 beginWithRandomNGram:(BOOL)beginWithRandomNGram
		  allowDuplicates:(BOOL)allowDuplicates;
{
	if (self = [super init]) {
		self.nextSceneName = nextSceneName;
		self.characterDescriptions = [self generateNRandomCharacterDescriptions:nCharacters preferredVoices:preferredVoices voiceCriteria:criteria];
#if defined USE_RAW_TEXT_CORPORA
		_corpus = [[W4RCorpusMarkov alloc]
				   initWithRawText:rawFile
				   withNGramLength:ngl
				   maxSentencesPerLine:maxSentencesPerLine
				   beginWithRandomNGram:beginWithRandomNGram
				   allowDuplicates:allowDuplicates];
# else
		_corpus = [[W4RCorpusMarkov alloc]
				   initWithCorpusFile:(NSString *)corpusFile
				   withNGramLength:ngl
				   maxSentencesPerLine:maxSentencesPerLine
				   beginWithRandomNGram:beginWithRandomNGram
				   allowDuplicates:allowDuplicates];
#endif
	}
	return self;
}

- (NSArray *)generateNRandomCharacterDescriptions:(int)nCharacters preferredVoices:(NSArray *)preferredVoices voiceCriteria:(W4RVoiceTypeCriteria)criteria{
	NSArray *descriptions = [[NSArray alloc]init];
	for (int i = 0; i<nCharacters;i++){
		W4RCharacterDescription *character = [[W4RCharacterDescription alloc]
									  initWithName:[self generateCharacterName]
											  voice: i < [preferredVoices count] ? preferredVoices[i] : nil
											  fallbackCriteria:criteria
											  performer:YES];
		descriptions = [descriptions arrayByAddingObject:character];
	}
	return descriptions;
}

- (NSString *)generateCharacterName{
	NSString *consonant = [Random consonant];
	NSString *vowel = [Random vowel];
	return [NSString stringWithFormat:@"[[char NORM]]%@%@-[[char NORM]]%@%@",[consonant uppercaseString],vowel,consonant,vowel]; // [[char NORM]] is a speech synth embedded command that prevents 'Zo-zo' being read as 'zo zee oh'
}

- (NSString *) dramatisPersonae{
	NSString *personae = @"";
	int counter = 0;
	for (W4RCharacterDescription *character in self.characterDescriptions){
		NSString *s = [NSString stringWithFormat:@" With %@ as %@.", character.voiceName, character.name];
		if (counter == 0) {
			s = [NSString stringWithFormat:@" The part of %@ is played by %@.", character.name, character.voiceName];
		} else {
			unsigned long nCharacters = [self.characterDescriptions count];
			if (([self.characterDescriptions count] > 2) && (counter == nCharacters-1)) s = [NSString stringWithFormat:@" And %@ as %@.", character.voiceName, character.name];
		}
		personae = [personae stringByAppendingString:s];
		counter++;
	}
	return personae;
}

- (W4RCharacterDescription *)nextSpeaker{
	NSMutableArray *availableCharacters = [self.characterDescriptions mutableCopy];
	if (self.lastSpeaker) [availableCharacters removeObject:self.lastSpeaker];
	W4RCharacterDescription *character = [Random fromArray:availableCharacters];
	self.lastSpeaker = character;
	return character;
}

- (NSArray *)line{
	NSString *name = [self nextSpeaker].name;
	NSString *speech = [self replacePlaceholdersIn:[self.corpus generate]];
	return @[name,speech];
}

// character names are placeholdered in the input corpora
- (NSString *)replacePlaceholdersIn:(NSString *)input{
	NSString *name = [self nameOfRandomlySelectedCharacterNot:self.lastSpeaker.name];
	NSString *output = [input stringByReplacingOccurrencesOfString:CHARACTER_NAME_PLACEHOLDER withString:name];
	return output; // FIXME - this uses same name every time, should generate new name for each
}

@end
