# Clean repository

Remove unnecessary files from git repository

It is usefull when first uploading repository to github/gitlab service


## Requirements

```
brew install bfg
```

## Run

1. Check if in repo is unwanted phrase: `git grep secret-phrase`

2. Update `passwords.txt`

3. Update `run.sh` -> `bfg --delete-files del.txt` ( more on https://rtyley.github.io/bfg-repo-cleaner/ )

4. Execute`run.sh repo-name` -> it will look for ../repo-name
