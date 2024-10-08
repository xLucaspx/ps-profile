function Prompt {
	$computerInfo = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split('\');
	$computerName = (Get-Culture).TextInfo.ToTitleCase($computerInfo[0].ToLower());
	$currentUser = $computerInfo[1];
	$currentPath = $executionContext.SessionState.Path.CurrentLocation.ToString() -ireplace [regex]::Escape($HOME), '~';

	# expected output:
	# username@machine PS ~/path/to/dir (branch-name)
	# > 

	Write-Host "$currentUser@$computerName " -ForegroundColor Green -NoNewline
	Write-Host "PS " -ForegroundColor Magenta -NoNewline
	Write-Host $currentPath -ForegroundColor DarkBlue -NoNewline
	
	if (Test-Path .git) {
		Write-BranchName
	}

	return "`n$('>' * ($nestedPromptLevel + 1)) "
}

function Write-BranchName {
	try {
		$branch = git rev-parse --abbrev-ref HEAD

		if ($branch -eq "HEAD") {
			# we're probably in detached HEAD state, so print the SHA
			$branch = git rev-parse --short HEAD
			Write-Host " ($branch)" -ForegroundColor Red -NoNewline
		}
		else {
			# we're on an actual branch, so print it
			Write-Host " ($branch)" -ForegroundColor Cyan -NoNewline
		}
	}
 catch {
		# we'll end up here if we're in a newly initiated git repo
		Write-Host " (no branches yet)" -ForegroundColor Yellow -NoNewline
	}
}

function Get-Path {
	$env:Path.Split(";")
}

function Open-Logisim {
	Start-Process powershell -WorkingDirectory "C:\logisim" -WindowStyle hidden { java -jar "logisim-evolution-3.9.0.jar" }
}

New-Alias logisim Open-Logisim

function Open-BrModelo {
	Start-Process powershell -WorkingDirectory "C:\brmodelo" -WindowStyle hidden { java -jar "brModelo.jar" }
}

New-Alias brmodelo Open-BrModelo

function Open-Rars {
	Start-Process powershell -WorkingDirectory "C:\rars" -WindowStyle hidden { java -jar "rars1_6.jar" }
}

New-Alias rars Open-Rars
