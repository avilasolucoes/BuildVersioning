#
# This script will increment the build number in an AssemblyInfo.cs file
#

$assemblyInfoPath = "/Users/ral/documents/AssemblyInfo.vb"

$contents = [System.IO.File]::ReadAllText($assemblyInfoPath)

$versionString = [RegEx]::Match($contents,"(AssemblyFileVersion\("")(?:\d+\.\d+\.\d+\.\d+)(""\))")
Write-Host ("AssemblyFileVersion: " +$versionString)

#Parse out the current build number from the AssemblyFileVersion
#$currentBuild = [RegEx]::Match($versionString,"(\.)(\d+)(""\))").Groups[2]
$currentBuild = [RegEx]::Match($versionString,"(\.)(\d+)(\.)(\d+)(\.)(\d+)").Groups[2]
$currentMajorBuild = [RegEx]::Match($versionString,"(\d+)(\.)(\d+)(\.)(\d+)(\.)(\d+)").Groups[1]

Write-Host ("Current Minor Build: " + $currentBuild.Value)
Write-Host ("Current Major Build: " + $currentMajorBuild.Value)

#Increment the build number
$newBuild= [int]$currentBuild.Value +  1
$newMajorBuild = [int]$currentMajorBuild.Value 
if ($newBuild -lt 10) {
  $newBuild = [string] "0" + $newBuild
}
if($newBuild -gt 99) {
  $newBuild = [string] "01"
  $newMajorBuild = $newMajorBuild + 1
}

Write-Host ("New Build: " + $newBuild)
Write-Host ("New Major Build: " + $newMajorBuild)

$newBuildVersion = [string] $newMajorBuild + "." + $newBuild
Write-Host ("New Number Build: " + $newBuildVersion)


$data = Get-Date -Format "ddMM.yy"
Write-Host ("Data: " +$data)

$newBuildVersion = [string] $newBuildVersion + "." + $data

#update AssemblyFileVersion and AssemblyVersion, then write to file
Write-Host ("Setting version in assembly info file ")
#$contents = [RegEx]::Replace($contents, "(AssemblyVersion\(""\d+\.\d+\.\d+\.)(?:\d+)(""\))", ("`${1}" + $newBuild.ToString() + "`${2}"))
#$contents = [RegEx]::Replace($contents, "(AssemblyFileVersion\(""\d+\.\d+\.\d+\.)(?:\d+)(""\))", ("`${1}" + $newBuild.ToString() + "`${2}"))

$contents = [RegEx]::Replace($contents, "(AssemblyVersion\("")(?:\d+\.\d+\.\d+\.\d+)(""\))", ("`${1}" + $newBuildVersion.ToString() + "`${2}"))
$contents = [RegEx]::Replace($contents, "(AssemblyFileVersion\("")(?:\d+\.\d+\.\d+\.\d+)(""\))", ("`${1}" + $newBuildVersion.ToString() + "`${2}"))

[System.IO.File]::WriteAllText($assemblyInfoPath, $contents)

$versionString = [RegEx]::Match($contents,"(AssemblyFileVersion\("")(?:\d+\.\d+\.\d+\.\d+)(""\))")

Write-Host ("AssemblyFileVersion: " +$versionString)

