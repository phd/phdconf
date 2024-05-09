#!/bin/bash -e

declare -a KEYS=(
'0686B78420038257'
'079FA39EE6A75D23'
'18763DBDC5B8CA84'
'2836CB0A8AC93F7A'
'3B22AB97AF1CDFA9'
'4EB27DB2A3B88B8B'
'54678CF75A278D9C'
'76F1A20FF987672F'
'83FBA1751378B444'
'869689FE09306074'
'86F7D09EE734E623'
'8AEB4F8B29D82806'
'8CADE14440A2D6D6'
'9352A0B69B72E6DF'
'9BDB3D89CE49EC21'
'A2F683C52980AECF'
'A8580BDC82D3DC6C'
'AD5F235DF639B041'
'C8CAB6595FDFF622'
'C93AF1698685AD8B'
'D29FBD5F93C0CFC3'
'D97A3AE911F63C51'
'EB3E94ADBE1229CF'
'F24AEA9FB05498B7'
'F6F9C5299263FB77'
'FCAE110B1118213C'
)

for key in "${KEYS[@]}"
do
    sudo apt-key del "${key}" 2>/dev/null
    sudo wget "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${key}" -O "/etc/apt/trusted.gpg.d/${key}.asc" --no-verbose
done
