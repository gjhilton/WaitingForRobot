//
//  W4RSceneGenerativeMonologue.h
//  WaitingForRobot
//
//  Created by g j hilton on 10/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RSceneAbstract.h"
#import "W4RCharacterDescription.h"

@interface W4RSceneGenerativeMonologue : W4RSceneAbstract

- (id)initWithCharacterDescription:(W4RCharacterDescription *)characterDescription
						   rawFile:(NSString *)rawFile
						corpusFile:(NSString *)corpusFile
				   withNGramLength:(int)ngl
					 wordsPerChunk:(int)nWordsPerChunk
			   maxSentencesPerLine:(int)maxSentencesPerLine
					 nextSceneName:(NSString *)nextSceneName
			  beginWithRandomNGram:(BOOL)beginWithRandomNGram
				   allowDuplicates:(BOOL)allowDuplicates;

@end
