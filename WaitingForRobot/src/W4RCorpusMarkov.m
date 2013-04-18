//
//  W4RCorpusMarkov.m
//  WaitingForRobot
//
//  Created by g j hilton on 09/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RCorpusMarkov.h"
#import "Random.h"

typedef NSArray NGram;

@interface W4RCorpusMarkov()

@property (readonly) NSCharacterSet *sentenceEndCharacters;
@property (nonatomic, strong) NGram *previousNGram;
@property (nonatomic) int ngramLength;
@property (nonatomic) int maxSentencesPerLine;
@property (nonatomic) BOOL beginWithRandomNGram;
@property (nonatomic) BOOL allowDuplicates;

@end

@implementation W4RCorpusMarkov

-(id)initWithRawText:(NSString *)filePath
	 withNGramLength:(int)ngramLength
 maxSentencesPerLine:(int)maxSentencesPerLine
beginWithRandomNGram:(BOOL)beginWithRandomNGram
	 allowDuplicates:(BOOL)allowDuplicates
{
	if (self = [super init]) {
		self.ngramLength = ngramLength;
		self.beginWithRandomNGram = beginWithRandomNGram;
		self.allowDuplicates = allowDuplicates;
		self.maxSentencesPerLine = maxSentencesPerLine;
		self.model = [self makeCorpusFromTextFile:filePath];
		[self optionallySaveCorpusFileFor:filePath];
    }
    return self;
}

-(id)initWithCorpusFile:(NSString *)filePath
		withNGramLength:(int)ngramLength
	maxSentencesPerLine:(int)maxSentencesPerLine
   beginWithRandomNGram:(BOOL)beginWithRandomNGram
		allowDuplicates:(BOOL)allowDuplicates
{
	if (self = [super init]) {
		self.ngramLength = ngramLength;
		self.beginWithRandomNGram = beginWithRandomNGram;
		self.allowDuplicates = allowDuplicates;
		self.maxSentencesPerLine = maxSentencesPerLine;
		self.model = [self loadCorpusFile:filePath];
    }
    return self;
}

-(id)initWithRawText:(NSString *)filePath{
	return nil; // ERROR: W4RCorpusMarkov needs to be initialised with NGramLength
}

-(id)initWithCorpusFile:(NSString *)filePath{
	return nil; // ERROR: W4RCorpusMarkov needs to be initialised with NGramLength
}

#pragma mark
#pragma mark W4RCorpus implementation

// generate a line consisting of a small random number of sentences
- (NSString *)generate{
	return [self generateNextLine];
}

- (NSDictionary *)makeCorpusFromTextFile:(NSString *)filePath{
	NSString *rawText = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
	NSCharacterSet *separator = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	__block NSMutableDictionary *tempModel = [[NSMutableDictionary alloc]init];
	__block NGram *currentNG = [self makeEmptyNGram];
	__block NSArray *firstWordsOfDocument = @[]; // used for workaround - see below
	LineIterator lineHandler = ^(NSString *line, BOOL *stop){
		NSArray *words = [line componentsSeparatedByCharactersInSet:separator];
		for (NSString *word in words){
			if ([firstWordsOfDocument count]<self.ngramLength) firstWordsOfDocument = [firstWordsOfDocument arrayByAddingObject:word];
			if ([word isEqualToString:@""]) NSLog(@"WARNING: empty string after %@", [self stringFromNGram:currentNG]); // often happens if there is trailing whitespace
			[self addToken:word toModel:tempModel forNGram:currentNG];
			currentNG = [self makeNGramByPushing:word ontoNGram:currentNG];
		}
	 };
	[rawText enumerateLinesUsingBlock:lineHandler];

	// WORKAROUND
	// The last word of the input is a potential problem, as there's potentially nowhere to go from here.
	//
	// To prevent this, we make the end of the text point to the beginning by constructing new ngrams
	for (NSString *word in firstWordsOfDocument){
		[self addToken:word toModel:tempModel forNGram:currentNG];
		currentNG = [self makeNGramByPushing:word ontoNGram:currentNG];
	}

	// Confirm that the workaround worked...
	if ([self validateModel:tempModel]){
		NSLog(@"SUCCESS: model validated. Contiuing.");
		[self printNGramCountForModel:tempModel];
		return tempModel;
	} else {
		NSString *errorReport = @"ERROR: model is invalid. Stopping.";
		NSLog(@"%@",errorReport);
		[[NSAlert alertWithMessageText:errorReport
						 defaultButton:@"Drat!"
					   alternateButton:nil
						   otherButton:nil
			 informativeTextWithFormat:@""]
		 runModal];
		return @[][1]; // intentional crash
	}
}

- (NSMutableDictionary *) addToken:(NSString *)token toModel:(NSMutableDictionary *)model forNGram:(NGram *)ng{
	NSArray *productions = model[ng];
	if (!productions) {
		productions = [[NSArray alloc]init];
	}
	if ((self.allowDuplicates) || (![productions containsObject:token])){
		productions = [productions arrayByAddingObject:token];
	}
	[model setObject:productions forKey:ng];
	return model;
}

// NSDictionary:writeToFile doesnt' support arrays as keys, so use an archive instead :(
- (NSMutableDictionary *)loadCorpusFile:(NSString *)filePath{
	return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}
- (BOOL) saveCorpusFile:(NSString *)filePath{
	return [NSKeyedArchiver archiveRootObject:self.model toFile:filePath];
}

#pragma mark
#pragma mark developer utils

