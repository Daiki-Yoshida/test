#!/usr/bin/env bash
# project.sh — Management Root public operations for the test project.
# Contract: documents/project/EXECUTION.md. Non-destructive by default;
# non-zero exit on failure; resolved targets printed before acting.
set -euo pipefail

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }
note() { printf '%s\n' "$*"; }

usage() {
  cat <<'USAGE'
project.sh — Management Root public operations

Usage: ./scripts/project.sh <command> [KEY=VALUE ...]

Commands:
  help                              Show this help
  status                            Non-mutating diagnosis: repo/worktree/tool state
  bootstrap                         Check host deps, build managed tools runtime, print setup guidance
  verify [DIR=<checkout>]           Standard final verification (default: primary checkout)
  worktree-create WORK=<w> REPO=<r> [BASE=<ref>]
                                    Create or reuse the resolved Work checkout (idempotent)
  worktree-status WORK=<w> REPO=<r> Resolved identity/branch/path/materialization state
  worktree-remove WORK=<w> REPO=<r> Remove only the selected clean worktree (branch kept)
  work-docs-commit WORK=<w>         Record .worktrees/<w>/documents/ onto work/<w>/main
  artifacts-sync [DIR=<checkout>]   Sync managed artifacts pack into <checkout>/documents/artifacts/
  cleanup                           Remove project-owned scratch resources (targets printed)

Parameters:
  WORK   <type>/<name>   Work Identity (e.g. refactor/git-test-workspace)
  REPO   <selector>      Repository selector: main | dotnet-test | script-test | documents-test
  BASE   <ref>           Base ref for a missing Work branch (default: master for REPO=main)
  DIR    <path>          Execution target directory resolved from the Project Root

Boundaries: GitHub writes target Daiki-Yoshida/test only; baseline master is never
modified directly; all effects stay inside the Project Root.
USAGE
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

resolve_project_root() {
  local common
  common="$(git -C "$SCRIPT_DIR" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" \
    || fail "cannot resolve the Management Root repository from $SCRIPT_DIR"
  (cd -- "$common/.." && pwd -P)
}

PROJECT_ROOT="$(resolve_project_root)"

ARTIFACTS_REPO="https://github.com/Daiki-Yoshida/documents-artifacts.git"
ARTIFACTS_REF="e38e79843388f4a8f8dabde03d6988be4acaf08e"
VALID_REPOS="main dotnet-test script-test documents-test"

WORK=""; REPO=""; BASE=""; DIR=""

parse_kv() {
  local a
  for a in "$@"; do
    case "$a" in
      WORK=*) WORK="${a#WORK=}" ;;
      REPO=*) REPO="${a#REPO=}" ;;
      BASE=*) BASE="${a#BASE=}" ;;
      DIR=*)  DIR="${a#DIR=}" ;;
      *) fail "unknown parameter: $a (expected KEY=VALUE)" ;;
    esac
  done
}

resolve_dir() {
  local d="${1:-}" abs
  [[ -n "$d" ]] || { printf '%s' "$PROJECT_ROOT"; return; }
  d="${d%/}"
  case "$d" in /*) fail "absolute DIR is not supported; supply a path relative to the Project Root" ;; esac
  [[ -d "$PROJECT_ROOT/$d" ]] || fail "DIR target does not exist: $d"
  abs="$(cd -- "$PROJECT_ROOT/$d" && pwd -P)"
  case "$abs" in "$PROJECT_ROOT"|"$PROJECT_ROOT"/*) ;; *) fail "DIR escapes the Project Root: $d" ;; esac
  printf '%s' "$abs"
}

resolve_work() {
  [[ "$WORK" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*/[A-Za-z0-9][A-Za-z0-9._-]*$ ]] \
    || fail "WORK must look like <type>/<name> (got: '${WORK:-unset}')"
  case " $VALID_REPOS " in
    *" $REPO "*) ;;
    *) fail "unknown REPO selector: '${REPO:-unset}' (valid: $VALID_REPOS)" ;;
  esac
  WT_BRANCH="work/$WORK/$REPO"
  WT_PATH="$PROJECT_ROOT/.worktrees/$WORK/$REPO"
  DOCS_PATH="$PROJECT_ROOT/.worktrees/$WORK/documents"
}

