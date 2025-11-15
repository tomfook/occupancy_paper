# Next Steps for Seat Occupancy Analysis

このファイルは、occupancy.Rmdに追加すべき分析内容を記録したものです。
分析は以下の順序で実施することを推奨します：

1. **Part 1**: Single Queue Caseの一般4パラメータ分析（基礎的な理解）
2. **Part 2**: Pre-grouping戦略の最適性条件の導出（応用的な改善策）

## 最新の進捗状況（2025-11-16）

### ✅ 今回完了したこと

1. **Dispatch Probabilityの解析解導出** - 一般4パラメータモデルでの $p_D$ を導出
2. **p1を含む多項式形式での表現** - $N_D = a_0 + a_1 p_1 + a_2 p_1^2 + a_3 p_1^3$ の形で整理
3. **ドキュメントへの追加** - occupancy.Rmdに「Dispatch Probability」セクションを新設
4. **設計判断の記録** - p1を消去せずに残すことで、Single-Rider Queue Case（p1=0）への移行を明確化

### 🔄 今回明らかになった設計の改善

**重要な設計判断**: 当初の計画では制約条件 $p_1 + p_2 + p_3 + p_4 = 1$ を使って $p_1$ を消去する予定だったが、**p1を残す形式に変更**。

理由：
- p1が式の複雑さの主要因であることが可視化される
- Single-Rider Queue Case（p1=0）で式が劇的に簡略化されることを示せる
- 論理的な流れ：General model → Single-Rider Queue が自然になる
- p1を消去すると、かえって式が複雑化する（p2, p3, p4の4次式になる）

### 📋 次のステップ

**最優先**: Part 1, Phase 1, Step 1.3b - Expected occupancy の解析解導出

こちらもp1を含む多項式形式で表現する。その後、Phase 2（数値分析の実装）に進む。

---

# Part 1: General Four-Parameter Analysis for Single Queue Case

## 背景と問題意識

現在の "Practical Example: Single Row of Four Seats" セクションでは、Transition Matrixを提示した直後（occupancy.Rmd:332行目付近）にすぐsingle parameter model ($p_1=p, p_2=p_3=p_4=(1-p)/3$) に特殊化している。

一般的な $p_1, p_2, p_3, p_4$ モデルでの分析が欠けており、以下の問題がある：
- Frameworkの一般性が明確でない
- 特定のパラメータ設定に依存した印象を与える
- Two-seat caseとの構造的一貫性が不足（Two-seat caseは一般→特殊の流れ）
- 実際のゲスト分布での予測能力が示されていない

## 分析の目的

Single Queue Case（pre-groupingなし）において、一般的な4パラメータモデル $(p_1, p_2, p_3, p_4)$ での分析を追加し、その後にsingle parameter modelへ移行する論理的な流れを構築する。

## 進捗状況（2025-11-16時点）

### ✅ 完了した作業

1. **状態空間の明確化** (occupancy.Rmd:319-323)
   - 状態0を除外し、状態空間を $\{1,2,3,4\}$ と定義
   - Two-seat caseの $\pi_0=0$ の結果を根拠として説明を追加

2. **遷移行列の検証と修正** (occupancy.Rmd:330-336)
   - 正しい4×4遷移行列を確認・修正
   - 行の和=1の検証完了

3. **定常分布の解析解導出** (occupancy.Rmd:338-365)
   - SymPy MCPを使用して解析的に導出
   - 一般4パラメータ $(p_1, p_2, p_3, p_4)$ での定常分布 $\pi = (\pi_1, \pi_2, \pi_3, \pi_4)$ を取得
   - 正規化定数を$Z$と命名（$p_D$との混同回避）
   - ドキュメントに「Stationary Distribution」セクションとして追加

4. **Dispatch Probabilityの解析解導出** (occupancy.Rmd:367-409)
   - p1を含む多項式形式で表現：$N_D = a_0 + a_1 p_1 + a_2 p_1^2 + a_3 p_1^3$
   - 同様に $Z = b_0 + b_1 p_1 + b_2 p_1^2 + b_3 p_1^3$
   - p1=0での簡略化への伏線を構築
   - ドキュメントに「Dispatch Probability」セクションとして追加

### 🔄 次に必要な作業

#### Step 1.3a: Dispatch Probability の解析解導出 ✅ 完了

