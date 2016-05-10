Function Delete-Module{

<#
    .Synopsis
        Removes Module Files from a computer
    
    .Description
        Removes module files from computer.  Can be local or remote.

    .Parameter ComputerName
        Defaults to Local Computer.  Name of computer to delete the module

    .Parameter Module
        Object representing the module to deleted.  

    .Parameter ModuleName
        Name of the module to be deleted.

    .Example
        Delete the FileSystem Module.

        Get-Module -Name FileSystem | Delete-Module

    .Example
        Delete the FileSystem Module by name from a remote computer

        Delete-Module -ModuleName 'FileSystem' -ComputerName 'ServerA'

    .Note
        Author: Jeff Buenting
        Date: 2015 DEC 08
#>

    [CmdletBinding()]
    Param (
        [String[]]$ComputerName = 'LocalHost',

        [Parameter(ParameterSetName='ModuleObject',Mandatory=$True,ValueFromPipeline=$True)]
        [System.Management.Automation.PSModuleInfo[]]$Module,

        [Parameter(ParameterSetName='ModuleName',Mandatory=$True,ValueFromPipeline=$True)]
        [String[]]$ModuleName
    )

    Process {
        Switch ( $PSCmdlet.ParameterSetName) {
            'ModuleObject' {
                Write-Verbose "ModuleObject ParameterSet"
                Foreach ( $M in $Module ) {
                    Write-Verbose "Deleting Module $($M.Name) Files"
                    foreach ( $C in $ComputerName ) {
                        Write-Verbose "     On computer $C"
                        
                        # ----- Convert local path to remote path
                        $Path = $M.ModuleBase -replace "C:","\\$C\C$"
                        
                        Remove-Item -Path $Path -Recurse -Force                       
                    }
                }
            }

            'ModuleName' {
                Write-Verbose "ModuleName ParameterSet"
                Foreach ( $M in $ModuleName ) {
                    Write-Verbose "Deleting Module $M"
                    Foreach ( $C in $ComputerName ) {
                       Get-Item -Path "\\$C\c$\Program Files\WindowsPowershell\Modules\$M" | Remove-Item -Recurse -Force
                    }
                }
            }
        }
    }
}

'stratuslive' | Delete-Module -Verbose