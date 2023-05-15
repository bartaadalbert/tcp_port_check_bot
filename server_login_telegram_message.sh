#!/usr/bin/env bash

# Content of /etc/ssh/login_notify.sh
# apt install jq
# nano /etc/ssh/login-notify.sh
# sudo chmod +x /etc/ssh/login-notify.sh 
# nano /etc/pam.d/sshd
# add after @include ... session ... 
# @include common-password
# session optional pam_exec.so /etc/ssh/login-notify.sh

TELEGRAM_TOKEN="TELEGRAM_TOKEN"
CHAT_ID="-00000000000"

# prepare any message you want
login_ip=$PAM_RHOST
LINE=$login_ip
FILE_LOGIN="/etc/ssh/login_ip.txt"
FILE_WHITE="/etc/ssh/white_ip.txt"
if [[ ! -e $FILE_LOGIN ]]; then
    touch $FILE_LOGIN
fi
grep -qxF -- "$LINE" "$FILE_LOGIN" || echo "$LINE" >> "$FILE_LOGIN"
if [[ ! -e $FILE_WHITE ]]; then
    touch $FILE_WHITE
fi
if grep -Fxq "$LINE" "$FILE_WHITE"
then
    exit 0
fi
#login_ip_data=$(curl -s "https://ipapi.co/${login_ip}/json/")
login_ip_data=$(wget -qO- "https://ipapi.co/${login_ip}/json/")
login_ip_city=$(echo -e $login_ip_data | jq -r ".city")
login_ip_org=$(echo -e $login_ip_data | jq -r ".org")

login_date="$(date +"%e %b %Y, %a %r")"
login_name="${PAM_USER}"
login_hostname="$(hostname)"

login_ip_country_name=$(echo -e $login_ip_data | jq -r ".country_name")
login_ip_asn=$(echo -e $login_ip_data | jq -r ".asn")

read -r -d '' MESSAGE << EOM
<b>${login_hostname}</b> ($login_name)
IP: ${login_ip}
City: ${login_ip_city} (${login_ip_country_name})
Organization: ${login_ip_org} (${login_ip_asn})
$PAM_SERVICE Login at: $login_date
EOM

if [ ${PAM_TYPE} = "open_session" ]; then
#  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$CHAT_ID" --data-urlencode text="$MESSAGE" -d parse_mode="HTML" > /dev/null 2>&1
  wget -qO- "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage?chat_id=$CHAT_ID&parse_mode=html&disable_web_page_preview=true&text=$MESSAGE" > /dev/null 2>&1
fi