// #import "@local/ori:0.2.5": *
#import "lib.typ" : *
#import "@preview/i-figured:0.2.4"
#import "@preview/pinit:0.2.2": *
#show math.equation: i-figured.show-equation.with(only-labeled: true)
#set heading(numbering: numbly("{1:一}、", default: "1.1  "))
#import cosmos.rainbow: *
// #set math.equation(numbering: "(1.1)")
// 为所有块级公式启用跨页
#show math.equation: set block(breakable: true)
#set-inherited-levels(1)


#let crimson = rgb("#c00000")
#let greybox(..args, body) = block(fill: luma(95%), stroke: 0.5pt, inset: 0pt, outset: 5pt, ..args, body)
#let redbox(..args, body) = block(fill: red.lighten(95%), stroke: 0.5pt, inset: 0pt, outset: 5pt, ..args, body)
#let bluebox(..args, body) = block(fill: blue.lighten(95%), stroke: 0.5pt, inset: 0pt, outset: 5pt, ..args, body)

#let redbold(body) = {
  set text(fill: crimson, weight: "bold")
  body
}
#let blueit(body) = {
  set text(fill: blue)
  body
}


#show: ori.with(
  title: "不太适合速记的速记纸",
  author: "吴钦鸿",
  subject: "信息论",
  semester: "2026 春",
  date: datetime.today(),
  maketitle: true,
  makeoutline: true,
  // theme: "dark",
  // media: "screen",
)

= 信息的统计度量

#let KL = $D_"KL"$
#grid(
  columns: (1fr, 3fr),
  align: (left, center),
  gutter: 2em,
  
)[
  熵
][
  $H(X) = EE[-log p(X)]$
][
  条件熵
][
$
H(X|Y) &= EE_(X,Y)[-log p(X|Y)] \
&= EE_Y [EE_(X|Y) [-log p(X|Y)]] \
&= EE_Y [H(X|Y = y)]
$
][
互信息
][
$
I(X; Y) &= H(X) - H(X|Y)\
&= sum_(X Y) p(x,y) log p(x|y)/p(x)\
&= sum_(X Y) p(x,y) log p(x,y)/(p(x) p(y))\
&= EE_(X, Y) [log p(x,y)/(p(x) p(y))]
$
][
  联合熵
][
  $
  H(X, Y) &= EE_(X,Y)[-log p(X, Y)]\
  &= sum_(X,Y) p(x,y) log 1/(p(x)p(y|x))\
  &= sum_(X,Y) p(x,y) log 1/p(x) +sum_(X,Y) p(x,y) log 1/p(y|x)\
  &= H(X) + H(Y|X)
  $
  #remark[链式法则][
    $
    H(X,Y) = H(X) + H(Y|X)
    $
    $
    H(X,Y|Z) = H(X|Z) + H(X|Y,Z)
    $
    推广：
    $
    H(X_1^n) = sum_(i=1)^(n) H(X_i|X_1^(i-1))
    $
  ]
][
  相对熵（KL散度）
][
  $
  D_(K L)(p||q) &= EE_(X~p(X))[log p(X)/q(X)]\
  &= "CE"(p,q) - H(p)
  $
  #remark[
    $
    I(X;Y) = D_(K L)(p(X, Y)||p(X)p(Y))
    $
  ]
][
  交叉熵
][
  $"CE"(p,q) = EE_(X~p) [-log q(X)]$
]
#figure[
#image("assets/image.png", width: 40%)
]

= 信息度量的界与凹凸性
#theorem[Jesen不等式][
  对凸函数$f(x)$, 
  $ E(f(X)) >= f(E(X)) $
  当且仅当 $X equiv E(X)$ 时取等。
]
#remark[
  $-log x$，$x log x$ 都是凸函数，所以
  $ EE[-log X] >= -log(EE [X]) $ <log>
  $ EE[X log(X)] >= EE(X) log(EE(X)) $ <xlogx>
]

#property[KL散度非负性][
  $ D_"KL" = EE_(X~p) [-log p(X)/q(X)]\ attach(>=,t:"(*)") -log (EE_(X~p)[q(X)/p(X)])=-log(sum_X p(X) q(x)/p(x)) = -log(sum_X q(X)) = -log 1 = 0 $
  第(\*)步用到了@eqt:log. 
  
  当且仅当 $p = q$ 时取等.

  #corollary[互信息非负性][
  $ I(X;Y) = D_(K L)(p(X, Y)||p(X)p(Y)) >= 0 $
  当且仅当 $X bot Y$ 时取等.
  ]
  #corollary[条件熵不大于原熵][
  $ H(X) - H(X|Y) = I(X;Y) >= 0 $
  当且仅当 $X bot Y$ 时取等.
  ]
  #corollary[均匀分布时熵最大][
    假设X是离散随机变量，$cal(X)$上的均匀分布$u(x) = 1/abs(cal(X))$
    $
    H(X) &= EE[- log p(X)] = EE_(X~p)[- log u(X) p(X)/u(X)]\
    &= -log u(X) - D_"KL" (p||u)\
    &= log abs(cal(X)) - D_"KL"(p||u)\
    &<=log abs(cal(X)) quad ("p = u 时取等")
    $
    当且仅当 $X$ 服从均匀分布时取等.
  ]
]

#theorem[对数和不等式][
  $
  sum a_i log a_i/b_i >= (sum a_i) log((sum a_i) / (sum b_i))
  $
  当且仅当 $a_i/b_i$ 为定值时取等.
]<log-sum>

#property[KL散度的凸性][
  $KL$ 关于$(p, q)$ 是凸的. 即
  $
  lambda KL(p_1||q_1)+ (1-lambda) KL(p_2||q_2) >= KL(lambda p_1 + (1-lambda) p_2 || lambda q_1 + (1-lambda)q_2)
  $
  #proof[
    $
    &lambda KL(p_1||q_1)+ (1-lambda) KL(p_2||q_2) \
    &= sum_X lambda p_1(x) log (lambda p_1(x))/(lambda q_1(x)) + (1-lambda) p_2(x) log (lambda p_2(x))/(lambda q_2(x))\
    & attach(>=, t:"(*)") sum_X (lambda p_1(x) + (1-lambda) p_2(x)) log (lambda p_1(x) + (1-lambda) p_2(x))/(lambda q_1(x) + (1-lambda)q_2(x))\
    &= KL(lambda p_1 + (1-lambda) p_2 || lambda q_1 + (1-lambda)q_2)
    $
    第 (\*) 步用到了@log-sum[!!]
  ]
]

#property[熵的凹性][
  $H(X)$ 关于 $X$ 的分布具有凹性,即
  $ lambda H(p_1) + (1 - lambda) H(p_2) <= H(lambda p_1 + (1 - lambda) p_2) $

  #proof[
    $
    "左边" &= - sum_X lambda p_1(x) log p_1(x) + (1 - lambda) p_2(x) log p_2(x)\
    &= - sum_X lambda p_1(x) log (lambda p_1(x))/lambda + (1 - lambda) p_2(x) log ( (1-lambda) p_2(x)) / (1 - lambda)\
    &attach(<=, t:"(*)") -sum_X (lambda p_1(x) + (1- lambda) p_2(x)) log (lambda p_1(x) + (1 - lambda) p_2(x)) / (lambda + (1 - lambda))\
    &= H(lambda p_1 + (1 - lambda) p_2)
    $
    第 (\*) 步用到了@log-sum[!!]
  ]
]


