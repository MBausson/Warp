package tests

import (
	"testing"
)

func TestTest(t *testing.T) {
	res, err := execute("echo $PSVersionTable")

	if err == nil {
		t.Log(res)
	}
}
