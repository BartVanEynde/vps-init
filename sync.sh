#!/bin/bash
# bveynde 2016012 sync script
#

conffile="/root/bin/sync.conf"
options="-az -e '/usr/bin/ssh -o strictHostKeyChecking=no -2 -T -i /root/.ssh/id_rsa'"


echo -n "Syncing: "
while read -r item src dst
do
	[[ $item = \#* ]] && continue
	[[ -z $item || -z $src || -z $dst ]] && continue
	[[ ! -z $1 && "x$item" != "x$1" ]] && continue
	#echo "$item - $options - $src - $dst"
	echo -n "$item "
	#/usr/bin/rsync "$options" $src $dst
	/usr/bin/rsync -az --delete -e '/usr/bin/ssh -o strictHostKeyChecking=no -2 -T -i /root/.ssh/id_rsa' $src $dst

done < "$conffile"

echo "DONE!"