#property[互信息的凹凸性][
  $p(Y|X)$ 确定时, $I(X; Y)$ 是 $p(X)$ 的凹函数.\
  $p(X)$ 确定时, $I(X; Y)$ 是 $p(Y|X)$ 的凸函数.
]

= 渐进均分性

独立同分布的 n 个符号 $U$ 组成符号序列 $U^n$. n充分大时, $U^n$ 的典型集高概率地出现, 而且典型集中元素概率对数地接近, 这就是渐进均分性.

#lemma[弱大数定理][
  $overline(X) = sum_(i=1)^n X_i, "Var"[X] = sigma^2$, 那么
  $
  forall epsilon > 0\
  P(abs(overline(X) - EE[X]) <= epsilon) > 1 -  sigma^2/(n epsilon^2)\
  $
  $
  exists N, forall n > N\
  P(abs(overline(X) - EE[X]) <= epsilon) > 1 -  sigma^2/(n epsilon^2) > 1 - epsilon 
  $ <prob-lower-bound>
]<big-num>

#let typset = $A^((n))_epsilon$
#definition[#sym.epsilon -典型集][
  随机变量序列 $U^n$ 的#sym.epsilon -典型集定义为
  $
  typset = {u^n mid(|) abs(1/n log 1/p(u^n) - H(U)) < epsilon}
  $

  #property[高概率][
    $
    forall epsilon>0, P(U^n in typset) limits(-->)^(n->oo) 1
    $
    利用@big-num[!!]立刻可以得到.
  ]<高概率>

  #property[概率上下界][
    $
    2^(-n(H(U) + epsilon))<= p(u^n) <= 2^(-n(H(U) - epsilon))
    $
    从定义立刻得到.
  ]<概率上下界>
  
  #property[数量上下界][
    $
    (1-epsilon) 2^(n(H(U) - epsilon)) <= abs(typset) <= 2^(n(H(U) + epsilon))
    $
    其中,下界是在n充分大时的下界,利用了@eqt:prob-lower-bound.
  ]<数量上下界>

  #property[占比][
    $
    abs(typset)/abs(U^n) approx 2^(n H(U))/abs(cal(U))^n = 2^(-n(log abs(cal(U)) - H(U))) = 2 ^(-n(KL(p||u)))
    $
    当 $p eq.not u$, n 充分大时, $abs(typset)/abs(U^n)->0$
  ]
]


#proposition[高概率集的下界][
  $B^((n)) subset.eq U^n, delta > 0$, #redbold($abs(B^((n))) <= 2^(n (H(U) -delta))$), 那么
  $
  P(U^n in B^((n))) attach(-->, t:n->oo) 0
  $
  #proof[
    取 $epsilon < delta$ 的典型集#typset
    $
    P(U^n in B^((n))) &= #pin(1)P(U^n in (B^((n)) inter typset))#pin(2) + underbrace(P(U^n in (B^((n)) - typset)), <=P(U^n in.not typset) -> 0)
    $
    #pinit-highlight(1, 2)

    #pinit-point-from((1, 2),offset-dx: -35pt, body-dx: -120pt)[
      #greybox[
      $
      P(U^n in (B^((n)) inter typset)) &= sum_(u^n in B^((n)) inter typset) p(u^n)\
      &<= #redbold($abs(B^((n)))$) 2^(-n (H(U) - epsilon))\
      &<= #redbold($2^(n (H(U) -delta))$) 2^(-n (H(U) - epsilon))\
      &= #blueit($2^(-n(delta - epsilon)) $) attach(-->, t:n->oo) 0
      $
      ]
    ]
  ]
  \
  \
  \
  \
  \
  \
  #corollary[
  任何满足@高概率[!!] 的集合$B^((n))$, 下界还可以比@数量上下界 更紧:
  $
    abs(B^((n))) >= 2^(n H(U))
  $
  ]
]<high_prob_lower_bound>

#theorem[信源定长编码定理][
  #let Set = $S_delta$
  对于i.i.d信源$U^n$, 记#Set 为编码误差在$delta$内 ($P(U^n in Set )>= 1 - delta$) 的最小集合, 对于任意 $epsilon > 0$ 和 $0 < delta < 1$, 存在正整数 $n_0$ , 当 $n > n_0$ 时, 编码长度$log abs(Set)$满足:
  $
  abs(1/n log abs(Set) - H(U)) < epsilon
  $

  #proof[
    先证明存在$n_0$使得$1/n log abs(Set) < H(U) + epsilon$:
    #redbox(width:100%)[
      只编码典型集 #typset 中的元素.
      
      对于任意 $epsilon > 0$, 选取 $n_0$ 使得 $1 -  sigma^2/(n_0 epsilon^2) >= 1 - delta$

      $n > n_0$时, #typset 是编码误差在 $delta$ 内的集合:
      $
      P(U^n in typset) >= 1 -  sigma^2/(n_0 epsilon^2) >= 1 - delta
      $
      编码误差在$delta$内的最小集合 #Set 应该不比 #typset 大:
      $
      1/n log abs(Set) <= 1/n log abs(typset) <= H(U) + epsilon
      $
    ]
    再证明存在$n_0$使得$1/n log abs(Set) > H(U) - epsilon$:
    #bluebox(width:100%)[
      如果存在$epsilon$, 使得对于任意$n_0$ 总存在$n > n_0$, $1/n log abs(Set) <= H(U) - epsilon$ 即

      $
      abs(Set) <= 2 ^(n(H(U) -epsilon)
      $

      取$n_0 -> oo$, 那么 $n$ 也 $->oo$, 根据@high_prob_lower_bound[!!]

      $
      P(U^n in Set) attach(-->, t:n->oo) 0
      $

      与$P(U^n in Set )>= 1 - delta > 0$矛盾.
    ]
  ]
]<source_codec>

#definition[熵率][
  对于未必i.i.d的符号序列 $X^n$, *熵率*$H(cal(X))$定义为
  $
  H(cal(X)) = lim_(n->oo) H(X^n)
  $
]
#definition[平稳信源][
  联合分布时不变的信源称为*平稳信源*, 即满足
  $
  forall k, n, p(X_1^n) = p(X_k^(n + k - 1))
  $
  #property[熵下标可平移][
    $ H(X_1^n) = H(X_k^(n + k - 1)) = H(X_(-n)^(-1)) $
    $ H(X_n|X_1^(n-1)) = H(X_k + n| X_k^(k + n - 1)) = H(X_0|X_(-(n -1))^(-1)) $
  ]
  #property[平稳信源的熵率存在][
    平稳信源的熵率$H(cal(X))$存在, 且

    $ H(cal(X)) = lim_(n->oo)H(X_n|X_1^(n-1)) =lim_(n->oo) H(X_0|X_(-(n-1))^(-1)) $
  ]<stationaty_enropy_rate>
]

