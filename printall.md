# Introduction #

Печатаем из любого приложения через GP.


# Details #

## Зависимости ##
  * GhostScript. http://www.ghostscript.com/
  * RedMonEE.
    * Win32:http://www.is-foehr.de/
    * Win64:http://www.winimage.com/misc/redmon/


## Настройка RedMonEE ##
![http://wingp.googlecode.com/svn/wiki/images/rmconfig1.png](http://wingp.googlecode.com/svn/wiki/images/rmconfig1.png)
```
Redirect this port to the programm:
C:\Program Files\gs\gs8.71\bin\gswin32c.exe

Arguments for this program:
-q -dBATCH -dNOPAUSE -sDEVICE=tiff24nc -r300 -sOutputFile="%1"  -f -

Program to Start after finishing
D:\dick\gp\img2gpraw\to_raster.bat - необходимо указать правильный путь

Arguments for this
"%1" - кавычки обязательны
```
![http://wingp.googlecode.com/svn/wiki/images/rmconfig2.png](http://wingp.googlecode.com/svn/wiki/images/rmconfig2.png)
```
Template for Output to File
%GPRINT_TEMP%%n.tiff
```

Если меняли значения переменных среды, то необходимо перезапустить RedMonEE (подробности в документации к RedMonEE).