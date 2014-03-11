//
//  Template.m
//
// Copyright 2007-2013 metaio GmbH. All rights reserved.
//

#import "Template.h"
#import "EAGLView.h"

@implementation Template


#pragma mark - UIViewController lifecycle

- (void)dealloc
{
    [super dealloc];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    gesture_id = 0;
    m_gestures = 3<<0; //enables all gestures
    m_gestureHandler = [[GestureHandlerIOS alloc] initWithSDK:m_metaioSDK withView:glView withGestures:m_gestures];
    modelList = [[NSMutableArray alloc] init];
    
    
    
    if( !m_metaioSDK )
    {
        NSLog(@"SDK instance is 0x0. Please check the license string");
        return;
    }
    
    
    // load our tracking configuration
    NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"TrackingData_Marker" ofType:@"xml" inDirectory:@"Assets"];
	if(trackingDataFile)
	{
		bool success = m_metaioSDK->setTrackingConfiguration([trackingDataFile UTF8String]);
		if( !success)
			NSLog(@"No success loading the tracking configuration");
	}
	
	metaio::Vector3d scale = metaio::Vector3d(11);
//	metaio::Rotation rotation = metaio::Rotation(metaio::Vector3d(M_PI_2, 0.0, 0.0));

    // load content
    NSString* earthModel = [[NSBundle mainBundle] pathForResource:@"guizi" ofType:@"zip" inDirectory:@"Assets"];
    
	if(earthModel)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        m_earth =  m_metaioSDK->createGeometry([earthModel UTF8String]);
        if( m_earth )
        {
            // scale it a bit down
            m_earth->setScale(scale);
             [m_gestureHandler addObject:m_earth andGroup:gesture_id++];
            
//			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", earthModel);            
        }
    }
 /*
    // load content
    NSString* earthOcclusionModel = [[NSBundle mainBundle] pathForResource:@"Earth_Occlusion" ofType:@"zip" inDirectory:@"Assets"];
    
	if(earthOcclusionModel)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        m_earthOcclusion =  m_metaioSDK->createGeometry([earthOcclusionModel UTF8String]);
        if( m_earthOcclusion )
        {
            // scale it a bit down
            m_earthOcclusion->setScale(scale);
			m_earthOcclusion->setRotation(rotation);
			m_earthOcclusion->setOcclusionMode(true);
        }
        else
        {
            NSLog(@"error, could not load %@", earthOcclusionModel);            
        }
    }
	
    // load content
    NSString* earthIndicatorsModel = [[NSBundle mainBundle] pathForResource:@"EarthIndicators" ofType:@"zip" inDirectory:@"Assets"];
    
	if(earthIndicatorsModel)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        m_earthIndicators =  m_metaioSDK->createGeometry([earthIndicatorsModel UTF8String]);
        if( m_earthIndicators )
        {
            // scale it a bit down
            m_earthIndicators->setScale(scale);
			m_earthIndicators->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", earthIndicatorsModel);            
        }
    }
*/
	//setup splash image (shown till metaio SDK is loaded)
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		if ([[[UIScreen mainScreen] currentMode] size].height > 960) {
			self.splashImageView.image = [UIImage imageNamed:@"Default-568h.png"];
		} else {
			self.splashImageView.image = [UIImage imageNamed:@"Default.png"];
		}
	} else {
		if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
			self.splashImageView.image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
		} else {
			self.splashImageView.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
		}
	}
}


#pragma mark - @protocol metaioSDKDelegate

- (void) onSDKReady
{
    NSLog(@"The SDK is ready");
}

- (void) onAnimationEnd: (metaio::IGeometry*) geometry  andName:(NSString*) animationName
{
	 NSLog(@"animation ended %@", animationName);
}


- (void) onMovieEnd: (metaio::IGeometry*) geometry  andName:(NSString*) movieName
{
	NSLog(@"movie ended %@", movieName);
	
}

- (void) onNewCameraFrame:(metaio::ImageStruct *)cameraFrame
{
    NSLog(@"a new camera frame image is delivered %f", cameraFrame->timestamp);
}

- (void) onCameraImageSaved:(NSString *)filepath
{
    NSLog(@"a new camera frame image is saved to %@", filepath);
}

-(void) onScreenshotImage:(metaio::ImageStruct *)image
{
    
    NSLog(@"screenshot image is received %f", image->timestamp);
}

- (void) onScreenshotImageIOS:(UIImage *)image
{
    NSLog(@"screenshot image is received %@", [image description]);
}