**完了内容**:
- 一般4パラメータモデルでの $p_D = \frac{N_D}{Z}$ を導出
- p1を含む多項式形式で表現：$N_D = a_0 + a_1 p_1 + a_2 p_1^2 + a_3 p_1^3$
- 同様に $Z = b_0 + b_1 p_1 + b_2 p_1^2 + b_3 p_1^3$
- occupancy.Rmdに「Dispatch Probability」セクションとして追加済み

#### Step 1.3b: Expected Occupancy の解析解導出 🔄 次のタスク

**目標**: 一般4パラメータモデルでの $\mathrm{E}[Ocp]$ を解析的に導出

**Expected Occupancy**:
$$
\mathrm{E}[Ocp] = \frac{1}{p_D} \sum_{j=1}^{4} \pi_j \cdot \frac{j}{4} \cdot p_D(j)
$$
where
- $p_D(1) = p_4$ (状態1: 着席数1からdispatchする確率)
- $p_D(2) = p_3 + p_4$ (状態2: 着席数2からdispatchする確率)
- $p_D(3) = p_2 + p_3 + p_4$ (状態3: 着席数3からdispatchする確率)
- $p_D(4) = 1$ (状態4: 満席なので必ずdispatch)

**実装方法**:
- SymPy MCPで $\mathrm{E}[Ocp]$ の分子を計算
- p1を含む多項式形式で整理
- occupancy.Rmdの「Expected Occupancy」セクションに追記

**期待される結果**:
- 解析的な式（p1の多項式形式）
- p1=0での簡略化が明確に示される

#### Step 2: 汎用関数の実装（R）

**目標**: occupancy.Rmdのsetup chunkで数値計算用の汎用関数を定義

**実装方法**:
```r
library(Matrix)

# Define transition matrix as function of p1, p2, p3, p4
# State space: {1, 2, 3, 4}
get_transition_matrix <- function(p1, p2, p3, p4) {
  matrix(c(
    0, p1, p2, p3+p4,
    0, 0, p1+p3, p2+p4,
    0, p2, p3, p1+p4,
    p1, p2, p3, p4
  ), nrow = 4, byrow = TRUE)
}

# Solve for stationary distribution
get_stationary <- function(T_matrix) {
  # Solve (T^T - I)π = 0 with constraint sum(π) = 1
  eigen_result <- eigen(t(T_matrix))
  pi_index <- which.min(abs(eigen_result$values - 1))
  pi <- Re(eigen_result$vectors[, pi_index])
  pi <- pi / sum(pi)
  return(pi)
}

# Calculate dispatch probability
get_dispatch_prob <- function(pi, p1, p2, p3, p4) {
  # p_D(j) = probability of dispatch from state j
  # State 1: p_D(1) = p2 + p3 + p4
  # State 2: p_D(2) = p3 + p4
  # State 3: p_D(3) = p4
  # State 4: p_D(4) = 1 (always dispatch)
  p_D <- pi[1] * (p2+p3+p4) + pi[2] * (p3+p4) + pi[3] * p4 + pi[4] * 1
  return(p_D)
}

# Calculate expected occupancy
get_occupancy <- function(pi, p_D, p1, p2, p3, p4) {
  # E[Ocp] = (1/p_D) * sum_j π_j * (j/n) * p_D(j)
  ocp <- (1/p_D) * (
    pi[1] * (1/4) * (p2+p3+p4) +
    pi[2] * (2/4) * (p3+p4) +
    pi[3] * (3/4) * p4 +
    pi[4] * (4/4) * 1
  )
  return(ocp)
}
```

**注**: 遷移行列は修正版（状態空間 $\{1,2,3,4\}$）を使用

#### Step 3: Representative Distributionsでの数値計算

**Representative distributions**:

| Distribution Type | $p_1$ | $p_2$ | $p_3$ | $p_4$ | Characteristics |
|-------------------|-------|-------|-------|-------|-----------------|
| Uniform | 0.25 | 0.25 | 0.25 | 0.25 | Balanced |
| Singles-heavy | 0.60 | 0.20 | 0.10 | 0.10 | Many solo guests |
| Pairs-heavy | 0.10 | 0.60 | 0.20 | 0.10 | Many couples |
| Large groups | 0.10 | 0.20 | 0.30 | 0.40 | Families/groups |
| Optimal (4s only) | 0 | 0 | 0 | 1.0 | Perfect packing |
| Worst case (3s only) | 0 | 0 | 1.0 | 0 | Maximum waste |

**目標**: Representative distributionsでの数値計算とテーブル作成