require_primary_checkout() {
  local ad cd
  ad="$(git rev-parse --absolute-git-dir 2>/dev/null)" || fail "not inside a Git checkout"
  cd="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || fail "not inside a Git checkout"
  [[ "$cd" == "$PROJECT_ROOT/.git" ]] || fail "this checkout does not belong to the Project Root repository"
  [[ "$ad" == "$cd" ]] \
    || fail "run project-level worktree operations from the primary checkout (Project Root), not from a linked worktree"
}

worktree_registered() { # <abs path>
  git -C "$PROJECT_ROOT" worktree list --porcelain | grep -qx "worktree $1"
}

worktree_branch_owner() { # <branch> → owning path or empty
  git -C "$PROJECT_ROOT" worktree list --porcelain \
    | awk -v ref="refs/heads/$1" '/^worktree / { p=$2 } $0 == "branch " ref { print p }'
}

verify_worktree_postconditions() {
  worktree_registered "$WT_PATH" || fail "postcondition failed: $WT_PATH is not a registered worktree"
  [[ "$(git -C "$WT_PATH" rev-parse --abbrev-ref HEAD)" == "$WT_BRANCH" ]] \
    || fail "postcondition failed: unexpected branch at $WT_PATH"
  [[ "$(worktree_branch_owner "$WT_BRANCH")" == "$WT_PATH" ]] \
    || fail "postcondition failed: $WT_BRANCH checkout owner mismatch"
  if [[ "$REPO" == "main" ]]; then
    [[ ! -d "$WT_PATH/.worktrees" ]] || fail "postcondition failed: nested .worktrees materialized at $WT_PATH"
    git -C "$WT_PATH" sparse-checkout list 2>/dev/null | grep -qx -- '!/.worktrees/' \
      || fail "postcondition failed: worktree-local sparse policy missing at $WT_PATH"
    git -C "$WT_PATH" check-ignore -q ".worktrees/$WORK/other-selector/x" \
      || fail "postcondition failed: ignore boundary does not cover sibling checkouts"
    ! git -C "$WT_PATH" check-ignore -q ".worktrees/$WORK/documents/x.md" \
      || fail "postcondition failed: Work Documents path is wrongly ignored"
  fi
}

cmd_worktree_create() {
  require_primary_checkout
  resolve_work
  if worktree_registered "$WT_PATH"; then
    [[ "$(git -C "$WT_PATH" rev-parse --abbrev-ref HEAD 2>/dev/null)" == "$WT_BRANCH" ]] \
      || fail "worktree $WT_PATH is registered on a different branch"
    [[ "$REPO" != "main" ]] || verify_worktree_postconditions
    note "action=existing work=$WORK repo=$REPO branch=$WT_BRANCH path=$WT_PATH"
    return 0
  fi
  local owner; owner="$(worktree_branch_owner "$WT_BRANCH")"
  [[ -z "$owner" ]] || fail "branch $WT_BRANCH is already checked out at $owner"
  [[ ! -e "$WT_PATH" ]] || fail "target path exists with unrelated content: $WT_PATH"

  if git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/heads/$WT_BRANCH"; then
    :
  elif git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/remotes/origin/$WT_BRANCH"; then
    git -C "$PROJECT_ROOT" branch --track "$WT_BRANCH" "origin/$WT_BRANCH" >/dev/null
    note "created tracking branch $WT_BRANCH from origin/$WT_BRANCH"
  else
    local base="$BASE"
    if [[ -z "$base" ]]; then
      [[ "$REPO" == "main" ]] && base="master" \
        || fail "REPO=$REPO requires an explicit BASE (no documented default)"
    fi
    git -C "$PROJECT_ROOT" rev-parse --verify --quiet "$base^{commit}" >/dev/null \
      || fail "base ref does not resolve: $base"
    git -C "$PROJECT_ROOT" branch --no-track "$WT_BRANCH" "$base" >/dev/null
    note "created branch $WT_BRANCH from base $base"
  fi

  if [[ "$REPO" == "main" ]]; then
    git -C "$PROJECT_ROOT" worktree add --no-checkout "$WT_PATH" "$WT_BRANCH" >/dev/null \
      || fail "git worktree add failed for $WT_PATH"
    if ! git -C "$WT_PATH" sparse-checkout set --no-cone '/*' '!/.worktrees/' \
       || ! git -C "$WT_PATH" reset --hard HEAD >/dev/null; then
      git -C "$PROJECT_ROOT" worktree remove "$WT_PATH" 2>/dev/null || true
      fail "materialization failed; rolled back the worktree created by this invocation"
    fi
  else
    git -C "$PROJECT_ROOT" worktree add "$WT_PATH" "$WT_BRANCH" >/dev/null \
      || fail "git worktree add failed for $WT_PATH"
  fi

  verify_worktree_postconditions
  local mat=normal; [[ "$REPO" == "main" ]] && mat=worktree-local-sparse
  note "action=created work=$WORK repo=$REPO branch=$WT_BRANCH path=$WT_PATH materialization=$mat"
}

