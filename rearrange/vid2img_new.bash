#!/bin/bash
# Script to cut video into small clips and extract into images with high fps.
# Written by Qiong Wang, at University of Pennsylvania
# 06/07/2013
# Last Editted 04/18/2014

############## Modification part ################

# File Preporcessing Parameters
export MOVE=0                           # Whether to move files
export SORT=0                           # Whether to sort files
export VID_NUM=29                       # Number of videos in each folder

# Video Extraction Prameters
export EXTRACT=0                        # Whether to extract images
export RATE=1                           # Sample fps
export DURATION=225                     # Sample length
export N=9                              # Number of cameras
export EXTENSION=png                    # File extension format of extraction images

# The directory contains camera# subfolders
export GOPRO_PATH="/media/Qiong/shops_loop"
export EXTRACT_FILE=$GOPRO_PATH/long_vid_idx.txt
export KEYFRAME_FILE=$GOPRO_PATH/keyframes.txt

############## Modification end #################

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
#    rm -rf $GOPRO_PATH/images_raw
    mkdir $GOPRO_PATH/images
    for ((n=1;n<=$N;++n)) 
    do
        if [ $n -eq 8 ]
        then
            continue
        fi
        m=$(printf "%02d" $n)
        rm -rf $GOPRO_PATH/images/camera$m
        mkdir $GOPRO_PATH/images/camera$m
        ffmpeg -i "$GOPRO_PATH/video_raw/video_$m.MP4" -f image2 -t $DURATION -r $RATE "$GOPRO_PATH/images/camera$m/camera$m""_%5d.$EXTENSION"
    done
fi

# mkdir $GOPRO_PATH/raw
for ((n=1;n<=$N;++n))
do 
    if [ $n -eq 8 ]
    then
        continue
    fi
    m=$(printf "%02d" $n)
    cp $GOPRO_PATH/images/camera$m/*.$EXTENSION $GOPRO_PATH/raw/
done

:<< '--COMMENT--'
rm -rf $GOPRO_PATH/raw_keyframes
mkdir $GOPRO_PATH/raw_keyframes
while read line
do
    echo "Processing image""_00$line.$EXTENSION..."  
    cp $GOPRO_PATH/raw/*_00$line.$EXTENSION $GOPRO_PATH/raw_keyframes/
done < $KEYFRAME_FILE
--COMMENT--
