#!powershell


## Copyright 2020 Colton Hughes <colton.hughes@firemon.com>

## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
## The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#AnsibleRequires -CSharpUtil Ansible.Basic

$spec = @{
  options = @{
    dl_name = @{ type = "str"; required= $true }
    member = @{ type = "str"; required = $true }
    exo_username = @{ type = "str"; required = $true }
    exo_password = @{ type = "str"; required = $true; no_log = $true }
  }
}

try{
  $module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)
  ##$module.FailJson("test with module", $_)
}
catch{
  $module.FailJson("There was an issue initializing the Ansible Module", $_)
}


$dl_name = $module.Params.dl_name
$member = $module.Params.member
$exoUsername = $module.Params.exo_username
$exoPassword = $module.Params.exo_password

## Seed result
$module.Result.distribution_list = $dl_name
$module.Result.member = $member


## Convert plaintext password to securestring
$secure_password = ConvertTo-SecureString -String $exoPassword -AsPlainText -Force

## Creating a secure reusable credential object
$credObject = New-Object System.Management.Automation.PSCredential ($exoUsername, $secure_password)

## Try to import the module
try {
  Import-Module ExchangeOnlineManagement
}
catch {
  $module.FailJson("Failed to import ExchangeOnlineManagement PowerShell module", $_)

}


##Connect to Exchange Online
try
{
  Connect-ExchangeOnline -Credential $credObject -ShowBanner:$false
  
}
catch {
  $module.Result.changed = $false
  $module.FailJson("Could not Connect to ExchangeOnline", $_)
}

  ## Verify that distribution list exists
try {
  ## fetch distribution list
  $status = Get-DistributionGroup -Identity $dl_name
}
catch {
  ## Bigger error passed in module fail
  $module.Result.changed = $false
  $module.FailJson("Distribution Group does not exist!", $_)
}

try {
  ## find member email in distribution list object
  
  $isMember = ((Get-DistributionGroupMember -Identity $dl_name | select PrimarySMTPAddress) | Select-String -Pattern $member)

  $removal = (Remove-DistributionGroupMember -Identity $dl_name -Member $member -Confirm:$false)
  $module.Result.changed = $true

}
catch {
  if (-Not($isMember)) {
    $module.Result.changed = $false
    $module.FailJson("The user was not a member of the distribution list")
  }
  $module.Result.changed = $false
  $module.FailJson("There was an error removing the user from the distribution list", $_)
}

 ## Cleanup session
Disconnect-ExchangeOnline -Confirm:$false | out-null
$module.ExitJson()