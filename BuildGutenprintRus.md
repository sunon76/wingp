# Введение #

Собираем пакет Gutenprint и пишем консольную утилиту для печати под Linux и Windows.
Документ пишется в потоковом режиме, поэтому могут быть неточности и избыточность.

# Сборка пакета #
## Linux ##
На сайте http://gimp-print.sourceforge.net/p_Download.php в самом низу находим команды для получения пакета из репозитория. Выполняем:
```
cvs -d:pserver:anonymous@gimp-print.cvs.sourceforge.net:/cvsroot/gimp-print login
cvs -z3 -d:pserver:anonymous@gimp-print.cvs.sourceforge.net:/cvsroot/gimp-print co -P print
```

Для удобства переименовываем print в gutenprint:
```
mv print gutenprint
```

Запускаем скрипт autogen.sh
```
./autogen.sh
```
Смотрим вывод команды. Если есть ошибки о недостающих пакетах - устанавливаем их.
Пример лога с ошибками:
```
dgarkaev@t-34:~/gutenprint$ ./autogen.sh
./autogen.sh: 1: ./scripts/autogen.sh: libtool: not found
./autogen.sh: 24: test: Illegal number:

**Error**: You must have `autoconf' installed to compile gutenprint.
Download the appropriate package for your distribution,
or get the source tarball at ftp://ftp.gnu.org/pub/gnu/

**Error**: You must have `libtool' installed to compile gutenprint.
Get ftp://ftp.gnu.org/pub/gnu/libtool/libtool-1.5.tar.gz
(or a newer version if it is available)

**Error**: You must have `pkg-config' installed to compile gutenprint.
Download the appropriate package for your distribution,
or get the source tarball at http://www.freedesktop.org/

**Error**: You must have `autopoint' installed to compile gutenprint.
Get ftp://ftp.gnu.org/pub/gnu/gettext/gettext-0.11.5.tar.gz
(or a newer version if it is available)

**Error**: You must have `automake' installed to compile gutenprint.
Get ftp://ftp.gnu.org/pub/gnu/automake/automake-1.7.tar.gz
(or a newer version if it is available)
./autogen.sh: 144: test: Illegal number:
./autogen.sh: 146: test: Illegal number:
./autogen.sh: 147: test: Illegal number:

***Warning***: You must have "Jade" version 1.2.1 or
newer installed to build the Gutenprint user's guide.
Get ftp://ftp.jclark.com/pub/jade/jade-1.2.1.tar.gz
(or a newer version if available)

./autogen.sh: 201: test: Illegal number:
./autogen.sh: 202: test: Illegal number:

***Warning***: You must have "OpenJade" version 1.3 or
newer installed to build the Gutenprint user's guide.
Get http://download.sourceforge.net/openjade/openjade-1.3.tar.gz
(or a newer version if available)

./autogen.sh: 1: ./scripts/autogen.sh: sgmltools: not found
./autogen.sh: 245: test: Illegal number:
./autogen.sh: 246: test: Illegal number:
./autogen.sh: 247: test: Illegal number:

***Warning***: You must have "sgmltools-lite" version 3.0.2
or newer installed to build the Gutenprint user's guide.
Get http://prdownloads.sourceforge.net/projects/sgmltools-lite/sgmltools-lite-3.0.2.tar.gz
(or a newer version if available)


***Warning***: You must have Docbook v4 installed to
build the Gutenprint user's guide.

dgarkaev@t-34:~/gutenprint$
```
Пакеты помеченные как `**Warning**` можно игнорировать, т.к. они нужны для генерации документации. Доустанавливаем пакеты помеченные как `**Error**`:
```
dgarkaev@t-34:~/gutenprint$sudo apt-get -y install libtool autoconf pkg-config autopoint automake
```

Запускаем configure, который нам сгенерил autogen.sh и анализируем вывод скрипта:
```
dgarkaev@t-34:~/gutenprint$./configure
[...]
Configuration Summary:
------------- --------

If you have any problems, please report the information below to
gimp-print-devel@lists.sourceforge.net

