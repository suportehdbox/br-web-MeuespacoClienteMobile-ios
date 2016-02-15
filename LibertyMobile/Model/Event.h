//
//  Event.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Driver, EventPhoto, PoliceOfficer, PoliceReport, User, Witness;

@interface Event : NSManagedObject {
    NSTimeInterval lengthOfVoiceNote;
}

@property (nonatomic, retain) NSString *policyNumber;
@property (nonatomic, retain) NSDate * incidentDateTime;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSDate * createDateTime;
@property (nonatomic, retain) NSString * eventStatus;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * submitDateTime;
@property (nonatomic)		  NSTimeInterval lengthOfVoiceNote;
@property (nonatomic, retain) NSNumber * sortValue;
@property (nonatomic, retain) NSString * pathToVoiceNote;
@property (nonatomic, retain) NSString * eventSubType;
@property (nonatomic, retain) NSSet* eventPhotos;
@property (nonatomic, retain) Address * eventLocation;
@property (nonatomic, retain) NSSet* eventWitnesses;
@property (nonatomic, retain) NSSet* eventDrivers;
@property (nonatomic, retain) NSSet* eventPoliceReports;
@property (nonatomic, retain) NSSet* eventPoliceOfficers;
@property (nonatomic, retain) User * eventUser;

- (NSArray *)sortedPhotoArrayForSection:(NSUInteger)section;

@end

@interface Event (CoreDataGeneratedAccessors)
- (void)addEventPhotosObject:(EventPhoto *)value;
- (void)removeEventPhotosObject:(EventPhoto *)value;
- (void)addEventPhoto:(NSSet *)value;
- (void)removeEventPhoto:(NSSet *)value;

- (void)addEventWitnessesObject:(Witness *)value;
- (void)removeEventWitnessesObject:(Witness *)value;
- (void)addEventWitnesses:(NSSet *)value;
- (void)removeEventWitnesses:(NSSet *)value;

- (void)addEventDriversObject:(Driver *)value;
- (void)removeEventDriversObject:(Driver *)value;
- (void)addEventDrivers:(NSSet *)value;
- (void)removeEventDrivers:(NSSet *)value;

- (void)addEventPoliceOfficersObject:(PoliceOfficer *)value;
- (void)removeEventPoliceOfficersObject:(PoliceOfficer *)value;
- (void)addEventPoliceOfficers:(NSSet *)value;
- (void)removeEventPoliceOfficers:(NSSet *)value;

- (void)addEventPoliceReports:(NSSet *)value;
- (void)removeEventPoliceReports:(NSSet *)value;
@end
