#!/bin/bash
# bveynde 2016012 backup script
#

conffile='/root/etc/keys.txt'   #user:ssh-key syntax = grep output ...
ts=$( date +"%Y%m%d.%H%M%S" )

echo -n "Adding Users: "
while IFS=":" read -r user key
do
        [[ $user = \#* ]] && continue
        [[ -z $user || -z $key ]] && continue
        #echo "user = $user"
        #echo "key = $key"

        if [[ ! -d /home/$user ]]; then
                echo -n "$user "
                useradd $user -U -m -s /bin/bash -p f110abe5b3cfd324c2e5128eb4733879
                echo $key > /home/$user/.ssh/authorized_keys
        else
                echo -n "!$user! "
        fi

        #echo ""
done < "$conffile"

echo "DONE!"