cmd_worktree_status() {
  resolve_work
  note "work:              $WORK"
  note "repo:              $REPO"
  note "resolved_branch:   $WT_BRANCH"
  note "resolved_path:     $WT_PATH"
  note "work_documents:    $DOCS_PATH ($([[ -d "$DOCS_PATH" ]] && echo present || echo absent))"
  local reg=no; worktree_registered "$WT_PATH" && reg=yes
  note "registered:        $reg"
  note "branch_owner:      $(worktree_branch_owner "$WT_BRANCH" || true)"
  if git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/heads/$WT_BRANCH"; then
    note "local_branch:      exists ($(git -C "$PROJECT_ROOT" rev-parse --short "$WT_BRANCH"))"
  else
    note "local_branch:      missing"
  fi
  git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/remotes/origin/$WT_BRANCH" \
    && note "remote_branch:     exists" || note "remote_branch:     missing"
  if [[ "$reg" == yes ]]; then
    note "branch:            $(git -C "$WT_PATH" rev-parse --abbrev-ref HEAD)"
    note "head:              $(git -C "$WT_PATH" rev-parse HEAD)"
    note "dirty_entries:     $(git -C "$WT_PATH" status --porcelain | wc -l | tr -d ' ')"
    note "sparse_active:     $(git -C "$WT_PATH" config --worktree --get core.sparseCheckout 2>/dev/null || echo no)"
    note "sparse_patterns:   $(git -C "$WT_PATH" sparse-checkout list 2>/dev/null | tr '\n' ' ' || true)"
    note "nested_worktrees:  $(test -d "$WT_PATH/.worktrees" && echo PRESENT-ERROR || echo absent)"
  fi
}

cmd_worktree_remove() {
  require_primary_checkout
  resolve_work
  worktree_registered "$WT_PATH" || fail "not a registered worktree: $WT_PATH"
  [[ "$(git -C "$WT_PATH" rev-parse --abbrev-ref HEAD)" == "$WT_BRANCH" ]] \
    || fail "worktree branch mismatch at $WT_PATH"
  [[ -z "$(git -C "$WT_PATH" status --porcelain)" ]] \
    || fail "worktree has uncommitted changes; refusing removal: $WT_PATH"
  git -C "$PROJECT_ROOT" worktree remove "$WT_PATH"
  note "action=removed work=$WORK repo=$REPO path=$WT_PATH (branch $WT_BRANCH preserved; Work Documents untouched)"
}

cmd_work_docs_commit() {
  require_primary_checkout
  REPO="main"; resolve_work
  local docs_rel=".worktrees/$WORK/documents"
  [[ -d "$DOCS_PATH" ]] || { note "no Work Documents directory: $docs_rel (nothing to record)"; return 0; }
  find "$DOCS_PATH" -type f -print -quit | grep -q . \
    || { note "no files under $docs_rel (nothing to record)"; return 0; }
  git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/heads/$WT_BRANCH" \
    || fail "branch missing: $WT_BRANCH"
  worktree_registered "$WT_PATH" || fail "worktree missing (needed to advance $WT_BRANCH): $WT_PATH"

  local scratch="$PROJECT_ROOT/.worktrees/$WORK/.scratch"
  mkdir -p "$scratch"
  local idx="$scratch/.index.work-docs.$$" tree old_tree commit
  old_tree="$(git -C "$PROJECT_ROOT" rev-parse "$WT_BRANCH^{tree}")"
  GIT_INDEX_FILE="$idx" git -C "$PROJECT_ROOT" read-tree "$WT_BRANCH"
  GIT_INDEX_FILE="$idx" git -C "$PROJECT_ROOT" add -- "$docs_rel"
  tree="$(GIT_INDEX_FILE="$idx" git -C "$PROJECT_ROOT" write-tree)"
  rm -f "$idx"
  if [[ "$tree" == "$old_tree" ]]; then
    note "no changes: $docs_rel already matches $WT_BRANCH"
    return 0
  fi
  commit="$(git -C "$PROJECT_ROOT" commit-tree "$tree" -p "$WT_BRANCH" \
    -m "docs: record Work Documents ($WORK)")"
  git -C "$WT_PATH" merge --ff-only "$commit" >/dev/null \
    || fail "could not fast-forward $WT_BRANCH to the recorded documents commit"
  note "action=recorded work=$WORK branch=$WT_BRANCH commit=$commit docs=$docs_rel"
}

