# Установка библиотек

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install git build-essential libz1:i386 libc6:i386 libstdc++6:i386

# Получаем библиотеку cgminerS9 из github репозитория

git clone https://github.com/AntonWebwo/cgminerS9

# Переходим в наш каталог

cd cgminerS9

# Создаём каталог для компиляторов

mkdir build-tools
cd build-tools

# Получаем компилятор и распаковываем его

wget https://minerflash.ru/files/gcc-linaro-arm-linux-gnueabihf-4.7-2012.11-20121123_linux.tar.bz2
tar xvf gcc-linaro-arm-linux-gnueabihf-4.7-2012.11-20121123_linux.tar.bz2

# Для экономии места удаляем скаченый архив

rm gcc-linaro-arm-linux-gnueabihf-4.7-2012.11-20121123_linux.tar.bz2

# Получаем библиотеки для компиляции под xilinx

git clone https://github.com/AntonWebwo/prebuilt-libz

# Возвращаемся в рабочий каталог cgminerS9

cd ..

# Выбираем тип асика (Нас интересует Antminer S9)

./setminertype S9

# Работаем с исходниками cgminer, по завершению собираем билд

make

# Производим очистку каталога от лишних файлов

make clean

# По окончанию очистки наблюдаем в каталоге cgminerS9 наш bmminer
# В зависимости от прошивки (для стоковой оставляем имя файла), для других переименовать в cgminer
