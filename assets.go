package resources

const (
	// Version contains the assets version.
	Version = 20191121162556

	// ASNDatabaseName is the ASN-DB file name
	ASNDatabaseName = "asn.mmdb"

	// CABundleName is the name of the CA bundle file
	CABundleName = "ca-bundle.pem"

	// CountryDatabaseName is country-DB file name
	CountryDatabaseName = "country.mmdb"

	// RepositoryURL is the asset's repository URL
	RepositoryURL = "http://github.com/ooni/probe-assets"
)

// ResourceInfo contains information on a resource.
type ResourceInfo struct {
	// URLPath is the resource's URL path.
	URLPath string

	// GzSHA256 is used to validate the downloaded file.
	GzSHA256 string

	// SHA256 is used to check whether the assets file
	// stored locally is still up-to-date.
	SHA256 string
}

// All contains info on all known assets.
var All = map[string]ResourceInfo{
	"asn.mmdb": ResourceInfo{
		URLPath:  "/releases/download/20191121162556/asn.mmdb.gz",
		GzSHA256: "ae53fa9d5a7bbba4c26d90df7604054e72e0c80fac4a3fb4d03f603d6e370bca",
		SHA256:   "d5c08af2011a4e6559e04317773198c72e9ed4b749efe73dfc66097ab01196b5",
	},
	"ca-bundle.pem": ResourceInfo{
		URLPath:  "/releases/download/20191121162556/ca-bundle.pem.gz",
		GzSHA256: "2ef0d342c1a451ee0a4e3b14a65faf7b3ecc649a0cb4e49d23be560417d1af4f",
		SHA256:   "5cd8052fcf548ba7e08899d8458a32942bf70450c9af67a0850b4c711804a2e4",
	},
	"country.mmdb": ResourceInfo{
		URLPath:  "/releases/download/20191121162556/country.mmdb.gz",
		GzSHA256: "5172eaef2fd2246e224dea6bff02af29b1d7d5c99b9c511eb765582273f027a8",
		SHA256:   "057ba471fde4a0007428ef1d0efb93e04a644eb3f6ace8a775fc842168e95af9",
	},
}
