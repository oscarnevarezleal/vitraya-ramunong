#!/usr/bin/env sh

# `$*` expands the `args` supplied in an `array` individually
# or splits `args` in a string separated by whitespace.
#echo "args: $*"
#env
#args

OWNER="${OWNER:=$1}"           # If variable not set or null, set it to 1st argument.
REPO="${REPO:=$2}"             # If variable not set or null, set it to 2nd argument
GITHUB_TOKEN="${GITHUB_TOKEN:=$3}"             # If variable not set or null, set it to 2nd argument

echo "OWNER ---> ${OWNER}"
echo "REPO ---> ${REPO}"

echo "$GITHUB_TOKEN" > .githubtoken
unset GITHUB_TOKEN
gh auth login --with-token < .githubtoken
rm .githubtoken

forks="$(gh api graphql -F owner=$OWNER -F name=$REPO -f query='
  query ($name: String!, $owner: String!) {
    repository(owner: $owner, name: $name) {
      forkCount
      forks(first: 10, orderBy: {field: NAME, direction: DESC}) {
        totalCount
        nodes {
          owner {
            id
            login
            avatarUrl
          }
          name
          nameWithOwner
        }
      }
    }
  }
' --jq '.data.repository.forks.nodes')"

echo $forks

echo "# Forks" >FORKS.md
echo "" >> FORKS.md

echo "Here's the list of forks" >>FORKS.md

for row in $(echo "${forks}" | jq -r '.[] | @base64'); do
  _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
  }
  login=$(_jq '.owner.login')
  node=$(curl -s https://api.github.com/repos/${OWNER}/${REPO}/compare/main...${login}:main |
    jq 'with_entries(if (.key|test("(ahead|behind)")) then ( {key: .key, value: .value } ) else empty end )')

  _jqNode() {
    echo ${node} | jq -r ${1}
  }

  echo "- [$login](https:/$login}/${REPO}) is $(_jqNode '.ahead_by') commit(s) ahead and, $(_jqNode '.ahead_by') commit(s) behind" >>FORKS.md
  echo " " >>FORKS.md
done

cat FORKS.md
