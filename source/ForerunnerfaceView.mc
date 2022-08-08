//
// Watch face view for Garmin Forerunner 55
//
// Copyright 2022 Will Johnson
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class ForerunnerfaceView extends WatchUi.WatchFace {

    private var _timeFont;
    private var _iconFont;

    private const DATE_FONT = Graphics.FONT_XTINY;
    private const DATE_GAP = 25;
    private const ICON_PAD_Y = 21;
    private const ICON_PAD_X = 56;
    private const PEN_WIDTH = 1;
    private const ARC_DEGREE_START = 330;
    private const LOW_BATTERY_LEVEL = 20;
    private const BG_COLOR = Graphics.COLOR_BLACK;
    private const TIME_COLOR = Graphics.COLOR_LT_GRAY;
    private const DATE_COLOR = Graphics.COLOR_BLUE;
    private const ICON_COLOR = Graphics.COLOR_DK_BLUE;
    private const TIME_FONT = Rez.Fonts.sauce_code_pro;
    private const ICON_FONT = Rez.Fonts.icons;


    public function initialize() {
        WatchFace.initialize();
    }


    // Load your resources here
    public function onLayout(dc as Dc) as Void {
        _timeFont = WatchUi.loadResource(TIME_FONT);
        _iconFont = WatchUi.loadResource(ICON_FONT);
    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    public function onShow() as Void {
    }


    // Update the view
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, BG_COLOR);
        dc.clear();

        drawIcons(dc);
        drawClock(dc);
        drawBatteryArc(dc);
        
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }


    private function drawClock(dc as Dc) as Void {
        var timeFontHeight = Graphics.getFontHeight(_timeFont);
        var dateFontHeight = Graphics.getFontHeight(DATE_FONT);
        var dateLocY = (dc.getHeight() / 2) - (timeFontHeight / 2) - DATE_GAP - (dateFontHeight / 2);

        // Get the current time
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        
        // Convert to 12-hour format
        if (hour == 0) {
            hour = 12;
        }
        if (hour > 12) {
            hour -= 12;
        }
        var timeString = Lang.format(
            "$1$:$2$", 
            [
                hour, clockTime.min.format("%02d")
            ]
        );

        // Get the date
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format(
            "$1$ $2$ $3$",
            [
                today.day_of_week,
                today.month,
                today.day
            ]
        );

        // var secondsString = Lang.format(
        //     "$1$", 
        //     [
        //         clockTime.sec.format("%02d")
        //     ]
        // );
        
        var clockHourMinuteText = new WatchUi.Text({
            :text=>timeString,
            :color=>TIME_COLOR,
            :backgroundColor=>Graphics.COLOR_TRANSPARENT,
            :font=>_timeFont,
            :justification=>Graphics.TEXT_JUSTIFY_CENTER,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
        clockHourMinuteText.draw(dc);

        var clockDateText = new WatchUi.Text({
            :text=>dateString,
            :color=>DATE_COLOR,
            :backgroundColor=>Graphics.COLOR_TRANSPARENT,
            :font=>DATE_FONT,
            :justification=>Graphics.TEXT_JUSTIFY_LEFT,
            :locX =>dc.getWidth() / 2,
            :locY=>dateLocY
        });
        clockDateText.draw(dc);
    }

    private function drawBatteryArc(dc as Dc) as Void {
        var batteryLevel = System.getSystemStats().battery;
        var penColor;
        var isBatteryLow = false;
        var arcCenterX = dc.getWidth() / 2;
        var arcCenterY = dc.getHeight() / 2;
        var arcRadius = arcCenterY - PEN_WIDTH;
        var batteryDegree = 360 - (batteryLevel * 3.6) + ARC_DEGREE_START;
        var degreeEnd = batteryDegree.toNumber() % 360;
        
        if (batteryLevel < LOW_BATTERY_LEVEL) {
            penColor = Graphics.COLOR_DK_RED;
        }
        else {
            penColor = Graphics.COLOR_DK_GREEN;
        }
        dc.setColor(penColor, Graphics.COLOR_TRANSPARENT);
        
        if (degreeEnd > 0) {
            dc.drawArc(arcCenterX, arcCenterY, arcRadius, Graphics.ARC_CLOCKWISE, ARC_DEGREE_START, degreeEnd);
        }
    }

    private function drawIcons(dc as Dc) as Void {
        var iconLocX = (dc.getWidth() / 2) - ICON_PAD_X;
        var iconString = " ";
        var iconColor = BG_COLOR;

        // Bluetooth icon is digit 8 from the icons font
        if (System.getDeviceSettings().phoneConnected) {
            iconString = "8";
            iconColor = ICON_COLOR;
        }
            
        var iconText = new WatchUi.Text({
            :text=>iconString,
            :color=>iconColor,
            :backgroundColor=>Graphics.COLOR_TRANSPARENT,
            :font=>_iconFont,
            :justification=>Graphics.TEXT_JUSTIFY_LEFT,
            :locX =>iconLocX,
            :locY=>ICON_PAD_Y
        });
        iconText.draw(dc);
    }


    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    public function onHide() as Void {
    }


    // The user has just looked at their watch. Timers and animations may be started here.
    public function onExitSleep() as Void {
    }


    // Terminate any active timers and prepare for slow updates.
    public function onEnterSleep() as Void {
    }

}
