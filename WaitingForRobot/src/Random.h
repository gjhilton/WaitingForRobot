//
//  Random.h
//  WaitingForRobot
//
//  Created by g j hilton on 16/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Random : NSObject

+ (BOOL)evenly;
+ (BOOL)withProbability:(float)p;
+ (float)f;
+ (id)fromArray:(NSArray *)array;
+ (id)fromSet:(NSSet *)set;
+ (NSString *)vowel;
+ (NSString *)consonant;

@end
