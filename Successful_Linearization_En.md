Engplish:
Linearization is completely succeed.
Only adjustment points TRANS\_PNT were not applied.
If in upcoming versions printcal it turns out to implement at recalibrate, it will be easier.

1. targen.exe  -v  -d4 -l100 -f0 -m0 -s200 -p3 1stPass

2. printtarg\_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 1stPass (I use tweaked printtagr own compilation which for i1 by default generates square patches 10x10mm and reduces several times a font of the name of columns and the information signature. The idea to apply patches 6x6 belongs Nikolay Pokhilchenko. By the way, Graeme, can be to add in printtarg options of control in the sizes of a patch, for example to set height and width of a patch manually and as type sizes?)

3. I print a target on absolutely not linearized device.

4. chartread 1stPass

5. printcal -v -i -p 1stPass. We receive curves of the first pass

6. We implement them in the driver (RIP). I use WinGP it is primary GIMP -plugin -gutenprint compiled under photoshop (win)  - http://code.google.com/p/wingp/
And so, I add curves in printrc. Thus, I receive a linearized output from the first pass.

7. targen.exe -v -d4 -l100 -f0 -m0 -s200 -p3 2ndPass

8. printtarg\_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 2ndPass

9. I print a target 2ndPass on initially linearized device (by means of gutenprint).

10. chartread 2ndPass

11. printcal -v -i -p 2ndPass

12. Rename 1stPass.cal -> 1stPassTweaked.cal (afterwards we will edit it)

13. Excel. We open 2ndPass.cal (see attachment)

14. 1st section(slice)  - Device Calibration Curves (further under text СС). We find coefficient of the relation of each curve to the first column (I named it(her) reference. As for convenience Second pass curves to Reference relation coefficient  - 2ndCCrc). We receive 4 columns with coefficients  - Crc Mrc Yrc Krc.

15. We open 1stPassTweaked.cal. Now us 3rd section  - Output Calibration Expected DE Response (further under text EDR) and it 4 columns interests: Cedr Medr Yedr Kedr.

16. We multiply columns. Crc\*Cedr Mrc\*Medr Yrc\*Medr Krc\*Medr. We receive скоррекрированные EDR each channel.

17. We transfer (copy -paste) corrected EDR values in 1stPassTweaked.cal

18. printcal -v -r -p 1stPassTweaked.cal 1stPass
On an output it is received 1stPass.cal with gage curves. What not to be tangled rename 1stPass.cal -> 1stPassFinal.cal

19. We interpose gage curves from 1stPassFinal.cal in RIP (in my a case gutenprint)

20. The last check.
21. targen.exe -v -d4 -l100 -f0 -m0 -s64 -p3 1stPassFinalTEST
22. printtarg\_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 1stPassFinalTEST
23. chartread 1stPassFinalTEST
24. printcal -v -i -p 1stPassFinalTEST
After point 24 printcal showed ideal linearity :)