================================================================
  Release: gutenprint 5.2.11-pre1 generated on 05 авг. 2014

  Features:
    Build CUPS:                                 no
    Build EPSON inkjet utility:                 yes
    Build enhanced Print plugin for GIMP:       no
    Build Ghostscript IJS driver:               no
    Build Foomatic data:                        no
    Build test programs:                        yes
    Build testpattern generator:                yes

  Installation summary:
    Installation prefix:                        /usr/local
    Exec prefix:                                /usr/local (${prefix})
    Data directory:                             /usr/local/share/gutenprint
    Library directory:                          /usr/local/lib/gutenprint (/usr/local/lib/gutenprint)
    XML data directory:                         /usr/local/share/gutenprint/5.2/xml
    Module directory:                           /usr/local/lib/gutenprint/5.2/modules (/usr/local/lib/gutenprint/5.2/modules)
    Install sample images:                      yes

  General configuration:
    Compiler options:                           -Disfinite=finite  -O6  -Wall -Wcast-align -Wstrict-prototypes 
                                                -Wmissing-prototypes -Wmissing-declarations -Wnested-externs 
                                                -Wwrite-strings -Werror-implicit-function-declaration -Winline 
                                                -Wformat=2 -finline-limit=131072 -pedantic -Waggregate-return 
                                                -Wcast-qual -Wshadow -Wredundant-decls
    Build static libraries:                     yes
    Build shared libraries:                     yes
    Maintainer mode:                            yes
    Use i18n:                                   yes
    Generate profiling information:             no
    Generate debugging symbols:                 no
    Use modules:                                static
    Use readline libraries:                     yes
    uname -a output:                            Linux t-34 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:08:14 UTC 2014 i686 athlon i686 GNU/Linux
================================================================
[...]
```

Если нужен плагин для GIMP, или планируется использовать GUI для настройки печати, то устанавливаем пакет libgimp2.0-dev. При установке он вытянет и GTK-2.
```
dgarkaev@t-34:~/gutenprint$sudo apt-get install libgimp2.0-dev
dgarkaev@t-34:~/gutenprint$./configure
[...]
  Features:
    Build CUPS:                                 no
    Build EPSON inkjet utility:                 yes
    Build enhanced Print plugin for GIMP:       yes
        GIMP plugin will be named:              gutenprint
        Install plugin(s) in home directory:    no
    Build Ghostscript IJS driver:               no
    Build Foomatic data:                        no
    Build test programs:                        yes
    Build testpattern generator:                yes
[...]
```

Собираем пакет и устанавливаем в систему:
```
dgarkaev@t-34:~/gutenprint$make
dgarkaev@t-34:~/gutenprint$sudo make install
```
Если пакет не собирается из-за отсутствия утилиты yacc, то устанавливаем недостающие пакеты, переконфигурируем (заодно отключим сборку документации) и собираем:
```
dgarkaev@t-34:~/gutenprint$sudo apt-get install bison flex
dgarkaev@t-34:~/gutenprint$./configure --without-doc
dgarkaev@t-34:~/gutenprint$make clean && make
dgarkaev@t-34:~/gutenprint$sudo make install
```


# Утилита печати gprint (Draft поэтому пока не читаем :) ) #




## Makefile ##
Создадим Makefile для сборки утилиты:

```
dgarkaev@t-34:~/gprint$cat ./Makefile 

CC = gcc

CFLAGS = -g3 -Wall -O0 -std=c99
LIBS =

GPLIBSUI = $(shell pkg-config --libs gutenprintui2)
GPCFLAGSUI =  $(shell pkg-config --cflags gutenprintui2)

PROG = gprint

all:
        $(CC) gprint.c -o $(PROG) $(CFLAGS) $(GPCFLAGSUI) $(LIBS) $(GPLIBSUI)

```

### Замечание ###
Для компиляции gprint со статической версией библиотеки gutenprint, в pkg-config добавить --static и доустановить
пакеты libselinux1-dev и libffi-dev (это в моем случае. У вас могут потребоваться другие пакеты, в зависимости что уже было установленно в систему).
```
dgarkaev@t-34:/lib$ sudo apt-get install libselinux1-dev libffi-dev
```

Соответствующие строки в Makefile должны выглядеть так:
```
GPLIBS = $(shell pkg-config --static --libs gutenprint)
GPLIBSUI = $(shell pkg-config --static --libs gutenprintui2)
```

Создадим файл gprint.c, подключим библиотеку gutenprint и проверим правильность сборки.

```
#include <gutenprint/gutenprint.h>
#include <gutenprintui2/gutenprintui.h>

