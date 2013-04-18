//
//  W4RAppDelegate.m
//  WaitingForRobot
//
//  Created by g j hilton on 08/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "W4RAppDelegate.h"
#import "W4RPlayController.h"
#import "W4RSceneGenerative.h"
#import "W4RSceneGenerativeMonologue.h"
#import "W4RSceneScripted.h"
#import "W4RCharacterDescription.h"

#define INTRO_SCENE_NAME @"intro"
#define MAIN_SCENE_NAME @"main"
#define LUCKY_SCENE_NAME @"lucky"

#define LUCKY_CORPUS_FILENAME @"lucky"			// ie ?.corpus
#define MAIN_CORPUS_FILENAME @"scene_nonames"	// ie ?.corpus

#define DRAWER_OFFSET 10
#define DRAWER_HEIGHT 101

@interface W4RAppDelegate()

@property (nonatomic, strong) W4RPlayController* play;
@property (strong) IBOutlet NSDrawer *drawer;
@property (weak) IBOutlet NSButton *drawerTwirler;

@property (weak) IBOutlet NSSlider *pinterSlider;
@property (weak) IBOutlet NSSlider *walkenSlider;
@property (weak) IBOutlet NSSlider *olivierSlider;
@property (weak) IBOutlet NSTextField *pinterLabel;
@property (weak) IBOutlet NSTextField *walkenLabel;
@property (weak) IBOutlet NSTextField *olivierLabel;

@end

#pragma mark

@implementation W4RAppDelegate

- (void)configurePlay{

		W4RSceneGenerative *mainScene			= [[W4RSceneGenerative alloc]
												   initWithNCharacters:2
												   preferredVoices:@[
														@"com.apple.speech.synthesis.voice.Alex",
														@"com.apple.speech.synthesis.voice.Bruce"
												   ]
												   voiceCriteria:W4RVoiceTypeGenderMale
												   rawFile:@"/Users/gjh/Documents/Work/HLTN Co/WaitingForRobot/WaitingForRobot/resources/raw_text/scene_nonames.txt"
												   corpusFile:[[NSBundle mainBundle] pathForResource:MAIN_CORPUS_FILENAME ofType:@"corpus"]
												   withNGramLength:2
												   maxSentencesPerLine:3
												   nextSceneName:LUCKY_SCENE_NAME
												   beginWithRandomNGram:YES
												   allowDuplicates:NO
												   ];

		W4RSceneScripted *introScene			= [[W4RSceneScripted alloc]
												   initWithCharacterDescriptions:@[
														[[W4RCharacterDescription alloc]
															initWithName:@"Narrator"
															voice:@"com.apple.speech.synthesis.voice.Vicki"
															fallbackCriteria:W4RVoiceTypeGenderFemale
															performer:NO]
												   ]
												   andLines:@[
														@[@"Narrator",@"Waiting for ROBOT. . A never-ending semi automatic traji comedy. ."],
														@[@"Narrator",[mainScene dramatisPersonae]]
												   ]
												   nextSceneName:MAIN_SCENE_NAME];

		W4RSceneGenerativeMonologue *luckyScene = [[W4RSceneGenerativeMonologue alloc]
												   initWithCharacterDescription:
														[[W4RCharacterDescription alloc]
															initWithName:@"Lucky"
															voice:@"com.apple.speech.synthesis.voice.Ralph"
															fallbackCriteria:W4RVoiceTypeGenderMale
															performer:NO]
												   rawFile:@"/Users/gjh/Documents/Work/HLTN Co/WaitingForRobot/WaitingForRobot/resources/raw_text/lucky.txt"
												   corpusFile:[[NSBundle mainBundle] pathForResource:LUCKY_CORPUS_FILENAME ofType:@"corpus"]
												   withNGramLength:2
												   wordsPerChunk:200
												   maxSentencesPerLine:0
												   nextSceneName:MAIN_SCENE_NAME
												   beginWithRandomNGram:NO
												   allowDuplicates:NO
												   ];


		self.play = [[W4RPlayController alloc]
				 initWithScenes:@{
					 INTRO_SCENE_NAME:introScene,
					 MAIN_SCENE_NAME:mainScene,
					 LUCKY_SCENE_NAME:luckyScene
					 }
				 beginningWith:INTRO_SCENE_NAME];

}

#pragma mark
#pragma mark application lifecycle

- (void)awakeFromNib {
    [self setupDrawer];
	[self configurePlay];
	[self initNuances];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self.play start];
}

#pragma mark
#pragma mark gui - playbutton

- (IBAction)togglePlay:(NSButton *)sender {
	[self.play togglePlay];
}

#pragma mark gui -lucky

- (IBAction)toggleLucky:(NSButton *)sender{
	if ([sender state] == 1){
		// ie if checked
		[self.play goToScene:LUCKY_SCENE_NAME];
		[self disableDrawerControls];
	} else {
		// ie if unchecked
		[self.play goToScene:MAIN_SCENE_NAME];
		[self enableDrawerControls];
	}
}

#pragma mark gui - drawer & contents

- (void)setupDrawer {
	NSSize size = NSMakeSize(0, DRAWER_HEIGHT);
	[self.drawer setMaxContentSize:size];
	[self.drawer setMinContentSize:size];
	[self.drawer setContentSize:size];
	[self.drawer setLeadingOffset:DRAWER_OFFSET];
	[self.drawer setTrailingOffset:DRAWER_OFFSET];
	[self.drawer setDelegate:self];
}
- (IBAction)setPinter:(NSSlider *)sender{
	[self.play setHesitation:(sender.intValue/(float)sender.maxValue)];
}
- (IBAction)setWalken:(NSSlider *)sender {
	[self.play setInflection:(sender.intValue/(float)sender.maxValue)];
}
- (IBAction)setOlivier:(NSSlider *)sender {
	[self.play setDynamics:(sender.intValue/(float)sender.maxValue)];
}
- (void)initNuances{
	[self setPinter:self.pinterSlider];
	[self setWalken:self.walkenSlider];
	[self setOlivier:self.olivierSlider];
}
- (void)drawerWillClose:(NSNotification *)notification{
	[self.drawerTwirler setState:NSOffState];
}
- (IBAction)toggleDrawer:(NSButton *)sender {
	NSDrawerState state = [self.drawer state];
    if (NSDrawerOpeningState == state || NSDrawerOpenState == state) {
        [self.drawer close];
    } else {
        [self.drawer openOnEdge:NSMinYEdge];
    }
}
- (void) disableDrawerControls{
	[self.pinterSlider setEnabled:NO];
	[self.walkenSlider setEnabled:NO];
	[self.olivierSlider setEnabled:NO];
	[self.pinterLabel setTextColor:[NSColor disabledControlTextColor]];
	[self.walkenLabel setTextColor:[NSColor disabledControlTextColor]];
	[self.olivierLabel setTextColor:[NSColor disabledControlTextColor]];
}
- (void) enableDrawerControls{
	[self.pinterSlider setEnabled:YES];
	[self.walkenSlider setEnabled:YES];
	[self.olivierSlider setEnabled:YES];
	[self.pinterLabel setTextColor:[NSColor controlTextColor]];
	[self.walkenLabel setTextColor:[NSColor controlTextColor]];
	[self.olivierLabel setTextColor:[NSColor controlTextColor]];
}

@end
