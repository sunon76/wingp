# Introduction #

Набросал основной рабочий поток.

# Details #

Печатаем из Photoshop-а. Выбираем "File->Export->PhotoGP".
  * Плагин photogp.8be создаёт в папке **GPRINT\_TEMP** временный файл в формате **gpraw\_t** и вызывает **GPRINT**, в качестве параметра передавая имя файла.
  * **GPRINT** инициирует ядро gutenprint-а, запрашивает параметры печати и растрирует файл в **GPSPOOLERJOB**.
  * После окончания растрирования, создается файл с описанием параметров печати.
  * Вызывается **GPSPOOLER**, который посылает данные на принтер.

![http://wingp.googlecode.com/svn/wiki/images/GPrintWorkflow.png](http://wingp.googlecode.com/svn/wiki/images/GPrintWorkflow.png)