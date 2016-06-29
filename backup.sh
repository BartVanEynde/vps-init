#!/bin/bash
# bveynde 2016012 backup script
#

conffile='/root/bin/backup.conf'
#budir='/var/backups/lab28'
budir='/var/backups/'`hostname -s`
ts=$( date +"%Y%m%d.%H%M%S" )

cd $budir
echo -n "Creating backup: "
while read -r item dirs
do
	[[ $item = \#* ]] && continue
	[[ ! -z $1 && "x$item" != "x$1" ]] && continue
	[[ -z $item || -z $dirs ]] && continue
	#echo "item = $item"
	echo -n "$item "
	#echo "dirs = $dirs"
	tar cpvzf $item.$ts.tgz $dirs > $item.$ts.log 2>&1
	md5sum $item.$ts.tgz > $item.$ts.md5
	#echo ""
	ls $item.*.{md5,tgz,log}|sed -e 's/...$/\*/'|sort -r|uniq|awk 'NR>5 {print "rm "$0}'|sh 
done < "$conffile"

echo "DONE!"
