Param
(
[string] $srcPath
)

#
# This script will increment the build number in an AssemblyInfo.cs file
#

#$SrcPath = "/Users/ral/documents/"

if ($srcPath -eq "") {
  Write-Host "É necessário informar um path para buscar os aquivos .vb ou .cs"
  EXIT
}

$AllVersionFiles = Get-ChildItem $SrcPath\* -Include AssemblyInfo.cs,AssemblyInfo.vb -recurse

foreach ($file in $AllVersionFiles)
{ 
    Write-Host "Modifying file " + $file.FullName
    #save the file for restore
    # $backFile = $file.FullName + "._ORI"
    # $tempFile = $file.FullName + ".tmp"
    # Copy-Item $file.FullName $backFile -Force
    # #now load all content of the original file and rewrite modified to the same file
    # Get-Content $file.FullName |
    # %{$_ -replace 'AssemblyVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', "AssemblyVersion(""$assemblyVersion"")" } |
    # %{$_ -replace 'AssemblyFileVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', "AssemblyFileVersion(""$fileAssemblyVersion"")" }  > $tempFile
    # Move-Item $tempFile $file.FullName -Force


    $assemblyInfoPath = $file.FullName #"/Users/ral/documents/AssemblyInfo.cs"
    
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


}

# $assemblyInfoPath = "/Users/ral/documents/AssemblyInfo.cs"

# $contents = [System.IO.File]::ReadAllText($assemblyInfoPath)

# $versionString = [RegEx]::Match($contents,"(AssemblyFileVersion\("")(?:\d+\.\d+\.\d+\.\d+)(""\))")
# Write-Host ("AssemblyFileVersion: " +$versionString)

# #Parse out the current build number from the AssemblyFileVersion
# #$currentBuild = [RegEx]::Match($versionString,"(\.)(\d+)(""\))").Groups[2]
# $currentBuild = [RegEx]::Match($versionString,"(\.)(\d+)(\.)(\d+)(\.)(\d+)").Groups[2]
# $currentMajorBuild = [RegEx]::Match($versionString,"(\d+)(\.)(\d+)(\.)(\d+)(\.)(\d+)").Groups[1]

# Write-Host ("Current Minor Build: " + $currentBuild.Value)
# Write-Host ("Current Major Build: " + $currentMajorBuild.Value)

# #Increment the build number
# $newBuild= [int]$currentBuild.Value +  1
# $newMajorBuild = [int]$currentMajorBuild.Value 
# if ($newBuild -lt 10) {
#   $newBuild = [string] "0" + $newBuild
# }
# if($newBuild -gt 99) {
#   $newBuild = [string] "01"
#   $newMajorBuild = $newMajorBuild + 1
# }

# Write-Host ("New Build: " + $newBuild)
# Write-Host ("New Major Build: " + $newMajorBuild)

# $newBuildVersion = [string] $newMajorBuild + "." + $newBuild
# Write-Host ("New Number Build: " + $newBuildVersion)


# $data = Get-Date -Format "ddMM.yy"
# Write-Host ("Data: " +$data)

# $newBuildVersion = [string] $newBuildVersion + "." + $data

# #update AssemblyFileVersion and AssemblyVersion, then write to file
# Write-Host ("Setting version in assembly info file ")
# #$contents = [RegEx]::Replace($contents, "(AssemblyVersion\(""\d+\.\d+\.\d+\.)(?:\d+)(""\))", ("`${1}" + $newBuild.ToString() + "`${2}"))
# #$contents = [RegEx]::Replace($contents, "(AssemblyFileVersion\(""\d+\.\d+\.\d+\.)(?:\d+)(""\))", ("`${1}" + $newBuild.ToString() + "`${2}"))

# $contents = [RegEx]::Replace($contents, "(AssemblyVersion\("")(?:\d+\.\d+\.\d+\.\d+)(""\))", ("`${1}" + $newBuildVersion.ToString() + "`${2}"))
# $contents = [RegEx]::Replace($contents, "(AssemblyFileVersion\("")(?:\d+\.\d+\.\d+\.\d+)(""\))", ("`${1}" + $newBuildVersion.ToString() + "`${2}"))

# [System.IO.File]::WriteAllText($assemblyInfoPath, $contents)

# $versionString = [RegEx]::Match($contents,"(AssemblyFileVersion\("")(?:\d+\.\d+\.\d+\.\d+)(""\))")

# Write-Host ("AssemblyFileVersion: " +$versionString)

