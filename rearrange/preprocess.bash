#!/bin/bash
# Script to cut video into small clips and extract into images with high fps.
# Written by Qiong Wang, at University of Pennsylvania
# 04/12/2013

############## Modification part ################

# Video Extraction Prameters
export EXTRACT=0                        # Whether to extract images
export RATE=0.1                         # Sample fps
export DURATION=150                     # Sample length
export N=10                             # Number of cameras
export EXTENSION=png                    # File extension format of extraction images
export START_INDEX=23                   # The start index for video sequence
export MAX_FRAME=3375                   # The last frame index in the sequence

# The directory contains camera# subfolders
export GOPRO_PATH="/media/Qiong/shops_loop/"
export EXTRACT_FILE=$GOPRO_PATH/offset.txt

############## Modification end #################

# Extract from full rate sequence at 1 fps
rm -rf $GOPRO_PATH/raw
mkdir $GOPRO_PATH/raw

# for ((i=1;i<=$N;++i))
# do
    i=8
    m=$(printf "%02d" $i)
    mkdir $GOPRO_PATH/images/camera$m
    idx=$START_INDEX
    nidx=1
    if [ $i -eq 2 ]
    then
        idx=$(( $idx - 1 ))
    fi
    while [ $idx -le $MAX_FRAME ]
    do
        index=$(printf "%05d" $idx)
        nindex=$(printf "%05d" $nidx)
        cp "$GOPRO_PATH/images_raw/camera$m/camera$m""_$index.$EXTENSION" "$GOPRO_PATH/images/camera$m/camera$m""_$nindex.$EXTENSION"
        idx=$(( $idx + 15 ))
        nidx=$(( $nidx + 1 ))
    done
# done
    
    
:<< '--COMMENT--'
# Preprocess the videos
if [ "$MOVE" = 1 ]
then
    for ((i=1;i<=$N;++i))
    do 
        m=$(printf "%02d" $i)
        mkdir $GOPRO_PATH/camera$m/video_raw$m
        mv $GOPRO_PATH/camera$m/*.MP4 $GOPRO_PATH/camera$m/video_raw$m
    done
fi

# Reagrrange the folders
if [ "$SORT" = 1 ]
then
    for ((i=1;i<=$N;++i))
    do
        m=$(printf "%02d" $i)
        cd $GOPRO_PATH/camera$m/video_raw$m
        ls *.MP4 > videos.txt
        cd ../..
        count=0
        while read line
        do
            let "++count"
            echo "Processing video $count for camera$m..."
            Count=$(printf "%03d" $count)
            mv $GOPRO_PATH/camera$m/video_raw$m/$line "$GOPRO_PATH/camera$m/video_raw$m/camera$m""_video$Count.MP4"
        done < $GOPRO_PATH/camera$m/video_raw$m/videos.txt
    done
fi


# Extract images from video for rectification
if [ "$EXTRACT" = 1 ]
then
    for ((n=1;n<=$N;++n)) 
    do
        m=$(printf "%02d" $n)
        rm -rf $GOPRO_PATH/camera$m/images_raw$m
        mkdir $GOPRO_PATH/camera$m/images_raw$m
        count=0
        for ((i=1;i<=$VID_NUM;++i))
        do
            j=$(printf "%03d" $i)
            echo "Processing video $j for camera$m..."
            if [ $i -eq 24 -o $i -eq 26 ]
            then
                rm -rf temp.txt
                if [ $i -eq 24 ]
                then
#                    export RATE=0.1
                    ffmpeg -ss 00:00:10 -t $DURATION -i "$GOPRO_PATH/camera$m/video_raw$m/camera$m""_video$j.MP4" -f image2 -r $RATE "$GOPRO_PATH/camera$m/images_raw$m/temp_""%05d.$EXTENSION"
                else
                    export RATE=0.2
                    ffmpeg -ss 00:00:10 -i "$GOPRO_PATH/camera$m/video_raw$m/camera$m""_video$j.MP4" -f image2 -r $RATE "$GOPRO_PATH/camera$m/images_raw$m/temp_""%05d.$EXTENSION"
                fi
                cd $GOPRO_PATH/camera$m/images_raw$m
                ls temp*.$EXTENSION > temp.txt
                cd ../..
                while read line
                do
                    let "++count"
                    echo "Processing video $count for camera$m..."
                    echo "file is $line"
                    Count=$(printf "%05d" $count)
                    mv $GOPRO_PATH/camera$m/images_raw$m/$line "$GOPRO_PATH/camera$m/images_raw$m/camera$m""_$Count.$EXTENSION"
                done < $GOPRO_PATH/camera$m/images_raw$m/temp.txt
            else
                let "++count"
                Count=$(printf "%05d" $count)
                ffmpeg -ss 00:00:00.500 -t 1 -i "$GOPRO_PATH/camera$m/video_raw$m/camera$m""_video$j.MP4" -f image2 -r 1 "$GOPRO_PATH/camera$m/images_raw$m/camera$m""_$Count.$EXTENSION"
            fi
        done
  done
fi

mkdir $GOPRO_PATH/raw
for ((n=1;n<=$N;++n))
do 
    m=$(printf "%02d" $n)
    cp $GOPRO_PATH/camera$m/images_raw$m/*.$EXTENSION $GOPRO_PATH/raw/
done

rm -rf $GOPRO_PATH/raw_keyframes
mkdir $GOPRO_PATH/raw_keyframes
while read line
do
    echo "Processing image""_00$line.$EXTENSION..."  
    cp $GOPRO_PATH/raw/*_00$line.$EXTENSION $GOPRO_PATH/raw_keyframes/
done < $KEYFRAME_FILE
--COMMENT--
cp $GOPRO_PATH/images/camera$m/*.$EXTENSION $GOPRO_PATH/raw/
