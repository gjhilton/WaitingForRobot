//
//  Random.m
//  WaitingForRobot
//
//  Created by g j hilton on 16/04/2013.
//  Copyright (c) 2013 g j hilton. All rights reserved.
//

#import "Random.h"

@implementation Random

+ (BOOL)evenly{
	return [self withProbability:0.5];
}
+ (BOOL)withProbability:(float)p{
	return [self f] < p;
}
+ (float)f{
	return arc4random() % ((unsigned)RAND_MAX + 1) / (float)RAND_MAX;
}
+ (id)fromArray:(NSArray *)array{
	return array[arc4random_uniform([array count])];
}
+ (id)fromSet:(NSSet *)set{
	return [self fromArray:[set allObjects]];
}
+ (NSString *)vowel{
	return [self fromArray:@[@"a",@"e",@"i",@"o",@"u"]];
}
+ (NSString *)consonant{
	return[self fromArray:@[@"b",@"c",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"m",@"n",@"p",@"qu",@"r",@"s",@"t",@"v",@"w",@"z"]];
}

@end
