//
//  W4RSceneGenerativeMonologue.m
//  WaitingForRobot
//
//  Created by g j hilton on 10/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RSceneGenerativeMonologue.h"
#import "W4RCorpusMarkov.h"

@interface  W4RSceneGenerativeMonologue()

@property (nonatomic,strong) NSString *characterName;
@property (nonatomic,strong) W4RCorpusMarkov *corpus;
@property (nonatomic) int nWordsPerChunk;

@end

@implementation W4RSceneGenerativeMonologue

- (id)initWithCharacterDescription:(W4RCharacterDescription *)characterDescription
						   rawFile:(NSString *)rawFile
						corpusFile:(NSString *)corpusFile
				   withNGramLength:(int)ngl
					 wordsPerChunk:(int)nWordsPerChunk
			   maxSentencesPerLine:(int)maxSentencesPerLine
					 nextSceneName:(NSString *)nextSceneName
			  beginWithRandomNGram:(BOOL)beginWithRandomNGram
				   allowDuplicates:(BOOL)allowDuplicates
{
	if (self = [super init]) {
		self.nextSceneName = nextSceneName;
		self.characterDescriptions = @[characterDescription];
		_characterName = characterDescription.name;
		_nWordsPerChunk = nWordsPerChunk;
#if defined USE_RAW_TEXT_CORPORA
		_corpus = [[W4RCorpusMarkov alloc]
				   initWithRawText:rawFile
				   withNGramLength:ngl
				   maxSentencesPerLine:maxSentencesPerLine
				   beginWithRandomNGram:(BOOL)beginWithRandomNGram
				   allowDuplicates:(BOOL)allowDuplicates
				   ];
# else
		_corpus = [[W4RCorpusMarkov alloc]
				   initWithCorpusFile:(NSString *)corpusFile
				   withNGramLength:ngl
				   maxSentencesPerLine:maxSentencesPerLine
				   beginWithRandomNGram:(BOOL)beginWithRandomNGram
				   allowDuplicates:(BOOL)allowDuplicates
				   ];
#endif
	}
	return self;
}

- (NSArray *)line{
	NSArray *line = @[self.characterName,[self.corpus generateNextNTokens:self.nWordsPerChunk]];
	return line;
}

@end