int main( int argc, char* argv[] )
{
 stp_init();
 stp_set_output_codeset( "UTF-8" );

 printf( "Gutenprint library version: %s\n", stp_get_version() );

return 0;
}
```

Собираем командой make
```
dgarkaev@t-34:~/gprint$ make
gcc gprint.c -o gprint -g3 -Wall -O0 -std=c99  -pthread -I/usr/local/include 
-I/usr/include/gtk-2.0 -I/usr/lib/i386-linux-gnu/gtk-2.0/include -I/usr/include/atk-1.0 
-I/usr/include/cairo -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/pango-1.0 
-I/usr/include/gio-unix-2.0/ -I/usr/include/freetype2 -I/usr/include/glib-2.0 
-I/usr/lib/i386-linux-gnu/glib-2.0/include -I/usr/include/pixman-1 
-I/usr/include/libpng12 -I/usr/include/harfbuzz     -pthread 
-L/usr/local/lib -lgutenprintui2 -lgutenprint -lgtk-x11-2.0 -lgdk-x11-2.0 -latk-1.0 
-lpangoft2-1.0 -lXinerama -lXi -lXrandr -lXcursor -lXcomposite -lXdamage 
-lpangocairo-1.0 -lgdk_pixbuf-2.0 -lgio-2.0 -lresolv -lselinux -lXfixes 
-lcairo -lpixman-1 -lxcb-shm -lxcb-render -lXrender -lXext -lX11 -lpthread 
-lxcb -lXau -lXdmcp -lm -lharfbuzz -lpango-1.0 -lfontconfig -lgmodule-2.0 
-ldl -lgobject-2.0 -lffi -lglib-2.0 -lpcre -lexpat -lfreetype -lz -lpng12
```

... и запускаем
```
dgarkaev@t-34:~/gprint$./gprint
./gprint: error while loading shared libraries: libgutenprint.so.2: cannot open shared object file: No such file or directory
```
Приложение не запустилось, т.к. система не нашла libgutenprint.so.2

Проверим видимость всех библиотек необходимых нашему приложению:
```
dgarkaev@t-34:~/gprint$ ldd ./gprint
        linux-gate.so.1 =>  (0xb771f000)
        libgutenprint.so.2 => not found
        libpthread.so.0 => /lib/i386-linux-gnu/libpthread.so.0 (0xb76f3000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xb7543000)
        /lib/ld-linux.so.2 (0xb7720000)

```
Библиотека libgutenprint.so.2 лежит в /usr/local/lib, но система не видит этого пути. Сконфигурируем пути с помощью команды ldconfig.
Проверим что в /etc/ld.so.conf.d/libc.conf прописан путь /usr/local/lib. Если нет - добавляем. У меня этот файл выглядит так:
```
dgarkaev@t-34:/etc/ld.so.conf.d$ cat ./libc.conf
# libc default configuration
/usr/local/lib
```
Пропишем пути загрузки библиотек:
```
dgarkaev@t-34:~/gprint$ sudo ldconfig
```
Пробуем еще раз запустить утилиту:
```
dgarkaev@t-34:~/gprint$ ./gprint
Gutenprint library version: 5.2.11-pre1
```
Убеждаемся что все нормально собралось и запустилось.

### Вызов GUI gutenprint-а ###
Добавим вызов GUI. (TODO: добавить параметры изображения и thumnails-callback)
```
#include <locale.h>
#include <gutenprint/gutenprint.h>
#include <gutenprintui2/gutenprintui.h>

int main( int argc, char* argv[] )
{
    stp_init();
    stp_set_output_codeset( "UTF-8" );

    printf( "Gutenprint library version: %s\n", stp_get_version() );

    gtk_set_locale();
    setlocale( LC_ALL, "C" );
    gtk_init( &argc, &argv );

    int runme;

    runme = stpui_do_print_dialog();

return 0;
}
```

Собираем и убеждаемся что приложение запускается и появляется GUI от gutenprint-а.

### ImageMagic ###
Для загрузки изображений будем использовать ImageMagic. Установим пакет, как рекомендуется на сайте:
```
sudo apt-get install imagemagick libmagick++-dev
```

### Добавление Callback-функций ###