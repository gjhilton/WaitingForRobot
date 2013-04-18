//
//  W4RSceneAbstract.m
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RSceneAbstract.h"
#import "W4RCharacterDescription.h"
#import "Random.h"

@implementation W4RSceneAbstract

- (id)init{
	if (self = [super init]) {
		_isFinished = NO;
	}
    return self;
}

- (void)finish{
	self.isFinished = YES;
}

- (NSArray *)line{
	return nil;
}

- (NSArray *) characterDescriptions{
	if (!_characterDescriptions){
		_characterDescriptions = [[NSArray alloc]init];
	}
	return _characterDescriptions;
}

- (NSString *)nameOfRandomlySelectedCharacter{
	return [self nameOfRandomlySelectedCharacterNot:nil];
}

- (NSString *)nameOfRandomlySelectedCharacterNot:(NSString *)unwantedCharcterName{
	NSMutableArray *names = [[NSMutableArray alloc] init];
	for (W4RCharacterDescription *desc in self.characterDescriptions){
		[names addObject:desc.name];
	}
	[names removeObject:unwantedCharcterName];
	if ([names count]<1){
		return unwantedCharcterName; // no other option.
	}
	return [Random fromArray:names];
}

@end
