#!/bin/bash

#echo "ConquestArchive suspended while archive system is down"
#exit;

# conquest_hosts can be a list of locations

#conquest_hosts="Skyra-AWP45031 Allegra-MRC20413"
conquest_hosts="Skyra-AWP45031 Prisma-MSTZ400D"
conquest_root="/jukebox/dicom/conquest/"
#archive_root="/jukebox/dicom_archive/conquest/"
#archive_root="/mnt/archive/dicom/dicom_archive/conquest/"
#archive_root="/mnt/pail/PNI-archive/dicom/dicom_archive/conquest/"
archive_root="/mnt/puddle/PNI-archive/dicom/dicom_archive/conquest/"
log="/ConquestArchive.log"
#mountpoints="/mnt/cd/dicom /mnt/archive"
#mountpoints="/mnt/bucket/dicom /mnt/pail/PNI-archive/dicom"
mountpoints="/mnt/bucket/dicom /mnt/puddle/PNI-archive/dicom"

for fs in $mountpoints ;
do
        if ! mountpoint -q "$fs" ; then
                echo "$fs not mounted";
                exit;
        fi
done

# Archive files older than $age days

age=45
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
    rsync -a --exclude NII/ --exclude .snapshot $a_dir/ $dest;
    ec=$?;
    if [ $ec -ne 0 ] ; then
        echo "*** problem with rsync from $a_dir to $dest: exit code = $ec - skipping delete" >> $logfile;
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
