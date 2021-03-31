// Package assets contains the embedded assets
package assets

import "embed"

// go:embed *.mmdb.gz
var efs embed.FS

// Assets returns the embedded FS containing the assets.
func Assets() embed.FS {
	return efs
}