cmd_artifacts_sync() {
  local target; target="$(resolve_dir "$DIR")"
  local src="$PROJECT_ROOT/.scratch/documents-artifacts"
  mkdir -p "$PROJECT_ROOT/.scratch"
  if [[ ! -d "$src/.git" ]]; then
    note "fetching canonical pack source (read-only) → .scratch/documents-artifacts"
    git clone --quiet "$ARTIFACTS_REPO" "$src" || fail "clone of canonical source failed"
  fi
  git -C "$src" checkout --quiet "$ARTIFACTS_REF" || fail "cannot checkout pinned ref $ARTIFACTS_REF"
  [[ "$(git -C "$src" rev-parse HEAD)" == "$ARTIFACTS_REF" ]] \
    || fail "source ref mismatch (expected $ARTIFACTS_REF)"
  "$src/artifacts.sh" --target "$target" --sync --non-interactive \
    || fail "artifacts.sh sync failed"
  [[ -f "$target/documents/artifacts/INDEX.md" ]] \
    || fail "postcondition failed: $target/documents/artifacts/INDEX.md missing"
  note "action=synced target=$target source_ref=$ARTIFACTS_REF files=$(find "$target/documents/artifacts" -type f | wc -l | tr -d ' ')"
}

cmd_cleanup() {
  local d removed=0
  for d in "$PROJECT_ROOT/.scratch" "$PROJECT_ROOT"/.worktrees/*/*/.scratch \
           "$PROJECT_ROOT"/documents/.artifacts.new.* "$PROJECT_ROOT"/documents/.artifacts.old.*; do
    [[ -e "$d" ]] || continue
    note "removing project-owned scratch: ${d#"$PROJECT_ROOT"/}"
    rm -rf -- "$d"
    removed=$((removed+1))
  done
  note "cleanup complete: $removed target(s)"
}

cmd_status() {
  note "project_root:      $PROJECT_ROOT"
  note "primary_branch:    $(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD)"
  note "primary_head:      $(git -C "$PROJECT_ROOT" rev-parse HEAD)"
  note "uncommitted:       $(git -C "$PROJECT_ROOT" status --porcelain | wc -l | tr -d ' ') entries"
  note "worktrees:"
  git -C "$PROJECT_ROOT" worktree list | sed 's/^/  /'
  note "tools:"
  local t
  for t in git docker bash sh; do
    if command -v "$t" >/dev/null 2>&1; then note "  $t: present"; else note "  $t: MISSING"; fi
  done
  if command -v docker >/dev/null 2>&1; then
    local dv
    if dv="$(docker version --format '{{.Server.Version}}' 2>/dev/null)"; then
      note "  docker_daemon:   reachable (server $dv)"
    else
      note "  docker_daemon:   unreachable"
    fi
  fi
}

cmd_bootstrap() {
  local ok=0
  note "project_root: $PROJECT_ROOT"
  local t
  for t in git docker bash; do
    if command -v "$t" >/dev/null 2>&1; then note "dep $t: present"; else note "dep $t: MISSING"; ok=1; fi
  done
  note "repository selectors: $VALID_REPOS"
  note "component primary checkouts (planned): tests/dotnet-test tests/script-test tests/documents-test"
  if command -v docker >/dev/null 2>&1 && docker version --format '{{.Server.Version}}' >/dev/null 2>&1; then
    note "building managed tools runtime (project-scoped image test-mgmt-tools:local)"
    docker compose -f "$SCRIPT_DIR/../docker/compose.yaml" build tools \
      || { note "docker build FAILED"; ok=1; }
  else
    note "docker daemon unreachable — managed runtime build skipped (WARN)"
  fi
  note "next: ./scripts/project.sh artifacts-sync DIR=<checkout> installs the managed pack"
  return "$ok"
}

