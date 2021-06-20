#!/usr/bin/env bash
rm -f /tmp/filter_complex.ff
touch /tmp/filter_complex.ff

IN=$1
OUT=$2
THRESH=$3
DURATION=$4

UNPARSED_TIMESTAMPS=$(ffmpeg -hide_banner -vn -i $IN -af "silencedetect=n=${THRESH}dB:d=${DURATION}" -f null - 2>&1 | \
	grep "silence_end" | \
	awk '{print $5 " " $8}')

i=0
pairs=()
current_time=0
while read -r line; do
	let i+=1
	array=($line)
	end=${array[0]}
	length=${array[1]}
	# Replace with this: https://www.shell-tips.com/bash/math-arithmetic-calculation/#using-the-printf-builtin-command
	start=$(node -p "$end - $length") # Can be replaced with any floating point calculator
	# Try this: https://superuser.com/a/1498811
	echo "[0:v]trim=start=$current_time:end=$start,setpts=PTS-STARTPTS,format=yuv420p[${i}v];[0:a]atrim=start=$current_time:end=$start,asetpts=PTS-STARTPTS[${i}a];" >> /tmp/filter_complex.ff
	pairs+=("[${i}v]" "[${i}a]")
	current_time=$end
done <<< $UNPARSED_TIMESTAMPS

pairs_str=$(printf '%s' "${pairs[@]}")

echo "${pairs_str}concat=n=$i:v=1:a=1[outv][outa]" >> /tmp/filter_complex.ff

ffmpeg -v verbose -hide_banner -i $IN -filter_complex_script /tmp/filter_complex.ff -map [outv] -map [outa] $OUT
