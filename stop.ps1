$demon = docker version -f '{{.Server.Os}}'

if ($demon  -eq "windows")
{
    & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon
}

docker compose -f .\linux-services.yml down

& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon

docker compose -f .\windows-services.yml down