#theorem[SMB定理][
  对于平稳遍历信源$X^n$, 有
  $
  lim_(n->oo) 1/n log 1/p(x^n) =  lim_(n->oo) 1/n sum_(i=1)^n log 1/p(x_i|x_1^(i-1)) = "熵率"H(cal(X))
  $
  从而@source_codec[!!]对平稳遍历信源依然成立.
]

= Markov信源
#definition[Markov过程][
  如果
  $ p(X_i|X_(i-1)) = p(X_i|X_(i - 1), X_(i - 2), dots.h.c ) $称随机过程为*Markov过程*, 也称为*Markov链*.
  
  一般研究的Markov过程是时不变的, 类似上节所说的平稳信源.

  #definition[转移矩阵][
    Markov过程的*转移矩阵*$P_(i, j)$, 第 $i$ 行第 $j$ 列是从状态 $i$ 转移到状态 $j$ 的概率, 即
    $ P_(i j) = p(X_0 = S_j | X_(-1) = S_i) $
    从而
    $ p_X_0 = p_X_(-1) P $

    #property[多步转移的转移矩阵][
      如果单步转移矩阵为P, 那么转移 $n$ 步的转移矩阵为 $P^n$. 即
      $ p(x_n = S_j | x_0 = S_i) = P^n_(i j) $
      结合C-K方程证明.
    ]
  ]

  #definition[平稳分布][
    如果
    $ u_X = u_X P $
    称分布 $u_X$ 是平稳分布

    #remark[细致平衡条件][
      如果分布$u$ 满足细致平衡条件,即

      $ forall i, j\
      u_i P_(i j) = u_j P_(j i) $

      (直观地看,就是对于每对状态$i,j$, 从$i$ 转移到 $j$ 的概率等于从$j$转移到$i$的概率)

      那么 $u$ 是平稳分布.
    ]
  ]
]

#property[Markov过程的熵率][
  初始态为平稳分布 $u$ 的Markov过程是平稳过程.\
  根据@stationaty_enropy_rate[!!]可得:
  
  $
  H(cal(X)) &= lim_(n->oo)H(X_0|X_(-(n - 1))^(-1))\
  &= lim_(n->oo) H(X_0|X_(-1))\
  &= H(X_0|X_(-1))\
  &= - sum_i u_i sum_j P_(i j) log P_(i j)
  $
]

#definition[不可约][
  如果
  $ forall i, j, exists k, P_(i j)^k > 0 $
  称该Markov过程*不可约*.

  直观来看, 每个状态总可以转移到另一状态.
]

#definition[非周期][
  $gcd{k: P(X_k = s| X_0 = s) > 0}$ 称为状态 $s$ 的*周期*. 如果周期 > 1, 那么称状态 $s$ 是*周期的*, 否则称为*非周期的*.

  如果所有状态时周期的, 称该Markov过程是周期的. 否则称为非周期的, 即如果
  $ exists s, gcd{k: P(X_k = s| X_0 = s) > 0} = 1 $
  称该Markov过程*非周期*.

  直观来看,该状态s的所有环长度互质. 结合裴蜀定理, 充分多步之后,再走任意步都有可能走到状态s.

  #remark[
    不可约Markov过程, 各状态周期相等. 所以检查是否非周期只需要检查一个状态.
  ]
]<非周期>

#theorem[遍历性][
  有限状态的Markov链(转移矩阵为$P$), 如果不可约且非周期, 那么存在唯一平稳分布. 且该平稳分布等于极限分布
  
  $ pi_j = lim_(n->oo)p(X_n=j|X_0=i) = lim_(n->oo) P^n_(i j) > 0 $
  此时称该Markov链是*遍历*的.

  直观来看, 从任意状态出发, 该Markov链都会收敛到该唯一的平稳分布, 且各状态概率 $> 0$, 任意状态经过充分多步之后, 总会到达. 这就是就是遍历性的直觉含义.

  #proof[
    下面给出笔者的证明思路, 中间步骤交给读者完成. 
    #lemma[Perron–Frobenius定理][
      如果方阵 $A > 0$, 那么
      - A 有唯一最大模的特征值
      - 该特征值几何重数为1, 且有一个对应的正特征向量
    ]<PF定理>
    + 从不可约和非周期出发, 证明 $ exists N, forall m > N, forall i, j, P^m_(i j) > 0 $ (提示: 结合@非周期[!!]的 "直观来看"句.)
    + 证明对于一个转移矩阵, 若存在特征向量, 那么最大模特征值必为1. (提示: 对特征向量各分量求和)
    + 取一个 $m > N$, 那么 $P^m, P^(m+1), P^(m(m+1)) >0$. 根据@PF定理 和第2步, 证明三个矩阵都含有唯一各分量全正的平稳分布, 分别记为$u^((m)), u^((m+1)), u^((m(m+1)))$
    + 证明$u^((m))= u^((m+1)) = u^((m(m+1)))$, 此分布记为$u_X$(提示: $P^m$的特征向量也是$P^(k m)$ 的特征向量)
    + 证明$u_X$是转移矩阵$P$对应的唯一平稳分布.
    + 证明$u_X$是极限分布, 即$(u_X)_j = lim_(n->oo) P^n_(i j)$ (提示: 利用$u_X = lim_(n->oo) u_0P^n_(i j)$, 选择合适的$u_0$ 并比较两侧同一分量. )
  ]
]

#definition[遍历变换和遍历过程][
  对于状态空间$Omega$, 概率测度$P$, 称一个变换$T: Omega->Omega$是*遍历*的, 如果
  $ X = T(X), X subset.eq Omega "当且仅当" P(X) = 0 "或" P(X) = 1 $
  由遍历变换$T$组成的过程$X_i = T^i (X_0)$, 称为*遍历过程*.
]
显然, 遍历的Markov链, 如果从平稳状态开始, 或者经过充分多步之后收敛到平稳状态, 那么每一步表示的变换是遍历变换. 这给出了遍历的Markov链可用于遍历定理的依据. 

#theorem[遍历定理][
  设平稳遍历过程 ${X_i}$ 的变换为 $T$ (即 $X_i = T^i (X_0)$ ),那么对于任意函数 $f$:
  $ lim_(n->oo) sum_(i=1)^n f(T^i (X)) = EE[f(X)] $
]

= Markov信源(二)

#definition[Markov链][
Markov链的另一个等价定义是:如果$X bot Y | Z$, 称随机变量 $X, Y, Z$ 构成Mrkov链(记为$X->Y->Z$)
]

#theorem[数据处理不等式][
  如果$X->Y->Z$, 那么
  $ I(X; Z) <= I(X; Y) $
]<数据处理不等式>

#definition[充分统计量][
  在 $theta -> X -> T(X)$ 中, 如果$ theta -> T(X) -> X $称统计量 $T(X)$ 是充分统计量.
  #property[
    - $I(T(X);X) = I(T(X); theta)$ (从数据处理不等式立刻得到)
    - $f(x|T(x) = t, theta)$ 与 $theta$ 无关(结合Markov链的定义)
    - T(X) 是充分统计量 $<==> f(x; theta) "可写为" h(x) g(T(x); theta)$ 
  ]
]

