# Cross platform shebang:
shebang := if os() == 'windows' {
  'powershell.exe'
} else {
  '/usr/bin/env pwsh'
}

# Set shell for non-Windows OSs:
set shell := ["pwsh", "-c"]

# Set shell for Windows OSs:
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# If you have PowerShell Core installed and want to use it,
# use `pwsh.exe` instead of `powershell.exe`


alias list := default

default:
  just --list

setup:
  uv venv
  uv run prek install
  uv run prek install --hook-type commit-msg
  uv run prek install --hook-type pre-push

clean:
  if (Test-Path ".venv") { Remove-Item ".venv" -Recurse -Force }
  git clean -d -X --force

pre_commit_auto_update:
  uv run prek autoupdate

refresh_deps: pre_commit_auto_update
  uv lock --upgrade
  uv sync

run:
  uv run tempo_cli --help

lint:
    uv run ruff check --fix
    uv run ty check --fix
