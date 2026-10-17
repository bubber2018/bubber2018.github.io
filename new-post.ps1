param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Title
)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

# 文件名去掉 Windows 不允许的字符，其它保持原样
$slug = ($Title -replace '[\\/:*?"<>|]', '').Trim()
if ([string]::IsNullOrWhiteSpace($slug)) {
    Write-Host '标题为空（去掉非法字符后），请重新输入。' -ForegroundColor Red
    exit 1
}

$file = Join-Path 'source\_posts' "$slug.md"
if (Test-Path $file) {
    Write-Host "已存在同名文章：$file" -ForegroundColor Yellow
    Write-Host '直接打开它就行。'
}
else {
    npx hexo new post $slug
}

Write-Host ''
Write-Host "文章文件：$file" -ForegroundColor Green
Write-Host '用 Typora / VSCode / Obsidian 打开它，写 Markdown 正文。'
Write-Host '写完执行：.\publish.ps1' -ForegroundColor Cyan

# 有 code 命令就用 VSCode 打开
if (Get-Command code -ErrorAction SilentlyContinue) {
    code $file
}
