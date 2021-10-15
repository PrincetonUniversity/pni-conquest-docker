#!/bin/bash

#echo "ConquestArchive suspended while archive system is down"
#exit;

# conquest_hosts can be a list of locations

conquest_hosts="Skyra-AWP45031 Prisma-MSTZ400D"

conquest_root="/mnt/data/"

#archive_root="/mnt/archive/"
archive_root="/mnt/archive/dicom_archive/conquest/"

log="/ConquestArchive.log"

mountpoints="/mnt/data /mnt/archive"

for fs in $mountpoints ;
do
	if ! mountpoint -q "$fs" ; then
		echo "$fs not mounted";
		exit;
	fi
done

# Archive files older than $age days

age="${ARCHIVE_AGE:=45}"

echo "Archiving data older than ${age}"

echo "***** Beginning dicom archive to $archive_root *****"

# Find directories older than $age days, create a target directory with the
# same trailing path, copy all but the "NII" directory to the archive
# directory, delete the source directory.

for c_host in $conquest_hosts ;
do
  echo "Checking $c_host";
  logfile=${archive_root}${c_host}${log};
  c_dir=${conquest_root}${c_host};
  archive_dirs=`find $c_dir -maxdepth 3 -mindepth 3 -type d -mtime +$age -print `;
  for a_dir in $archive_dirs;
  do
    echo "Archiving $a_dir";
    end_path=`sed s@$c_dir@@ <<EOF
$a_dir
EOF
`;
#    echo "end path = $end_path";
    dest=${archive_root}${c_host}${end_path};
    mkdir -p $dest;
    if [[ -z "${BACKUP_NOOP}" ]]; then
      #if no-op is set do a dryrun instead of an actual rsync
      echo "no-op rsync"
      rsync -a -n --exclude NII/ --exclude .snapshot $a_dir/ $dest;
    else
      rsync -a --exclude NII/ --exclude .snapshot $a_dir/ $dest;
    fi
    ec=$?;
    if [ $ec -ne 0 ] ; then
	echo "*** problem with rsync from $a_dir to $dest: exit code = $ec - skipping delete" >> $logfile;
    elif [[ -z "${BACKUP_NODELETE}" ]]; then
        echo "*** no delete set - skipping delete ***" >> $logfile;
    else
	date=`date`;
	if [ "$(ls -A $dest)" ] ; then
	    echo "$date: rsync of $a_dir/ to $dest OK: deleting $a_dir" >> $logfile;
	    rm -fr $a_dir;
        else
	    echo "$date: destination $dest is empty: not deleting $a_dir" >> $logfile;
	fi
    fi
  done 
done
