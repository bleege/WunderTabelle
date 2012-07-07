//
//  Player.h
//  WunderTabelle
//
//  Created by Brad Leege on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * playerId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * club;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * kitNumber;

@end
