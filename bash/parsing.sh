#!/bin/bash
declare -r THERSHOLD=0

function usage() {
  echo "Usage: $0 <junit xml file or directory> [failure thershold]"
}

function main() {
  local fso="$1"
  local thershold=$THERSHOLD
  local files=()

  case "$#" in
    1) ;;
    2) thershold=$2 ;;
    *) usage; exit 1 ;;
  esac
  
  case "$fso" in
    '~/'*) fso="${HOME}/${fso#"~/"}" ;;
  esac

  if [[ -f $fso ]]; then
    files+=("$fso")
  elif [[ -d $fso ]]; then
    while IFS= read -r -d $'\0'; do
      files+=("$REPLY")
    done < <(find "$fso" -type f -name "*.xml" -print0)
    if [[ ${#files[@]} -eq 0 ]]; then
      echo "There are no *.xml files in $fso"
      exit 1
    fi 
  else
    echo "File or directory $fso does not exist."
    exit 1
  fi
  

  echo "fso: $fso"
  echo "thershold: $thershold"
  echo "files: $(printf "\n%s" "${files[@]}")"

  local filename
  local testsuites
  local testsuiteName
  local errors
  local errorsMax=0
  local failures
  local failuresMax=0
  local message
  

  for file in "${files[@]}"; do
    filename="${file##*/}"
    testsuites="$(xpath -q -e "count(//testsuite)" "$file" 2>/dev/null)"
    if [[ $testsuites -eq 0 ]]; then
      echo
      echo "$filename - skipped, not valid junit xml file"
      continue
    else
      for testsuite in $( seq 1 "$testsuites" ); do
        errors="$(xpath -q -e "count(//testsuite[$testsuite]/testcase/error)" "$file")"
        failures="$(xpath -q -e "count(//testsuite[$testsuite]/testcase/failure)" "$file")"
        testsuiteName="$(xpath -q -e "string(//testsuite[$testsuite]/@name)" "$file")"
        echo
        echo "$filename - testsuite $testsuiteName"
        if [[ $errors -ne 0 ]]; then
          for error in $( seq 1 "$errors" ); do
            message="$(xpath -q -e "string((//testsuite[$testsuite]/testcase/error/@message)[$error])" "$file")"
            echo "error: $message"
          done
        fi
        if [[ $failures -ne 0 ]]; then
          for failure in $( seq 1 "$failures" ); do
            message="$(xpath -q -e "string((//testsuite[$testsuite]/testcase/failure/@message)[$failure])" "$file")"
            echo "failure: $message"
          done
        fi
        if [[ $errors -eq 0 ]] && [[ $failures -eq 0 ]]; then
          echo "OK"
        fi
        errorsMax=$((errors>errorsMax ? errors : errorsMax))
        failuresMax=$((failures>failuresMax ? failures : failuresMax))
      done
    fi
  done

  echo
  echo "max errors in separate testsuites: $errorsMax"
  echo "max failures in separate testsuites: $failuresMax"
  if [[ $errorsMax -ne 0 ]]; then
    exit 1
  fi
  if [[ $failuresMax -eq 0 ]]; then
    echo "OK"
    exit 0
  fi
  if [[ $thershold -eq 0 ]]; then
    exit 1
  fi
  if [[ $failuresMax -gt $thershold ]]; then
    exit 1
  else
    exit 128
  fi

}

main "$@"