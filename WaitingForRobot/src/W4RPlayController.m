//
//  W4RPlayController.m
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RPlayController.h"
#import "W4RActor.h"
#import "W4RPerformer.h"
#import "W4RSceneAbstract.h"
#import "W4RCharacterDescription.h"
#import "Random.h"

@interface W4RPlayController()

@property (nonatomic) BOOL playing;

@property (nonatomic,strong) NSMutableDictionary *actors;
@property (nonatomic,strong) W4RActor *currentActor;

@property (nonatomic,strong) NSDictionary *scenes;
@property (nonatomic,strong) W4RSceneAbstract *currentScene;
@property (nonatomic,strong) W4RSceneAbstract *nextScene;

@end

@implementation W4RPlayController

- (id)initWithScenes:(NSDictionary *)scenes beginningWith:(NSString *)firstSceneKey{
	if (self = [super init]) {
		_playing = NO;
		_scenes = scenes;
		for (W4RSceneAbstract *scene in [scenes allValues]){
			for (W4RCharacterDescription *character in scene.characterDescriptions){
				[self addActorFromCharacterDescription:character];
			}
		}
		[[self.actors objectForKey:@"Lucky"] setSpeechSpeed:290]; // FIXME ughly kludge to force lucky speed to *fast*
		[self goToScene:firstSceneKey];
	}
    return self;
}

- (void) goToScene:(NSString *)name{
	// NSLog(@"next scene will be %@", name);
	self.nextScene = self.scenes[name];
	self.nextScene.isFinished = NO;
	if (self.currentActor){
		[self.currentActor shush];
		self.currentActor = NULL;
	}
	[self.currentScene finish];
}

- (void)setCurrentScene:(W4RSceneAbstract *)scene{
	_currentScene = scene;
	self.nextScene = self.scenes[_currentScene.nextSceneName];
}

- (NSMutableDictionary *)actors{
	if (!_actors){
		_actors = [[NSMutableDictionary alloc]init];
	}
	return _actors;
}

- (void)addActorFromCharacterDescription:(W4RCharacterDescription *)character{
	W4RActor *actor;
	if (character.isPerformer){
		actor = [[W4RPerformer alloc]initWithVoice:character.voice scene:self name:character.name];
	} else {
		actor = [[W4RActor alloc]initWithVoice:character.voice scene:self name:character.name];
	}
	[self.actors setObject:actor forKey:character.name];
}

- (void)togglePlay{
	if(self.playing){
		[self pause];
	} else {
		[self resume];
	}
}

- (void) pause{
	self.playing = NO;
	if (self.currentActor) [self.currentActor pause];
}

- (void) resume{
	self.playing = YES;
	if (self.currentActor && [self.currentActor canResume]) { // check canresume in case pause prevented didFinish firing
		[self.currentActor resume];
	} else {
		self.currentActor = NULL; // null it in case where canResume failed
		[self nextLine];
	}
}

- (void)start{
	self.playing = YES;
	[self nextLine];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking{
	self.currentActor = NULL;
	if (self.playing){
		[self nextLine];
	}
}

- (NSString *)nameOfScene:(W4RSceneAbstract *)scene{
	for (NSString *name in self.scenes.allKeys){
		if ([self.scenes[name] isEqual:scene]) return name;
	}
	return nil;
}

- (void)nextLine{
	if (!self.currentScene || self.currentScene.isFinished){
		self.currentScene = self.nextScene;
		// NSLog(@"nextline -> set currentscene to %@", [self nameOfScene:self.currentScene]);
	}
	if (self.playing && !self.currentActor){
		NSArray *nextLine = [self.currentScene line];
		NSString *speakerName = nextLine[0];
		NSString *words = nextLine[1];
		self.currentActor = [self.actors objectForKey:speakerName];
		[self.currentActor say:words];
	}
}

#pragma mark
#pragma mark set voice attributes

- (void)setHesitation:(float)val{
	for (id actor in self.actors){
		if ([actor respondsToSelector:@selector(setHesitation:)]) [actor setHesitation:val];
	}
}
- (void)setDynamics:(float)val{
	for (id actor in self.actors){
		if ([actor respondsToSelector:@selector(setDynamics:)]) [actor setDynamics:val];
	}
}
- (void)setInflection:(float)val{
	for (id actor in self.actors){
		if ([actor respondsToSelector:@selector(setInflection::)]) [actor setInflection:val];
	}
}

@end
