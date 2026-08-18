#Current User
GCI -recurse cert:\currentuser\my | FORMAT-LIST –PROPERTY *

#LocalMachine
GCI -recurse cert:\localmachine\my | FORMAT-LIST –PROPERTY *

#Request Certificate
Get-Certificate -Template "VPN User Authentication" -CertStoreLocation "cert:\CurrentUser\My"