//
//  W4RSceneAbstract.h
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import <Foundation/Foundation.h>

// #define USE_RAW_TEXT_CORPORA

@interface W4RSceneAbstract : NSObject

@property (nonatomic,strong) NSArray *preferredVoices;
@property (nonatomic,strong) NSArray *characterDescriptions;
@property (nonatomic,strong,readonly) NSArray *line;
@property (nonatomic) BOOL isFinished;
@property (nonatomic,strong) NSString *nextSceneName;

- (NSString *)nameOfRandomlySelectedCharacter;
- (NSString *)nameOfRandomlySelectedCharacterNot:(NSString *)unwantedCharcterName;

- (void) finish;

@end