-(void) onScreenshot:(NSString *)filepath
{
    NSLog(@"screenshot is saved to %@", filepath);
}

- (void) onTrackingEvent:(const metaio::stlcompat::Vector<metaio::TrackingValues>&)trackingValues
{
    NSLog(@"The tracking time is: %f", trackingValues[0].timeElapsed);
}

- (void) onInstantTrackingEvent:(bool)success file:(NSString*)file
{
    if (success)
    {
        NSLog(@"Instant 3D tracking is successful");
    }
}

- (void) onVisualSearchResult:(bool)success error:(NSString *)errorMsg response:(std::vector<metaio::VisualSearchResponse>)response
{
    if (success)
    {
        NSLog(@"Visual search is successful");
    }
}

- (void) onVisualSearchStatusChanged:(metaio::EVISUAL_SEARCH_STATE)state
{
    if (state == metaio::EVSS_SERVER_COMMUNICATION)
    {
        NSLog(@"Visual search is currently communicating with the server");
    }
}

#pragma mark - Handling Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    try {
        [m_gestureHandler touchesBegan:touches withEvent:event withView:glView];
    } catch (NSException *e) {
        NSLog(@"Exception at begin %@",e);
    }
    
    
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    try {
        [m_gestureHandler touchesMoved:touches withEvent:event withView:glView];
    } catch (NSException *e) {
        NSLog(@"Exception at moved %@", e);
    }
    
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    try {
        [m_gestureHandler touchesEnded:touches withEvent:event withView:glView];
    } catch (NSException *e) {
        NSLog(@"Exception at ended %@", e);
    }

}
#
-(void) loadModel:(id ) m_name  wtihScale:(float ) scale{
    
    
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:m_name ofType:@"zip" inDirectory:@"Assets"];
    
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(scale));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }

    
}

- (IBAction)onClick1:(id)sender {
   // NSString *str = [NSString stringWithCString:"shafa" encoding:NSUTF8StringEncoding];
    
   // [self loadModel:@"shafa" wtihScale:(float) 5];
     
    
    
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"shafa" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
  //      metaio::IGeometry *g = [[metaio::IGeometry alloc] init];
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
      //  NSString *s = [[NSString alloc] init];
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(25));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
          //  std::vector<metaio:: IGeometry*> vector = m_metaioSDK->getLoadedGeometries();
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
            
        }
    }

    
    
}

- (IBAction)onClick2:(id)sender {
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"shugui" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(12));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }
    

}

- (IBAction)onClick3:(id)sender {
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"dengzi" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(35));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }
    

}

- (IBAction)onClick4:(id)sender {
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"tv" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(70));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            g->setRotation(metaio::Rotation(metaio::Vector3d(M_PI_2, 0.0, 0.0)));
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }
    

}

- (IBAction)onClick5:(id)sender {
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"chuang" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(25));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }
    

}

- (IBAction)onClick6:(id)sender {
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"chuangtougui" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(25));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }
    

}

- (IBAction)onClick7:(id)sender {
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"yigui" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(20));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }

    
}

- (IBAction)onClick8:(id)sender {
    
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"guizi" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(26));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }

}

- (IBAction)onClick9:(id)sender {
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"zuozi" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(33));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }

}

- (IBAction)onClick10:(id)sender {
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"chaji" ofType:@"zip" inDirectory:@"Assets"];
    if(modelPath)
	{
		// if this call was successful, m_earth will contain a pointer to the 3D model
        
        metaio::IGeometry *g =  m_metaioSDK->createGeometry([modelPath UTF8String]);
        if( g )
        {
            
            // scale it a bit down
            g->setScale(metaio::Vector3d(20));
            [m_gestureHandler addObject:g andGroup:gesture_id++];
            //			m_earth->setRotation(rotation);
        }
        else
        {
            NSLog(@"error, could not load %@", modelPath);
        }
    }

}

- (IBAction)deleteAll:(id)sender {
    std::vector<metaio:: IGeometry*> vector = m_metaioSDK->getLoadedGeometries();
    
    for (std::vector<metaio::IGeometry*>::iterator modelItl = vector.begin(); modelItl != vector.end(); ++modelItl) {
        metaio::IGeometry* model = *modelItl;
        if (model) {
            m_metaioSDK->unloadGeometry(model);
            //model->setVisible(false);
        }
    }
   // gesture_id = 0;
    
   
    
}

@end