**実装方法**:
```r
# Analysis for representative distributions
library(dplyr)

distributions <- data.frame(
  Type = c("Uniform", "Singles-heavy", "Pairs-heavy", "Large groups", "Optimal", "Worst"),
  p1 = c(0.25, 0.60, 0.10, 0.10, 0, 0),
  p2 = c(0.25, 0.20, 0.60, 0.20, 0, 0),
  p3 = c(0.25, 0.10, 0.20, 0.30, 0, 1.0),
  p4 = c(0.25, 0.10, 0.10, 0.40, 1.0, 0)
)

results <- distributions %>%
  rowwise() %>%
  mutate(
    T = list(get_transition_matrix(p1, p2, p3, p4)),
    pi = list(get_stationary(T[[1]])),
    p_D = get_dispatch_prob(pi[[1]], p1, p2, p3, p4),
    E_Ocp = get_occupancy(pi[[1]], p_D, p1, p2, p3, p4)
  )

# Display results table
knitr::kable(results %>% select(Type, p1, p2, p3, p4, p_D, E_Ocp),
             digits = 3)
```

**分析内容**:
- 各distributionでのstationary state $\pi$
- Expected occupancy $\mathrm{E}[Ocp]$
- Dispatch probability $p_D$
- テーブルでの比較表示

#### Step 4: パラメータ感度分析と可視化

**Question**: 各パラメータの変化がoccupancyに与える影響は？

**Approach 1: One-at-a-time sensitivity**
- Baseline: $p_1=p_2=p_3=p_4=0.25$
- 各 $p_k$ を変化させて他をrenormalizeした時の影響を測定

**Approach 2: Heat map visualization**
- 2次元断面での可視化
- 例: $(p_1, p_4)$ plane with $p_2=p_3=(1-p_1-p_4)/2$

**実装方法**:
```r
# Parameter sensitivity analysis - heat map
sensitivity_analysis <- function() {
  p_values <- seq(0, 1, by = 0.02)
  results <- data.frame()

  for (p1 in p_values) {
    for (p4 in p_values) {
      if (p1 + p4 > 1) next
      p2 <- p3 <- (1 - p1 - p4) / 2

      T <- get_transition_matrix(p1, p2, p3, p4)
      pi <- get_stationary(T)
      p_D <- get_dispatch_prob(pi, p1, p2, p3, p4)
      ocp <- get_occupancy(pi, p_D, p1, p2, p3, p4)

      results <- rbind(results, data.frame(p1=p1, p4=p4, occupancy=ocp))
    }
  }
  return(results)
}

# Visualization
library(ggplot2)

sens_data <- sensitivity_analysis()

ggplot(sens_data, aes(x=p1, y=p4, fill=occupancy)) +
  geom_tile() +
  scale_fill_gradient2(low="red", mid="yellow", high="green",
                       midpoint=0.85, limits=c(0.75, 1.0)) +
  labs(title="Expected Occupancy Sensitivity Analysis",
       subtitle=expression(paste("with ", p[2], "=", p[3], "=(1-", p[1], "-", p[4], ")/2")),
       x=expression(p[1]),
       y=expression(p[4]),
       fill="E[Ocp]") +
  theme_minimal()
```

### 4. 可視化

**Plot 1: Occupancy vs p1 (similar to Two-seat Fig.3)**
- Baseline: $p_2=p_3=p_4=(1-p_1)/3$
- X-axis: $p_1$ from 0 to 1
- Y-axis: Expected occupancy
- Compare with two-seat case pattern

```r
# Occupancy vs p1
p1_values <- seq(0, 1, by = 0.01)
ocp_vs_p1 <- data.frame()

for (p1 in p1_values) {
  p2 <- p3 <- p4 <- (1 - p1) / 3

  T <- get_transition_matrix(p1, p2, p3, p4)
  pi <- get_stationary(T)
  p_D <- get_dispatch_prob(pi, p1, p2, p3, p4)
  ocp <- get_occupancy(pi, p_D, p1, p2, p3, p4)

  ocp_vs_p1 <- rbind(ocp_vs_p1, data.frame(p1=p1, occupancy=ocp))
}

ggplot(ocp_vs_p1, aes(x=p1, y=occupancy)) +
  geom_line(color="blue", linewidth=1) +
  labs(title="Expected Occupancy vs Single Guest Probability",
       subtitle=expression(paste("Four-seat case with ", p[2], "=", p[3], "=", p[4], "=(1-", p[1], ")/3")),
       x=expression(p[1]),
       y="Expected Occupancy Rate") +
  theme_minimal()
```

