# DAY 2 HOMEWORK
#
# 名前：

# 以下の質問を答えるのに、まずはBLASTデータ（4_相同性が高い生物種リスト(BLAST結果10位まで)_ALL.xlsx）
# を読み込んでから、janitorパッケージのclean_names()関数で行の名前をきれいにしてください。

# 1. パイプ（%>%）を使って、次の作業を行なって下さい：blast_animalsからchiba_1_zbjとtarget_top1の
# 行だけを選んで、リード数が0よりも多いOTUだけに絞る。

# 2. パイプ（%>%）を使って、種（target_top1）ごとにのアラインメントの長さ（alignment_length_top1）
#　の平均を計算して下さい。

# 3. ggplot()を使って、identity_top1とalignment_length_top1の関係を可視化して下さい
