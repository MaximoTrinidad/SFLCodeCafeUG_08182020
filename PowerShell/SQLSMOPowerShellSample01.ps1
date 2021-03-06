<#        
    .SYNOPSIS
     A brief summary of the commands in the file.

    .DESCRIPTION
    A detailed description of the commands in the file.

    .NOTES
    ========================================================================
         Windows PowerShell Source File 
         Created with SAPIEN Technologies PrimalScript 2020
         
         NAME: SQLSMOPowerShellSample01.ps1
         
         AUTHOR: max_trinidad@hotmail.com , 
         DATE  : 8/17/2020
         
         COMMENT: Sample SMO block for listing given SQL Server names.
         
    ==========================================================================
#>

$SQLServerInstanceName = @('10.0.0.227,1433','10.0.0.250,1433');

## - Import SQL Server Module:
Import-Module SqlServer

## - Collect Server Edition Info:
$AllSqlServerEdition = $null;
[array]$AllSqlServerEdition = foreach($s in $SQLServerInstanceName){ 
	
	## - SQLServer Authentication:
	$SQLUserName = 'sa'; $SqlPwd = '$SqlPwd01!';
	
	## - Prepare connection to SQL Server:
	$SQLSrvConn = New-Object `
		Microsoft.SqlServer.Management.Common.SqlConnectionInfo($s, $SQLUserName, $SqlPwd);
	$SQLSrvObj = new-object Microsoft.SqlServer.Management.Smo.Server($SQLSrvConn);
	
	## - Sample T-SQL Queries:
	$SqlQuery = 'Select @@Version as FullVersion';
	
	## - Execute T-SQL Query:
	[array]$result = $SQLSrvObj.Databases['master'].ExecuteWithResults($SqlQuery);
	$GetVersion = $result.tables.Rows;
	
	## - SMO Get SQL Server Info:
	$SqlEdtion = $SQLSrvObj.Information `
	| Select-Object parent, platform, `
					@{ label = 'FullVersion'; Expression = { $GetVersion.FullVersion.Split(' - ')[0]; } }, `
					OSVersion, Edition, version, HostPlatform, HostDistribution;
					
	$SqlEdtion;
};

$AllSqlServerEdition | Format-List;
