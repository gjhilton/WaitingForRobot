//
//  W4RCorpusMarkov.h
//  WaitingForRobot
//
//  Created by g j hilton on 09/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RCorpusAbstract.h"

@interface W4RCorpusMarkov : W4RCorpusAbstract

@property (nonatomic, strong) NSDictionary *model;

-(id)initWithRawText:(NSString *)filePath
	 withNGramLength:(int)ngramLength
 maxSentencesPerLine:(int)maxSentencesPerLine
beginWithRandomNGram:(BOOL)beginWithRandomNGram
	 allowDuplicates:(BOOL)allowDuplicates;

-(id)initWithCorpusFile:(NSString *)filePath
		withNGramLength:(int)ngramLength
	maxSentencesPerLine:(int)maxSentencesPerLine
   beginWithRandomNGram:(BOOL)beginWithRandomNGram
		allowDuplicates:(BOOL)allowDuplicates;

- (NSString *) generateNextToken;
- (NSString *) generateNextNTokens:(int)n;
- (NSString *) generateNextSentence;
- (NSString *) generateNextNSentences:(int)n separatedBy:(NSString *)separator;

@end
