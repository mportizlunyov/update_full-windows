# Written by Mikhail P. Ortiz-Lunyov (mportizlunyov)
#
# Version 0.0.2 (December 1st, 2024)
#
# This script is licensed under the GNU Public License Version 3 (GPLv3).
# Compatible and tested with Windows 10 & 11.
#
#
# More information about license in README and bottom.
# Best practice is to limit writing permissions to this script in
#  order to avoid accidental or malicious tampering.
# Checking the hashes from the github can help to check for tampering.

# Get script flags
param (
  # Informational flags
  [Alias("h","help")]
  [Switch]$ShowHelp = $false,
  [Alias("v","version")]
  [Switch]$ShowVersion = $false,
  [Alias("c","conditions")]
  [Switch]$ShowConditions = $false,
  [Alias("w","warranty")]
  [Switch]$ShowWarranty = $false,
  [Alias("pp","privacy-policy")]
  [Switch]$ShowPrivacyPolicy = $false,
  # Functional Flags
  [Alias("cd","custom-domain")]
  [String]$CustomDomain = "N/A",
  [Alias("oo","official-only")]
  [Switch]$OfficialOnly = $false,
  [Alias("ao","alternative-only")]
  [Switch]$AlternativeOnly = $false
)

# Critical Variables
## Version
$VersionNumb = "0.0.2"
$VersionName = "December 1st 2024"
$VersionFull = "v$VersionNumb ($VersionName)"
## Package manager
### Official
$OfficialPackageManagerList = @('winget')
### Alternative
$AlternativePacakgemanagerList = @('choco')


# Exit statement
function Show-ExitStatement () {
  Write-Host ""
  Write-Host "`t* I hope this project was useful for you!"
  Write-Host "`t* Please give this project a star on GitHub"
  Write-Host "`t* https://github.com/mportizlunyov/update_full-windows"
}

# Display Methods
## Generic Information
function Write-Information ($InformationToWrite) {
  Write-Host "* $InformationToWrite"
}
## Errors/Warnings
function Write-Error ($ErrorToWrite, $Criticality) {
  switch ($Criticality) {
    0 { Write-Host "!!$ErrorToWrite" }
    1 { Write-Host "!!!$ErrorToWrite" }
    2 { Write-Host "!!! $ErrorToWrite !!!" }
  }
}
## Display seperator for display purposes
function Show-Seperator () {
  Write-Host " = = ="
}

# Error-managing method
function Confirm-Errors ($ErrorCode, $Desc1, $Desc2) {
  # Initialise variables
  $ExitErrorCode = 1
  # Create new line for displaying
  Write-Host ""
  # Display appropriate error message
  switch ($ErrorCode)
  {
    # Incompatible flags
    0 {
      Write-Error "-official-only & -alternative-only flags are incompatible!" 0
      Write-Error "-official-only: $Desc1" 0
      Write-Error "-alternative-only: $Desc2" 0
    }
    # No official package manager
    1 { Write-Error "No OFFICIAL package manager found!" 1 }
    # No alternative pacakge managers, -ao forced
    2 { Write-Error "No ALTERNATIVE package managers, -alternative-only/-ao flag FORCED" 1 }
    # Domain pinging failed
    3 {
      switch ($Desc1) {
        "raw.githubusercontent.com" { Write-Error "Connection to CheckSum repository FAILED!" 1 }
        Default { Write-Error "Connection to custom domain ($Desc1) Failed!" 0 }
      }
      Write-Error "Check internet connection" 0
    }
    # No defined error code
    Default {
      Write-Error "Error NOT found!" 0
      Write-Error "INTERNAL Script error" 2
      $ExitErrorCode = 404
    }
  }
  # Exit with $false error codes
  Show-ExitStatement
  exit $ExitErrorCode
}

