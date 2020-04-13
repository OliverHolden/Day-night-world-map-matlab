
% Start and end months must be in the same year

% Start points
TimeZone = 0;
Year = 2019;
Month = 0;
Day = 0;
Hour = 0;
Minute = 0;
Second = 0;

% Run till NumofMonths after start
NumOfMonths = 12;

% Hours between each picture
ImageInterval = 4;

HoursPerDay = 24;

ImageCounter = 0;

MapLow = imread('MapLow.jpg');
MapNightLow = imread('MapNightLow.jpg');

MapNightR = MapNight(:, :, 1);
MapNightG = MapNight(:, :, 2);
MapNightB = MapNight(:, :, 3);

MapLowR = MapLow(:, :, 1);
MapLowG = MapLow(:, :, 2);
MapLowB = MapLow(:, :, 3);

[PixelHeight, PixelWidth] = size(MapLowR);

DayNightYN = zeros(PixelHeight, PixelWidth);

DayNightR(PixelHeight, PixelWidth) = uint8(0);
DayNightG(PixelHeight, PixelWidth) = uint8(0);
DayNightB(PixelHeight, PixelWidth) = uint8(0);

SolarElevationCorrectedforATMRefractionDeg = zeros(PixelHeight, PixelWidth);

CorectSolarElevationCorrectedforATMRefractionDeg = zeros(PixelHeight, PixelWidth);

