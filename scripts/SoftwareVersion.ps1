# SoftwareVersion.ps1: This is part of Nimble Group Management SDK.
#
# © Copyright 2023 Hewlett Packard Enterprise Development LP.

function Get-NSSoftwareVersion {
<#  
.SYNOPSIS
  Read software versions.
.DESCRIPTION
  Read software versions.
#>
[CmdletBinding(DefaultParameterSetName='id')]
param(
  )
process{
    $API = 'software_versions'
    $Param = @{ ObjectName = 'SoftwareVersion'
                APIPath = 'software_versions'
              }
    # Get list of objects matching the given filter.
    $Param.Filter = @{}
    $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
    foreach ($key in $ParameterList.keys)
        { if ($key.ToLower() -ne 'fields')
            {   $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
                if($var -and ($PSBoundParameters.ContainsKey($key)))
                  {  $Param.Filter.Add("$($var.name)", ($var.value))
                  }
            }
        }
    $ResponseObjectList = Get-NimbleStorageAPIObjectList @Param
    $CustomerReturnObj = $ResponseObjectList[0]
    $x11 = 0
    while ($x11 -lt $CustomerReturnObj.count)
      { $DataSetType = "NimbleStorage.SoftwareVersion"
        $CustomerReturnObj[$x11].PSTypeNames.Insert(0,$DataSetType)
        $DataSetType = $DataSetType + ".TypeName"
        $CustomerReturnObj[$x11].PSObject.TypeNames.Insert(0,$DataSetType)
        $x11 = $x11 + 1
      }

    return $CustomerReturnObj
  }
}



