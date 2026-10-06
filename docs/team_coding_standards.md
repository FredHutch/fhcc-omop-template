# Team Coding Standards

## General

- Use meaningful and descriptive [names](https://vickiboykis.com/2023/06/29/naming-things/) for objects and functions.
- Don’t use names that overwrite known functions (e.g., table or data).
- Don't overwrite previous object names within the same script.
    - Overwriting previous object names makes it much more difficult to error-check code and interactively run code.
    - Using names like data1, data2, data3, etc., is also uninformative.
- Use relative paths.
    - Don't hard code paths to scripts, raw data, etc.
    - In R, use RStudio projects (.Rproj) and `here::here()` or `fs::path()`, (or if necessary, `file.path()`) to help you avoid this.
    - In Python use `pathlib`, or if necessary `os.path`. Another option is to use the `here` function from the [`pyprojroot` package](https://pypi.org/project/pyprojroot/).
    - It's ok to specify the dataset location when sensitive data is stored outside of the code repo.
- Avoid hard coding (hard coding refers to fixing data or parameters in the code).
- Avoid magic numbers. Magic numbers are unique values with unexplained meaning, often with multiple occurrences in the code, which could be replaced with named constants. Using magic numbers obscures intent and makes these values harder to change.
    - Always assign unique values to an object with a meaningful and descriptive name, and use ALL CAPS for object names.
    - In R, you can use `lockBinding()` to prevent re-assignment.
- Limit your code to 80 characters per line (you can set up a vertical line at 80 characters in Rstudio, VSCode, Positron, etc.).
- Be mindful about how you set random seeds—a good strategy is to use the current date. If you set your seed to 42, [someone may come and set your computer on fire](https://blog.genesmindsmachines.com/p/if-your-random-seed-is-42-i-will). 🔥
- Make sure to consult "Working with Sensitive Data & Code" guidance, especially if you are working with restricted use data.

## R

- Follow the [tidyverse style guide](https://style.tidyverse.org).
- Employ tools to help you adhere to the style guide before you open a PR. For example:
    - Turn on RStudio Code Style Diagnostics option and follow their suggestions (Tools -> Global Options -> Code -> Diagnostics -> Provide R style diagnostics)
    - Use [styler,](https://styler.r-lib.org) [lintr](https://github.com/r-lib/lintr), or [air](https://github.com/posit-dev/air).
    - Highlight code and click `CTRL + Shift + A` to reformat.
    - Set up a [Github action](https://github.com/r-lib/lintr?tab=readme-ov-file#setting-up-github-actions) to reformat code.
        - 1. Run on push. Can cause merge conflicts, can clutter history, but it’s very straightforward to set up. I recommend styling PRs get opened instead of GHA committing directly.
        - 2. Pre-commit hooks. Styling always gets run before you commit, but every contributor has to set this up for themselves.
        - 3. Write a test that’s run by GHA and fails on bad style. Puts the onus on individuals to run styling and then push themselves.
- When naming objects, use alphanumeric characters and underscores.
    - Specifically avoid dots in variable names as they have a special meaning in R.
- Use hyphens (not underscores or spaces) for naming code chunks in Quarto/R Markdown.
    - With descriptive chunk names you can use the document outline (`Ctrl + Shift + O`) to easily navigate within your document.
- It is bad practice to save .RData workspace on exit, and restoring .RData at startup.
    - In RStudio, go to Tools -> Global Options -> General
    - Uncheck Restore .RData into workspace at startup
    - Mark “Never” for Save workspace to .RData on exit

## SQL

- We use the "docs/sql_style_guideline.md".

## Python

- Follow the [PEP 8 style guide](https://peps.python.org/pep-0008/)
- Use [Sphinx docstring format](https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html#the-sphinx-docstring-format)
- Use single quotes for strings
- Use a linter (e.g. `ruff`, `[pylint](https://pypi.org/project/pylint/)`)

## Resources

- [What They Forgot to Teach You About R](https://rstats.wtf) is a great resource for learning about how to address common sources of friction in R.
