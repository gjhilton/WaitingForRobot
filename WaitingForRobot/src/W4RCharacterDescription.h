//
//  W4RCharacterDescription.h
//  WaitingForRobot
//
//  Created by g j hilton on 16/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "W4RVoiceRepertoire.h"

@interface W4RCharacterDescription : NSObject

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* voice;
@property (nonatomic, strong, readonly) NSString* voiceName;
@property (nonatomic, readonly) BOOL isPerformer;

- (id) initWithName:(NSString *)name
			  voice:(NSString *)preferredVoice
   fallbackCriteria:(W4RVoiceTypeCriteria)criteria
		  performer:(BOOL)isPerformer;

@end
