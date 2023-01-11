#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "ERROR: Provide exactly one directory argument."
    exit 1
fi

for file in $(find $1 -type f -perm 755)
do
    bad=1
    while [ $bad -eq 1 ]
    do
        read -p "Change perms of $file from 755 to 744? [Y/n] " result
        bad=0

        case $result in 
            [Yy] | [Yy][Ee][Ss] )
                chmod 744 "$file"
                echo "INFO: Changed perms of file $file from 755 to 744"
                ;;
            [Nn] | [Nn][Oo] )
                echo "INFO: Did not change perms from 755 for file $file"
                ;;
            * )
                echo "ERROR: Invalid choice."
                bad=1
                ;;
        esac
    done
done

