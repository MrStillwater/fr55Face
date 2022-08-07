using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;

class ForerunnerfaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state ) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state ) as Void {
    }

    // Return the initial view of your application here
    function getInitialView()  {
        return [ new ForerunnerfaceView() ] ;
    }
    
}

function getApp() as ForerunnerfaceApp {
    return Application.getApp() as ForerunnerfaceApp;
}