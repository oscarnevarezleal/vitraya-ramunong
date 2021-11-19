## Usage

Here's a basic example, also available [here](./github/workflows/example.yml).

There's a [FORKS.md](https://github.com/oscarnevarezleal/vitraya-ramunong/FORKS.md) file available in this repo if you feel curious about the aspect of the file.

```yaml
name: Example
on:
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  example:
    runs-on: ubuntu-latest

    steps:
      - name: Calling docker action
        uses: oscarnevarezleal/vitraya-ramunong@dev
        with:
          owner: CHANGE_THIS
          repo: AND_THIS
          token: ${{ secrets.GITHUB_TOKEN }}
```