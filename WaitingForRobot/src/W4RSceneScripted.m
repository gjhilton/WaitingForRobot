//
//  W4RSceneScripted.m
//  WaitingForRobot
//
//  Created by g j hilton on 10/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RSceneScripted.h"

@interface  W4RSceneScripted()

@property (nonatomic,strong) NSArray *lines;
@property (nonatomic) int lineNum;

@end

@implementation W4RSceneScripted

-(id)initWithCharacterDescriptions:(NSArray *)characterDescriptions
						  andLines:(NSArray *)lines
					 nextSceneName:(NSString *)nextSceneName
{
	if (self = [super init]) {
		self.characterDescriptions = characterDescriptions;
		self.nextSceneName = nextSceneName;
		_lines = lines;
		_lineNum = 0;
    }
    return self;
}

- (NSArray *)line{
	NSArray *line = self.lines[self.lineNum];
	if (self.lineNum++ == [self.lines count] -1) [self finish];
	return line;
}

@end