#definition[指数族分布][
  如果
  $ f(x; theta) = h(x) exp(eta(theta)^T tau(x) - A(theta)) $
  称$f(x; theta)$ 为指数族分布.
  #property[
    - 单次实验时, $tau(x)$ 是充分统计量.
    - 多是实验时, $f(x_1, x_2, dots.h.c, x_n) = product_(i=1)^n h(x_i)exp(eta(theta)^T (sum_(i=1)^n tau(x_i)) - n A(theta))$, $sum_(i=1)^n tau(x_i)$ 是充分统计量
  ]
]

#theorem[Fano不等式][
  如果$X->Y->hat(X)$, 那么错误率$P_e eq.delta P(X != hat(X))$ 满足
  $ H(X|Y) <= 1 + P_e H(X) $
  当然可以进一步变成
  $
  P_e &>= (H(X|Y) - 1) / H(X)\
  &=( H(X) - I(X; Y) - 1 )/ H(X)\
  &== 1 - (I(X; Y) + 1 )/ H(X)\
  $
  从中可见, $H(X)$ 不变时, $H(X|Y)$ 越大, 错误率下界越高; $I(X; Y)$ 越大, 错误率下界越低, 这很符合直觉.
]<Fano不等式>

= 符号编码
概念: 前缀码、 即时码（前缀码与即时码的等价性）、非奇异码、唯一可译码, 略过.
#definition[二分分布][
  分布 $p(x) = 2^(-n_x)$， 称为二分分布.
  #property[
    - 概率最小的元素一定有偶数个.
    - 二分分布可构造一个前缀码\ 选两个概率最小的元素合并, 并分别在这两个元素的码字前添加0和1. 合并完之后, 仍然是二分分布, 递归操作.
  ]
]

设符号为随机变量$X$, 符号集为 $cal(X)$, $x$ 对应码字长为 $l(x)$, 采用二进制编码. 下述各定理都采用这些记号. 

#theorem[Kraft定理][
  存在给定长度 ${l(x)}$ 的前缀码的充分必要条件是
  $ sum_(x in cal(X)) 2^(-l(x)) <= 1 $
  #proof[
    充分性:
    #redbox[
      补充剩余概率 $1 - sum_(x in cal(X)) 2^(-l(x)) = sum_i 2^(-i)$, 形成一个二分分布, 在该二分分布构造的前缀码中只考虑$cal(X)$的元素.
    ]
    必要性:
    #bluebox[
      将前缀码对应的二叉树扩展称为满二叉树, 每个符号 $x$ 对应节点为根的子树有 $2^(l_max - l(x))$ 个叶子, 那么
      $ sum_(x in cal(X)) 2^(l_max - l(x)) <= "总叶子数" 2^(l_max) $
      所以
      $ sum_(x in cal(X)) 2^(-l(x)) <= 1 $
    ]
  ]
]<Kraft定理>

#theorem[McMillan不等式][
  码字长为 ${l(x)}$ 的唯一可译码满足
  $ sum_(x in cal(X)) 2^(-l(x)) <= 1 $
  #proof[
    记符号总数$m = abs(cal(X))$, 符号总码长 $S = sum_(i=1)^m 2^(-l_i)$.
    长度为 $N$ 的符号序列, 所有可能的序列码长之和为
    $
    S^N &= sum_(i_1 = 1)^m sum(i_2 = 1)^m dots.h.c sum(i_2 = N)^m #redbold($2^(-sum_(j=1)^N l_(i_j))$)\
    &= sum_(l = N l_min)^(N l_max) #blueit[$a_l$] #redbold($ 2^(-l)$) ("合并同类项")\
    &<= sum_(l = N l_min)^(N l_max) #blueit[$2^l$] #redbold($ 2^(-l)$) (#[唯一可译码中, 码长为 $l$ 的符号序列至多#blueit[$2^l$]个])\
    &= N(l_max - l_min)
    $
    从而
    $ S <= (N(l_max - l_min))^(1/N) $
    所以
    $ S <= lim_(N->oo) (N(l_max - l_min))^(1/N)  = 1$
  ]
  #remark[前缀码在唯一可译码的最优性][
    结合@Kraft定理, 符号编码中, 任何唯一可译码, 都能构造出码字长对应的前缀码. 所以, 在求解最优符号编码时, 只需考虑前缀码.
  ]
]

#theorem[码长下界][
符号X的期望码长$>=H(X)$.
#proof[
  求解最优期望码长的问题表述为
  $ min L = sum_(x in cal(X)) p(x)l(x)\ s.t. sum_(x in cal(X)) 2^(-l(x)) <= 1 $
  令$z =  sum_(x in cal(X)) 2^(-l(X)) <= 1$, 构造概率分布 $q(x) = 2^(-l(x))/ z$. 那么
  $ l(x) = -log q(x) - log z $
  $
  L &= sum_(x in cal(X)) p(x) l(x)\
  &= sum_(x in cal(X)) - p(x) log q(x) - p(x) log z\
  &= sum_(x in cal(X)) - p(x) log q(x) - log z\
  &>= "CE"(p, q) (#[当且仅当 $z = 1$ 即Kraft不等式取等时取等])\
  &>= H(X)(#[当且仅当$p=q$时取等])
  $
]

#remark[
  用近似分布$q$来编码真实分布$p$的符号, 最优期望码长是 $"CE"(p, q) = KL(p, q) + H(p)$. $KL(p, q)$ 衡量的是用近似分布的额外编码开销.
]
]

#theorem[变长编码定理][
  符号X,存在前缀码, 使得其平均编码码长 $L$ 满足$ H(X) <= L < H(X) + 1 $
  #proof[
    取 $l(x) = ceil(- log p(x))$即可. 这种码字长的码称*香浓码*.
  ]
]

#property[最优前缀码的性质][
  存在这样的最优前缀码, 满足
  + $forall j, k, "如果"p_j > p_k, "那么" l_j <= l_k$
  + 最长的两个码字长度相等
  + 最长的两个码字仅在最后一位有区别, 对应概率最小的两个符号
]<最优前缀码的性质>

