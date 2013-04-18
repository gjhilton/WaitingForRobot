//
//  W4RCorpusAbstract.h
//  WaitingForRobot
//
//  Created by g j hilton on 09/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LineIterator)(NSString *line, BOOL *stop);

@interface W4RCorpusAbstract : NSObject

@property (nonatomic, strong) id model; // usually an NSArray, but might be different in wacky subclasses

// MUST OVERRIDE

-(id)initWithRawText:(NSString *)fileName;
-(id)initWithCorpusFile:(NSString *)filePath;
-(NSString *)generate;

// may override

- (BOOL) saveCorpusFile:(NSString *)f;

// development only

- (void)optionallySaveCorpusFileFor:(NSString *)filePath;

@end
