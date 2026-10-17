param(
    [switch]$NoDeploy
)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host '[1/3] 清理旧产物' -ForegroundColor Cyan
npx hexo clean
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host '[2/3] 生成静态页面' -ForegroundColor Cyan
npx hexo generate
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if ($NoDeploy) {
    Write-Host '已跳过部署，本地产物在 public\' -ForegroundColor Yellow
    exit 0
}

Write-Host '[3/3] 推送到 GitHub（master 分支）' -ForegroundColor Cyan
npx hexo deploy
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ''
Write-Host '完成。线上地址：https://bubber2018.github.io/' -ForegroundColor Green
Write-Host 'GitHub Pages 有 10 分钟左右缓存，急的话用无痕窗口看。' -ForegroundColor DarkGray