**Plot 2: Heat map**
- $(p_1, p_4)$ parameter space (上記のsensitivity analysis)

**Plot 3: Multiple curves**
- Fix $p_4$ at different values (0, 0.25, 0.5, 0.75, 1.0)
- For each, vary $p_1$ with $p_2=p_3=(1-p_1-p_4)/2$
- Show family of curves

```r
# Multiple curves with fixed p4
p4_levels <- c(0, 0.25, 0.5, 0.75, 1.0)
multi_curve_data <- data.frame()

for (p4_fixed in p4_levels) {
  p1_range <- seq(0, 1-p4_fixed, by = 0.02)

  for (p1 in p1_range) {
    p2 <- p3 <- (1 - p1 - p4_fixed) / 2

    T <- get_transition_matrix(p1, p2, p3, p4_fixed)
    pi <- get_stationary(T)
    p_D <- get_dispatch_prob(pi, p1, p2, p3, p4_fixed)
    ocp <- get_occupancy(pi, p_D, p1, p2, p3, p4_fixed)

    multi_curve_data <- rbind(multi_curve_data,
                               data.frame(p1=p1, p4=p4_fixed, occupancy=ocp))
  }
}

ggplot(multi_curve_data, aes(x=p1, y=occupancy, color=factor(p4))) +
  geom_line(linewidth=1) +
  labs(title="Expected Occupancy for Various Group Size Distributions",
       subtitle=expression(paste("with ", p[2], "=", p[3], "=(1-", p[1], "-", p[4], ")/2")),
       x=expression(p[1]),
       y="Expected Occupancy Rate",
       color=expression(p[4])) +
  theme_minimal()
```

### 5. Single Parameter Modelへの移行の論理的説明

**現在の問題**: 唐突にsingle parameter modelが導入される

**改善後の流れ**:

```markdown
### General Four-Parameter Model

#### Numerical Analysis for Representative Distributions

(上記のテーブルとその解釈)

#### Parameter Sensitivity Analysis

(ヒートマップと複数曲線プロット)

From the numerical analysis above, we observe that:
- Expected occupancy is highly sensitive to the arrival distribution
- Groups of size 4 achieve perfect occupancy (E[Ocp]=1.0), while groups of size 3 alone result in the lowest occupancy (E[Ocp]=0.75)
- The relationship between parameters and occupancy is complex and nonlinear
- Single guests (p1) generally decrease occupancy, but the effect depends on the distribution of other group sizes

While these numerical results provide practical insights for specific distributions, exact analytical formulas for the stationary state in terms of all four parameters are cumbersome and do not yield simple closed-form expressions.

### Simplified Single-Parameter Model (for Analytical Insight)

To gain deeper analytical insight into the trade-off between single guests and multi-person groups, we introduce a simplified parameterization.

We set $p_1=p$ and $p_2=p_3=p_4=(1-p)/3$, representing the scenario where:
- Single guests arrive with probability $p$
- All multi-person groups (sizes 2, 3, 4) are equally likely, each with probability $(1-p)/3$

This parameterization allows us to:
1. Obtain closed-form analytical solutions for $\pi$ and $\mathrm{E}[Ocp]$
2. Clearly visualize the effect of single-guest proportion on occupancy
3. Compare with the two-seat case analysis structure

(既存のsingle parameter analysis)
```

## 推奨される新しいセクション構造

```markdown
## Practical Example: Single Row of Four Seats

### Transition Matrix
(既存の内容 - occupancy.Rmd:319-330)

### General Four-Parameter Model

#### Numerical Analysis for Representative Distributions
(新規: 数値例の表 - テーブル形式)

#### Parameter Sensitivity Analysis
(新規: ヒートマップと複数曲線プロット)

#### Occupancy vs Single Guest Proportion
(新規: p1を変化させたときのプロット)

### Simplified Single-Parameter Model (for Analytical Insight)

#### Motivation
(新規: なぜsimplified modelを導入するかの説明)

#### Analytical Solution
(既存の内容 - occupancy.Rmd:334-357)

#### Numerical Example
(既存の内容 - occupancy.Rmd:360-388)

### Single-Rider Queue Case
(既存の内容 - occupancy.Rmd:390-418)

### Pre-grouping Case
(既存の内容 - occupancy.Rmd:420-578)
```

## 実装ロードマップ（更新版）

### Phase 1: 解析解の完成 🔄 進行中

