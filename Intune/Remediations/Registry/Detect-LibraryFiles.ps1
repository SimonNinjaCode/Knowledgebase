# Define the registry parameters to check
$RegPath = "HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}" #
$RegName = "System.IsPinnedToNameSpaceTree" 
$ExpectedValue = "1" 

try {
    # Check if the registry path exists
    if (Test-Path -Path $RegPath) {
        # Check if the registry value exists
        $RegValue = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue
        
        if ($null -ne $RegValue) {
            # Check if the value matches expected value
            if ($RegValue.$RegName -eq $ExpectedValue) {
                Write-Output "Registry key found with the expected value."
                exit 0 # Compliant - Registry key exists with expected value
            }
            else {
                Write-Output "Registry key found but value doesn't match expected: $($RegValue.$RegName) vs $ExpectedValue"
                exit 1 # Non-compliant - Registry key exists but value is not as expected
            }
        }
        else {
            Write-Output "Registry path exists but value name '$RegName' not found."
            exit 1 # Non-compliant - Registry key doesn't exist
        }
    }
    else {
        Write-Output "Registry path '$RegPath' not found."
        exit 1 # Non-compliant - Registry path doesn't exist
    }
}
catch {
    Write-Error "An error occurred: $_"
    exit 1 # Non-compliant - An error occurred
}