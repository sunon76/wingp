# Калибровка + Линеаризация + Профилирование. #

# Полный процесс настройки Принтер-Чернила-Бумага. #

Состоит из основных этапов:

## 0. Калибровка принтера с помощью сервисной утилиты: ##

"Epson Service Adjustment Program". Зачастую без этого этапа все последующие во многом лишены смысла.

```
* Head angular adjustment
* Bi-Directional adjustmen
* PW adjustment
* First Dot Posision adjustment
* PF adjustment
```

## 1. Калибровка: ##

1 `Соотношений размеров капель`. Пока только визуально - testgenerator + паттерны Роберта Кравитца (Robert Krawitz). Нахождение значений `DropSize1` и `DropSize2`.

Testpattern для Windows - http://wingp.googlecode.com/files/testpattern.7z - СПАСИБО Владу!


Небольшое пояснение:

Необходимо вручную отредактировать файлы ex2.test (имя файла может быть произвольным) и выставить нужное разрешение -

---

```
parameter "Resolution" "720un";
```

---

подробнее про Resolusion см. файл escp2\model\model_???.xml_

testpattern.exe <ex2.test >ИмяФайлаВывода_ex2.prn_

Далее, посылаем ИмяФайлаВывода_ex2.prn на печать пользую rawprint (http://wingp.googlecode.com/files/rawprint.zip)._

(Можно и unprint ИмяФайлаВывода_ex2.prn - чтобы убедиться в правильности действий до реальной печати на носителе - ссылка - http://wingp.googlecode.com/files/unprint.zip)._

Далее, определяем DropSize1 и DropSize2 по верхним шкалам (см. картинку ниже)
![http://wingp.googlecode.com/files/DropSize%20calibration%2012.12.png](http://wingp.googlecode.com/files/DropSize%20calibration%2012.12.png)

Далее, редактируем ex4.test, приводя его в сответствие с ex2.test и печатаем аналогично ex2.

Смотрим нижнюю часть картинки выше (на картинке небольшое описание).

Вообще, ex4 для контроля правильности значений DS1 и DS2.

2 Лайтов. (визуально, возможно инструментально - Gplin). Нахождение значений параметров а) `Value` (виз. или инстр.) б) `Transition` (виз. в) `DensityScale` (виз. и/или инстр.)

# 2. Линеаризация и канальные лимиты: #

·         Подготовка WinGP (xml и/или printrс) к линеаризации;

_·        __«Нулевой проход» - ПредПредЛинеаризация (полей 50-60 на канал) для выяснения «гаммы» (параметр «-__p__»__targen__) нелинеаризованного (__raw__) устройства по формуле Николая Похильченко (http://forum.rudtp.ru/showthread.php?t=45954&p=525658&viewfull=1#post525658 ) -_p=Log10(X)/Log10(0,5), где X - аппаратное значение (0..1) при котором получается середина (0,5) по шкале dE, см. графики printcal;

_·        __«Первый проход» - ПредЛинеаризация (полей на 200 на канал СМ. ИСПРАВЛЕНИЯ НИЖЕ) с использованием ранее найденной «гаммы -__p__», например__targen__‑__p__3.2 для смещения центра плотности распределения контрольных точек в область основной центральной части перехода_

_·        __Внедрение данных линеаризации первого прохода в__WinGP__._

_·        __«Второй проход» - «Линеаризация как бы линеаризованного» (полей на 100 на канал) с использованием меньшего значения «гаммы -__p__» или без – этот же второй проход покажет правы мы были при выборе гаммы жтого прохода или нет - , например__targen__‑__p__2 для смещения центра плотности распределения контрольных точек в область части перехода, оставшейся после первого прохода недостаточно линеаризованной. (отсутствие –__p__не критично!)_

_·        __Корректировка данных ожидаемого ответа (вторая часть .__cal__файла –__EDR__) первого прохода с помощью данных второго прохода. На выходе .__cal__файл со скорректированными данными__EDR__для перекалибровки первого прохода с применением__ti__3 первого же прохода. (можно пользовать мой__.xls) http://wingp.googlecode.com/files/Expected%20DE%20Response%20tweaking.xls_

_·        __«Третий проход» - перекалибровка первого прохода с использованием .__cal__со скорректированными EDR и .__ti__3 первого же прохода. Перед эти этапом можно «слить» (вручную)__ti__3 файлы нулевого и первого проходов в один, который и пользовать._

_·        __Можно проверить калибровку – шагов 50 на канал будет достаточно._

_·        __Внедрение данных третьего прохода, то есть калибровочных кривых идеальной калибровки, в__WinGP__(__printrc__) с замещением ранее находившихся промежуточных._

## 2.1 Подготовка WinGP (printrc или xml) к Линеаризации ##

Печать проходит в режиме uncorrected. Для того что бы процесс работы gutenprint был полностью предсказуемым надо привести все его параметры в значения по умолчанию. Это, в основном, относится к параметрам density.

Перед правкой файлов xml можно/нужно сделать копию всей папки xml для возможного последующего возврата в изначальным параметрам. Следует понимать, что после таких изменений использовать gutenprint с этими параметрами будет возможно только в рамках описываемого процесса. Хотя, если планируется использовать различные интерпретации gutenprint, например для `PhotoPrint` или плагина для GIMP, возможно всякий раз перед использованием иной интерпретации GP изменять значение переменной STP\_DATA\_PATH, которая указывает на путь нахождения папки с xml файлами.

### 2.1.1 Правим все xml где встречается density. ###

**printers****.****xml**:

```
<family name="escp2">
       <parameters name="standard_params">
         <parameter type="float" name="Gamma">0.470</parameter>
       </parameters>
       <parameters name="480_params">
         <parameter type="float" name="MagentaGamma">0.95</parameter>
         <parameter type="float" name="YellowGamma">0.9</parameter>
         <parameter type="float" name="Gamma">0.470</parameter>
       </parameters>
       <parameters name="pro_5500_params">
         <parameter type="float" name="CyanGamma">0.8</parameter>
         <parameter type="float" name="Gamma">0.470</parameter>
       </parameters>
       <parameters name="cx3500_params">
         <parameter type="float" name="CyanGamma">0.96</parameter>
         <parameter type="float" name="MagentaGamma">1.02</parameter>
         <parameter type="float" name="YellowGamma">1.02</parameter>
         <parameter type="float" name="Gamma">0.500</parameter>
       </parameters>
       <parameters name="claria_params">
         <parameter type="float" name="Gamma">0.470</parameter>
<!-- ПРАВКА_REDLINE________________________________________________CHAPA -->
         <parameter type="float" name="BlackDensity">1.0</parameter>
<!-- ПРАВКА_REDLINE________________________________________________CHAPA -->
       </parameters>
```

Так же можно исправить значение гаммы – 1, хотя необязательно.

**model.xml**:

```
<resolution translate="text" name="720un" text="720 DPI High Quality">
    <physicalResolution>720 720</physicalResolution>
<!-- ПРАВКА_REDLINE________________________________________________CHAPA -->
    <parameter type="float" name="escp2_density">1.000000</parameter>
<!-- ПРАВКА_REDLINE________________________________________________CHAPA -->
    <parameter type="integer" name="escp2_ink_type">51</parameter>
    <parameter type="integer" name="escp2_base_res">360</parameter>
    <parameter type="integer" name="escp2_bits">2</parameter>
    <parameter type="float" name="DropSize1">0.107000</parameter>
    <parameter type="float" name="DropSize2">0.330000</parameter>
    <parameter type="float" name="DropSize3">1.000000</parameter>
   </resolution>

*media.xml*:

<ink translate="text" name="None" text="EPSON Standard Inks">
<!-- ПРАВКА_REDLINE________________________________________________CHAPA -->
   <parameter type="float" name="Density">1.000000</parameter>
<!-- ПРАВКА_REDLINE________________________________________________CHAPA -->
   <parameter type="float" name="SubchannelCutoff">0.250000</parameter>
   <parameter type="float" name="BlackTrans">0.750000</parameter>
   <parameter type="float" name="GCRLower">0.100000</parameter>
   <parameter type="float" name="GCRUpper">0.500000</parameter>
   <parameter type="float" name="CyanBalance">1.000000</parameter>
   <parameter type="float" name="MagentaBalance">0.700000</parameter>
   <parameter type="float" name="YellowBalance">0.700000</parameter>
   <parameter type="float" name="BlackDensity">1.000000</parameter>
   <parameter type="float" name="Saturation">1.000000</parameter>
   <parameter type="float" name="Gamma">1.000000</parameter>
   <parameter type="curve" name="HueMap" ref="hue_map"/>
   <parameter type="curve" name="LumMap" ref="lum_map"/>
   <parameter type="curve" name="SatMap" ref="sat_map"/>
  </ink>
```

**Вот что бывает, когда не установили единички плотностей в XML (!!!)**
![http://wingp.googlecode.com/files/IfWeDidn%27tEditXML%2020.01.png](http://wingp.googlecode.com/files/IfWeDidn%27tEditXML%2020.01.png)

### 2.1.2 Надо явно указать GP наличие параметров описания линеаризационных кривых! Как только GP «видит», что есть такие описания, он, в режиме uncorrected, НЕ принимает никаких действий по коррекции (гамма-коррекции). ###

### Если есть любой .cal файл - берём первую колонку и вставляем 256 значений идеальной линейной калибровки (вообще это арифметическая прогрессия с шагом 1/255 от 0.00000 до 1.00000) в printrc (media.xml) в каждый канал: ###

```
Parameter CyanCurve Curve True '<?xml version="1.0"?>
 <gutenprint xmlns="http://gimp-print.sourceforge.net/xsd/gp.xsd-1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://gimp-print.sourceforge.net/xsd/gp.xsd-1.0
 gutenprint.xsd">
 <curve wrap="nowrap" type="linear" gamma="0" piecewise="false">
 <sequence count="256" lower-bound="0" upper-bound="1">
 0 0.0039216 0.0078431 0.011765 0.015686 0.019608 0.023529 0.027451 0.031373
 0.035294 0.039216 0.043137 0.047059 0.05098 0.054902 0.058824 0.062745 0.066667
 0.070588 0.07451 0.078431 0.082353 0.086275 0.090196 0.094118 0.098039 0.10196
 0.10588 0.1098 0.11373 0.11765 0.12157 0.12549 0.12941 0.13333 0.13725 0.14118
 0.1451 0.14902 0.15294 0.15686 0.16078 0.16471 0.16863 0.17255 0.17647 0.18039
 0.18431 0.18824 0.19216 0.19608 0.2 0.20392 0.20784 0.21176 0.21569 0.21961
 0.22353 0.22745 0.23137 0.23529 0.23922 0.24314 0.24706 0.25098 0.2549 0.25882
 0.26275 0.26667 0.27059 0.27451 0.27843 0.28235 0.28627 0.2902 0.29412 0.29804
 0.30196 0.30588 0.3098 0.31373 0.31765 0.32157 0.32549 0.32941 0.33333 0.33725
 0.34118 0.3451 0.34902 0.35294 0.35686 0.36078 0.36471 0.36863 0.37255 0.37647
 0.38039 0.38431 0.38824 0.39216 0.39608 0.4 0.40392 0.40784 0.41176 0.41569
 0.41961 0.42353 0.42745 0.43137 0.43529 0.43922 0.44314 0.44706 0.45098
 0.4549 0.45882 0.46275 0.46667 0.47059 0.47451 0.47843 0.48235 0.48627 0.4902
 0.49412 0.49804 0.50196 0.50588 0.5098 0.51373 0.51765 0.52157 0.52549 0.52941
 0.53333 0.53725 0.54118 0.5451 0.54902 0.55294 0.55686 0.56078 0.56471 0.56863
 0.57255 0.57647 0.58039 0.58431 0.58824 0.59216 0.59608 0.6 0.60392 0.60784
 0.61176 0.61569 0.61961 0.62353 0.62745 0.63137 0.63529 0.63922 0.64314
 0.64706 0.65098 0.6549 0.65882 0.66275 0.66667 0.67059 0.67451 0.67843 0.68235
 0.68627 0.6902 0.69412 0.69804 0.70196 0.70588 0.7098 0.71373 0.71765 0.72157
 0.72549 0.72941 0.73333 0.73725 0.74118 0.7451 0.74902 0.75294 0.75686 0.76078
 0.76471 0.76863 0.77255 0.77647 0.78039 0.78431 0.78824 0.79216 0.79608
 0.8 0.80392 0.80784 0.81176 0.81569 0.81961 0.82353 0.82745 0.83137 0.83529
 0.83922 0.84314 0.84706 0.85098 0.8549 0.85882 0.86275 0.86667 0.87059 0.87451
 0.87843 0.88235 0.88627 0.8902 0.89412 0.89804 0.90196 0.90588 0.9098 0.91373
 0.91765 0.92157 0.92549 0.92941 0.93333 0.93725 0.94118 0.9451 0.94902 0.95294
 0.95686 0.96078 0.96471 0.96863 0.97255 0.97647 0.98039 0.98431 0.98824
 0.99216 0.99608 1
 </sequence>
 </curve>
 </gutenprint>
```

Теоретически можно сделать проще:

```
Parameter CyanCurve Curve True '<?xml version="1.0"?>
 <gutenprint xmlns="http://gimp-print.sourceforge.net/xsd/gp.xsd-1.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://gimp-print.sourceforge.net/xsd/gp.xsd-1.0
 gutenprint.xsd">
 <curve wrap="nowrap" type="linear" gamma="0" piecewise="false">
 <sequence count="2" lower-bound="0" upper-bound="1">
 0 1
 </sequence>
 </curve>
 </gutenprint>
```

_Этот способ мной не проверен. Хотя должен работать._

Дмитрий (aka Dickobraz) напомнил, что есть ещё более простой способ. Главное окно плагина -> Adjust Output -> Curves -> ставим галку напротив, например, cyan curve -> открывается окошко с видом кривой -> справа нижняя в вертикальном ряду кнопка (это приведение в состояние идеальной линейности) -> OK -> закрыть -> сохранить параметры.
_Одним словом, проще некуда_
![http://wingp.googlecode.com/files/WinGP_preparing_NullCalibrationCurves%2020.01.png](http://wingp.googlecode.com/files/WinGP_preparing_NullCalibrationCurves%2020.01.png)

Проверим printrc. Должно быть что-то похожее на:
```
<sequence count="256" lower-bound="0" upper-bound="1">
0 0.00392157 0.00784314 0.0117647 0.0156863 0.0196078 0.0235294 0.027451
```

### 2.1.3. Непосредственно сам процесс линеаризации с использованием ArgyllCMS. ###

### Далее следуют пункты указанные в статье "Successful linearization", однако, я не использовал «нулевой» проход, то есть «гамма» «-p» для targen была найдена опытным путём ранее: ###

```
1)     *Первый проход: *targen.exe -v -d4 -l100 -f0 -m0 -s200 -p3 1stPass
2)     printtarg_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 1stPass (Я использую tweaked printtagr собственной компиляции, который для i1 по умолчанию генерирует квадратные патчи 10x10mm и уменьшает в несколько раз шрифт наименования колонок и информационной подписи. Идея применять патчи 6x6 принадлежит Nikolay Pokhilchenko. Кстати, Graeme, может быть добавить в printtarg опции управления размерами патча, например задавать высоту и ширину патча вручную а так же размеров шрифта?)
3)     Печатаю мишень на совершенно нелинеаризованном устройстве (WinGP).
4)     chartread 1stPass
5)     printcal -v -i -p 1stPass. Получаем кривые первого прохода
6)     Внедряем их в драйвер (RIP), в данном случае WinGP. Замещаем кривые в printrc (ранее там находились «инициализирующие» идеально линейные). Таким образом, получаю линеаризованный с первого прохода принтер.
7)     *Второй** **проход:* targen.exe -v -d4 -l100 -f0 -m0 -s200 -p3 2ndPass
8)     printtarg_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 2ndPass
9)     Печатаю мишень 2ndPass на первично линеаризованном устройстве.
10)  chartread 2ndPass
11)  printcal -v -i -p 2ndPass
12)  Переименовываем 1stPass.cal -> 1stPassTweaked.cal (впоследствии мы будем его редактировать)
13)  Excel. Открываем 2ndPass.cal (см. attachment)
14)  1-й раздел - Device Calibration Curves (далее по тексту CC). Находим коэффициент отношения каждой кривой к первой колонке (я назвал её reference, так же для удобства - Second pass curves to Reference relation coefficient - 2ndCCrc). Получаем 4 колонки с коэффициентами - Crc Mrc Yrc Krc.
15)  Открываем 1stPassTweaked.cal . Теперь нас интересует 3-й раздел - Output Calibration Expected DE Response (далее по тексту EDR) и его 4 колонки: Cedr Medr Yedr Kedr.
16)  Умножаем колонки. Crc*Cedr Mrc*Medr Yrc*Medr Krc*Medr. Получаем скорректированные EDR каждого канала.
17)  Переносим (copy-paste) скорректированные EDR значения в 1stPassTweaked.cal
18)  *Перекалибровка**: *printcal -v -r -p 1stPassTweaked.cal 1stPass На выходе получаем 1stPass.cal с окончательными калибровочными кривыми. Что бы не запутаться rename 1stPass.cal -> 1stPassFinal.cal
19)  Вставляем калибровочные кривые из 1stPassFinal.cal в драйвер (RIP), в моём случае WinGP printrc.
20)  Последняя проверка.
21)  targen.exe -v -d4 -l100 -f0 -m0 -s64 -p3 1stPassFinalTEST
22)  printtarg_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 1stPassFinalTEST
23)  chartread 1stPassFinalTEST
24)  printcal -v -i -p 1stPassFinalTEST После пункта
25)  printcal показал идеальную линейность
```

## 3. Определение `TotalInkLimit` (визуально). ##

- думаю, на данный момент наилучшим решением будет рекомендация пользователя «Aspirin» на форуме rudtp.ru - http://forum.rudtp.ru/showthread.php?t=45954&p=525825&viewfull=1#post525825

## 4. Профилирование. (инструментально, ArgyllCMS) ##

4.1 Предварительный профиль

4.2 Профиль

## 5. Печать фото материала - WinGP, `PhotoPrint`, Gplin (DeviceN) и проч. ##

5.1 "Вручную"

- Построение devicelink для каждой фото с помощью tiffgamut и collink --> WinGP

5.2


# ИСПРАВЛЕНИЯ И ДОПОЛНЕНИЯ #

_·        __«Первый проход» - ПредЛинеаризация (полей на 200 на канал_

{{{провёл сравнение 200 шагов и 73 на канал - в результате калибровочные кривые в .cal файле практически идентичны. **Вывод:** - можно обойтись и 70-80-ю патчами на канал.1)     *Первый проход: *targen.exe -v -d4 -l100 -f0 -m0 -s200 -p3 1stPass
2)     printtarg_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 1stPass (Я использую tweaked printtagr собственной компиляции, который для i1 по умолчанию генерирует квадратные патчи 10x10mm и уменьшает в несколько раз шрифт наименования колонок и информационной подписи. Идея применять патчи 6x6 принадлежит Nikolay Pokhilchenko. Кстати, Graeme, может быть добавить в printtarg опции управления размерами патча, например задавать высоту и ширину патча вручную а так же размеров шрифта?)
3)     Печатаю мишень на совершенно нелинеаризованном устройстве (WinGP).
4)     chartread 1stPass
5)     printcal -v -i -p 1stPass. Получаем кривые первого прохода
6)     Внедряем их в драйвер (RIP), в данном случае WinGP. Замещаем кривые в printrc (ранее там находились «инициализирующие» идеально линейные). Таким образом, получаю линеаризованный с первого прохода принтер.
7)     *Второй** **проход:* targen.exe -v -d4 -l100 -f0 -m0 -s200 -p3 2ndPass
8)     printtarg_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 2ndPass
9)     Печатаю мишень 2ndPass на первично линеаризованном устройстве.
10)  chartread 2ndPass
11)  printcal -v -i -p 2ndPass
12)  Переименовываем 1stPass.cal -> 1stPassTweaked.cal (впоследствии мы будем его редактировать)
13)  Excel. Открываем 2ndPass.cal (см. attachment)
14)  1-й раздел - Device Calibration Curves (далее по тексту CC). Находим коэффициент отношения каждой кривой к первой колонке (я назвал её reference, так же для удобства - Second pass curves to Reference relation coefficient - 2ndCCrc). Получаем 4 колонки с коэффициентами - Crc Mrc Yrc Krc.
15)  Открываем 1stPassTweaked.cal . Теперь нас интересует 3-й раздел - Output Calibration Expected DE Response (далее по тексту EDR) и его 4 колонки: Cedr Medr Yedr Kedr.
16)  Умножаем колонки. Crc*Cedr Mrc*Medr Yrc*Medr Krc*Medr. Получаем скорректированные EDR каждого канала.
17)  Переносим (copy-paste) скорректированные EDR значения в 1stPassTweaked.cal
18)  *Перекалибровка**: *printcal -v -r -p 1stPassTweaked.cal 1stPass На выходе получаем 1stPass.cal с окончательными калибровочными кривыми. Что бы не запутаться rename 1stPass.cal -> 1stPassFinal.cal
19)  Вставляем калибровочные кривые из 1stPassFinal.cal в драйвер (RIP), в моём случае WinGP printrc.
20)  Последняя проверка.
21)  targen.exe -v -d4 -l100 -f0 -m0 -s64 -p3 1stPassFinalTEST
22)  printtarg_6x6.exe -v2 -a0.6 -A0.67 -T 360 -ii1 -p210x297 -L -m0 1stPassFinalTEST
23)  chartread 1stPassFinalTEST
24)  printcal -v -i -p 1stPassFinalTEST После пункта
25)  printcal показал идеальную линейность
}}}

) с использованием ранее найденной «гаммы -__p__», например __targen__ ‑__p__3.2 для смещения центра плотности распределения контрольных точек в область основной центральной части перехода _```