#theorem[Huffman编码的最优性][
  在符号编码中, Huffman编码的期望码长是最优的.
  #proof[
    将分布$ bold(p) = (p_1, p_2, dots, p_m) (p_1 <= p_2 <= dots <= p_m) $ 的两个最小概率符号融合, 得到$ bold(p)' = (p_1, p_2, dots, p_(m - 1) + p_(m + 1)) $

    要证明Huffman编码的最优性, 只需证明$bold(p)$的最优前缀码可由$bold(p)'$的最优前缀码扩展#footnote[*扩展*: 将 $bold(p)'$ 中$p_(m - 1) + p_(m + 1)$对应码字末尾分别添上0和1作为 $bold(p)$ 中 $p_(m - 1)$ 和 $p_(m + 1)$ 的对应码字将]得到即可.

    #redbox[
      *扩展* 将$bold(p)'$的最优前缀码 (期望码长为$L^*(bold(p)') = sum_(i=1)^(m) p_i l'^*_i$), 扩展得到 $bold(p)$ 的码, 其期望码长
      $ 
      L(bold(p)) &= sum_(i=1)^(m-2) p_i l'^*_i + p_(m-1) (l'^*_(m-1) + 1) + p_m (l'^*_m + 1)\
      &= sum_(i=1)^(m) p_i l'^*_i + p_(m-1) + p_m\
      &= L^*(bold(p)') + p_(m-1) + p_m
      $<扩展>
    ]

    #bluebox[
      *合并* 用 $bold(p)$ 的满足@最优前缀码的性质 的最优前缀码 (期望码长为$L^*(bold(p)) = sum_(i=1)^(m) p_i l^*_i$), 合并两个概率最小符号的码字#footnote[*合并*: 这两个码字都去掉最后一位即相同], 得到 $bold(p)'$ 的码, 其期望码长
      $ 
      L(bold(p)') &= sum_(i=1)^(m-2) p_i l^*_i + p_(m-1) (l^*_(m-1) - 1) + p_m (l^*_m - 1)\
      &= sum_(i=1)^(m) p_i l^*_i - p_(m-1) - p_m\
      &= L^*(bold(p)) - p_(m-1) - p_m
      $<合并>
    ]
    将@eqt:扩展 和@eqt:合并 相加, 得到
    $ (L(bold(p)) - L^*(bold(p))) + (L(bold(p)') - L^*(bold(p)')) = 0 $
    考虑到 $L^*(bold(p))$ 和 $L^*(bold(p)')$ 的最优性, 可得
    #grid(
      columns: (1fr, 1fr),
      //align: ,
      gutter: 1em,
      
    )[$ L(bold(p)) = L^*(bold(p)) $][$ L(bold(p)') = L^*(bold(p)') $]
    这就说明$bold(p)'$ 扩展得到的码 (期望码长 $L(bold(p))$ ), 也是 $bold(p)$ 的最优码(期望码长 $L^*(bold(p)$ ), 从而求解$bold(p)$的最优码, 只需求解$bold(p)'$的最优码, 这正是Huffman编码的过程.
  ]
]

#remark[
  - Huffman编码的平均码长 $<=$ 香浓码的平均码长
  - Huffman编码与一套Yes/No问题等价.
]

= 信道容量

概念: 通信模型、信道矩阵($p_(i j) = p_(Y divides X) (Y = j divides X = i)$)、离散无记忆信道、信道编码、传输率、可达传输率

#definition[信道容量][
  信道 $P(Y|X)$ 的信道容量 $C^I$ 定义为
  $ C^I eq.delta max_(P_X) I(X; Y) $
  #greybox(width:100%)[
    *信道容量的计算*

    #grid(
      columns: (3fr, 1fr, 3fr),
      align: (horizon, horizon, horizon),
      // gutter: 1em,
      
    )[
    $
    C^I = max_(P_X) I(X; Y)\
    x.t. sum_x p(x) = 1\
    p(x) >= 0 comma forall x in cal(X)
    $
    ][
      $ ==> $
    ][
      $
      C^I = - min_(P_X) -I(X; Y)\
      x.t. sum_x p(x) = 1\
      - p(x) <= 0 comma forall x in cal(X)
      $
      #align(center)[(凸优化问题标准形式)]
    ]
    拉格朗日函数:
    $ L(p , lambda , {mu_i }) = - I(X; Y) + lambda(sum_i p_i - 1) - sum_i mu_i p_i) $
    KKT条件:
    #grid(
      columns: (4fr, 1fr, 4fr),
      align: (horizon, horizon, center + horizon),
      // gutter: 1em,
      
    )[
    $ (partial L(p, lambda, {mu_i }))/(partial p_i) =  (partial I(X; Y))/ (partial p_i) - lambda + mu_i = 0\
    mu_i >=0\
    mu_i p_i = 0\
    sum_i p_i = 1\
    $][$ ==> $][
      #rect[$ cases((partial I(X; Y))/(partial p_i) = lambda quad a n d quad p_i > 0,
      (partial I(X; Y))/(partial p_i) <= lambda quad a n d quad p_i = 0)\
      sum_i p_i = 1\
      $]
    ]
    导数计算
    #align(center)[
      #rect[$ (partial I(X; Y))/(partial p_i) = D_(K L) (p(y|X = x_i)||p(y) ) - 1 $]
    ]
  ]
]

#definition[弱对称信道][
  如果信道矩阵每一行是其他行的置换, 每一列元素和 $sum_x p(y|x)$ 相等, 那么称该信道是*弱对称的*.

  弱对称信道的信道容容易求出, 设 $upright(bold(r))$ 为转移矩阵的一行, 则有
  $
  I(X;Y) &= H(Y) - H(Y|X)\
  &= H(Y) - H(upright(bold(r)))\
  &<= log abs(cal(Y))  - H(upright(bold(r)))
  $
  当且仅当Y为均匀分布时取得等号. 而且, $p(x) = 1 / (log abs(cal(X)))$ 可以让 $Y$ 达到均匀分布, 这是因为
  $
  p(y) = sum_(x in cal(X)) p(y|x) p(x) = 1 / (log abs(cal(X)))sum p(y|x) = c 1/abs(cal(X)) = 1/abs(cal(Y))
  $

]

#image("assets/image-1.png")

#theorem[噪声信道编码定理][
- 正：如果 $ R < max_(P_X) I(X; Y) $则存在编码方案，使得 *传输误差* 无限趋近于零
- 反：如果 $ R > max_(P_X) I(X; Y) $则 *传输误差* 必大于零

