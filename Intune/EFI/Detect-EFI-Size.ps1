try {
    # 1. Get the EFI Partition using its specific GPT GUID
    # {c12a7328-f81f-11d2-ba4b-00a0c93ec93b} is the standard GUID for EFI System Partitions
    $efiPartition = Get-Partition | Where-Object { $_.GptType -eq '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}' } -ErrorAction Stop

    if ($efiPartition) {
        # 2. Convert the Size (Bytes) to Megabytes
        # [math]::Round is used to remove excessive decimal places
        $sizeMB = [math]::Round($efiPartition.Size / 1MB, 2)

        # 3. Return the value for Intune to capture
        Write-Output "EFI Size: $sizeMB MB"
        
        # 4. Exit 0 indicates 'Compliant' (Detection passed)
        # This ensures the script reports the value without triggering a remediation error
        Exit 0
    }
    else {
        # If no EFI partition is found (rare on modern PCs, but possible on Legacy BIOS)
        Write-Output "Error: No EFI Partition found."
        Exit 1
    }
}
catch {
    Write-Output "Error: $($_.Exception.Message)"
    Exit 1
}