- ✅ **Step 1.1**: 状態空間の明確化と遷移行列の検証
- ✅ **Step 1.2**: 定常分布の解析解導出（SymPy MCP使用）
- ✅ **Step 1.3a**: Dispatch probability の解析解導出
  - p1を含む多項式形式で表現：$N_D = a_0 + a_1 p_1 + a_2 p_1^2 + a_3 p_1^3$
  - occupancy.Rmdに「Dispatch Probability」セクションを追加
- 🔄 **Step 1.3b**: Expected occupancy の解析解導出（次のタスク）
  - SymPy MCPで $\mathrm{E}[Ocp]$ を計算
  - p1を含む多項式形式で整理
  - occupancy.Rmdの「Expected Occupancy」セクションに追記

### Phase 2: 数値分析の実装

- **Step 2.1**: Rで汎用関数を実装
  - `get_transition_matrix(p1, p2, p3, p4)`
  - `get_stationary(T_matrix)`
  - `get_dispatch_prob(pi, p1, p2, p3, p4)`
  - `get_occupancy(pi, p_D, p1, p2, p3, p4)`
  - occupancy.Rmdの冒頭setup chunkで定義

- **Step 2.2**: Representative distributionsの計算
  ```r
  ```{r general_four_param_table}
  # 6つのdistributionで計算
  # 結果をknitr::kable()でテーブル表示
  ```
  ```

- **Step 2.3**: Parameter sensitivity analysis
  ```r
  ```{r sensitivity_heatmap, fig.width=7, fig.height=6}
  # (p1, p4)ヒートマップの生成
  ```

  ```{r multiple_curves, fig.width=8, fig.height=5}
  # 複数曲線プロット（固定p4）の生成
  ```

  ```{r ocp_vs_p1, fig.width=7, fig.height=4}
  # p1 vs occupancy プロット
  ```
  ```

### Phase 3: ドキュメント統合

- **Step 3.1**: テキスト記述の追加
  - 解析解の解釈
  - 数値結果の解釈
  - Single-Parameter Modelへの移行の動機説明

- **Step 3.2**: セクション構造の最終調整
  - General Four-Parameter Model セクション完成
  - Single-Parameter Model セクションとの接続

- **Step 3.3**: レンダリングと確認
  ```bash
  Rscript -e "rmarkdown::render('occupancy.Rmd')"
  ```

## 期待される成果

### 学術的価値
- Frameworkの一般性が明確に示される
- Two-seat caseとの構造的一貫性
- 数学的厳密性の向上
- 一般→特殊という自然な論理的流れ

### 実務的価値
- 実際のゲスト分布データを入力すれば予測可能
- パラメータ感度により運用施策の効果が予測可能
- Single parameter modelの位置づけが明確化（analytical insightのためのツール）

### 論理的流れの改善
```
General framework (Markov chain model)
  ↓
Two-seat case (complete analysis: general → specific)
  ↓
Four-seat case:
  - Transition matrix
  - General 4-parameter model (numerical analysis)
  - Simplified 1-parameter model (analytical insight)
  - Operational variations (single-rider, pre-grouping)
```

## 参考資料

### R Packages
- `Matrix`: Eigenvalue計算
- `ggplot2`: 基本可視化
- `dplyr`: データ処理
- `knitr`: テーブル表示
- `viridis`: カラースケール（オプション）

### Two-seat caseとの対応
- Two-seat case (occupancy.Rmd:147-309) の構造を参考に
- Fig.3のような可視化スタイルを踏襲

## メモ

- 一般分析の追加により、論文としての完成度が大幅に向上
- 実装の複雑さは限定的（既存のTransition matrixベース）
- 計算コストも許容範囲（状態数が4のみ）
- CLAUDE.mdのガイドラインに完全準拠
- **このPart 1を完了してから、Part 2（pre-grouping最適性分析）に進むことを推奨**

---

# Part 1.5: Single-Parameter Model Section の表記修正（将来の課題）

## 問題点

occupancy.Rmdの「Single-Parameter Model」セクション（行367-397周辺）に表記の不備がある：

### 1. ベクトル表記の不統一（行372-377）
- 定常分布$\pi$が縦ベクトル（column vector）で記述されている
- 他のセクション（General Four-Parameter Model）では横ベクトル（row vector）で統一されている
- CLAUDE.mdでも行ベクトル表記が推奨されている

**修正すべき箇所**：
```markdown
$$
\pi = \frac{1}{6(p+1)(2p^2-p+2)}\begin{pmatrix}
  2p^2+2p+5\\
  2p^3+2p^2+5p\\
  4p^3+4p^2-2p+3\\
  6p^3-2p^2+p+4
  \end{pmatrix}
$$
```

