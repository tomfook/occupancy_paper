# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a research repository focused on mathematical modeling of seat occupancy optimization for theme park ride attractions. The project establishes a general framework to predict and maximize seat occupancy rates using Markov chain models.

**Key research question**: How to maximize seat occupancy when guests arrive in groups of varying sizes and must be seated together in rows with limited capacity?

## Repository Structure

- `occupancy.Rmd` - Main research paper: "General Framework for Seat Occupancy Expectation"
  - Establishes Markov chain model for predicting seat occupancy
  - Analyzes simple cases (single row of seats)
  - Includes mathematical derivations and examples using Harry Potter attraction configuration (4 seats per row)
  - Contains R code for generating diagrams and calculations

- `planning.Rmd` - Research planning document (in Japanese)
  - Outlines future research directions for multi-row scenarios
  - Discusses dynamic programming approaches for complex seat configurations
  - Addresses robustness and meta-strategy considerations

- `*.html` - Rendered output files from R Markdown documents

## Working with R Markdown

### Rendering Documents

To render an R Markdown file to HTML:
```r
# In R or RStudio
rmarkdown::render("occupancy.Rmd")
rmarkdown::render("planning.Rmd")
```

Or using command line with knitr:
```bash
Rscript -e "rmarkdown::render('occupancy.Rmd')"
```

### Key R Dependencies

The documents use:
- `knitr` - For document rendering and R code chunk execution
- `DiagrammeR` - For creating Markov chain state diagrams (using GraphViz)

## Mathematical Framework

The research models seat occupancy as a **Markov chain** where:

- **States (σ)**: Patterns of filled seats in a vehicle
- **Transitions**: Determined by arrival group sizes (probability distribution p_k)
- **Actions**: Grouper's decision on which row to assign and whether to dispatch vehicle
- **Objective**: Maximize expected seat occupancy rate

### Key Assumptions
- Stationary environment: Group size probabilities are time-independent
- First-come-first-served: Guests must be seated in arrival order
- Group integrity: Friend groups must sit together in the same row
- No foresight: Cannot predict next group's size

### Analysis Approach
1. Define transition matrix T from seat count and group size distribution
2. Calculate stationary state (eigenvector with eigenvalue 1)
3. Compute expected occupancy from stationary probabilities

## Mathematical Notation and Rigor

When working with mathematical content in this repository, maintain the following standards:

### Variable Definitions
- **Always distinguish between general notation and specific realizations**:
  - $\Sigma$: state space (set of all possible states)
  - $\sigma \in \Sigma$: a general state variable (any element of the state space)
  - $s_i \in \Sigma$: specific realization at time $i$
- **Define all variables before use**, including seemingly obvious ones like $n$ (total seats)
- **Maintain consistency** throughout the document - avoid switching between $s_i$, $a_i$, $\sigma$ for the same concept

### Assumptions and Constraints
- **Explicitly state all assumptions** with clear justification
- **Distinguish between**:
  - "Out of scope" (valid cases not analyzed in current work)
  - "Impossible by definition" (cases that contradict problem constraints)
- **Example**: In single-row analysis, $p_k = 0$ for $k > n$ is not a modeling choice but a consequence of the constraint that groups cannot be split

### General vs. Simplified Cases
- **Start with general framework** (arbitrary state space $\Sigma$, multiple rows)
- **Then explicitly describe simplification** for specific cases (e.g., single-row → state becomes a natural number)
- **Explain what allows simplification** (e.g., "FIFO seating in single row means state = number of filled seats")

### Mathematical Precision
- Use proper conditional probability notation: $P[s_{i+1}=k|s_i=j]$ should not include $P[s_i=j]$ in the definition
- When multiple transition paths lead to same state, use summation over all paths
- Prefer rigorous formulations (e.g., indicator functions, explicit summations) over ambiguous case-by-case definitions

## Research Context

This work was developed for theme park operation planning to optimize attraction throughput. The framework is general enough to apply to any ride attraction with rectangular seat configurations.
