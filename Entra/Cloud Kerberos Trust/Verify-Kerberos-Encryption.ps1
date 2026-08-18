<#
.Synopsis
   Turns the integer stored in msDS-SupportedEncryptionTypes into a human readable value
.DESCRIPTION
   Turns the integer stored in msDS-SupportedEncryptionTypes into a human readable value
   For more info on the encryption types: https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/decrypting-the-selection-of-supported-kerberos-encryption-types/ba-p/1628797
.EXAMPLE
   Get-ETypeDefiniton 7
.PARAMETER msDSSupportedEncryptionTypes
    Returns an array of results indicating the supported encryption types
.PARAMETER AsString
    Returns the result as a comma delimited string
#>
function Get-ETypeDefinition
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $msDSSupportedEncryptionTypes,
        [switch] $AsString
    )
    Begin
    {
        $ETypes = [HASHTABLE]@{
            0 = 'Not defined - defaults to RC4_HMAC_MD5'
            1 = 'DES_CBC_CRC'
            2 = 'DES_CBC_MD5'
            4 = 'RC4'
            8 = 'AES 128'
            16 = 'AES 256'
        }
    }
    Process
    {
        $Types = $ETypes.keys | %{
            If([int]($msDSSupportedEncryptionTypes -band [int]$_) -ne 0){
                $ETypes[[int]$_]
            }
        }
        If($AsString){
            $Types -join(',')
        }Else{
            $Types
        }
    }
    End
    {
    }
}

$Computers = (Get-ADComputer -Filter * -Properties msDS-SupportedEncryptionTypes)
$Computers | `
select name,'msDS-SupportedEncryptionTypes', @{N='EncryptionTypes';E={Get-ETypeDefinition -msDSSupportedEncryptionTypes ($_.'msDS-SupportedEncryptionTypes')}}, @{N='EncryptionTypesAsString';E={Get-ETypeDefinition -msDSSupportedEncryptionTypes ($_.'msDS-SupportedEncryptionTypes') -AsString}} | `
select name,EncryptionTypes