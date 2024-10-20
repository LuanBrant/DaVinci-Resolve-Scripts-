# DaVinci-Resolve-Scripts-
Codes for DaVinci Resolve 

The subtitles2markers_v1.py script is designed to automate marker creation based on subtitle clips in DaVinci Resolve. It performs the following steps:

Initialize DaVinci Resolve and access the currently open project. Check for an active project and timeline; if none is found, it halts execution with an appropriate message. Retrieve subtitle tracks in the timeline and verify if any exist. Iterate through subtitle clips and add a marker at the start of each clip, linking it with the subtitle text. This script is particularly useful for organizing and quickly navigating through subtitles in video editing projects


The compound.py script automates the creation of a Compound Clip from video clips on track V1 of a timeline in DaVinci Resolve. It performs the following steps:

Initializes DaVinci Resolve and accesses the currently open project. If no active project or timeline is found, the script halts execution with an appropriate message.
Retrieves all video clips on track V1 of the timeline and checks if there are any clips on the track.
Calculates the start time of the first clip and the end time of the last clip on track V1.
Creates a Compound Clip in the Media Pool based on these start and end times, grouping all video clips from track V1.
Displays a success message upon creating the Compound Clip or an error message in case of failure.
This script is useful for streamlining the process of creating a Compound Clip, making it easier to manage complex edits involving multiple video clips in the timeline.


The subtitles2dmakers_v1.py script automates the creation of duration markers based on subtitle clips in DaVinci Resolve. It performs the following steps:

Initializes DaVinci Resolve and accesses the currently open project. If no active project or timeline is found, the script stops execution with an appropriate message.
Retrieves subtitle tracks from the timeline and checks if any exist. If no subtitle tracks are found, the script exits.
Iterates through each subtitle clip on the first subtitle track, obtaining the start time, end time, and subtitle text for each clip.
Searches for a video clip in track V1 that spans the same duration as the subtitle clip. If a matching clip is found, it retrieves the corresponding media pool item.
Calculates the exact frame position within the media pool item where the subtitle starts and ends based on the timeline’s frame rate.
Creates a duration marker in the media pool, marking the start and end of the subtitle, and associates the subtitle text with the marker.
This script is particularly useful for adding visual markers linked to subtitle text, helping editors easily navigate and manage subtitles in relation to video content in complex projects.
