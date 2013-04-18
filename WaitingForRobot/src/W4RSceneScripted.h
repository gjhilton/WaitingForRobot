//
//  W4RSceneScripted.h
//  WaitingForRobot
//
//  Created by g j hilton on 10/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RSceneAbstract.h"

@interface W4RSceneScripted : W4RSceneAbstract

-(id)initWithCharacterDescriptions:(NSArray *)characterDescriptions
			   andLines:(NSArray *)lines
		  nextSceneName:(NSString *)nextSceneName;

@end
