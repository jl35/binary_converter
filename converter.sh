#/bin/bash

# ansi "0x00:0 0x01:1 0x02:2 0x03:3 0x04:4 0x05:5 0x06:6 0x07:7 0x08:8 0x09:9
# 0x0a:a 0x0b:b 0x0c:c 0x0d:d 0x0e:e 0x0f:f 0x10:g 0x11:h 0x12:i 0x13:j 
# 0x14:k 0x15:l 0x16:m 0x17:n 0x18:o 0x19:p 0x1a:q 0x1b:r 0x1c:s 0x1d:t 
# 0x1e:u 0x1f:v 0x20:w 0x21:x 0x22:y 0x23:z
# 0x24:A 0x25:B 0x26:C 0x27:D 0x28:E 0x29:F 0x2a:G 0x2b:H 0x2c:I 0x2d:J 
# 0x2e:K 0x2f:L 0x30:M 0x31:N 0x32:O 0x33:P 0x34:Q 0x35:R 0x36:S 0x37:T 
# 0x38:U 0x39:V 0x3a:W 0x3b:X 0x3c:Y 0x3d:Z
# 0x3e:. 0x3f:, 0x40:? 0x41:! 0x42:/ 0x43:- 0x44:+ 0x45:= 0x46:* 0x47::
# 0x48:% 0x49:< 0x4a:> 0x4b:\ 0x4c:( 0x4d:) 0x4e:[ 0x4f:] 0x50:{ 0x51:} 
# 0x52:# 0x53:; 0x54:' 0x55:\" 0x56:^ 0x57:$ 0x58:& 0x59:_ 0x5a:@
# 0x5b:` 0x5c:~ 0x5d:| 0x5e:\s 0x5d:\n"


if [[ ! -n "${1}" ]]; then
  path=`readlink -f "."`
else
  path=`readlink -f "${1}"`
fi

convert () 
{

  bits=128
  abspath=`readlink -f "${1}"`
  echo "${abspath}"
  filename=`echo "${0}" | sed "s/^\.\///"`
  

  for i in $(ls -p "${abspath}" | grep -v / | grep -v "${filename}" | grep -Ev "(\.bin|\.hex)$")
  do
    
    filename="${i}"

    if [[ ! -e "${abspath}/${filename}.hex" || ! -e "${abspath}/${filename}.bin" ]]; then
      echo "..processing ${abspath}/${filename}"
      touch "${abspath}/${filename}.hex"
      touch "${abspath}/${filename}.bin"
    

      sed -z '
      s/0/00000000/g;s/1/00000001/g;s/2/00000002/g;s/3/00000003/g;s/4/00000004/g;s/5/00000005/g;s/6/00000006/g;s/7/00000007/g;s/8/00000008/g;s/9/00000009/g;
      s/a/0000000a/g;s/b/0000000b/g;s/c/0000000c/g;s/d/0000000d/g;s/\e/0000000e/g;s/f/0000000f/g;
      s/g/00000010/g;s/h/00000011/g;s/i/00000012/g;s/j/00000013/g;s/k/00000014/g;s/l/00000015/g;s/m/00000016/g;s/n/00000017/g;s/o/00000018/g;s/p/00000019/g;
      s/q/0000001a/g;s/r/0000001b/g;s/s/0000001c/g;s/t/0000001d/g;s/u/0000001e/g;s/v/0000001f/g;
      s/w/00000020/g;s/x/00000021/g;s/y/00000022/g;s/z/00000023/g;s/A/00000024/g;s/B/00000025/g;s/C/00000026/g;s/D/00000027/g;s/E/00000028/g;s/F/00000029/g;
      s/G/0000002a/g;s/H/0000002b/g;s/I/0000002c/g;s/J/0000002d/g;s/K/0000002e/g;s/L/0000002f/g;
      s/M/00000030/g;s/N/00000031/g;s/O/00000032/g;s/P/00000033/g;s/Q/00000034/g;s/R/00000035/g;s/S/00000036/g;s/T/00000037/g;s/U/00000038/g;s/V/00000039/g;
      s/W/0000003a/g;s/X/0000003b/g;s/Y/0000003c/g;s/Z/0000003d/g;s/\./0000003e/g;s/\,/0000003f/g;
      s/\?/00000040/g;s/\!/00000041/g;s/\//00000042/g;s/\-/00000043/g;s/\+/00000044/g;s/\=/00000045/g;s/\*/00000046/g;s/\:/00000047/g;s/\%/00000048/g;s/</00000049/g;
      s/>/0000004a/g;s/\\/0000004b/g;s/(/0000004c/g;s/)/0000004d/g;s/\[/0000004e/g;s/\]/0000004f/g;
      s/{/00000050/g;s/}/00000051/g;s/\#/00000052/g;s/\;/00000053/g;s/\x27/00000054/g;s/\"/00000055/g;s/\^/00000056/g;s/\$/00000057/g;s/\&/00000058/g;s/\_/00000059/g;
      s/\@/0000005a/g;s/`/0000005b/g;s/\~/0000005c/g;s/|/0000005d/g;s/\x20/0000005e/g;s/\n/0000005f/g;
      ' "${abspath}/$filename" | sed -z 's/[[:blank:]]/  /g' | tr -d '[:blank:]' | sed -zE 's/[0-9a-f]{128}/\0\n/g' | sed -zE 's/[0-9a-f]{8}/\0 /g' | sed 's/^/ /g' > "${abspath}/${filename}.hex"


      IN=`cat "${abspath}/${filename}.hex"`



      while IFS=' ' read -ra ADDR; do
        for i in "${ADDR[@]}"; do
          num=`echo "obase=2;ibase=16; ${i^^}" | bc`
          test=`echo ${num} | wc -m`
          a=$(($bits - $((test-1))))
          for ((c=$a;c>0;--c)) do
              num="0${num}"
          done
          
          echo $num >> "${abspath}/${filename}.bin"

        done
      done <<< "$IN"
    else

      echo "converted files exists.. skip"
      continue
      
    fi

  done

  if [[ ! -n "${2}" ]]; then
    for i in `ls -p "${abspath}" | grep /`
    do
      
      convert "${abspath}/${i}"
    done
  
  fi

}

convert "${path}" 0

for i in `ls -p ${path} | grep /`
do
  convert `readlink -f "${path}/${i}"`
done








