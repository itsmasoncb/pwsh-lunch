
# Define OU Variables, Dot-Sourced to avoid OU structure being public.
. .\Grad-Variables.ps1
$cceeGradOU
$cbeGradOU

# Define List of Advisor OUs (professor, staff, etc.)
$cceeAdvisors = Get-ADOrganizationalUnit -Filter * -SearchBase $cceeGradOU | Select-Object -ExpandProperty Name | Out-String
$cbeAdvisors = Get-ADOrganizationalUnit -Filter * -SearchBase $cbeGradOU  | Select-Object -ExpandProperty Name | Out-String

# Ask user for CBE or CCEE User List
$UserInput = Read-Host "Which OU do you want to search Grad Students for? CBE or CCEE?"

# Action based on user input that iterates through each advisor and ouputs members of .Users and .Administrators of each group. It adds them to the $MemberList variable.
if ($UserInput -like "CCEE") {
    $MemberList = foreach ($Advisor in $cceeAdvisors.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)) {
        Get-ADGroupMember -Filter {Name -like '*\.Users' -or Name -like '*\.Administrators'} | Select-Object @{Name='Advisor';Expression={$Advisor}}, SamAccountName
    }    
}
elseif ($UserInput -like "CBE") {
    $MemberList = foreach ($Advisor in $cbeAdvisors.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)) {
        Get-ADGroupMember -Filter {Name -like '*\.Users' -or Name -like '*\.Administrators'} | Select-Object @{Name='Advisor';Expression={$Advisor}}, SamAccountName
    }    
}
else {
    Write-Host "Invalid OU entered. Please type CCEE or CBE."
    return
}

# This outputs the $MemberList to the PowerShell console AND exports the list a .csv to your desktop.
Write-Host $MemberList | Format-Table -AutoSize
$MemberList | Export-Csv "$env:USERPROFILE\Desktop\Users-$UserInput.csv" -NoTypeInformation
Read-Host "This output has also been saved to your Desktop as Users-$UserInput.csv for easier reading."