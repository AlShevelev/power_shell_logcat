# PowerShell logcat script

This is a wrapper over the android logcat that allows you to view logs by process name (by default, it is as same as a package name of an application).  

## List of keys
**help, -help, --help, ?, -? or --?**  
Show the guidance  

**--id=[process name]**  
Set the process for which the log is shown (this is a mandatory key)  

**--file=[file name]**  
Redirect output to a file  

**--filter=[logcat filter value]**  
Restrict output by logcat filter. Possible values are: 'V', 'D', 'I', 'W', 'E', 'F' (see logcat guidance for details)  

**--tag=[tag value]**  
Restrict output by tag (see logcat guidance for details)  

## How to use it
Here are several examples how to use this script.  
./log --help  
./log --id=com.shevelev.some_app  
./log --id=com.shevelev.some_app --filter=D  
./log --id=com.shevelev.some_app --filter=D --tag=LOCATION  
./log --id=com.shevelev.some_app --file=d:\temp\1.log  

## My contacts

Have questions? - contact me via Github tools or email me to **al.e.shevelev@gmail com** .
