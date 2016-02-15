//
//  Event.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "Address.h"
#import "Driver.h"
#import "EventPhoto.h"
#import "PoliceOfficer.h"
#import "PoliceReport.h"
#import "User.h"
#import "Witness.h"


@implementation Event
@dynamic policyNumber;
@dynamic incidentDateTime;
@dynamic eventType;
@dynamic createDateTime;
@dynamic eventStatus;
@dynamic title;
@dynamic notes;
@dynamic submitDateTime;
@dynamic lengthOfVoiceNote;
@dynamic sortValue;
@dynamic pathToVoiceNote;
@dynamic eventSubType;
@dynamic eventPhotos;
@dynamic eventLocation;
@dynamic eventWitnesses;
@dynamic eventDrivers;
@dynamic eventPoliceReports;
@dynamic eventPoliceOfficers;
@dynamic eventUser;

- (NSArray *)sortedPhotoArrayForSection:(NSUInteger)section 
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageSection == %d", section];
	
	NSSet *photosForSection = [self.eventPhotos filteredSetUsingPredicate:predicate];
	
    NSSortDescriptor *sortNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"imagePosition" ascending:YES] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortNameDescriptor, nil] autorelease];
	
    NSArray *sortThese = [photosForSection allObjects];
    
    return [sortThese sortedArrayUsingDescriptors:sortDescriptors];
}


- (void)addEventPhotosObject:(EventPhoto *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventPhotos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventPhotos"] addObject:value];
    [self didChangeValueForKey:@"eventPhotos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEventPhotosObject:(EventPhoto *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventPhotos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventPhotos"] removeObject:value];
    [self didChangeValueForKey:@"eventPhotos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEventPhotos:(NSSet *)value {    
    [self willChangeValueForKey:@"eventPhotos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventPhotos"] unionSet:value];
    [self didChangeValueForKey:@"eventPhotos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEventPhotos:(NSSet *)value {
    [self willChangeValueForKey:@"eventPhotos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventPhotos"] minusSet:value];
    [self didChangeValueForKey:@"eventPhotos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



- (void)addEventWitnessesObject:(Witness *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventWitnesses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventWitnesses"] addObject:value];
    [self didChangeValueForKey:@"eventWitnesses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEventWitnessesObject:(Witness *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventWitnesses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventWitnesses"] removeObject:value];
    [self didChangeValueForKey:@"eventWitnesses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEventWitnesses:(NSSet *)value {    
    [self willChangeValueForKey:@"eventWitnesses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventWitnesses"] unionSet:value];
    [self didChangeValueForKey:@"eventWitnesses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEventWitnesses:(NSSet *)value {
    [self willChangeValueForKey:@"eventWitnesses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventWitnesses"] minusSet:value];
    [self didChangeValueForKey:@"eventWitnesses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addEventDriversObject:(Driver *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventDrivers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventDrivers"] addObject:value];
    [self didChangeValueForKey:@"eventDrivers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEventDriversObject:(Driver *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventDrivers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventDrivers"] removeObject:value];
    [self didChangeValueForKey:@"eventDrivers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEventDrivers:(NSSet *)value {    
    [self willChangeValueForKey:@"eventDrivers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventDrivers"] unionSet:value];
    [self didChangeValueForKey:@"eventDrivers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEventDrivers:(NSSet *)value {
    [self willChangeValueForKey:@"eventDrivers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventDrivers"] minusSet:value];
    [self didChangeValueForKey:@"eventDrivers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addEventPoliceReportsObject:(PoliceReport *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventPoliceReports" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventPoliceReports"] addObject:value];
    [self didChangeValueForKey:@"eventPoliceReports" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEventPoliceReportsObject:(PoliceReport *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventPoliceReports" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventPoliceReports"] removeObject:value];
    [self didChangeValueForKey:@"eventPoliceReports" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEventPoliceReports:(NSSet *)value {    
    [self willChangeValueForKey:@"eventPoliceReports" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventPoliceReports"] unionSet:value];
    [self didChangeValueForKey:@"eventPoliceReports" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEventPoliceReports:(NSSet *)value {
    [self willChangeValueForKey:@"eventPoliceReports" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventPoliceReports"] minusSet:value];
    [self didChangeValueForKey:@"eventPoliceReports" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addEventPoliceOfficersObject:(PoliceOfficer *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventPoliceOfficers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventPoliceOfficers"] addObject:value];
    [self didChangeValueForKey:@"eventPoliceOfficers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEventPoliceOfficersObject:(PoliceOfficer *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"eventPoliceOfficers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"eventPoliceOfficers"] removeObject:value];
    [self didChangeValueForKey:@"eventPoliceOfficers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEventPoliceOfficers:(NSSet *)value {    
    [self willChangeValueForKey:@"eventPoliceOfficers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventPoliceOfficers"] unionSet:value];
    [self didChangeValueForKey:@"eventPoliceOfficers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEventPoliceOfficers:(NSSet *)value {
    [self willChangeValueForKey:@"eventPoliceOfficers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"eventPoliceOfficers"] minusSet:value];
    [self didChangeValueForKey:@"eventPoliceOfficers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


// Needed for CoreData since it is a scalar type
- (NSTimeInterval) lengthOfVoiceNote 
{
	return lengthOfVoiceNote;
}

// Needed for CoreData since it is a scalar type
- (void) setLengthOfVoiceNote:(NSTimeInterval) newLength 
{
	[self willChangeValueForKey:@"lengthOfVoiceNote"];
	lengthOfVoiceNote = newLength;
	[self didChangeValueForKey:@"lengthOfVoiceNote"];
}

@end
