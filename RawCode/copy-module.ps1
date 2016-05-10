Function Copy-Module {

<#
    .Synopsis
        Copies a Module file structure to a computer

    .Description
        So the thought behind this cmdlet is that I need to distribut modules to various system.  I need to do this because the double hop issue in windows.

    .Parameter ComputerName
        Defaults to Local Computer.  Name of computer to delete the module

    .Parameter ModulePath
        Path of the module to be copied

    .Example
        copies the filesystem module to the local computer

        Copy-Module -modulepath 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\FileSystem'

    .Note
        Author: Jeff Buenting
        Date: 2015 DEC 08

#>

    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$True)]
        [String[]]$ComputerName = 'LocalHost',

        [Parameter(Mandatory=$True)]
        [String[]]$ModulePath
    )

    Process {
        Foreach( $C in $ComputerName ) {
            Write-Verbose "Copying modules to $C"
                Copy-Item -Path $ModulePath -Destination "\\$C\c$\Program Files\WindowsPowerShell\Modules" -Recurse 
        }
    }

}

Copy-Module -modulepath 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\StratusLive','F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\FileSystem' -Verbose