cmd_verify() {
  local target; target="$(resolve_dir "$DIR")"
  local fails=0 warns=0 s f
  pass() { note "PASS: $1"; }
  bad()  { note "FAIL: $1"; fails=$((fails+1)); }
  warn() { note "WARN: $1"; warns=$((warns+1)); }

  note "verify target: $target"

  for s in "$target"/scripts/*.sh; do
    [[ -e "$s" ]] || continue
    if bash -n "$s" 2>/dev/null; then pass "shell syntax: ${s#"$target"/}"; else bad "shell syntax: ${s#"$target"/}"; fi
  done

  for f in documents/INDEX.md documents/artifacts/INDEX.md AGENTS.md README.md; do
    [[ -f "$target/$f" ]] && pass "required file: $f" || bad "missing: $f"
  done

  if [[ -d "$target/documents/artifacts" ]]; then
    local cnt; cnt="$(find "$target/documents/artifacts" -type f -name '*.md' | wc -l | tr -d ' ')"
    [[ "$cnt" -ge 40 ]] && pass "managed pack file count: $cnt" || bad "managed pack too small: $cnt files"
    local src="$PROJECT_ROOT/.scratch/documents-artifacts"
    if [[ -d "$src/artifacts" ]]; then
      if diff -qr "$src/artifacts" "$target/documents/artifacts" >/dev/null 2>&1; then
        pass "managed pack identical to canonical source @$ARTIFACTS_REF"
      else
        bad "managed pack diverges from canonical source"
      fi
    else
      warn "canonical source clone absent; skipped byte-identical pack check"
    fi
  fi

  if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$target" check-ignore -q "tests/probe-component/x" \
      && pass "ignore boundary: tests/*/" \
      || bad "ignore boundary missing: tests/*/"
    git -C "$target" check-ignore -q ".worktrees/w/w/other-repo/x" \
      && pass "ignore boundary: .worktrees/*/*/*" \
      || bad "ignore boundary missing: .worktrees/*/*/*"
    if git -C "$target" check-ignore -q ".worktrees/w/w/documents/x.md"; then
      bad "Work Documents path wrongly ignored"
    else
      pass "Work Documents path trackable"
    fi
  else
    warn "target is not a git checkout; skipped ignore-boundary checks"
  fi

  local wt
  for wt in "$PROJECT_ROOT"/.worktrees/*/*/main; do
    [[ -e "$wt/.git" ]] || continue
    worktree_registered "$wt" || { bad "unregistered checkout dir: ${wt#"$PROJECT_ROOT"/}"; continue; }
    [[ ! -d "$wt/.worktrees" ]] && pass "no nested .worktrees: ${wt#"$PROJECT_ROOT"/}" \
      || bad "nested .worktrees materialized: ${wt#"$PROJECT_ROOT"/}"
    git -C "$wt" sparse-checkout list 2>/dev/null | grep -qx -- '!/.worktrees/' \
      && pass "sparse policy active: ${wt#"$PROJECT_ROOT"/}" \
      || bad "sparse policy missing: ${wt#"$PROJECT_ROOT"/}"
  done

  [[ -d "$PROJECT_ROOT/.serena" ]] && pass ".serena/ preserved" || warn ".serena/ absent"

  if command -v docker >/dev/null 2>&1 && docker version --format '{{.Server.Version}}' >/dev/null 2>&1; then
    if docker image inspect test-mgmt-tools:local >/dev/null 2>&1; then
      if docker compose -f "$target/docker/compose.yaml" run --rm tools bash -n /workspace/scripts/project.sh >/dev/null 2>&1 \
         && docker compose -f "$target/docker/compose.yaml" run --rm tools test -f /workspace/documents/INDEX.md >/dev/null 2>&1; then
        pass "in-container checks (test-mgmt-tools:local)"
      else
        bad "in-container checks failed"
      fi
    else
      warn "tools image absent; run bootstrap to enable in-container checks"
    fi
  else
    warn "docker daemon unreachable; in-container checks skipped"
  fi

  note "verify result: $fails FAIL, $warns WARN"
  (( fails == 0 ))
}

cmd="${1:-help}"; (($#)) && shift
parse_kv "$@"
case "$cmd" in
  help|-h|--help) usage ;;
  status)           cmd_status ;;
  bootstrap)        cmd_bootstrap ;;
  verify)           cmd_verify ;;
  worktree-create)  cmd_worktree_create ;;
  worktree-status)  cmd_worktree_status ;;
  worktree-remove)  cmd_worktree_remove ;;
  work-docs-commit) cmd_work_docs_commit ;;
  artifacts-sync)   cmd_artifacts_sync ;;
  cleanup)          cmd_cleanup ;;
  *) fail "unknown command: $cmd (see: project.sh help)" ;;
esac
