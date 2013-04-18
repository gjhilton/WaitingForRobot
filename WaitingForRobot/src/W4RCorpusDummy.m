//
//  W4RCorpusDummy.m
//  WaitingForRobot
//
//  Created by g j hilton on 09/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RCorpusDummy.h"
#import "Random.h"

@implementation W4RCorpusDummy

- (NSString *)generate{
	return [Random fromArray:self.model];
}
- (NSArray *)loadCorpusFile:(NSString *)filePath{
	return [self dummyLines];
}
- (NSArray *)makeCorpusFromTextFile:(NSString *)filePath{
	return [self dummyLines];
}
- (NSArray *)dummyLines{
	return @[
	  @"To be, or not to be, that is the question.",
	  @"Now is the winter of our discontent made glorious summer by the son of york",
	  @"A handbag?",
	  @"I saw Lizzie Proctor consortin' with the devil.",
	  @"Romeo, Romeo wherfore art though Romeo?"
	];
}
@end