を横ベクトル表記に変更：
```markdown
$$
\pi = \frac{1}{6(p+1)(2p^2-p+2)}(2p^2+2p+5,\, 2p^3+2p^2+5p,\, 4p^3+4p^2-2p+3,\, 6p^3-2p^2+p+4)
$$
```

または
```markdown
$$
\pi = (\pi_1, \pi_2, \pi_3, \pi_4)
$$
where
$$
\begin{align}
\pi_1 &= \frac{2p^2+2p+5}{6(p+1)(2p^2-p+2)}\\
\pi_2 &= \frac{2p^3+2p^2+5p}{6(p+1)(2p^2-p+2)}\\
\pi_3 &= \frac{4p^3+4p^2-2p+3}{6(p+1)(2p^2-p+2)}\\
\pi_4 &= \frac{6p^3-2p^2+p+4}{6(p+1)(2p^2-p+2)}
\end{align}
$$
```

### 2. 状態インデックスの誤り（行397）
- 数値例で$\pi_0, \pi_1, \pi_2, \pi_3$というインデックスが使われている
- しかし状態空間は$\{1,2,3,4\}$と定義されているため、正しくは$\pi_1, \pi_2, \pi_3, \pi_4$

**修正すべき箇所**：
```markdown
$$
\pi = \begin{pmatrix}\pi_0 & \pi_1 & \pi_2 & \pi_3\end{pmatrix}= \begin{pmatrix}0.415 & 0.021 & 0.236 & 0.329\end{pmatrix}.
$$
```

を

```markdown
$$
\pi = (\pi_1, \pi_2, \pi_3, \pi_4) = (0.415, 0.021, 0.236, 0.329)
$$
```

に修正。

### 3. 検証タスク（オプション）
- Single-Parameter Modelの解析解が、General Four-Parameter Modelの解に$p_1=p, p_2=p_3=p_4=(1-p)/3$を代入したものと一致するか検証
- 整合性の確認により、両方の解析が正しいことを保証

## 優先度

- Part 1（一般分析の追加）およびPart 2（最適性分析）よりも優先度は低い
- ドキュメント全体の表記統一のため、時間があれば対応すべき
- 特に論文として公開する前には修正が必要

---

# Part 2: General Distribution Analysis for Optimal Pre-grouping Strategy

## 分析の目的

一般的な到着分布 $(p_2, p_3, p_4)$（制約: $p_2+p_3+p_4=1$）の下で、Case A, B, Cのうちどれが最適かを決定する条件を導出する。

**前提条件**: Part 1（Single Queue Caseの一般分析）が完了していること。これにより、pre-groupingの効果をSingle Queue Caseとの比較で明確に示せる。

現在のComparisonセクションでは $p_2=p_3=p_4=1/3$ の特定ケースのみを分析しているが、これを任意の到着分布に拡張する。

**注**: この分析では、single riders (p1) は別途single-rider queueで処理されるため、$p_1=0$ として $p_2+p_3+p_4=1$ を仮定する。

## 既に導出済みの期待占有率の式

### Case A (Separating Size-2)
$$
\mathrm{E}[Ocp_A] = p_2 + \frac{3}{4}p_3 + p_4
$$

### Case B (Separating Size-3)
$$
\mathrm{E}[Ocp_B] = p_3 \cdot \frac{3}{4} + (p_2+p_4) \cdot \frac{2+p-p^2}{2(1+p-p^2)}
$$
where $p=\frac{p_2}{p_2+p_4}$

### Case C (Separating Size-4)
$$
\mathrm{E}[Ocp_C] = p_4 + (p_2+p_3) \cdot \frac{3+2p-p^2}{4(1+p-p^2)}
$$
where $p=\frac{p_2}{p_2+p_3}$

## アプローチ

### 1. 最適性条件の導出

**Step 1**: Case AとCase Bの比較
- $\mathrm{E}[Ocp_A] > \mathrm{E}[Ocp_B]$ となる条件を導出
- $(p_2, p_3, p_4)$ 空間での境界線を求める

**Step 2**: Case AとCase Cの比較
- $\mathrm{E}[Ocp_A] > \mathrm{E}[Ocp_C]$ となる条件を導出

**Step 3**: Case BとCase Cの比較
- $\mathrm{E}[Ocp_B] > \mathrm{E}[Ocp_C]$ となる条件を導出

**Step 4**: 3つの領域の特定
- Case Aが最適な領域
- Case Bが最適な領域
- Case Cが最適な領域