#let jts = $A_epsilon^((n))(X, Y)$
#proof[
  #definition[联合典型集][
  分布 $P(X, Y)$ 的联合典型集#jts 定义为
  $
    jts eq.delta { (x^n, y^n) mid(|)
      &| 1/n log 1/(p(x^n)) - H(X) |  <= epsilon pin("X"), \
      &| 1/n log 1/(p(y^n)) - H(Y) | <= epsilon pin("Y"), \
      &| 1/n log 1/(p(x^n, y^n)) - H(X,Y) | <= epsilon pin("X, Y")
    }
  $
  #pinit-point-from("X", pin-dy: -5pt, body-dy: -5pt, offset-dy: -35pt)[$x^n$ 是 $p_X$ 的典型序列]
  #pinit-point-from("Y", pin-dy: -5pt, body-dy: -5pt, offset-dy: -35pt)[$y^n$ 是 $p_Y$ 的典型序列]
  #pinit-point-from("X, Y", pin-dy: -10pt, pin-dx: -30pt, body-dy: -5pt, offset-dx: -5pt, offset-dy: -35pt)[$(x^n, y^n)$ 是 $p_(X Y)$ 的典型序列]
  
  #property[
    如果$(X_i, Y_i) i.i.d ~ P_(X Y)(x, y)$, 那么$forall epsilon > 0$
    - $ P((x^n, y^n) in jts) attach(-->, t:n->oo) 1 #[(类似@高概率)] $ <联合典型集高概率>
    - $ p("集合中元素") <= 2^(-n(H(X) - epsilon)) #[(类似@概率上下界)] $
    - $ |jts| <= 2^(n (H(X, Y) + epsilon)) #[(类似@数量上下界)] $
  ]

  #property[
    假如 $tilde(X)_i$ 和 $tilde(Y)_i$ 相互独立，且 $tilde(X)_i ~ X$，$tilde(Y)_i ~ Y$，即：
    $
    tilde(X)_i "i.i.d." ~ P_X (x) = sum_Y P_(X Y)(x, y)
    $

    $
    tilde(Y)_i "i.i.d." ~ P_Y (y) = sum_X P_(X Y)(x, y)
    $

    如果 $tilde(x)^n$ 来自 $tilde(X)^n$，$tilde(y)^n$ 来自 $tilde(Y)^n$，则 $(tilde(x)^n, tilde(y)^n)$ 落在典型集 $jts$ 中的概率为：

    $
    p((tilde(x)^n, tilde(y)^n) in jts) <= 2^(-n (I(X;Y) - 3 epsilon))
    $

    #proof[
      $
      p((tilde(x)^n, tilde(y)^n) in jts) &= sum_((x^n, y^n) in jts) #redbold($p(x^n) p(y^n)$) \
      &<= #blueit($abs(jts)$) #redbold($2^(-n(H(X) - epsilon)) 2^(-n(H(Y) - epsilon))$)\
      &<= #blueit($2^(n (H(X, Y) + epsilon)$) #redbold($2^(-n(H(X) - epsilon)) 2^(-n(H(Y) - epsilon)$)\
      &= 2^(-n (I(X;Y) - 3 epsilon))
      $
    ]
    ]<独立低概率>
  ]

  #redbox(width:100%)[
    #let to0 = $attach(-->, t: n->oo)  0$
    *正向命题的证明*

    $n->oo$时, 要想存在编码方案 $C_n^*$, 使得 $ P(hat(U) != U|C_n^*) to0 $ 只需$ EE_(C_n ~ C) P(hat(U) != U | C_n) to0 $

    (这是因为误差最小编码方案$C_n^*$满足($P(hat(U) != U|C_n^*) <= EE_(C_n ~ C) P(hat(U) != U | C_n)$)

    而
    $
    EE_(C_n ~ C) P(hat(U) != U | C_n)
    &= P(hat(U) != U)\
    &= sum_(u in cal(U)) P(U = u)P(hat(u) != u | U = u)\
    $
    所以只需
    $
    forall u in cal(U), P(hat(u) != u | U = u) to0
    $<误差接近0>

    如下设计编码方案的分布 $C$:
    + 任取 $P_X$, 然后取 $R<I(X; Y)$. 
    + *编码* 从 $typset(X)$ 的约 $2^(n H(X))$ 个典型序列中*独立*地随机选取 $M$ 个作为码字集 ${x^n (i)}_(i=1)^(M)$ (因为$M = 2^(n R) <= 2^(n I(X;Y)) <= 2^(n H(X)$, 这是可行的).
    + *译码* 发送状态$U = u$, 收到 $y^n$, 若存在唯一$s$ 使 $(x^n (s), y^n) in jts$, 则译码 $hat(u) = s$.

    $hat(u) = u | U = u$ 的充要条件是
    $ (x^n (u), y^n) in A_e^(n) (X, Y) "且" forall k != u,(x^n (k), y^n) in.not A_e^(n) (X, Y) $
    所以 $hat(u) != u | U = u$ 的充要条件是
    $ (x^n (u), y^n) in.not jts "或" exists (x^n (k), y^n) in A_e^(n) (X, Y) $

    所以
    $
    P(hat(u) != u | U = u) =& P((x^n (u), y^n) in.not jts "或" exists (x^n (k), y^n) in A_e^(n) (X, Y) | U = u)\
    <=& underbrace(P((x^n (u), y^n) in.not jts |U = u), #[根据@eqt:联合典型集高概率 此项 #to0]) \
    &+ #redbold($sum_(k!=u)  (x^n (k), y^n) in.not A_e^(n) (X, Y) | U = u)$)
    $
    下面考虑第二项, 注意到 $x^n (k)~P_X, y^n ~sum_X P_X P_(Y|X) = P_Y$, 而且 $k!=u$ 时, $x^n (k) bot x^n (u)$, 从而$x^n (k) bot y^n$, 由@独立低概率 得
    $
    #redbold($sum_(k!=u)  (x^n (k), y^n) in.not A_e^(n) (X, Y) | U = u)$) <=& (M - 1) 2^(-n(I(X;Y) - 3 epsilon))\
    <=& M 2^(-n(I(X;Y) - 3 epsilon))\
    <=& 2^(n R) 2^(-n(I(X;Y) - 3 epsilon))\
    <=& 2^(-n(I(X;Y) - R - 3 epsilon))
    $
    取 $R<I(X; Y)$ 时 取充分小的 $epsilon$, $2^(-n(I(X;Y) - R - 3 epsilon)) to0$,所以
    $
    #redbold($sum_(k!=u)  (x^n (k), y^n) in.not A_e^(n) (X, Y) | U = u)$) to0
    $
    进而
    $ P(hat(u) != u | U = u) to0 $
    也就在 $R<I(X; Y)$ 的条件下, 得到了@eqt:误差接近0.
    
    在设计编码方案分布 $C$ 时, 取 $P_X = argmax_(P_X) I(X; Y)$, 那么@eqt:误差接近0 的条件( $R<I(X; Y)$ )的条件即变为 $R < P_X = max_(P_X) I(X; Y)$. 从而正向命题得证.
  ]
  #remark[
    如果状态 $U$ 均匀分布, 那么最优编码方案 $C^*_n$ 的单个状态最大错误率能逼近0:
    $ max_u P hat(U) != U |U = u, C^*_n ) attach(-->, t:n->oo) 0 $
  ]
  #property[无记忆信道的互信息不等式][
    $ I(X^n ; Y^n) <= sum_(i = - 1)^n I(X_i ; Y_i) $
    #proof[
    $
    I(X^n ; Y^n) &= H(Y^n) - H(Y^n |X^n)\
    &= H(Y^n) - sum_(i = 1)^n H(Y_i |X_i)\
    &<= sum_(i = 1)^n H(Y_i) - sum_(i = 1)^n H(Y_i |X_i)\
    &= sum_(i = 1)^n I(X_i ; Y_i)
    $
    ]
  ]<无记忆信道的互信息不等式>

  #bluebox(width: 100%)[
    *反向命题的证明*

    结合@无记忆信道的互信息不等式 和 @数据处理不等式 可得:
    $ I(U; Y^n) <= I(X^n ; Y^n) <= sum_(i = 1)^n I(X_i ; Y_i) <= n C^l $
    当 $U$ 均匀分布时，$P(hat(U) != U) = 1 / M sum_(i=1)^M P(hat(U) != U | U = i)$ 代表平均错误率.

    在 $U->Y^n->hat(U)$ 中, 由@Fano不等式
    $
    P(hat(U) != U) &>= 1 - (I(U;Y^n) + 1)/ (H(U))\
    &= 1 - (I(U;Y^n) + 1)/ (log M)\
    &>= 1 - (n C^I)/(log M) - 1/(log M)\
    &= 1 - (C^I)/R - 1/(n R)
    $
    $R > C^I, n->oo$ 时, $P(hat(U) != U) > 0$  
  ]
  ]
  
  #remark[反馈信道][
    因为反馈信道仍然满足$ I\(U\;Y^n\)lt.eq sum_(i = 1)^n I\(X_i\;Y_i\)lt.eq n C^I $
    所以反馈信道依然适用反向命题的证明, 这说明引入反馈不能提高信道容量. 任何反馈信道都可以的信道容量都可以被不带反馈的信道达到.
    #image("assets/image-6.png")
  
  ]

]

