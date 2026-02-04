## Domain Mapper


A batch file for running Domain Mapper under Windows.


**Description:** Will install Python and dependencies. For those who cannot do this on their own.


**Usage:**
- Download Win.bat and run it.

**You can try these options:**
- Launch PowerShell and run the command:
```
irm https://github.com/Ground-Zerro/DomainMapper/raw/main/Windows/Win.bat -OutFile "$env:TEMP\Win.bat"; cmd /c "$env:TEMP\Win.bat"
```
- Open Windows Command Prompt and run the command:
```
powershell -Command "irm https://github.com/Ground-Zerro/DomainMapper/raw/main/Windows/Win.bat -OutFile $env:TEMP\Win.bat" && cmd /c "%TEMP%\Win.bat"
```
