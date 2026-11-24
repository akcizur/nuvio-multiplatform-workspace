# Published workspace

Repository: https://github.com/akcizur/nuvio-multiplatform-workspace

This repository is the public, community-maintained source workspace for collecting the public Nuvio codebases at pinned commits. It is not an official NuvioMedia repository and does not imply affiliation or endorsement.

## Clone and fetch source

```bash
git clone https://github.com/akcizur/nuvio-multiplatform-workspace.git
cd nuvio-multiplatform-workspace
./scripts/bootstrap.sh
./scripts/verify.sh
```

The workspace Git history contains the aggregator tooling, lockfile and documentation. It does not contain copies of the upstream applications. Bootstrap downloads the original public repositories at the exact commits listed in `UPSTREAMS.lock`.

## Optional checkouts

```bash
./scripts/bootstrap.sh --include-optional
./scripts/bootstrap.sh --include-references
./scripts/bootstrap.sh --all
```

Five auxiliary/reference repositories are marked `NO-LICENSE-FILE` and excluded from the default bootstrap. Their lack of a license file does not make them public domain or automatically reusable. Review `docs/licensing.md` before mirroring or redistributing those source trees.

## Updating pins

Review an upstream branch and commit, update the branch and full SHA in `UPSTREAMS.lock`, run `./scripts/validate-manifest.sh`, then bootstrap and verify the changed checkout. Keep upstream projects and their original histories separate.
