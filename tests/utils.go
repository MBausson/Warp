package tests

import "os/exec"

func execute(command string) (string, error) {
	cmd := exec.Command(powerhsellPath, "-Command", command)

	output, err := cmd.Output()

	return string(output), err
}
