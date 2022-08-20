#!/bin/bash

banner() {
clear
echo
echo -e ${RED}"           ███████╗██╗██████╗ ███████╗███████╗ ██████╗ ██╗  ██╗              "
echo          "           ██╔════╝██║██╔══██╗██╔════╝██╔════╝██╔═══██╗╚██╗██╔╝              "
echo          "           █████╗  ██║██████╔╝█████╗  █████╗  ██║   ██║ ╚███╔╝               "
echo          "           ██╔══╝  ██║██╔══██╗██╔══╝  ██╔══╝  ██║   ██║ ██╔██╗               "
echo          "           ██║     ██║██║  ██║███████╗██║     ╚██████╔╝██╔╝ ██╗              "
echo          "           ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═╝              "
echo          "                                                                             "
echo          "   ██████╗ ███████╗ ██████╗██████╗ ██╗   ██╗██████╗ ████████╗███████╗██████╗ "
echo          "   ██╔══██╗██╔════╝██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██╔════╝██╔══██╗"
echo          "   ██║  ██║█████╗  ██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   █████╗  ██████╔╝"
echo          "   ██║  ██║██╔══╝  ██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██╔══╝  ██╔══██╗"
echo          "   ██████╔╝███████╗╚██████╗██║  ██║   ██║   ██║        ██║   ███████╗██║  ██║"
echo -e       "   ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝   ╚══════╝╚═╝  ╚═╝"${NC}
echo
echo
echo
}

getjq() {
banner
echo Das Paket jq wird benötigt.
read -p "Möchten Sie das Paket jq installieren? (y/n): " aw1
if [ $aw1 == y ] || [ $aw1 == Y ]
then
banner && echo Das jq Paket wird installiert...
sudo apt-get install -y jq &>/dev/null
if [ $? -eq 0 ]
then echo Das Paket jq wurde erfolgreich installiert.
elif [ $? -eq 1 ]
then banner && echo "ERROR: Das Paket jq konnte nicht installiert werden." && echo "Bitte Internetverbindung prüfen." && sleep 3 && getjq
else banner && echo "ERROR: Das Paket jq konnte nicht Installiert werden." && echo "Ein unbekannter Fehler ist aufgetreten." && sleep 3 && getjq
fi
elif [ $aw1 == n ] || [ $aw1 == N ]
then banner && echo "Firefox Decrypter wird beendet..." && sleep 3 && clear && exit 1
else banner && echo Ungültige Eingabe.
sleep 3 && getjq
fi
banner
}

getlibnss3() {
banner
echo Das Paket libnss3-tools wird benötigt.
read -p "Möchten Sie das Paket libnss3-tools installieren? (y/n): " aw2
if [ $aw2 == y ] || [ $aw2 == Y ]
then
banner && echo Das Paket libnss3-tools wird installiert...
sudo apt-get install -y libnss3-tools &>/dev/null
if [ $? -eq 0 ]
then banner && echo Das Paket libnss3-tools wurde erfolgreich installiert.
elif [ $? -eq 1 ]
then banner && echo "ERROR: Das Paket libnss3-tools konnte nicht installiert werden." && echo "Bitte Internetverbindung prüfen." && sleep 3 && getlibnss3
else banner && echo "ERROR: Das Paket libnss3-tools konnte nicht installiert werden." && echo "Ein unbekannter Fehler ist aufgetreten." && sleep 3 && getlibnss3
fi
elif [ $aw2 == n ] || [ $aw2 == N ]
then banner && echo "Firefox Decrypter wird beendet..." && sleep 3 && clear && exit 1
else banner && echo Ungültige Eingabe.
sleep 3 && getlibnss3
fi
banner
}

method() {
banner
echo Sollen die Daten...
echo
echo "(1) aus dem hier installierten Browser"
echo "(2) aus importierten Browserdateien"
echo
read -p "entschlüsselt werden? (1/2): " aw3
if [ $aw3 == 1 ]
then
find ~/.mozilla/firefox \( -type f -name "key4.db" -or -name "logins.json" -or -name "cert9.db" \) -exec cp -a '{}' $MYDIR/tmp_data \;
cd tmp_data
decrypt
elif [ $aw3 == 2 ]
then
cd win_tmp_data
decrypt
else banner && echo Ungültige Eingabe.
sleep 3 && method
fi
}

decrypt() {
banner
echo "">>$MYDIR/DECRYPTED_PASSWORDS.txt && jq -r -S '.logins[] | .hostname, .encryptedUsername, .encryptedPassword' logins.json | pwdecrypt -d . -p foobar>>$MYDIR/DECRYPTED_PASSWORDS.txt
if [ $? -ne 0 ]
then
banner
echo ERROR: Es konnten keine Daten entschlüsselt werden.
sleep 3 && method
fi
cd ..
echo "">>DECRYPTED_PASSWORDS.txt
echo "******************************" >>DECRYPTED_PASSWORDS.txt
echo "Die entschlüsselten Daten wurden erfolgreich in der Datei" && echo "DECRYPTED_PASSWORDS.txt gespeichert."
echo
}

RED='\033[0;31m'
NC='\033[0m'
MYDIR="`pwd`"
if [ ! -d $MYDIR/tmp_data ]; then mkdir $MYDIR/tmp_data; fi
banner
dpkg -l jq &>/dev/null
if [ $? -ne 0 ]; then getjq; fi
dpkg -l libnss3-tools &>/dev/null
if [ $? -ne 0 ]; then getlibnss3; fi
method
read -p "Beenden mit Enter"
clear && exit


