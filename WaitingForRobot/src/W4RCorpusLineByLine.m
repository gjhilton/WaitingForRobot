//
//  W4RCorpusLineByLine.m
//  WaitingForRobot
//
//  Created by g j hilton on 09/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RCorpusLineByLine.h"
#import "Random.h"

@implementation W4RCorpusLineByLine

- (NSString *)generate{
	return [Random fromArray:self.model];;
}

- (NSArray *)loadCorpusFile:(NSString *)filePath{
	NSArray *lines = [NSArray arrayWithContentsOfFile:filePath];
	return lines;
}

- (NSArray *)makeCorpusFromTextFile:(NSString *)filePath{
	NSString *rawText = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
	__block NSMutableArray *lines = [[NSMutableArray alloc]init];
	LineIterator lineHandler = ^(NSString *line, BOOL *stop){
		[lines addObject:line];
	};
	[rawText enumerateLinesUsingBlock:lineHandler];
	return lines;
}

@end