= 连续的情形
概念: 微分熵（不保持非负性）等
#property[微分熵的变量替换][
  $ h(A X + c) = h(X) + log|d e t(A)| $
]

#remark[
  用精度 $Delta$ 量化连续分布$p_k = integral_(k Lambda)^((k + 1) Delta) f(x) d x = f(x_k) Delta, exists x_k$，那么离散分布 $ X^Delta ~ p_k$ 的熵
  $ H (X^Delta ) approx h(X) + log 1/Delta $
  如果 $Delta = 2^(- n)$ ，则 $H\(X^Delta\)approx h\(X\)+ n$ 为将$X$ 量化成 $n$ bit精度，需要的平均bit数

]
== 高斯分布
#tip-block[
  $ t r (EE_p [X] ) = EE_p [t r(X)] $
  $ t r(A B C)= t r(C A B)= t r(B C A) $
]

#property[微分熵][
$X ^ ( n ) = ( X _ ( 1 ), X _ ( 2 ),... X _ ( n ) ) tilde cal( N ) ( mu, Sigma)$那么
$
  h ( X ^ ( n ) ) = h ( X _ ( 1 ), X _ ( 2 ),... X _ ( n ) ) = ( n ) / ( 2 ) log ( 2 pi e ) + ( 1 ) / ( 2 ) log abs( bold( upright( Sigma ) ) )
$

#property[高斯分布是最大微分熵分布][
  对任意 $n$ 维期望为 $bold(mu)$ 且协方差为$bold(Sigma)$ 的分布 $X^n$ ，其熵：
  $ h ( X ^ ( n ) ) <= ( n ) / ( 2 ) log ( 2 pi e ) + ( 1 ) / ( 2 ) log abs( bold( upright( Sigma ) ) ) $

  #proof[
    记 $X^n$ 的分布为 $f$. 记n维期望为 $bold(mu)$, 方差为 $bold(Sigma)$ 的高斯分布为 $g$.
    $
      h(X^n) &= KL(f||g) + "CE"(f, g)\
      &<= "CE"(f, g)\
      &= EE _ ( f ) [ - log g ( bold(x) ) ]\
      &= 1/2 EE_f [ n log(2pi) + log(abs(bold(Sigma))) + log e ( x - mu ) ^ ( T ) bold( upright( Sigma ) ) ^ ( - 1 ) ( x - mu )]\
      &= 1/2(n log(2pi) + log(abs(bold(Sigma)))) + log e #redbold($EE_f [tr(( x - mu ) ^ ( T ) bold( upright( Sigma ) ) ^ ( - 1 ) ( x - mu ))]$)\
      &= ( n ) / ( 2 ) log ( 2 pi e ) + ( 1 ) / ( 2 ) log abs( bold( upright( Sigma ) ) )\
    $
    最后一步是因为
    $
      #redbold($EE_f [tr(( x - mu ) ^ ( T ) bold( upright( Sigma ) ) ^ ( - 1 ) ( x - mu ))]$) 
      &= EE_f [tr( bold( upright( Sigma ) ) ^ ( - 1 ) ( x - mu ) ( x - mu ) ^ ( T ))]\
      &= tr( EE_f [ bold( upright( Sigma ) ) ^ ( - 1 ) ( x - mu ) ( x - mu ) ^ ( T )])\
      &= tr( bold( upright( Sigma ) ) ^ ( - 1 ) EE_f [ ( x - mu ) ( x - mu ) ^ ( T )])\
      &= tr( bold( upright( Sigma ) ) ^ ( - 1 ) bold( upright( Sigma ) ))\
      &= n\
    $

    #remark[
      从该证明中可见, 对于高斯分布 $g(bold(x))$, 任意同期望, 同方差的分布 $f(bold(x))$
      $
        "CE"(g, f) = h(g)
      $
    ]

  ]
]

]


#property[互信息][
  $ I(X^m;Y^n)= h(X^m)+ h(Y^n)- h(X^m,Y^n)= 1 / 2 upright(l o g) frac(|Sigma_(X^m)||Sigma_(Y^n)|, lr(|Sigma_(j o i n t)|)) $
  #remark[高斯分布的互信息衡量线性相关性][
    $I(X_1;X_2)= 0$ 当且仅当 $rho = 0$

    $ I(X_1;X_2)= 1 / 2 upright(l o g) frac(sigma_1^2 sigma_2^2, sigma_1^2 sigma_2^2(1 - rho^2)) = - 1 / 2 upright(l o g)(1 - rho^2) $

  ]
]

#property[KL散度][
  $p(x)=cal(N)(bold(mu)_1,bold(Sigma)_1), q(x)=cal(N)(bold(mu)_2,bold(Sigma)_2)$那么
  
  $ D_(K L)^((log_2 *))(p||q)= frac(1, ln 2) D_(K L)^((ln *))(p||q) $

  $ D_(K L)^((l n))(p||q)= integral p(x)ln frac(p(x), q(x)) d x 
 \ = 1 / 2 ln abs(bold(Sigma_2)) / abs(bold(Sigma_1)) - n / 2 + 1 / 2 tr ( upright(bold(Sigma))_2^(- 1) upright(bold(Sigma))_1 ) + 1 / 2(bold(mu)_2 - bold(mu)_1\)^T upright(bold(Sigma))_2^(- 1)\(bold(mu)_2 - bold(mu)_1) $
]

== 高斯信道

#definition[高斯信道][
  $ Y_i = X_i + W_i\ W_i ~ cal(N) (0, sigma^2) $
  $X_i$ 幅度越大噪声影响越小, 但幅度不能无限大, 表现为功率限制:
  $ EE[X_i^2] <= P $

  #property[高斯信道的容量][
    $
    I(X; Y) &= h(Y) - h(Y|X)\
    &= h(Y) - h(X + W |X)\
    &<= h(cal(N)(0, "Var"(X) + sigma^2)) - h(W|X)\
    &= h(cal(N)(0, "Var"(X) + sigma^2)) - h(cal(N)(0, sigma^2)))\
    &= 1/2 log (1 + P / sigma^2)
    $
    当X取 $cal(N)(0,P)$ 的时候取得等号.

    #remark[高斯信道的容量的几何解释][
      #image("assets/image-2.png")
    ]
  ]
]

#definition[并行高斯信道][ 
    单个功率限制为 $P$ 高斯信道的容量为 $C^I = 1/2 log (1 + P/sigma^2)$. 当每个信道可以并行传输, 且各自的噪声 $W_i$ 具有自己的方差 $N_i^2$时, 形成并行高斯信道:
    $ Y_i = X_i + W_i, quad W_i~cal(N)(0,N_i), quad i = 1, 2, dots, n $ 
    要求解的问题是: 如何分配功率, 使总信道容量最大, 即
    $ max_{P_i} 1/2 log (1 + P/N^i) \ s.t. sum_i P_i = P\ P_i>=0 $

    #remark[水填充][
      利用KKT条件求解上述问题, 可以得到如下解
      $ P_i^(*) =\(mu - N_i\)^(+)= max\(mu - N_i\,0\)\ sum_(i = 1)^n\(mu - N_i\)^+= P $
      形象地理解为"水填充"问题: 用 $P$ 体积的水来填充位置 $i$ 处高度为 $N_i$ 的水池, 填充完之后各个位置的水深即为对应信道分配的功率 $P_i$. 这个问题的求解, 可以用二分答案法.

      #figure(image("assets/image-3.png", width: 50%))
    ]
]

