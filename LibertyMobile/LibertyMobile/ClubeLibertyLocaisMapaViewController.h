//
//  ClubeLibertyLocaisMapaViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ClubeLibertyLocaisMapaViewController : UIViewController
{
    IBOutlet MKMapView* localMapView;
    IBOutlet UISegmentedControl* segmentsMapView;
    IBOutlet UIToolbar* toolbarMapView;
    NSMutableDictionary* cellDict;
}

@property(nonatomic,retain)NSMutableDictionary* cellDict;

- (IBAction)viewLocalAtual:(id)sender;
//- (IBAction)btnVoltar:(id)sender;
- (IBAction)setMapType:(id)sender;


@end
