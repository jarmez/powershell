Get-WMIObject -class Win32_UserProfile | Where-Object {
    (!$_.Special) -and ($_.ConvertToDateTime($_.LastUseTime) -lt (Get-Date).AddDays(-7))
} 
| Remove-WmiObject