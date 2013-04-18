//
//  W4RActor.h
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class W4RPlayController;

@interface W4RActor : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *voice;

- (id)initWithVoice:(NSString *)voice scene:(W4RPlayController *)scene name:(NSString *)name;
- (void)say:(NSString *)line;
- (void)shush;
- (void)pause;
- (void)resume;
- (BOOL)canResume;
- (void)setSpeechSpeed:(int)speed;

@end
