#CODE STARTS HERE

$programFiles = [environment]::getfolderpath("programfiles")

add-type -Path $programFiles'\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.SharePoint.Client.dll'

Write-Host 'Para habilitar a feature de SideLoading, entre com a url do portal, usuário e senha'
 
$siteurl = Read-Host 'Url do Portal SharePoint'
 
$username = Read-Host "Usuário"
 
$password = Read-Host -AsSecureString 'Senha'
 
if ($siteurl -eq '')
{
    $siteurl = 'https://mytenant.sharepoint.com/sites/mysite'
 
    $username = 'me@mytenant.onmicrosoft.com'
 
    $password = ConvertTo-SecureString -String 'mypassword!' -AsPlainText -Force
 
}
     $outfilepath = $siteurl -replace ':', '_' -replace '/', '_'
 
try
{
    [Microsoft.SharePoint.Client.ClientContext]$cc = New-Object Microsoft.SharePoint.Client.ClientContext($siteurl)
 
    [Microsoft.SharePoint.Client.SharePointOnlineCredentials]$spocreds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $password)
 
    $cc.Credentials = $spocreds
    
     Write-Host -ForegroundColor Yellow 'A feature de SideLoading não está habilitada no site:' $siteurl
     
     $site = $cc.Site;
     
        $sideLoadingGuid = new-object System.Guid "AE3A1339-61F5-4f8f-81A7-ABD2DA956A7D"
     
        $site.Features.Add($sideLoadingGuid, $true, [Microsoft.SharePoint.Client.FeatureDefinitionScope]::None);
     
        $cc.ExecuteQuery();
     
        Write-Host -ForegroundColor Green 'Feature de SideLoading habilitada no site' $siteurl
    #Activate the Developer Site feature
}
 
catch
 
{ 
    Write-Host -ForegroundColor Red 'Erro ao tentar habilitar a feature de SideLoading' $siteurl, ':' $Error[0].ToString();
}

#CODE ENDS HERE
