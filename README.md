# translator-testing-framework

This repo is a prototype to demonstrate how [Behave](https://behave.readthedocs.io/en/latest/) can be utilized to write tests in natural language. The interpretation and behavior of the natural language statements are handled by Python code.

## Getting started

Clone this repository,
```
git clone --recursive https://github.com/deepakunni3/translator-testing-framework.git
```

**Note:** Be sure to use `--recursive` flag to clone the [NCATS-Tangerine/NCATS-ReasonerStdAPI-diff](https://github.com/NCATS-Tangerine/NCATS-ReasonerStdAPI-diff) dependency.

After cloning the repo, set up a virtual environment using Python 3's `venv` module,
```
python3 -m venv my-working-environment
```

Then, activate `my-working-environment`,
```
source my-working-environment/bin/activate
```

Now install required packages,
```
pip install -r requirements.txt
```


## Running Behave tests

To run the Behave tests,
```
behave
```

> To successfully run all the defined tests, be sure to run the `reasoner_diff/server.py` first.
> `reasoner_diff/server.py` will start a local server on `http://0.0.0.0:9999`.


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

## Fork purpose

The purpose of this fork is to extend the Translator Testing Framework's capabilities to allow for [TranQL](https://github.com/NCATS-Tangerine/tranql) queries.

TranQL is a query language for interactive exploration of federated knowledge graphs. Its queries may span multiple reasoners, namely, ICEES, Gamma, RTX, and (partially) Indigo.
