$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host '启动本地预览：http://localhost:4000  （Ctrl+C 停止）' -ForegroundColor Cyan
npx hexo server