### 2. 可視化

**三角図（Ternary plot）**を作成：
- 頂点: $(p_2, p_3, p_4) = (1,0,0), (0,1,0), (0,0,1)$
- 色分けで各戦略が最適な領域を表示
- R の `ggtern` パッケージを使用

**実装方法**:
```r
library(ggtern)
library(dplyr)

# Create grid in ternary space
resolution <- 100
grid <- expand.grid(
  p2 = seq(0, 1, length.out = resolution),
  p3 = seq(0, 1, length.out = resolution)
) %>%
  mutate(p4 = 1 - p2 - p3) %>%
  filter(p4 >= 0, p4 <= 1)

# Calculate occupancy for each case
calc_ocp_A <- function(p2, p3, p4) {
  p2 + 0.75 * p3 + p4
}

calc_ocp_B <- function(p2, p3, p4) {
  if (p2 + p4 == 0) return(0.75)  # Only p3
  p <- p2 / (p2 + p4)
  p3 * 0.75 + (p2 + p4) * (2 + p - p^2) / (2 * (1 + p - p^2))
}

calc_ocp_C <- function(p2, p3, p4) {
  if (p2 + p3 == 0) return(1.0)  # Only p4
  p <- p2 / (p2 + p3)
  p4 + (p2 + p3) * (3 + 2*p - p^2) / (4 * (1 + p - p^2))
}

grid <- grid %>%
  rowwise() %>%
  mutate(
    Ocp_A = calc_ocp_A(p2, p3, p4),
    Ocp_B = calc_ocp_B(p2, p3, p4),
    Ocp_C = calc_ocp_C(p2, p3, p4),
    max_ocp = max(Ocp_A, Ocp_B, Ocp_C),
    optimal_case = case_when(
      Ocp_A >= Ocp_B & Ocp_A >= Ocp_C ~ "Case A",
      Ocp_B >= Ocp_A & Ocp_B >= Ocp_C ~ "Case B",
      TRUE ~ "Case C"
    )
  ) %>%
  ungroup()

# Ternary plot
ggtern(grid, aes(x = p2, y = p3, z = p4, color = optimal_case)) +
  geom_point(size = 0.5) +
  scale_color_manual(values = c("Case A" = "blue", "Case B" = "red", "Case C" = "green")) +
  labs(title = "Optimal Pre-grouping Strategy by Arrival Distribution",
       x = expression(p[2]),
       y = expression(p[3]),
       z = expression(p[4]),
       color = "Optimal Strategy") +
  theme_minimal()
```

### 3. 解析的 vs 数値的アプローチ

#### 解析的アプローチ
- Case Aの式はシンプル（線形）
- Case B, Cは複雑（有理関数）
- 不等式を解いて境界線を求める（可能であれば）
- 数学的洞察が得られる

#### 数値的アプローチ（推奨）
- $(p_2, p_3)$ グリッド上で全ケースの期待占有率を計算（$p_4=1-p_2-p_3$）
- 各点で最大値を取る戦略を特定
- より実装が簡単で確実
- 複雑な式でも対応可能

### 4. ドキュメントへの追加

**場所**: `occupancy.Rmd` の Comparison of Pre-grouping Strategiesセクション内に新しいサブセクションを追加

```markdown
#### Comparison at Reference Distribution (p2=p3=p4=1/3)

(既存の内容 - occupancy.Rmd:550-577)

#### General Distribution Analysis

To understand which pre-grouping strategy is optimal for arbitrary arrival distributions, we analyze the expected occupancy across the entire $(p_2, p_3, p_4)$ parameter space.

(三角図とその解釈)

```{r ternary_optimal_strategy, fig.width=7, fig.height=6}
# Rコードで三角図を生成
```

The ternary plot reveals:
- **Case A dominates** when ...
- **Case B is optimal** when ...
- **Case C performs best** when ...

This analysis allows operators to select the optimal pre-grouping strategy based on their attraction's actual guest arrival distribution.
```

## 実装ステップ

### Task 1: Case B, Cの式を$(p_2, p_3, p_4)$のみで表現
- パラメータ $p$ を消去して、直接 $(p_2, p_3, p_4)$ で表現
- 関数として実装（上記のcalc_ocp_B, calc_ocp_C）
- エッジケース（分母がゼロ）の処理

### Task 2: 数値計算の実装
- Ternary space でのグリッド生成
- 各点で3つのケースのoccupancyを計算
- 最大値を与える戦略を特定

