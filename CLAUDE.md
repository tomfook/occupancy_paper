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

### Vector and Scalar Notation
- **Use bold face to distinguish vectors from scalars only when the same letter is used for both types**:
  - Use `\mathbf{p}^{(i)}` (bold vector) when $p_k$ (scalar) already exists in the document
  - Use $\pi$ (regular) for stationary distribution since it is always a vector in context
  - Use $\pi_j$ (regular) for scalar elements of vector $\pi$
- **Rationale**: Bold face should serve a practical purpose (avoiding confusion), not be applied mechanically to all vectors
- **Example**: In this repository, `\mathbf{1}` is used for the all-ones vector, but $\pi$ remains regular since there's no scalar $\pi$ to confuse it with

### State Definition in Markov Chain Models
- **Carefully define observation timing** when specifying state space.
- Two valid interpretations exist:
  - **Interpretation A (adopted in this repository)**: State represents the number of filled seats immediately after a group has been seated
    - State space: $\{0, 1, \ldots, n\}$ (n+1 states)
    - State $n$ (full occupancy) is included
    - n seats → n+1 states → (n+1)×(n+1) transition matrix
  - **Interpretation B**: State represents the number of filled seats when the next group arrives
    - State space: $\{0, 1, \ldots, n-1\}$ (n states)
    - State $n$ is excluded (vehicle is immediately dispatched)
    - n seats → n states → n×n matrix
- **Both interpretations are mathematically valid** and yield the same expected occupancy rate.
- **This repository uses Interpretation A** for its intuitive state transition visualization.
- **Always explicitly state** which interpretation you are using and the observation timing.

### Stationary Distribution in Markov Chains
- **Explicitly state that stationary distribution exists** under appropriate conditions
- **Mention conditions briefly** (e.g., "finite state space and typical arrival distributions ensure irreducibility and aperiodicity")
- **Omit formal proofs** but provide reference to standard textbooks (e.g., Norris, 1997)
- **Justification**: Existence of stationary distribution is a mathematical prerequisite, not an empirical assumption

### Integrating Equations with Text
- **Use connecting phrases** when introducing equations:
  - "i.e." or "that is" for restating in mathematical form
  - ":" (colon) for defining or presenting results
  - "where" for explaining variables after an equation
- **Include quantifiers explicitly**: "for all $i$", "for each $k \in \{1,\ldots,n\}$"
- **Example**:
  - ❌ "The probability is independent of time $P[x_i=k]=p_k$."
  - ✅ "The probability is independent of time, i.e., $P[x_i=k]=p_k$ for all $i$."

### Introducing Parameters and Adjustments
- **Always explain why** when introducing new parameters or simplifying assumptions:
  - What does the parameter represent?
  - Why is this parameterization useful?
  - What special cases does it capture?
- **Before applying adjustments or corrections**, explain:
  - What effect is being adjusted for?
  - Why was it excluded from the base model?
  - How does the adjustment formula work?
- **Example** (from occupancy.Rmd:251-254):
  - ❌ "We assume $p_1=p, p_2=p_3=p_4=(1-p)/3$."
  - ✅ "We introduce a single-parameter model by setting $p_1=p$ and $p_2=p_3=p_4=(1-p)/3$. This represents the simplest scenario where single guests arrive with probability $p$, and all multi-person groups are equally likely."

## English Writing Style

When writing or revising English text in research documents, maintain the following standards:

### Tone and Formality
- Use **formal academic tone** appropriate for research papers
- Prefer present tense for describing the model and results
- Examples:
  - ❌ "a new vehicle will come"
  - ✅ "a new vehicle arrives"

### Active vs. Passive Voice
- **Use active voice with "we"** for author actions: "We define...", "We assume...", "We solve..."
- **Use passive voice** for general processes: "the vehicle is dispatched", "the matrix is constructed"
- **Use active voice** for describing actors in the model: "Guests arrive", "Groupers guide..."
- **Mixed usage is appropriate** when each choice serves its purpose

### Common Grammar and Style Corrections
- "a knowledge" → "knowledge" (uncountable noun)
- "each + plural" → "each + singular" ("each attraction", not "each attractions")
- "rectangle pattern" → "rectangular pattern" (use adjective form for shapes)
- "assumed by X" → "assumed to be X" (correct preposition)

## Research Context

This work was developed for theme park operation planning to optimize attraction throughput. The framework is general enough to apply to any ride attraction with rectangular seat configurations.
