//
//  W4RPlayController.h
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class W4RSceneAbstract;

@interface W4RPlayController : NSObject<NSSpeechSynthesizerDelegate>

- (id)initWithScenes:(NSDictionary *)scenes beginningWith:(NSString *)firstSceneKey; // scenes = {(NSString*)scenename:(W4RSceneAbstract *)scene,...}
- (void)start;
- (void)togglePlay;
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking;
- (void)goToScene:(NSString *)name;

- (void)setHesitation:(float)val;
- (void)setDynamics:(float)val;
- (void)setInflection:(float)val;

@end
