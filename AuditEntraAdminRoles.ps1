# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD (you'll be prompted to log in)
Connect-AzureAD

# Define the roles you want to search for
$targetRoles = @("Application Administrator", "Authentication Administrator", "Billing Administrator", "Cloud Application Administrator", "Conditional Access Administrator", "Exchange Administrator", "Global Administrator", "Global Reader", "Helpdesk administrator", "Password administrator", "Privileged Authentication Administrator", "Privileged Role Administrator", "Security administrator", "SharePoint administrator", "User administrator") # Add or modify roles as needed

# Retrieve all roles in Azure AD
$allRoles = Get-AzureADDirectoryRole

# Filter roles to match the target roles
$filteredRoles = $allRoles | Where-Object { $targetRoles -contains $_.DisplayName }

# Initialize an array to store results
$usersWithRoles = @()

# Loop through each filtered role and get assigned users
foreach ($role in $filteredRoles) {
    Write-Host "Processing role: $($role.DisplayName)"
    $roleMembers = Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId
    foreach ($member in $roleMembers) {
        $usersWithRoles += [PSCustomObject]@{
            RoleName = $role.DisplayName
            UserName = $member.UserPrincipalName
            DisplayName = $member.DisplayName
        }
    }
}

# Output the results
if ($usersWithRoles.Count -gt 0) {
    Write-Host "Users with specified roles:"
    $usersWithRoles | Format-Table -AutoSize
} else {
    Write-Host "No users found with the specified roles."
}

# Export the results to a CSV file
$usersWithRoles | Export-Csv -Path "UsersWithRoles.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Results exported to UsersWithRoles.csv"