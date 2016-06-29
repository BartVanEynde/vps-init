#!/bin/bash
#

logdir="/var/backups/lab29"

declare -A db
db[CustDev]="Customer_Devices"
#db[mysql]="lab28_mysql"
#db[error]="DoesNotExists"

cd $logdir
for d in "${!db[@]}"; do
        dd=${db[$d]}
        echo "=== $d = $dd ==="
	      ### bveynde do not overwrite the BVE_ tables in Customer_Devices for now ...
        ###mysql -e "DROP DATABASE IF EXISTS \`$dd\`; CREATE DATABASE  \`$dd\` DEFAULT CHARACTER SET latin1;"

        sqlgz=`ls -t dump.$d*.sql.gz|head -n 1`
        md5sum -c $sqlgz.md5
        [[ $? != 0 ]] && continue

        if [[ ! -z $sqlgz ]]; then
                echo "restoring $sqlgz into $dd"
                zcat $sqlgz | mysql "$dd"
        fi

        echo ""
done


