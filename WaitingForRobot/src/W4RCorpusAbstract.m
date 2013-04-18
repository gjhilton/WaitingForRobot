//
//  W4RCorpusAbstract.m
//  WaitingForRobot
//
//  Created by g j hilton on 09/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RCorpusAbstract.h"

@implementation W4RCorpusAbstract

-(id)initWithRawText:(NSString *)filePath{
	if (self = [super init]) {
		self.model = [self makeCorpusFromTextFile:filePath];
		[self optionallySaveCorpusFileFor:filePath];
    }
    return self;
}

-(id)initWithCorpusFile:(NSString *)filePath{
	if (self = [super init]) {
		self.model = [self loadCorpusFile:filePath];
    }
    return self;
}

- (void)optionallySaveCorpusFileFor:(NSString *)filePath{
	NSString *outFileName = [[[filePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"corpus"];
	NSString *outFilePath = [[[[filePath stringByDeletingLastPathComponent]stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"corpora"] stringByAppendingPathComponent:outFileName];

	// dirty doing this here, but it's only for development convenience anyway
	NSString *messageTitle = @"Save corpus file?";
	NSAlert *testAlert = [NSAlert alertWithMessageText:messageTitle
										 defaultButton:@"Don't save"
									   alternateButton:@"Save"
										   otherButton:nil
							 informativeTextWithFormat:@"Save processed corpus to: %@", outFilePath];
	NSInteger result = [testAlert runModal];
	if (result == 0) { // default button (ie dont save) returns 1
		BOOL success = [self saveCorpusFile:outFilePath];
		NSLog(@"Writing file %@ %@", outFilePath, success ? @"sucessful": @"FAILED");
	}
}

- (BOOL) saveCorpusFile:(NSString *)f{
	return [self.model writeToFile:f atomically:YES];
}

#pragma mark
#pragma mark override and implement in subclass

- (NSString *)generate{
	return @"";
}
- (id)loadCorpusFile:(NSString *)filePath{
	return nil;
}
- (id)makeCorpusFromTextFile:(NSString *)filePath{
	return nil;
}

@end
