<#
This is a wrapper over the android logcat that allows you to view logs by process name (by default, it is as same as a package name of an application).
(c) Alexander Shevelev (al.e.shevelev@gmail.com)
11-nov-2020
#>

<# 
 Errors visualization
#> 
function Show-Error {
	param($errorText)
	write-host $errorText -ForegroundColor Red
}

<# 
 Normal text visualization
#> 
function Show-Text {
	param($normalText)
	write-host $normalText
}

<# 
 Warnings visualization
#> 
function Show-Selected {
	param($selectedText)
	write-host $selectedText -ForegroundColor Yellow
}

<# 
 Provides help
#> 
function Show-Help {
	Show-Text("This is a wrapper over the android logcat that allows you to view logs by process name (by default, it is as same as a package name of an application).")
	Show-Text("(c) Alexander Shevelev (al.e.shevelev@gmail.com)")
    Show-Text("11-nov-2020")
	
	Show-Text("")
	Show-Text("")	
	
	Show-Selected("KEYS")
	Show-Text("")
	Show-Selected("help, -help, --help, ?, -? or --?")
	Show-Text "Show this guidance"
	
    Show-Text("")
	Show-Selected("--id=[process name]")
	Show-Text "Set the process for which the log is shown (this is a mandatory key)"

    Show-Text("")
	Show-Selected("--file=[file name]")
	Show-Text "Redirect output to a file"
	
	Show-Text("")
	Show-Selected("--filter=[logcat filter value]")
	Show-Text "Restrict output by logcat filter. Possible values are: 'V', 'D', 'I', 'W', 'E', 'F' (see logcat guidance for details)"

	Show-Text("")
	Show-Selected("--tag=[tag value]")
	Show-Text "Restrict output by tag (see logcat guidance for details)"
	
	Show-Text("")
	Show-Text("")

	Show-Selected("HOW TO USE IT")
	Show-Text("./log --help")
	Show-Text("./log --id=com.shevelev.some_app")
	Show-Text("./log --id=com.shevelev.some_app --filter=D")
	Show-Text("./log --id=com.shevelev.some_app --filter=D --tag=LOCATION")
	Show-Text("./log --id=com.shevelev.some_app --file=d:\temp\1.log")
}

$needHelp = $false
$invalidArg = $false
$argId = ''
$argFile = ''
$argFilter = ''
$argTag = ''

<#
 The arguments collection
#>
for($i = 0; $i -lt $args.count; $i++ ) {
	$currentArg = $args[$i]

	if($currentArg -match "^-{0,2}help$" -or $currentArg -match "^-{0,2}\?$	") {
		$needHelp = $true	
		continue
	}
	
	if($currentArg -match '^--id=.+$') {
		$argId = $currentArg
		continue
	}
	
	if($currentArg -match '^--file=.+$') {
		$argFile = $currentArg
		continue
	}
	
	if($currentArg -match '^--filter=.+$') {
		$argFilter = $currentArg
		continue
	}
	
	if($currentArg -match '^--tag=.+$') {
		$argTag = $currentArg
		continue
	}
	
	$invalidArg = $true
}

<#
 The argument values extraction
#>
$argIdValue = $argId.replace('--id=', '')
$argFileValue = $argFile.replace('--file=', '')
$argFilterValue = $argFilter.replace('--filter=', '')
$argTagValue = $argTag.replace('--tag=', '')

<# 
 The arguments validation
#> 
if($needHelp) {
	Show-Help
	exit
}

if($argId -eq '') {
	Show-Error("Argument 'id' is mandatory and can't be skipped")
	Show-Help
	exit
}

if(-not ('', 'V', 'D', 'I', 'W', 'E', 'F').contains($argFilterValue)) {
	Show-Error("Argument 'filter' has an invalid value")
	Show-Help
	exit
}

if($invalidArg) {
    Show-Error("Some argument is invalid")
	Show-Help
	exit
}

<#
 A call contruction
#>
$processIdStr = (./adb shell pidof $argIdValue) | Out-String
if($processIdStr -eq '') {
	Show-Selected("Process not found")
	exit
}

$processId = $processIdStr -as [int]

$fileKey = ''
$colorKey = '-v color'
if($argFileValue -ne '') {
	Show-Selected("Writing to file: $argFileValue")
	$fileKey = "> $argFileValue"
	$colorKey = ''
}

$filterKey = 'V'
if($argFilterValue -ne '') {
	$filterKey = $argFilterValue
}

$tagAndFilterKey = "*:${filterKey}"
if($argTagValue -ne '') {
	$tagAndFilterKey = "${argTagValue}:${filterKey} *:S"
}

iex "./adb logcat --pid=$processId $tagAndFilterKey $colorKey $fileKey"