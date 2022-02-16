# Load required libraries
import sys
import argparse
import cv2
import math
import os
import numpy as np

# Function to extract desired frames
def video2pic_py(pathIn, pathOut, fps):

    # # Testing
    # pathIn  = "/home/david/Schreibtisch/WhatsApp Video 2021-05-10.mp4"
    # pathOut = "/home/david/Schreibtisch/test"
    # fps     = 0.5

    # Identify original file name
    filename = os.path.basename(pathIn)
    filename = os.path.splitext(filename)[0]

    # Start video
    vidcap = cv2.VideoCapture(pathIn)

    # Get duration of the video in milliseconds
    frame = vidcap.get(cv2.CAP_PROP_FPS)
    count = vidcap.get(cv2.CAP_PROP_FRAME_COUNT)
    duration = count / frame * 1000

    # Read images
    success, image = vidcap.read()
    count          = 0
    success        = True

    # Extract frames
    while success:

        time = count * (1 / fps) * 1000
        if time > duration:
            break

        # Set video to location of the n-th frame
        vidcap.set(cv2.CAP_PROP_POS_MSEC, time)

        # Read that image
        success, image = vidcap.read()
        print ("Read a new frame: ", success)
        cv2.imwrite(pathOut + "/" + filename + "_Frame_%d.JPG" % count, image)
        count = count + 1

# # Function call
# if __name__ == "__main__":
#     print("aba")
#     a = argparse.ArgumentParser()
#     a.add_argument("--pathIn", help = "path to video")
#     a.add_argument("--pathOut", help = "path to images")
#     a.add_argument("--fps", help = "frames per second", type = int, default = 1)
#     args = a.parse_args()
#     print(args)
#     extractImages(args.pathIn, args.pathOut, args.fps)
