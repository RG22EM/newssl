# newssl
Установщик системы Openssl с модулем ГОСТ2012 для системы Centos 7 64x
Простая установка openssl крайней стабильной версии с поддержкой системы шифрации
ГОСТ 2012. 
Для установки на чистую минимальную версию выполните следующие команды:

1. из каталога cd /usr/local/src: 
2. yum install git -y
3. git clone --branch=master https://github.com/RG22EM/newssl.git
4. cp newssl/new-ssl.sh new-ssl.sh
5. bash new-ssl.sh
6. openssl ciphers|tr ':' '\n'|grep GOST
7. после перезагрузки сервера убеждаемся, что поддержка ГОСТ установлена

После установки пакета openssl 1.1.1x + engine + GOST2012 можно скомпилировать утилиту
конвертации ключа в формате крипто-про скопированного в корневую папку флэш накопителя
в виде контейнера в формат файла PEM поддерживаемого пакетом openssl.  Для этого:
 
 1. bash cp-to-pem.sh (на выходе утилита get-cpcert и её библиотека)
 
Применениe утилиты:
get-cpcert folder.000 password > certificate.pem

где folder.000 имя папки контейнера, password - пароль на контейнер
 
 
