import os, sys, subprocess, os.path
from os import path
import glob
import time

while True:
    linkFiles = glob.glob("../cache/*.link")
    for linkFile in linkFiles:
        print(linkFile)
        linkFilePathParts = linkFile.split("/")
        linkFileParts = linkFilePathParts[-1].split(".")
        print("linkFileParts: " + linkFileParts)
        file = open(linkFile)
        link = file.read()
        print(link)
        tempFileURL = linkFileParts[0] + "-temp.html"
        subprocess.call(["torsocks", "wget", "-O", tempFileURL, link])
        subprocess.call(["cp", tempFileURL, linkFileParts[0] + ".html"])
        subprocess.call(["rm", tempFileURL])
        subprocess.call(["rm", linkFile])
    time.sleep(60)