= Hamming码
概念: 零空间编码、Galois-field算数、GF(2)
#definition[零空间编码][
  对于变换 $H$, 零空间$"Null"(H) = {x| H x = 0}$, 取 $"Null"(H)$ 为数据流形.
]

#definition[GF(2)域][
  GF(2)域采用数域${0, 1}$, 用异或替代加法运算.
]

#remark[$"GF"(2)^(m times n)$ 上的矩阵， 也满足秩-零度定理]

#definition[Hamming码][
  在零空间编码中，取变换 $H$ 为GF(2)域上的矩阵, 第k列为二进制数k的位向量. H有m行, $n = 2^m - 1$ 列. 这样的零空间编码, 称为*Hamming码*. 矩阵 $H$也称Hamming矩阵.

  #property[Hamming矩阵满秩][H第 $2^t space (t = 0, 1, 2, dots, m-1)$ 列组合成的子矩阵行列式非零, 所以H满秩, $"Rank"(H) = m$, 零空间维度为$n - m$, 这也是可用于编码数据的位数.]

  #property[Hamming纠错][传输数据(二进制序列) $x^n$ 只错第k位时, $H(x^n + e_k) = H e_k = "H第k列"H_k$. 只错一位时, 可以纠错.
  
  错两位时, 可检测.

  错三位以上, 无法检测.
  ]<Hamming纠错>

  #remark[求解 $H$ 的零空间][
    H第 $2^t space (t = 0, 1, 2, dots, m-1)$ 列天然可以当作主元列, 此时主元的结果是所该主元所涉及的其他位的异或和, 即1出现的奇偶性.

    这给出了用"奇偶校验"法求 $H$ 的零空间的方法: *对所有非主元任意赋值, 然后用主元存奇偶校验的结果*.
  ]<求解Hamming矩阵零空间>
  @求解Hamming矩阵零空间 也给出了如何在零空间存储数据: 在非主元存数据, 用主元存做奇偶校验位. 这也直观地解释了可用于编码数据的位数为何为 $n - m$.
  
  在收到数据 $x^n$ 后, $H x^n$ 就给出了每一个校验位的奇偶校验结果. 由此, 实际解码过程中, 可不用计算矩阵乘法, 而用分组奇偶校验替代.
]

#property[Hamming矩阵零空间的性质][
  - 除了全零元之外，其他码字非零元个数均不小于 3 \ 证明： $H$ 的各列向量不相同
  - 不同码字之间汉明距离均不小于3 \ 证明：
  $ D_H\(x^n\,y^n\)= sum_(k = 1)^n x_k xor y_k =\|x^n + y^n\|=\|z^n\|gt.eq 3 $
  #remark[第二点性质, 也为@Hamming纠错 提供了直观解释:\ 每个码字之间的距离不小于3, 从合法码字出发, 当偏差1步时可以归类的最近的码字上, 当偏差2步时可以检测错误, 当偏差3步时有可能偏移到其他码字上, 无法检测是否出错.]
]

= 率失真
#figure(image("assets/image-4.png"))
概念: 压缩率(Rate)、 失真度、可达与不可达

#definition[率失真函数][
  率失真函数 $R(D)$ 表示给定失真度限制$D$时， 最小可达压缩率$R$, 即
  $ min R\ s.t. EE[d(V^N, hat(V)^N)] = EE[d(V, hat(V))] <= D $
  率失真定理说明
  $ R(D) = R^I (D)= min_(p(hat(V)|V)) I(V,hat(V)) $

  #property[凸性][
    $R^I\(D\)$ 是凸函数, 即
    $ forall D_1, D_2, 0 <= lambda <= 1: quad R^I\(lambda D_1 +\(1 - lambda\)D_2\)lt.eq lambda R^I\(D_1\)+\(1 - lambda\)R^I\(D_2\) $
  ]

  #property[零失真][
    $ R\(0\)= H\(V\) $
  ]
  #property[零码率][
    存在 $D_(m a x)$ ，使得 $R\(D_(m a x)\)= 0$. 且当 $D gt.eq D_(m a x)$时， $R\(D\)= 0$
    $ D_(m a x) = min_(p\(hat(V)\)) sum_(p\(hat(V)\)) sum_(p\(V\)) p\(hat(V)\)p\(V\)d\(V\,hat(V)\) $
  ]
  #property[单调递减][
    $R\(D\)= R^I\(D\)$ 是单调递减函数
  ]
]

#proposition[高斯信源的率失真][
  高斯信源 $V ~ cal(N)(0, sigma^2)$, 取失真函数$d\(v\,hat(v)\)=\(v - hat(v)\)^2$， 那么高斯信源的率失真函数为 $ R^I (D) = cases(1/2 log sigma^2/D comma 0 <= &D <= sigma^2, 0 comma &D > sigma^2) $
  #proof[
    $
    I(V; hat(V)) &= H(V) - H(V|hat(V))\
    &= H(V) - H(V - hat(V) | hat(V))\
    &>= H(V) - H(V - hat(V)) (#[当且仅当$V - hat(V) bot hat(V)$时取等]\
    &>= H(V) - H(cal(N)(0, D)) (#[当且仅当$V - hat(V) ~ cal(N)(0,D)$时取等])\
    &= 1/2 log sigma^2/D
    $
    $0 <= D <= sigma^2$时, 令$G ~ cal(N)\(0\,D\)$ $V = hat(V) + G .$
    $hat(V)$ 与 $G$ 独立. 可以满足取等条件.\
    $D > sigma^2$ 时, 取$hat(V) = 0$ 可满足$EE((hat(V) - V)^2) <= D$, 同时$I(V; hat(V))=0$.

    // $ hat(V) ~ cal(N)\(0\,sigma^2 - D\) $

  ]

  #remark[几何解释][
    #figure(image("assets/image-5.png"))
  ]
]

#remark[信源信道可分离][
  信源信道联合编码, 不能取得分离编码达不到的速率.
  #proof[
    #redbox(width: 100%)[
      *联合编码* 
      #image("assets/image-8.png")
      $ #[存在速率为$N/n$的联合编码方案]==> N R^I\(D\)lt.eq I (V^N\;hat(V)^N) lt.eq I\(X^n\;Y^n\)lt.eq n C^I $

    ]
    #bluebox(width: 100%)[
      *分离编码*
      #image("assets/image-7.png")
      $ N R^I\(D\) <= n C^I <==> exists M,quad N R^I\(D\)<= log M <= n C^I <==> #[存在速率为$N/n$的分离编码方案] $
    ]
    所以
    $ #[存在速率为$N/n$的联合编码方案]==> N R^I\(D\) <= n C^I <==> #[存在速率为$N/n$的分离编码方案] $
    也就是说, 任意联合编码方案, 都存在能达到相等速率的分离编码方案.
  ]
]