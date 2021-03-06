//
//  Template.h
//
//  Copyright 2007-2013 metaio GmbH. All rights reserved.
//

#import "MetaioSDKViewController.h"
#import <metaioSDK/GestureHandlerIOS.h>

@interface Template : MetaioSDKViewController
{

   // metaio::IGeometry* m_earth;			//!< Reference to  the earth model
    GestureHandlerIOS* m_gestureHandler;
    int m_gestures;
    int gesture_id;
    float Scale;
    NSMutableArray *modelList;
    
//    metaio::IGeometry* m_earthOcclusion;			//!< Reference to  the earth occlusion model
 //   metaio::IGeometry* m_earthIndicators;			//!< Reference to  the earth indicators model

 //   BOOL m_earthOpened;                     // has the earth open animation been triggered

}

@property (nonatomic, assign) IBOutlet UIImageView *splashImageView;
- (IBAction)onClick1:(id)sender;
- (IBAction)onClick2:(id)sender;
- (IBAction)onClick3:(id)sender;
- (IBAction)onClick4:(id)sender;
- (IBAction)onClick5:(id)sender;
- (IBAction)onClick6:(id)sender;
- (IBAction)onClick7:(id)sender;
- (IBAction)onClick8:(id)sender;
- (IBAction)onClick9:(id)sender;
- (IBAction)onClick10:(id)sender;
- (IBAction)deleteAll:(id)sender;
- (IBAction)onClick11:(id)sender;
- (IBAction)onClick12:(id)sender;
- (IBAction)onClick13:(id)sender;
- (IBAction)onClick14:(id)sender;
- (IBAction)onClick15:(id)sender;
- (IBAction)onClick16:(id)sender;
- (IBAction)onClick17:(id)sender;
- (IBAction)onClick18:(id)sender;
- (IBAction)onClick19:(id)sender;
- (IBAction)onClick20:(id)sender;
- (IBAction)onClick21:(id)sender;


@end

