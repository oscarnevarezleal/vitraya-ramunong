#!/usr/bin/env bash

echo "# Forks" >>FORKS.md
echo "## Here's the list of forks" >>FORKS.md
for row in $(echo "${REPO_FORKS}" | jq -r '.[] | @base64'); do
  _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
  }
  login=$(_jq '.owner.login')
  avatarUrl=$(_jq '.owner.avatarUrl')

  node=$(curl -s https://api.github.com/repos/${OWNER}/${REPO}/compare/main...${login}:main |
    jq 'with_entries(if (.key|test("(ahead|behind)")) then ( {key: .key, value: .value } ) else empty end )')

  _jqNode() {
    echo ${node} | jq -r ${1}
  }

  echo "- [$login]($avatarUrl) is $(_jqNode '.ahead_by') commit(s) ahead and, $(_jqNode '.ahead_by') commit(s) behind" >>FORKS.md
  echo " " >>FORKS.md
done

cat FORKS.md
