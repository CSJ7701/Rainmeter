[Variables]
# You can change this, but you must define all the measures/meters to go with additional repos
MaxRepos=10
fa-Linux=[\xf17c]
fa-Windows=[\xf17a]

# Repositories must be defined in order. For example, you can't fill out the fields for Repo1, then skip to Repo4. Everything will show up, but the background will not appear correctly.
# RepoXName is the name that will appear on the skin's header.
# RepoXPath is the filepath to your git repository. WSL paths are supported, but MUST be in '\\wsl.localhost\distroname\unix\path\starts\here' format.
# RepoXHost allows you to specify whether repo is hosted on WSL (linux) or Windows. You should enter either '#fa-Linux#' or '#fa-Windows#' to use FontAwesome icons. Otherwise, any text/unicode should work.

# Example:
# Repo1Name=MyRepo
# Repo1Path=\C:\Users\MYUSER\Documents\GitHub\RepoFolder
# Repo1Host=#fa-Windows#
# Repo2Name=MyOtherRepo
# Repo2Path=\\wsl.localhost\Ubuntu\home\USER\Projects\RepoFolder
# Repo2Host=#fa-Linux#

Repo1Name=School
Repo1Path=\\wsl.localhost\Ubuntu\home\csj7701\School
Repo1Host=#fa-Linux#

Repo2Name=Roam
Repo2Path=\\wsl.localhost\Ubuntu\home\csj7701\School
Repo2Host=#fa-Linux#

Repo3Name=Org
Repo3Path=\\wsl.localhost\Ubuntu\home\csj7701\org
Repo3Host=#fa-Linux#

Repo4Name=Ledger Report
Repo4Path=\\wsl.localhost\Ubuntu\home\csj7701\Projects\Ledger-Report
Repo4Host=#fa-Linux#

Repo5Name=Org Ranker
Repo5Path=\\wsl.localhost\Ubuntu\home\csj7701\Projects\org-ranker
Repo5Host=#fa-Linux#

Repo6Name=
Repo6Path=
Repo6Host=

Repo7Name=
Repo7Path=
Repo7Host=

Repo8Name=
Repo8Path=
Repo8Host=

Repo9Name=
Repo9Path=
Repo9Host=

Repo10Name=
Repo10Path=
Repo10Host=
