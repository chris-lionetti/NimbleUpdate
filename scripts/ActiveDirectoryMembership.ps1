# ActiveDirectoryMembership.ps1: This is part of Nimble Group Management SDK.
#
# © Copyright 2023 Hewlett Packard Enterprise Development LP.

function New-NSActiveDirectoryMembership {
<#
.SYNOPSIS
  Joins with the Active Directory domain.
.DESCRIPTION
  Joins with the Active Directory domain.
.PARAMETER id
  Identifier for the Active Directory Domain.
.PARAMETER description
  Description for the Active Directory Domain.
.PARAMETER name
  Identifier for the Active Directory domain.
.PARAMETER netbios
  Netbios name for the Active Directory domain.
.PARAMETER server_list
  List of IP addresses or names for the backup domain controller.
.PARAMETER computer_name
  The name of the computer account in the domain controller.
.PARAMETER organizational_unit
  The location for the computer account.
.PARAMETER user
  Name of the Activer Directory user with Administrator's privilege.
.PARAMETER password
  Password for the Active Directory user.
.PARAMETER enabled
  Active Directory authentication is currently enabled.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True)]
    [string] $name,

    [string] $netbios,

    [string] $server_list,

    [string] $computer_name,

    [string] $organizational_unit,

    [Parameter(Mandatory=$True)]
    [string] $user,

    [Parameter(Mandatory=$True)]
    [string] $password,

    [bool]  $enabled
  )
process {
        # Gather request params based on user input.
        $RequestData = @{}
        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
        foreach ($key in $ParameterList.keys)
        {
            $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
            if($var -and ($PSBoundParameters.ContainsKey($key)))
            {
                $RequestData.Add("$($var.name)", ($var.value))
            }
        }
        $Params = @{
            ObjectName = 'ActiveDirectoryMembership'
            APIPath = 'active_directory_memberships'
            Properties = $RequestData
        }

        $ResponseObject = New-NimbleStorageAPIObject @Params
        return $ResponseObject
  }
}

function Get-NSActiveDirectoryMembership {
<#
.SYNOPSIS
  List the Active Directory Information.
.DESCRIPTION
  List the Active Directory Information.
.PARAMETER id
        Identifier for the Active Directory Domain.
.PARAMETER description
        Description for the Active Directory Domain.
.PARAMETER name
        Identifier for the Active Directory domain.
.PARAMETER netbios
        Netbios name for the Active Directory domain.
.PARAMETER server_list
        List of IP addresses or names for the backup domain controller.
.PARAMETER computer_name
        The name of the computer account in the domain controller.
.PARAMETER organizational_unit
        The location for the computer account.
.PARAMETER user
        Name of the Activer Directory user with Administrator's privilege.
.PARAMETER password
        Password for the Active Directory user.
.PARAMETER enabled
        Active Directory authentication is currently enabled.
#>
[CmdletBinding(DefaultParameterSetName='id')]
param(
    [Parameter(ParameterSetName='id')]
    [ValidatePattern('([0-9a-f]{2})([0-9a-f]{16})([0-9a-f]{16})([0-9a-f]{8})')]
    [string] $id,

    [Parameter(ParameterSetName='nonId')]
    [string]$description,

    [Parameter(ParameterSetName='nonId')]
    [string]$name,

    [Parameter(ParameterSetName='nonId')]
    [string]$netbios,

    [Parameter(ParameterSetName='nonId')]
    [string]$server_list,

    [Parameter(ParameterSetName='nonId')]
    [string]$computer_name,

    [Parameter(ParameterSetName='nonId')]
    [string]$organizational_unit,

    [Parameter(ParameterSetName='nonId')]
    [string]$user,

    [Parameter(ParameterSetName='nonId')]
    [string]$password,

    [Parameter(ParameterSetName='nonId')]
    [bool]$enabled
  )
process{
    $API = 'active_directory_memberships'
    $Param = @{
      ObjectName = 'ActiveDirectoryMembership'
      APIPath = 'active_directory_memberships'
    }
    if ($id)
    {   # Get a single object for given Id.
        $Param.Id = $id
        $ResponseObject = Get-NimbleStorageAPIObject @Param
        return $ResponseObject
    }
    else
    {   # Get list of objects matching the given filter.
        $Param.Filter = @{}
        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
        foreach ($key in $ParameterList.keys)
        {
            if ($key.ToLower() -ne 'fields')
            {
                $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
                if($var -and ($PSBoundParameters.ContainsKey($key)))
                {
                    $Param.Filter.Add("$($var.name)", ($var.value))
                }
            }
        }
        $ResponseObjectList = Get-NimbleStorageAPIObjectList @Param
        return $ResponseObjectList
    }
  }
}

