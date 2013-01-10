//
//  main.m
//  Units
//
//  Created by Timothy Place on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "TTFoundationAPI.h"
#include "TTAudioGraphObject.h"
#include "TTAudioGraphGenerator.h"
#include "TTAudioGraphInlet.h"		// required for windows build

// this for loading the dataspacelib
extern "C" TTErr TTLoadJamomaExtension_DataspaceLib(void);


// NOTE: I had to change the extension of this file from .m (as in the template)
//		 to .mm so that C++ libraries would be linked when building [tap]


int main(int argc, char *argv[])
{
	
    int							errorCount = 0;
	int							testAssertionCount = 0;
	int							badSampleCount = 0;
    //	TTAudioSignalPtr			input = NULL;
	TTAudioSignalPtr			output = NULL;
	TTAudioGraphPreprocessData	mInitData;
    //	TTAudioSignalPtr			mAudioSignal = NULL;
	TTAudioGraphObjectPtr		obj0 = NULL;
	TTAudioGraphObjectPtr		obj1 = NULL;
	TTAudioGraphObjectPtr		obj2 = NULL;
	TTAudioGraphObjectPtr		obj3 = NULL;
    
	TTValue						audioObjectArguments;
    
	memset(&mInitData, 0, sizeof(mInitData));
	audioObjectArguments.setSize(3);
    
	// Create the Graph
    
	audioObjectArguments.set(0, TT("thru"));	// <<-- THIS IS THE SINK ON WHICH WE WILL PULL
	audioObjectArguments.set(1, 1);				// <<-- NUMBER OF INLETS
	audioObjectArguments.set(2, 1);
	TTObjectInstantiate(TT("audio.object"), (TTObjectPtr*)&obj0, audioObjectArguments);
	obj0->mKernel->setAttributeValue(TT("maxNumChannels"), 0);
	obj0->mKernel->setAttributeValue(TT("mute"), 0);
	obj0->mKernel->setAttributeValue(TT("bypass"), 0);
	obj0->mKernel->setAttributeValue(TT("sampleRate"), 44100u);
    
    
    
    
    TTObjectPtr dataspace = NULL;
	TTErr		err = kTTErrNone;
	TTValue		x;
	TTValue		y;
	
	// this loads the DataspaceLib, which calls the Foundation init function.
	err = TTLoadJamomaExtension_DataspaceLib();
	if (err)
		return err;
	
	err = TTObjectInstantiate(TT("dataspace"), &dataspace, kTTValNONE);
	if (err)
		return err;
	
	dataspace->setAttributeValue(TT("dataspace"), TT("temperature"));
	dataspace->setAttributeValue(TT("inputUnit"), TT("C"));
	dataspace->setAttributeValue(TT("outputUnit"), TT("F"));
	
	x = 100.0;
	dataspace->sendMessage(TT("convert"), x, y);
	TTLogMessage("100ºC should be 212ºF, and the dataspace says it is...  %f", TTFloat64(y));
    
    
	
	
	
	// This where Apple's code starts the app loop
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, nil);
	[pool release];
	
	
	
	// Quiting the App, so we can free ourselves
	
	TTObjectRelease(&dataspace);
	
    return retVal;
}
