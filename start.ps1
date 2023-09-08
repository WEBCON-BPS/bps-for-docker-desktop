$demon = docker version -f '{{.Server.Os}}'

if ($demon  -eq "windows")
{
    & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon
}

try {
    docker compose -f .\linux-services.yml up -d 
}
catch {
    Write-Host "Docker compose error occured: $_"
    ./stop.ps1
    exit 1
}


& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon

$serverName = "$env:COMPUTERNAME,8433"
$databaseName = "master"
$sqlUsername = "sa"
$sqlPassword = "P@ssw0rd"
$retryIntervalInSeconds = 2

# Function to check if the SQL Server instance is available
function Test-SqlServerInstance {
    param (
        [string]$serverName,
        [string]$databaseName,
        [string]$sqlUsername,
        [string]$sqlPassword
    )
    
    try {
        $connectionString = "Server=$serverName;Database=$databaseName;User Id=$sqlUsername;Password=$sqlPassword;"
        $connection = New-Object System.Data.SqlClient.SqlConnection
        $connection.ConnectionString = $connectionString
        $connection.Open()
        $connection.Close()
        return $true
    } catch {
        return $false
    }
}

# Loop to check SQL Server availability
while (-not (Test-SqlServerInstance -serverName $serverName -databaseName $databaseName -sqlUsername $sqlUsername -sqlPassword $sqlPassword)) {
    Write-Host "SQL Server instance is not available. Waiting..."
    Start-Sleep -Seconds $retryIntervalInSeconds
}

Write-Host "SQL Server instance is available. Success!"

try {
    docker compose -f .\windows-services.yml up -d
}
catch {
    Write-Host "Docker compose error occured: $_"
    ./stop.ps1
    exit 1
}

$url = "https://localhost"
$retryIntervalInSeconds = 3
$maxRedirections = 10  # Maximum number of redirections to follow

# Function to get HTTP status
function Get-HttpStatus {
    param (
        [string]$url
    )
    
    try {
        $request = Invoke-WebRequest -Uri $url -MaximumRedirection $maxRedirections -SkipCertificateCheck
        return $request.StatusCode
    } catch {
        return $null
    }
}

# Loop to check HTTP status
while ($true) {
    $httpStatus = Get-HttpStatus -url $url
    if ($httpStatus -eq 200) {
        Write-Host "HTTP Status 200 received. Opening the browser..."
        Start-Process $url
        break
    } elseif ($httpStatus -eq 302) {
        # If it's a redirection, get the new URL and try again
        $url = $request.Headers.Location.AbsoluteUri
        Write-Host "Received HTTP Status 302 (Redirect). Following the redirection to $url..."
    } else {
        Write-Host "Waiting for HTTP Status 200. Current status: $httpStatus"
        Start-Sleep -Seconds $retryIntervalInSeconds
    }
}