function Set-NSActiveDirectoryMembership {
<#
.SYNOPSIS
  Updates the Active Directory configuration.
.DESCRIPTION
  Updates the Active Directory configuration.
.PARAMETER id
  Identifier for the Active Directory Domain. 
  A 42 digit hexadecimal number. Example: '2a0df0fe6f7dc7bb16000000000000000000004817'.
.PARAMETER description
  Description for the Active Directory Domain. 
  String of up to 255 printable ASCII characters. Example: '99.9999% availability'.
.PARAMETER netbios
  Netbios name for the Active Directory domain. 
  Netbios name for the Active Directory. Example: 'corp'.
.PARAMETER server_list
  List of IP addresses or names for the backup domain controller. 
  Comma separated strings of up to 63 characters of hostname and/or ip addresses.
  Total length cannot exceed 255 characters.
.PARAMETER computer_name
  The name of the computer account in the domain controller. 
  Name of the computer account in Active Directory. Example: 'storage-array01'.
.PARAMETER organizational_unit
  The location for the computer account. The location where the computer account has to be created. 
  The value should be specified in fully distinguished name (DN) format. 
  Reserved characters - comma, plus sign, double quote, backslash, left angle bracket, right angle 
  bracket, semicolon, linefeed, carriage return, equals sign and forward slash must be escaped. 
  Example: ou=ABC\, San Jose,dc=MY,dc=LOCAL.
.PARAMETER enabled
  Active Directory authentication is currently enabled. Possible values: 'true', 'false'.
#>
[CmdletBinding()]
param(
    [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [ValidatePattern('([0-9a-f]{42})')]
    [string] $id,
    [string] $description,
    [string] $netbios,
    [string] $server_list,
    [string] $computer_name,
    [string] $orgainzational_unit,
    [bool]   $enabled
  )
process{
        # Gather request params based on user input.
        $RequestData = @{}
        $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
        foreach ($key in $ParameterList.keys)
        { if ($key.ToLower() -ne 'id')
            {   $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
                if($var -and ($PSBoundParameters.ContainsKey($key)))
                {   $RequestData.Add("$($var.name)", ($var.value))
                }
            }
        }
        $Params = @{
            ObjectName = 'ActiveDirectoryMembership'
            APIPath = 'active_directory_memberships'
            Id = $id
            Properties = $RequestData
        }

        $ResponseObject = Set-NimbleStorageAPIObject @Params
        return $ResponseObject
    }
}

function Remove-NSActiveDirectoryMembership {
<#
.SYNOPSIS
  Leaves the Active Directory domain.
.DESCRIPTION
  Leaves the Active Directory domain.
.PARAMETER id
  ID of the active directory. A 42 digit hexadecimal number. Example: '2a0df0fe6f7dc7bb16000000000000000000004817'.
.PARAMETER user
  Name of the Activer Directory user with the privilege to leave the domain. 
  Active Directory username. String up to 104 printable characters. Example: 'joe-91'.
.PARAMETER password
  Password for the Active Directory user. Active Directory user password. 
  String up to 255 printable characters. Example: 'password-91'.
.PARAMETER force 
  Use this option when there is an error when leaving the domain. 
  Possible values: 'true', 'false'.
#>
[CmdletBinding()]
param (
    [Parameter(ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [ValidatePattern('([0-9a-f]{42})')]
    [string]  $id,

    [Parameter(ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [string]  $user,

    [Parameter(ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [string]  $password,

    [Parameter(ValueFromPipelineByPropertyName=$True)]
    [bool]    $force
  )
process{
    $Params = @{
        APIPath = 'active_directory_memberships'
        Action = 'remove'
        ReturnType = 'void'
    }
    $Params.Arguments = @{}
    $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
    foreach ($key in $ParameterList.keys)
    {
        $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
        if($var -and ($PSBoundParameters.ContainsKey($key)))
        {
            $Params.Arguments.Add("$($var.name)", ($var.value))
        }
    }

    $ResponseObject = Invoke-NimbleStorageAPIAction @Params
    return $ResponseObject
  }
}

function Test-NSActiveDirectoryMembership {
<#
.SYNOPSIS
  Reports the detail status of the Active Directory domain.
.DESCRIPTION
  Reports the detail status of the Active Directory domain.
.PARAMETER id <string>
  ID of the active directory. A 42 digit hexadecimal number. Example: '2a0df0fe6f7dc7bb16000000000000000000004817'.
#>
[CmdletBinding()]
param (
    [Parameter(ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [ValidatePattern('([0-9a-f]{42})')]
    [string]$id
  )
process{
    $Params = @{
        APIPath = 'active_directory_memberships'
        Action = 'report_status'
        ReturnType = 'NsADReportStatusReturn'
    }
    $Params.Arguments = @{}
    $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
    foreach ($key in $ParameterList.keys)
    {
        $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
        if($var -and ($PSBoundParameters.ContainsKey($key)))
        {
            $Params.Arguments.Add("$($var.name)", ($var.value))
        }
    }

    $ResponseObject = Invoke-NimbleStorageAPIAction @Params
    return $ResponseObject
  }
}

function Test-NSActiveDirectoryMembershipUser {
<#
.SYNOPSIS
  Tests whether the user exist in the Active Directory. If the user is present, 
  then the user's group and role information is reported.
.DESCRIPTION
  Tests whether the user exist in the Active Directory. If the user is present, 
  then the user's group and role information is reported.
.PARAMETER id
  ID of the active directory. A 42 digit hexadecimal number. Example: '2a0df0fe6f7dc7bb16000000000000000000004817'.
.PARAMETER name
  Name of the Active Directory user. Active Directory username. 
  String up to 104 printable characters. Example: 'joe-91'.
#>
[CmdletBinding()]
param (
    [Parameter(ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [ValidatePattern('([0-9a-f]{42})')]
    [string]$id,

    [Parameter(ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [string]$name
  )
process{
    $Params = @{
        APIPath = 'active_directory_memberships'
        Action = 'test_user'
        ReturnType = 'NsADTestUserReturn'
    }
    $Params.Arguments = @{}
    $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
    foreach ($key in $ParameterList.keys)
    {
        $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
        if($var -and ($PSBoundParameters.ContainsKey($key)))
        {
            $Params.Arguments.Add("$($var.name)", ($var.value))
        }
    }

    $ResponseObject = Invoke-NimbleStorageAPIAction @Params
    return $ResponseObject
  }
}

function Test-NSActiveDirectoryMembershipGroup {
<#
.SYNOPSIS
  Tests whether the user group exist in the Active Directory.
.DESCRIPTION
  Tests whether the user group exist in the Active Directory.
.PARAMETER id
  ID of the active directory. A 42 digit hexadecimal number. Example: '2a0df0fe6f7dc7bb16000000000000000000004817'.
.PARAMETER name
  Name of the Active Directory group. 
  String of up to 64 uppercase or lowercase characters excluding ampersand, less than, 
  greater than and ^/\[]:;|=,+*?;. Example: 'admin-group-24'.
#>
[CmdletBinding()]
param (
    [Parameter(ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [ValidatePattern('([0-9a-f]{42})')]
    [string]$id,

    [Parameter(ValueFromPipelineByPropertyName=$True, Mandatory = $True)]
    [string]$name
  )
process{
    $Params = @{
        APIPath = 'active_directory_memberships'
        Action = 'test_group'
        ReturnType = 'void'
    }
    $Params.Arguments = @{}
    $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
    foreach ($key in $ParameterList.keys)
    {
        $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
        if($var -and ($PSBoundParameters.ContainsKey($key)))
        {
            $Params.Arguments.Add("$($var.name)", ($var.value))
        }
    }

    $ResponseObject = Invoke-NimbleStorageAPIAction @Params
    return $ResponseObject
  }
}
