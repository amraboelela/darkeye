import os, sys, subprocess, os.path
from os import path
import glob
import time

while True:
    linkFiles = glob.glob("../cache/*.link")
    for linkFile in linkFiles:
        print(linkFile)
        file = open(linkFile)
        link = file.read()
        print(link)
        tempFileURL = linkFile.replace('.link','-temp.html') #linkFileParts[0] + "-temp.html"
        subprocess.call(["torsocks", "wget", "-O", tempFileURL, link])
        subprocess.call(["cp", tempFileURL, linkFile.replace('.link','.html')])
        subprocess.call(["rm", tempFileURL])
        subprocess.call(["rm", linkFile])
    time.sleep(60)
