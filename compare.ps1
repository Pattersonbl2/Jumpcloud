

# creates the employees csv 
(Get-Content -Path /Users/brandonpatterson/Desktop/Jumpcloud/employees.json | ConvertFrom-Json)  | ConvertTo-Csv -NoTypeInformation | % { $_ -replace '"', "" } | Set-Content -Path /Users/brandonpatterson/Desktop/Jumpcloud/employees.csv

# import gengineers 

$engineers = Import-Csv -Path /Users/brandonpatterson/Desktop/Jumpcloud/engineering.csv  | Select-Object -Property firstName , lastName, manager, email  


# import employees while filtering out  employeee who do have totp_enabled 
$employees = Import-Csv -Path /Users/brandonpatterson/Desktop/Jumpcloud/employees.csv | Where-Object { $_.totp_enabled -eq 'false' } 
$list = @()

#run loop through both csv to find matches and create csv with matches 
foreach ($f in $engineers) {
    $matched = $false
    foreach ($e in $employees) {
        
        if ($f.email -eq $e.email) {
              
              $new = [PSCustomObject]@{
                'FirstName' = $e.firstName
                'lastName' = $e.lastName
                'email' = $e.email
                'username' = $e.username
                'JobTile'  = $e.JobTitle
                'manager'  = $f.manager
            }
    
            $list += $new
        
        }
    }
          
}      
    $List |select firstName , lastName , email , username , jobTile , manager | Export-Csv  -NoTypeInformation   -Path /Users/brandonpatterson/Desktop/Jumpcloud/list.csv   