- (BOOL) validateModel:(NSDictionary *)model{

	// step one: are there productions for every key? (shouldn't ever fail)
	for (NGram *ng in [model allKeys]){
		NSArray *productions = model[ng];
		unsigned long nProductions = [productions count];
		if (nProductions <1){
			NSLog(@"ERROR in model. No productions for [%@].",[self stringFromNGram:ng]);
			return NO;
		}
	}
	
	// step two: is there a key for every possible ngram generated?
	for (NGram *ng in [model allKeys]){
		NSArray *productions = model[ng];
		for (NSString * production in productions){
			NGram *nextNG = [self makeNGramByPushing:production ontoNGram:ng];
			NSArray *nextProductions = model[nextNG];
			if (!nextProductions || [nextProductions count] < 1){
				NSLog(@"ERROR in model. %@ might generate \"%@\", creating ngram %@ which has 0 productions.",
					  [self stringFromNGram:ng],
					  production,
					  [self stringFromNGram:nextNG]);
				return NO;
			}
		}
	}

	// if we got here, we're fine!
	return YES;
}
- (void) prettyPrintModel:(NSDictionary *)model{
	for (NGram *ng in [model allKeys]){
		NSLog(@"%@ --> %@",[self stringFromNGram:ng], [self productionsForNGramAsString:ng]);
	}
	[self printNGramCountForModel:model];
}
- (void) testNGram:(NGram *)ng{
	NSLog(@"%@ -> %@  --> eg: %@",
		  [self stringFromNGram:ng],
		  [self productionsForNGramAsString:ng],
		  [self randomProductionForNGram:ng]);
}
- (NSString *) productionsForNGramAsString:(NGram *)ng{
	return [NSString stringWithFormat:@"[%@]", [self.model[ng] componentsJoinedByString:@", "]];
}
- (NSString *) stringFromNGram:(NGram *)ng{
	NSString *s = [NSString stringWithFormat:@"[%@]", [ng componentsJoinedByString:@" "]];
	if ([[self.model allKeys] containsObject:ng]){
		s = [s stringByAppendingFormat:@"(%ld productions)", [[self productionsForNGram:ng] count]];
	}
	return s;
}
- (void) printNGramCountForModel:(NSDictionary *)model{
	NSLog(@"TOTAL: %ld ngrams in model", [[model allKeys]count]);
}

#pragma mark
#pragma mark lazy properties

- (NGram *) previousNGram{
	if (!_previousNGram){
		if (self.beginWithRandomNGram){
			_previousNGram = [self chooseRandomNGram];
		} else{
			_previousNGram = [self makeEmptyNGram];
		}
	}
	return _previousNGram;
}

- (NSCharacterSet *) sentenceEndCharacters{
	return [NSCharacterSet characterSetWithCharactersInString:@".!?:"];
}

#pragma mark
#pragma mark ngram manipulation

- (NGram *) makeEmptyNGram{
	return  [[NGram alloc] init];
}

- (NGram *) chooseRandomNGram{
	return  [Random fromArray:[self.model allKeys]];
}

- (NGram *) makeNGramByPushing:(NSString*)nextToken ontoNGram:ng{
	NSMutableArray *ngm = [ng mutableCopy];
	if ([ngm count] >= self.ngramLength) [ngm removeObjectAtIndex:0];
	[ngm addObject:nextToken];
	ng = [NSArray arrayWithArray:ngm];
	return ng;
}

- (void) updatePreviousNGramWith:(NSString*)nextToken{
	self.previousNGram = [self makeNGramByPushing:nextToken ontoNGram:self.previousNGram];
}

#pragma mark
#pragma mark generation utils

// get all possible strings that could follow nGram
- (NSArray *) productionsForNGram:(NGram *)ng{
	return self.model[ng];
}

// get a random string to follow nGram
- (NSString *) randomProductionForNGram:(NGram *)ng{
	NSArray *candidates = [self productionsForNGram:ng];
	if (!candidates || ([candidates count] < 1)){
		NSLog(@"ERROR: Couldnt find any productions for ngram: %@",[self stringFromNGram:ng]);
		return nil;
	}
	return [Random fromArray:candidates];
}

// get the last character of a string
- (unichar) getLastCharacterOfString:(NSString *)s{
	return [s characterAtIndex:(s.length - 1)];
}

#pragma mark
#pragma mark generation next x

// generate a single token - ie most probably a word
- (NSString *) generateNextToken{
	NSString *token = [self randomProductionForNGram:self.previousNGram];
	[self updatePreviousNGramWith:token];
	return token;
}

// generate a number of tokens
- (NSString *) generateNextNTokens:(int)n{
	NSArray *tokens = @[];
	for (int i=0;i<n;i++){
		tokens = [tokens arrayByAddingObject:[self generateNextToken]];
	}
	return [tokens componentsJoinedByString:@" "];
}

// generate one sentence
- (NSString *) generateNextSentence{
	NSArray *tokens = @[];
	NSString *token = @"";
	while (![self.sentenceEndCharacters characterIsMember:[self getLastCharacterOfString:token]]){
		token = [self generateNextToken];
		tokens = [tokens arrayByAddingObject:token];
	}
	return [tokens componentsJoinedByString:@" "];
}

// generate a number of sentences
- (NSString *) generateNextNSentences:(int)n separatedBy:(NSString *)separator{
	NSString *generated = @"";
	for (int i=0; i<n;i++){
		generated = [generated stringByAppendingString:[self generateNextSentence]];
		generated = [generated stringByAppendingString:separator];
	}
	return generated;
}

// generate a line consisting of a small random number of sentences
- (NSString *)generateNextLine{
	return [self generateNextNSentences:(1 + arc4random_uniform(self.maxSentencesPerLine)) separatedBy:@" "];
}

@end
