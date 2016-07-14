# igotugps

Code and description of how to extract all data off the Mobile Action Igotu GPS loggers (widely used in wildlife tracking)


> Get the most from your GPS tracking data!

__*Note*__ If using these scripts, please aknowledge the author (Tom Evans) and direct others to where this code is located.

*Downloading data from GPS devices and running R code to process this*

## 1. Downloading data from GPS device
### Install *igotu2gpx*

Download and install *igotu2gpx*: https://launchpad.net/igotu2gpx
  * If you have a Linux machine you can install this directly, otherwise:
  * In theory this will run on Windows and OSX. I didn’t manage to get it to work well on Windows, and I haven’t tried it on a Mac. My recommendation is to use it with Linux. If you do that you can either install [Ubuntu](http://www.ubuntu.com/) or similar on an old laptop/ PC, dual-boot, or install on a virtual machine. The last is what I have. I have [VirtualBox](https://www.virtualbox.org/) to run the virtual machine, then install Ubuntu/ Linux on that.

### Download data from a Mobile Action *igotu* GPS device
Download data from GPS tags using *igotu2gpx*. There is a graphical user interface (gui), but that doesn’t have as many options as the terminal commands. So I run *igotu2gpx* from the terminal using the following commands *(after having plugged in the USB download cable and attached a GPS logger)* to get a bunch of different information and files (examples of downloaded files are in the ‘guillemot_example.zip’ file):
  1. Download the raw GPS fix information. It’s in a bit of an odd format, but we can fix that (see below).
 ```sh
$ sudo igotu2gpx dump --format details > g31_details.txt
 ```
  2. Get all data off the tag. This is in some compressed format. Currently I don’t have a use for this file, but it feels good to have in case it can be useful in the future!
 ```sh
$ sudo igotu2gpx dump --format raw > g31_raw.txt
 ```
  3. Produces a GPX file, which can be viewed in Google Earth and various other programs.
 ```sh
$  sudo igotu2gpx dump --format gpx > g31_test.gpx
 ```
   4. Produces a **.kml* file, good for Google Earth.
 ```sh
$  sudo igotu2gpx dump --format kml > g31_test.kml
 ```
  5. Download the tag configuration data. I find this quite nice, as you can check then that the tag was configured as you thought. Or if you forget to note down how you configured the tag!
 ```sh
$   sudo igotu2gpx info > g31_config.txt
 ```


## 2. Convert the **_details.txt* file (from above) using *R*.
  * Have a look at the example file *g11_details.txt* (in the *zip* file *guillemot_example.zip*).
  * You can see that you get a bunch of information in addition to that you have with the *@trip* software. There is EHPE (estimated horizontal positional error), and also the id numbers of the satellites used, from which you can work out the number of satellites used for a fix. The file is in a funny format though, not immediately easy to use – so we need to convert it.
  * I have written a function for R that processes the *_details.txt file into a useful format. In the attached ‘R files’ see ‘parse_igotu2gpx_txt.R’. To work out how to use that see ‘parse_igotu2gpx_txt_example.R’.
  * If you are feeling ambitious then you can have a look at ‘parse_igotu2gpx_txt_to_db.R’ which is an R script wrote to process all the *_details.txt files in a directory and output them to a database table (MS Access in my case). This could be useful if you are collecting a lot of data from many birds, so want to efficiently extract all this data.

__Good luck!__

