// ===============================================================================
//	Copyright (c) 2013 Brinkbit
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//		
//		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
// ===============================================================================

package
{
	import com.brinkbit.admob.AdMobAd;
	import com.brinkbit.admob.AdMobController;
	import com.brinkbit.admob.constants.AdMobAdPosition;
	import com.brinkbit.admob.constants.AdMobAdType;
	import com.brinkbit.admob.event.AdMobEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	public class AdMobANE_Example extends Sprite
	{
		// insert your AdMob IDs here
		private static const MY_IOS_INTERSTITIAL_ID:String = "your id here";
		private static const MY_IOS_BANNER_ID:String = "your id here";
		private static const MY_ANDROID_INTERSTITIAL_ID:String = "your id here";
		private static const MY_ANDROID_BANNER_ID:String = "your id here";
		
		private var banner:AdMobAd;
		private var interstitial:AdMobAd;
		
		public function AdMobANE_Example()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(MouseEvent.CLICK, touched);
			
			// log what's happening
			AdMobController.debug = true;
			
			// create a new banner ad
			banner = new AdMobAd(AdMobAdType.BANNER, getID(AdMobAdType.BANNER));
			// we set the banner to wait an infinite time before showing
			banner.maxWaitTime = 0;
			// make the vertical position of the ad relative to the bottom of the screen
			banner.verticalGravity = AdMobAdPosition.BOTTOM;
			// set the banner's position 40px above the bottom of the screen
			banner.bottomPadding = 40;
			// we want to immediately show the ad
			banner.showAd();
			trace("Banner height: "+banner.height);
			trace("Banner width: "+banner.width);
			// on android this is the earliest the banner has a width and height
			banner.addEventListener(AdMobEvent.PRE_DRAW, function():void {
				trace("Banner height: "+banner.height);
				trace("Banner width: "+banner.width);
			});
			
			// create a new interstitial ad
			interstitial = new AdMobAd(AdMobAdType.INTERSTITIAL, getID(AdMobAdType.INTERSTITIAL));
			// hide the banner ad when the interstitial is shown
			interstitial.addEventListener(AdMobEvent.PRESENT_SCREEN, function():void { banner.hideAd(); });
			// show the banner ad when the interstial dismisses
			interstitial.addEventListener(AdMobEvent.DID_DISMISS_SCREEN, function():void { banner.showAd(); });
		}
		
		public function touched(event:MouseEvent):void {
			// display the interstitial
			interstitial.showAd();
		}
		
		// helper function to get the right ID
		public function getID(adType:String):String {
			if (Capabilities.manufacturer.indexOf("iOS") != -1)
				return (adType == AdMobAdType.INTERSTITIAL) ? MY_IOS_INTERSTITIAL_ID : MY_IOS_BANNER_ID;
			else if (Capabilities.manufacturer.indexOf("Android") != -1)
				return (adType == AdMobAdType.INTERSTITIAL) ? MY_ANDROID_INTERSTITIAL_ID : MY_ANDROID_BANNER_ID;
			return null;
		}
	}
}