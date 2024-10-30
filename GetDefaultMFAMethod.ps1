# Install the MSOnline module if not already installed
Install-Module -Name MSOnline -Force -AllowClobber

# Connect to MSOnline
Connect-MsolService

# Get all users and their MFA status
$users = Get-MsolUser -All

# Filter users and get their default MFA method
$defaultMfaMethods = foreach ($user in $users) {
    $mfaMethods = $user.StrongAuthenticationMethods
    if ($mfaMethods) {
        $defaultMethod = $mfaMethods | Where-Object { $_.IsDefault -eq $true }
        if ($defaultMethod) {
            [PSCustomObject]@{
                UserPrincipalName = $user.UserPrincipalName
                DisplayName       = $user.DisplayName
                DefaultMFAType    = $defaultMethod.MethodType
            }
        }
    }
}

# Output the results
$defaultMfaMethods | Select-Object UserPrincipalName, DisplayName, DefaultMFAType | Format-Table -AutoSize