# Informational Methods
## Help method
function Show-Help () {
  Show-Seperator
  Write-Host "This PowerShell script allows for full update of installed packages"
  Write-Host "  on a Windows system."
  Write-Host "This script uses two types of flags: Informational and Functional."
  Write-Host ""
  Write-Host "Informational:"
  Write-Host "`t--help/-h :  Displays this help message"
  Write-Host "`t--version/-v :  Displays the version of this script"
  Write-Host "`t--conditions/-c :  Shows the conditions related to the GPLv3 license"
  Write-Host "`t--warranty/-w :  Shows the warranty related to the GPLv3 license"
  Write-Host "`t--privacy-policy/-pp :  Shows this script's privacy policy"
  Write-Host "Functional:"
  Write-Host "`t--custom-domain/-cd :  Test connection another domain in addition to raw.githubusercontent.com"
  Write-Host "`t--official-only/-oo :  Only use official, built-on package managers"
  write-Host "`t--alternative-only/-ao :  Only use alternative package managers"
  Write-Host ""
  write-Host "To prevent tampering, change the EDIT permissions of this file."
  Write-Host "Additionally, verify this script with sha512 and sha256 checksums."
  Write-Host "For easiest use, execute this script from a PowerShell instance run as Admin."
}
## Version method
function Show-Version () {
  Show-Seperator
  Write-Host "Update_Full [Windows] $VersionFull"
}
## Condition method
function Show-Condition () {
  Show-Seperator
  Write-Host "If conditions are imposed on you (whether by court order, agreement or otherwise) that contradict the conditions of this"
  Write-Host "License, they do not excuse you from the conditions of this License. If you cannot convey a covered work so as to"
  Write-Host "satisfy simultaneously your obligations under this License and any other pertinent obligations, then as a consequence"
  Write-Host "you may not convey it at all. For example, if you agree to terms that obligate you to collect a royalty for further"
  Write-Host "conveying from those to whom you convey the Program, the only way you could satisfy both those terms and this"
  Write-Host "License would be to refrain entirely from conveying the Program."
}
## Warranty method
function Show-Warranty () {
  Show-Seperator
  Write-Host "THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW."
  Write-Host "EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES"
  Write-Host "PROVIDE THE PROGRAM ""AS IS"" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR"
  Write-Host "IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND"
  write-Host "FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE"
  Write-Host "OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE"
  Write-Host "COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION."
}
## Privacy policy method
function Show-PrivacyPolicy () {
  Show-Seperator
  Write-Host "THIS PROGRAM DOES NOT COLLECT ANY TELEMETRY OR USER DATA."
  Write-Host "THE ONLY TIME IN WHICH THIS PROGRAM CONNECTS TO THE INTERNET IS DURING"
  Write-Host "THE PING TEST (IN ORDER TO VERIFY CONNECTION TO THE INTERNET, CAN BE DISABLED)"
  Write-Host "AND WHILE UPDATING PACKAGES THROUGH THEIR RESPECTIVE PACKAGE MANAGERS."
  Write-Host "THE ONLY TIME THAT THIS SCRIPT ACCESSES THE USERS FILE SYSTEM IS WHEN MAKING"
  Write-Host "LOG FILES (WITH EXPRESS CONSENT FROM THE USER) AND WHEN CALLING UPON THE"
  Write-Host "VARIOUS PACKAGE MANAGERS THAT THE SCRIPT SUPPORTS TO UPDATE THEIR PACKAGES."
  Write-Host "THIS SCRIPT CAN ONLY CONTROL THE PACKAGE MANAGERS THROUGH THE"
  Write-Host "CONTROLS THEY PROVIDE TO THEIR USERS."
  Write-Host "ALL OF THESE STATEMENTS CAN BE VERIFIED, AS THIS SOFTWARE IS FREE & OPEN-SOURCE,"
  Write-Host "THUS MEANING THAT ANYBODY CAN READ THE SOURCE CODE AND VERIFY WHAT IT DOES."
}