for Day = 1:sum(eomday(Year, 1:12))
    
    if Day <= sum(eomday(Year, 1:1))
        
        Month = 1;
        
        DayOfMonth = Day;
        
    elseif Day > sum(eomday(Year, 1:1)) && Day <= sum(eomday(Year, 1:2));
        
        Month = 2;
        
        DayOfMonth = Day - sum(eomday(Year, 1:1));
    
    elseif Day > sum(eomday(Year, 1:2)) && Day <= sum(eomday(Year, 1:3))
        
        Month = 3;
        
        DayOfMonth = Day - sum(eomday(Year, 1:2));
        
    elseif Day > sum(eomday(Year, 1:3)) && Day <= sum(eomday(Year, 1:4));
        
        Month = 4;
        
        DayOfMonth = Day - sum(eomday(Year, 1:3));
    
    elseif Day > sum(eomday(Year, 1:4)) && Day <= sum(eomday(Year, 1:5))
        
        Month = 5;
        
        DayOfMonth = Day - sum(eomday(Year, 1:4));
        
    elseif Day > sum(eomday(Year, 1:5)) && Day <= sum(eomday(Year, 1:6));
        
        Month = 6;
        
        DayOfMonth = Day - sum(eomday(Year, 1:5));
    
    elseif Day > sum(eomday(Year, 1:6)) && Day <= sum(eomday(Year, 1:7))
        
        Month = 7;
        
        DayOfMonth = Day - sum(eomday(Year, 1:6));
        
    elseif Day > sum(eomday(Year, 1:7)) && Day <= sum(eomday(Year, 1:8));
        
        Month = 8;
        
        DayOfMonth = Day - sum(eomday(Year, 1:7));
    
    elseif Day > sum(eomday(Year, 1:8)) && Day <= sum(eomday(Year, 1:9))
        
        Month = 9;
        
        DayOfMonth = Day - sum(eomday(Year, 1:8));
        
    elseif Day > sum(eomday(Year, 1:9)) && Day <= sum(eomday(Year, 1:10))
        
        Month = 10;
        
        DayOfMonth = Day - sum(eomday(Year, 1:9));
    elseif Day > sum(eomday(Year, 1:10)) && Day <= sum(eomday(Year, 1:11));
        
        Month = 11;
        
        DayOfMonth = Day - sum(eomday(Year, 1:10));
    
    elseif Day > sum(eomday(Year, 1:11)) && Day <= sum(eomday(Year, 1:12))
        
        Month = 12;
        
        DayOfMonth = Day - sum(eomday(Year, 1:11));
        
    end
        
    
    JD = juliandate(Year,Month,Day,Hour,Minute,Second);
                
    JDCen = ((JD - 2451545) / 36525);

        for TimePastLocalMidnightCounter = 1:ImageInterval;

                for LAT1 = 1:PixelHeight
                    for LONG1 = 1:PixelWidth

                        LAT = (LAT1*(180/PixelHeight)) - 90;
                        LONG = (LONG1*(360/PixelWidth)) - 180;

                        TimePastLocalMidnightCounter2 = (TimePastLocalMidnightCounter - 1) * HoursPerDay/ImageInterval;

                        TimePastLocalMidnight = TimePastLocalMidnightCounter2/24;                

                        GeomMeanLongSunDeg = mod(280.46646+JDCen*(36000.76983 + JDCen*0.0003032),360);

                        GeomMeanAnomSunDeg = 357.52911+JDCen*(35999.05029 - 0.0001537*JDCen);

                        EccentEarthOrbit = 0.016708634-JDCen*(0.000042037+0.0000001267*JDCen);

                        SunEqofCtr = sind(GeomMeanAnomSunDeg)*(1.914602-JDCen*(0.004817+0.000014*JDCen))+sind(2*GeomMeanAnomSunDeg)*(0.019993-0.000101*JDCen)+sind(3*GeomMeanAnomSunDeg)*0.000289;

                        SunTrueLongDeg = SunEqofCtr + GeomMeanLongSunDeg;

                        SunTrueAnomDeg = SunEqofCtr + GeomMeanAnomSunDeg;

                        SunRadVectorAUs = (1.000001018*(1-EccentEarthOrbit*EccentEarthOrbit))/(1+EccentEarthOrbit*cosd(SunEqofCtr));

                        SunAppLongDeg = SunTrueLongDeg-0.00569-0.00478*sind(125.04-1934.136*JDCen);

                        MeanObliqEclipticDeg = 23+(26+((21.448-JDCen*(46.815+JDCen*(0.00059-JDCen*0.001813))))/60)/60;

                        ObliqCorrDeg = MeanObliqEclipticDeg+0.00256*cosd(125.04-1934.136*JDCen);

                        SunRtAscenDeg = (180/pi)*(atan2(cosd(ObliqCorrDeg)*sind(SunAppLongDeg),cosd(SunAppLongDeg)));

                        SunDeclinDeg = (180/pi)*(asin(sind(ObliqCorrDeg)*sind(SunAppLongDeg)));

                        varY = tand(ObliqCorrDeg/2)*tand(ObliqCorrDeg/2);

                        EqOfTimeMinutes = 4*(180/pi)*(varY*sin(2*GeomMeanLongSunDeg*(pi/180))-2*EccentEarthOrbit*sind(GeomMeanAnomSunDeg)+4*EccentEarthOrbit*varY*sind(GeomMeanAnomSunDeg)*cos(2*GeomMeanLongSunDeg*pi/180)-0.5*varY*varY*sin(4*GeomMeanLongSunDeg*(pi/180))-1.25*EccentEarthOrbit*EccentEarthOrbit*sin(2*GeomMeanAnomSunDeg*(pi/180)));

                        HASunriseDeg = (180/pi)*(acos(cosd(90.833)/(cosd(LAT)*cosd(SunDeclinDeg))-tand(LAT)*tand(SunDeclinDeg)));

                        SolarNoonLST =(720-4*LONG-EqOfTimeMinutes+TimeZone*60)/1440;

                        SunriseTimeLST = SolarNoonLST-HASunriseDeg*4/1440;

                        SunsetTimeLST = SolarNoonLST+HASunriseDeg*4/1440;

                        SunlightDurationMin = HASunriseDeg*8;

                        TrueSolarTimeMin = mod(TimePastLocalMidnight*1440+EqOfTimeMinutes+4*LONG-60*TimeZone,1440);

                        if (TrueSolarTimeMin/4<0)

                            HourAngleDeg = TrueSolarTimeMin/4+180;

                        else

                            HourAngleDeg = TrueSolarTimeMin/4-180;

                        end

                        SolarZenithAngleDeg = (180/pi)*(acos(sind(LAT)*sind(SunDeclinDeg)+cosd(LAT)*cosd(SunDeclinDeg)*cosd(HourAngleDeg)));

                        SolarElevationAngleDeg = 90 - SolarZenithAngleDeg;

                        if (SolarElevationAngleDeg > 85)

                            ApproxAtmosphericRefractionDeg = 0;

                        elseif(SolarElevationAngleDeg < 85 && SolarElevationAngleDeg > 5)

                            ApproxAtmosphericRefractionDeg = (58.1/tand(SolarElevationAngleDeg))-(0.07/(tand(SolarElevationAngleDeg))^3)+(0.000086/(tand(SolarElevationAngleDeg))^5);

                        elseif (SolarElevationAngleDeg < 5 && SolarElevationAngleDeg > -0.575)

                        ApproxAtmosphericRefractionDeg = 1735+SolarElevationAngleDeg*(-518.2+SolarElevationAngleDeg*(103.4+SolarElevationAngleDeg*(-12.79+SolarElevationAngleDeg*0.711)));

                        elseif (SolarElevationAngleDeg < -0.075)

                        ApproxAtmosphericRefractionDeg = -20.772/tand(SolarElevationAngleDeg)/3600;

                        end

                        SolarElevationCorrectedforATMRefractionDeg = ApproxAtmosphericRefractionDeg + SolarElevationAngleDeg;
                        
                        LATCoreted = (PixelHeight + 1) - LAT1;
                        
                        CorectSolarElevationCorrectedforATMRefractionDeg(LATCoreted, LONG1) = SolarElevationCorrectedforATMRefractionDeg;

                        if (CorectSolarElevationCorrectedforATMRefractionDeg(LATCoreted, LONG1) <= 0) 

                            DayNightYN(LATCoreted, LONG1) = 1;
                            
                        else

                            DayNightYN(LATCoreted, LONG1) = 0;

                        end

                        if DayNightYN(LATCoreted, LONG1) == 1

                          DayNightR(LATCoreted, LONG1) = MapNightR(LATCoreted, LONG1);
                          DayNightG(LATCoreted, LONG1) = MapNightG(LATCoreted, LONG1);
                          DayNightB(LATCoreted, LONG1) = MapNightB(LATCoreted, LONG1);

                        else

                          DayNightR(LATCoreted, LONG1) = MapLowR(LATCoreted, LONG1);
                          DayNightG(LATCoreted, LONG1) = MapLowG(LATCoreted, LONG1);
                          DayNightB(LATCoreted, LONG1) = MapLowB(LATCoreted, LONG1);

                        end
               
                    end

                end
                
           DayNight(:, :, 1) = DayNightR;
           DayNight(:, :, 2) = DayNightG;
           DayNight(:, :, 3) = DayNightB;
           
           ImageCounter = ImageCounter + 1;

           filename=sprintf('DayNight_%d_%d_%d_%d.jpg', ImageCounter, DayOfMonth, Month, TimePastLocalMidnightCounter2);

           imwrite(DayNight, filename);
        
        end        
end






