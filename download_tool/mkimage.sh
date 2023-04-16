#!/bin/bash

function usage()
{
  echo "Usage: $0 file"
  echo "	file : the image which you want to burn "
  echo "Example: $0 helloworld.bin"
}



cur_user=`env | grep USER | cut -d "=" -f 2`
echo $cur_user
if [ $cur_user == "root" ]; then
	echo -e "\033[31mThe cur_user is $cur_user. Please run the script with a normal user.\033[0m"
	exit 1
fi 

if [ "$#" -ne 1 ]; then
  usage $0
  exit 1
fi




SYSTEM=`uname -s`
if [ $SYSTEM == "Linux" ]; then
    DCD_BUILDER=dcdgen.bin
    IMG_BUILDER=imgutil.bin
else
		exit 1
fi

if [ ! -x $DCD_BUILDER ]; then
	chmod +x $DCD_BUILDER
fi

if [ ! -x $IMG_BUILDER ]; then
	chmod +x $IMG_BUILDER
fi

./$DCD_BUILDER dcd.config dcd.bin
./$IMG_BUILDER --combine base_addr=0x80000000 ivt_offset=0x400 app_offset=0x8000 dcd_file=dcd.bin app_file=$1 ofile=sdk20-app.img image_entry_point=0x80008000


