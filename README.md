# DaVinci-Resolve-Scripts-
Codes for DaVinci Resolve 

The subtitles2markers_v1.lua script is designed to automate marker creation based on subtitle clips in DaVinci Resolve. It performs the following steps:

Initialize DaVinci Resolve and access the currently open project.
Check for an active project and timeline; if none is found, it halts execution with an appropriate message.
Retrieve subtitle tracks in the timeline and verify if any exist.
Iterate through subtitle clips and add a marker at the start of each clip, linking it with the subtitle text.
This script is particularly useful for organizing and quickly navigating through subtitles in video editing projects.

