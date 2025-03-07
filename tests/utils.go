package tests

import "os/exec"

func execute(command string) (string, error) {
	const powershellPath = `C:\Program Files\PowerShell\7\pwsh.exe`

	cmd := exec.Command(powershellPath, "-Command", command)

	output, err := cmd.Output()

	return string(output), err
}
