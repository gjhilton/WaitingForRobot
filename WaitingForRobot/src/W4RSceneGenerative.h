//
//  W4RSceneGenerative.h
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RSceneAbstract.h"
#import "W4RVoiceRepertoire.h"

@interface W4RSceneGenerative : W4RSceneAbstract

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

- (NSString *) dramatisPersonae;

@end