### Task 3: 三角図を作成
```r
```{r ternary_optimal_strategy, fig.width=7, fig.height=6}
library(ggtern)
# (上記のコード)
```
```

### Task 4: 追加分析（オプション）
- Occupancy差のヒートマップ（例: Ocp_A - Ocp_B）
- 境界線付近での感度分析
- Single Queue Caseとの比較を三角図上に重ねる

### Task 5: 境界条件の解析的検討（可能なら）
- 特別なケース（境界上、頂点）での解析
- 数値結果の検証
- 数学的洞察の抽出

**例**: Case Aの式は線形なので、境界条件を調べる：
- $\mathrm{E}[Ocp_A] = p_2 + 0.75p_3 + p_4 = 1 - 0.25p_3$
- Case Aは $p_3$ が小さいほど有利
- Case Bは $p_3=1$ で最適（E[Ocp]=0.75）
- Case Cは $p_4=1$ で最適（E[Ocp]=1.0）

### Task 6: 結果の解釈とドキュメントへの追加
- どのような分布でどの戦略が最適か
- 境界線の意味
- 実務への示唆
- Single Queue Caseからの改善幅の分析

## 期待される結果

### 予想される領域
- **Case Aが最適**: $p_2$ が大きい場合（サイズ2のペアリングが効率的）
  - 線形式 $1 - 0.25p_3$ が最大
- **Case Bが最適**: $p_3$ が支配的な場合（ただし単独0.75の制約あり、領域は限定的と予想）
  - $p_3 \to 1$ で E[Ocp] → 0.75
- **Case Cが最適**: $p_4$ が大きい場合（完璧な占有率1.0）
  - $p_4 \to 1$ で E[Ocp] → 1.0

### 特殊ケースの確認（数値計算での検証）
- $(p_2, p_3, p_4) = (1/3, 1/3, 1/3)$: Case A最適 ✓（既に確認済み、E[Ocp]=0.917）
- $(1, 0, 0)$: Case A最適（E[Ocp]=1.0）
- $(0, 1, 0)$: Case B最適（E[Ocp]=0.75）
- $(0, 0, 1)$: Case C最適（E[Ocp]=1.0）
- $(0.5, 0.5, 0)$: Case A vs C の境界付近
- $(0, 0.5, 0.5)$: Case B vs C の境界付近

### Single Queue Caseとの比較
Part 1の分析結果を用いて、各pre-grouping戦略の改善効果を定量化：
- "Uniform distribution (p2=p3=p4=1/3)では、Single Queue (E[Ocp]=0.818)からCase A (E[Ocp]=0.917)への変更で約12%改善"
- 改善幅の分布依存性を三角図で可視化

## 参考文献・ツール

### R Packages
- `ggtern` - ternary plot作成（必須）
- `dplyr` - データ処理
- `ggplot2` - 基本的な可視化

### インストール
```r
# ggtern may require special installation
install.packages("ggtern")
```

## メモ

- この分析により、実際のアトラクションの到着分布データから最適なpre-grouping戦略を選択できるようになる
- 境界領域付近では複数の戦略が同等の性能を持つ可能性がある
- Single-rider queueとの組み合わせ効果も考慮できる（追加分析）
- **Part 1の完了が前提**: Single Queue Caseの一般分析があれば、pre-groupingの改善効果がより明確になる

---

# 実施優先順位まとめ

## 推奨される実施順序

1. **Part 1: Single Queue Caseの一般4パラメータ分析**
   - 理由: 基礎的な理解、ドキュメント構造との整合性、論理的依存関係
   - 期間: 中程度（数値計算とプロット作成）
   - 難易度: 中（既存コードの拡張）

2. **Part 2: Pre-grouping戦略の最適性条件の導出**
   - 理由: Part 1の結果を活用してpre-groupingの効果を明確化
   - 期間: 中程度（三角図作成と解釈）
   - 難易度: 中（ggternパッケージの習得が必要）

## 両Partの関連性

```
Part 1: Single Queue Case分析
  ↓ ベースラインの確立
Part 2: Pre-grouping最適性分析
  ↓ 比較により改善効果を明確化
完成した包括的な分析フレームワーク
```

## 期待される最終成果

- 一般的な到着分布に対応した予測フレームワーク
- 数値例から解析的洞察への自然な流れ
- 運用戦略（single-rider, pre-grouping）の効果の定量化
- 実務での意思決定を支援する可視化ツール
- 学術的にも実務的にも価値のある研究成果
