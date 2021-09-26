#!/usr/bin/env bash
# FFsilencer - a Bash script by Kyle Anthony Williams
# Use FFmpeg to quickly remove the silent portions of any video.

USAGE="
usage: ffsilencer IN OUT [THRESH] [DURATION]

Use FFmpeg to quickly remove the silent portions of any video.

positional arguments:
 IN          path to input file
 OUT         path to output file
optional arguments:
 THRESH      how loud the audio needs to be before it's cut out (default: -50dB)
 DURATION    how long the silnece needs to be in order to be cut out (default: 1 second)
"

if [ $# -eq 0 ]; then
    printf "$USAGE"
    exit 1
fi

# Recreate temporary filter complex
rm -f /tmp/filter_complex.ff
touch /tmp/filter_complex.ff

# Argument parsing
IN=$1
OUT=$2
THRESH=${3:-50dB}
DURATION=${4:-1}

# Parse silence end and length timestamps from audio of video
# Thanks Donald Feury!
# https://blog.feurious.com/automatically-trim-silence-from-video-with-ffmpeg-and-python
UNSEPARATED_TIMESTAMPS=$(ffmpeg -hide_banner -vn -i "$IN" -af "silencedetect=noise=${THRESH}:duration=${DURATION},ametadata=mode=print:file=-" -f null - | \
	grep -e end -e duration | \
	# Concatenate every two lines
	# lafvi metadata key-value pairs are separated with '='
	# Thanks, Dimitre Radoulov for the neat awk trick!
	# https://stackoverflow.com/a/3196948
	awk --field-separator='=' '!(NR%2){print end " " $2 }{end=$2}')

# Create FFmpeg filter complex through looping through timestamps
# Thanks shawnblais and Hashim Aziz!
# https://superuser.com/questions/681885/how-can-i-remove-multiple-segments-from-a-video-using-ffmpeg/1498811#1498811
i=0
pairs=()
current_time=0
while read -r line; do
	let i+=1

	# Separate silence end and silence length
	array=($line)
	end=${array[0]}
	length=${array[1]}

    # Get start of silence
	start=$(awk "BEGIN { printf $end - $length }")

	# Append filter context with new trim filters
	echo "[0:v]trim=start=$current_time:end=$start,setpts=PTS-STARTPTS,format=yuv420p[${i}v];[0:a]atrim=start=$current_time:end=$start,asetpts=PTS-STARTPTS[${i}a];" >> /tmp/filter_complex.ff
	pairs+=("[${i}v]" "[${i}a]")
	current_time=$end
done <<< $UNSEPARATED_TIMESTAMPS

# Combine all of our generated A/V pairs
pairs_str=$(printf '%s' "${pairs[@]}")

# Append concatenation line
echo "${pairs_str}concat=n=$i:v=1:a=1[outv][outa]" >> /tmp/filter_complex.ff

# Apply filter complex to input
ffmpeg -hide_banner -i "$IN" -filter_complex_script /tmp/filter_complex.ff -map [outv] -map [outa] "$OUT"
