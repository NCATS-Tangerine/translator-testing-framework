# translator-testing-framework

[![Build Status](https://travis-ci.org/NCATS-Tangerine/translator-testing-framework.svg?branch=master)](https://travis-ci.org/NCATS-Tangerine/translator-testing-framework)

This repo is a prototype to demonstrate how [Behave](https://behave.readthedocs.io/en/latest/) can be utilized to write tests in natural language. The interpretation and behavior of the natural language statements are handled by Python code.

## Getting started

### Cloning the Repository

Clone this repository,
```
git clone --recursive https://github.com/deepakunni3/translator-testing-framework.git
```

**Note:** Be sure to use `--recursive` flag to clone the 
[NCATS-Tangerine/NCATS-ReasonerStdAPI-diff](https://github.com/NCATS-Tangerine/NCATS-ReasonerStdAPI-diff) dependency.

### Creation of a Python 3.7 Virtual Environment

After cloning the repo, set up a virtual environment using Python 3's `venv` module (or your preferred tool, e.g. 
Conda or local IDE equivalent),

```
python3.7 -m venv venv
```

Here, `python3.7` is assumed to be a Python 3.7 binary. On your systems, you may simply need to type `python3` or even 
`python` (if your default python executable is a release 3.7 or better binary).

The command creates a virtual environment `venv`, which may be activated by typing:

```
source venv/bin/activate
```

To exit the environment, type:

```
deactivate
```

To reenter, source the activate command again.

Alternately, you can also use use `conda` env to manage packages and the development environment:

```
conda create -n translator-modules python=3.7
conda activate translator-modules
```

Some IDE's (e.g. PyCharm) may also have provisions for directly creating such a virtualenv. This should also work fine. 
Simply follow your IDE specific instructions to configure it.

### Installation of Python Dependencies

Now install required packages,

```
pip install -r requirements.txt --no-cache-dir
```

The `--no-cache-dir` flag ensures that the latest git repositories of special dependency projects are imported each 
time this command is run, given the "research and development" nature of this testing repo.

Note: double check which version of `pip` you have and its relationship to your Python executable. In some contexts, 
the visible `pip` will not be targeting your python3 binary. A safer way to execute `pip` may therefore be as follows: 

```
python -m pip install -r requirements.txt --no-cache-dir
```

Note that given the rapid cycles of development of the various NCATS projects being covered by Behave tests, it is 
advisable to periodically rerun the pip module installation process to ensure access to the latest synchronized code, 
especially after a `git pull` operation is done.

## Running Local support services for the Behave tests

Some Behave tests rely on access to additional REST microservices running locally. These need to be started first, 
before running the tests.

### Translator Reasoner Graph comparison service

Run the  `reasoner_diff/server.py`:
 
```
cd reasoner_diff
python server.py
```

which starts a local server on `http://0.0.0.0:9999` for Translator reasoner graph comparisons.

### TRANQL Server

The Translator Testing Framework now incorporates [TranQL](https://github.com/NCATS-Tangerine/tranql) queries.

TranQL is a query language for interactive exploration of federated knowledge graphs. Its queries may span multiple 
reasoners, namely, ICEES, Gamma, RTX, and (partially) Indigo.

To run the TranQL tests, you must run the TranQL dev server. You need to use 
[this fork](https://github.com/frostyfan109/tranql/).

To run the dev server, follow the installation and usage guide in the repository's README file. 
You only need to run the backplane and API.

### Translator Modules Support Services

Behave testing for several test scenarios in the Translator Modules feature testing require access to support web 
services which need to be running and accessible before running the tests.  Instructions for running these services is 
[documented here](https://github.com/ncats/translator-modules#special-prerequisite-for-running-the-translator-modules).
Either the DNS or system environment variables should be set to point to the services as indicated in the section about 
[support service host name resolution](https://github.com/ncats/translator-modules#service-host-name-resolution).

## Running Behave tests

To run the Behave tests,
```
behave
```

Run a single feature file

```shell
behave -i features/check-reasoners.feature
```

To only run TranQL specific tests, run 
`behave features/tranql-invalid-schema.feature features/tranql-reasoners.feature` in the root directory.

The behave outputs may be controlled with a variety of flags. Try:

```shell
behave  --no-capture --no-capture-stderr --no-color -i features/check-reasoners.feature
```


## Run with Docker

```shell
docker build -t translator-testing-framework .
docker run -it translator-testing-framework -i features/check-reasoners.feature
```

## Run reasoner_diff

```shell
cd reasoner_diff
pip install -r requirements.txt
python server.py
```



## Writing Behave tests

Write your tests similar to how you would type out a testing behavior.

For example,
```
Feature: Compare answers between reasoners

    Scenario: Compare answers between RTX and ROBOKOP
        Given an answer graph from "RTX"
        Given an answer graph from "ROBOKOP"
        When we compare the answer graphs
        Then the response should contain "graph_diff"
        Then the response should have some JSONPath "graph_diff.intersection.edges[*].source_id" containing "string" "HP:0002105"
        Then the response should have some JSONPath "graph_diff.intersection.edges[*].relation" containing "string" "RO:0002200"
        Then the response should have some JSONPath "graph_diff.intersection.edges[*].relation_label" containing "string" "has phenotype"
        Then the response should have some JSONPath "graph_diff.intersection.edges[*].target_id" containing "string" "MONDO:0018076"

```

Each suite of tests is called a `Feature`. You can group similar tests into one `Feature`.

Each `Feature` can have one (or more) `Scenario`.

In the above `Scenario`, there are two `Given` statements, one `When` statement and five `Then` statements.

Each of these statements are backed by Python code that handles what behavior you would like to see. The code itself resides in [features/steps](https://github.com/deepakunni3/translator-testing-framework/tree/master/features/steps) folder.

Take a look at the implementation,
- [Code](https://github.com/deepakunni3/translator-testing-framework/blob/dfb8183b1cf106ab415acc923d8466b262493a00/features/steps/steps.py#L33) that handles the behavior for `Given an answer graph from ...`
- [Code](https://github.com/deepakunni3/translator-testing-framework/blob/dfb8183b1cf106ab415acc923d8466b262493a00/features/steps/steps.py#L81) that handles the behavior for `When we compare the answer graphs`
- [Code](https://github.com/deepakunni3/translator-testing-framework/blob/dfb8183b1cf106ab415acc923d8466b262493a00/features/steps/steps.py#L106) that handles the behavior for `Then the response should contain ...`
- [Code](https://github.com/deepakunni3/translator-testing-framework/blob/dfb8183b1cf106ab415acc923d8466b262493a00/features/steps/steps.py#L143) that handles the behavior for `Then the response should have some JSONPath ... containing ...`


The above statements are defined in a flexible way such that they can be reused for different scenarios.

If there are new statements that originate from your scenarios, then add these statements to [features/steps](https://github.com/deepakunni3/translator-testing-framework/tree/master/features/steps).

## Motivation

The motivation for this framework originated from the Knowledge Graph Standardization call.

Objectives
- Testing reasoners
- Validate reasoner response against a minimal ground truth answers
- Validate answers according to input questions
- Allow for strict as well as fuzzy validation
- Easy for Subject Matter Experts (SMEs) to write tests
- Easy for programmers to codify testing behavior
