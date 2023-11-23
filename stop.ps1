$demon = docker version -f '{{.Server.Os}}'

if ($demon  -eq "windows")
{
    & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon
    docker context use desktop-linux
}

docker compose -f .\linux-services.yml down

& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon
docker context use desktop-windows

docker compose -f .\windows-services.yml down

# #remove certs
# $cert = Get-Content '.\data\local-data\intermediate-thumbprint'
# Get-ChildItem Cert:\CurrentUser\Root\$cert | Remove-Item -ErrorAction Continue 
# $cert = Get-Content '.\data\local-data\root-thumbprint'
# Get-ChildItem Cert:\CurrentUser\Root\$cert | Remove-Item -ErrorAction Continue 