# Ping domains
function Test-Domain ($Domain) {
  Write-Information "Ping-testing domain ($Domain)"
  try { ping -n 3 $Domain }
  catch { Confirm-Errors 3 $Domain "" }
}

# Flag filtering
function Resolve-Flags () {
  if ($OfficialOnly -eq $AlternativeOnly -and $OfficialOnly -eq $true) {
    Confirm-Errors 0 "$OfficialOnly" "$AlternativeOnly"
  }
}

# Package Manager methods
## Winget
function Update-Winget () {
  Write-Host ""
  Write-Host "`t* WinGet detected under $((Get-WmiObject -class Win32_OperatingSystem).Caption)"
  winget upgrade --all --accept-package-agreements
}

# Find package managers
## Official Package Managers
function Find-OfficialPkgManagers () {
  for ($i = 0; $i -lt $OfficialPackageManagerList.Length; $i++) {
    # Try/Catch block to check package managers
    try {
      Start-Process $OfficialPackageManagerList[$i] -ArgumentList "--help" -Wait
      switch ($i) {
        0 { Update-Winget ; break }
        Default { continue }
      }
    }
    catch {
      switch ($i) {
        ($OfficialPackageManagerList.Length-1) { Confirm-Errors 1 "" "" }
        Default { continue }
      }
    }
  }
}
## Alternative Package Managers
function Find-AlternativePkgManagers () {
  $AlternativeRan = $false
  for ($i = 0; $i -lt $AlternativePacakgemanagerList.Length; $i++) {
    # Try/Catch block to check package managers
    try {
      Start-Process $AlternativePacakgemanagerList[$i] -ArgumentList "--help" -Wait
      switch ($i) {
        0 { Update-Winget }
        Default { continue }
      }
    }
    catch { continue }
  }
  # Check if any alternative package managers were run and if -ao flag is run
  switch ($AlternativeRan) { $false { switch ($AlternativeOnly) { $true { Confirm-Errors 2 "" "" } } } }
}


# Pre-main section to check informational arguments
## Define value for exiting early
$ExitEarly = $false
switch ($ShowHelp) { $true { Show-Help ; $ExitEarly = $true } }
switch ($ShowVersion) { $true { Show-Version ; $ExitEarly = $true } }
switch ($ShowConditions) { $true { Show-Conditio ; $ExitEarly = $truen } }
switch ($ShowWarranty) { $true { Show-Warranty ; $ExitEarly = $true } }
switch ($ShowPrivacyPolicy) { $true { Show-PrivacyPolicy ; $ExitEarly = $true } }
switch ($ExitEarly) { $true { exit 0 } }

# Main
Clear-Host
## Resolve and act on flags
Resolve-Flags
## Initialise variables for description
$DescCD = ""
$DescManUsed = ""
### Fill description variables as needed
switch ($CustomDomain)
{
  "N/A" {}
  Default { $DescCD = "using custom domain ($CustomDomain)" }
}
if ($OfficialOnly -eq $true) {
  $DescManUsed = "using exclusively OFFICIAL pkg managers"
} elseif ($AlternativeOnly -eq $true) {
  $DescManUsed = "using exclusively ALTERNATIVE pkg managers"
}
$DescMain = "$DescCD$DescManUsed"
## Write description
Write-Information "Running Update_Full [Windows] v$VersionNumb script $DescMain"
Write-Information "Date and time is:`t$(Get-Date)"
## Ping-test domains
Test-Domain "raw.githubusercontent.com"
switch ($CustomDomain) {
  "N/A" {}
  Default { Test-Domain "$CustomDomain" }
}
## Begin running package manager
if ($OfficialOnly -eq $true) {
  Find-OfficialPkgManagers
} elseif ($AlternativeOnly -eq $true) {
  Find-AlternativePkgManagers
} else {
  Find-OfficialPkgManagers
  Find-AlternativePkgManagers
}
# Show Exit Statement before exiting
Show-ExitStatement
