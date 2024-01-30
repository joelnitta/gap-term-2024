library(tidyverse)
library(readxl)

# フローサイトメーターのデータを読み込む
flow_cyt_data_raw <- read_excel(
  "data_raw/itadori_flowcyt.xlsx", sheet = 2
)

# スタンダードのゲノムサイズ（pg）を設定する
tomato_size_pg <- 1.96

# 必要なデータだけに絞って、欠測グデータを排除して、サンプルのゲノムサイズを計算する
flow_cyt_data <-
  flow_cyt_data_raw %>%
  select(id_num = 通し番号, tomato_peak = トマト数値, sample_peak = サンプル数値) %>%
  filter(!is.na(tomato_peak)) %>%
  filter(!is.na(sample_peak)) %>%
  filter(tomato_peak > 0, sample_peak > 0) %>%
  mutate(sample_size = sample_peak * tomato_size_pg / tomato_peak)

# kmeansによって倍数性を推測する（グループ分けする）
# 先行研究によって、４つのサイトタイプが知られている
set.seed(123)
size_clusters <- kmeans(flow_cyt_data$sample_size, centers = 4)

# データに倍数性を追加する
flow_cyt_data <-
  flow_cyt_data %>%
  mutate(cluster = size_clusters$cluster) %>%
  mutate(ploidy = case_when(
    cluster == 1 ~ "6x",
    cluster == 2 ~ "8x",
    cluster == 3 ~ "2x",
    cluster == 4 ~ "4x"
  )) %>%
  mutate(ploidy = factor(ploidy, levels = c("2x", "4x", "6x", "8x")))

# ゲノムサイズと倍数性をプロットする
ggplot(flow_cyt_data, aes(x = sample_size, y = ploidy)) +
  geom_jitter()

# ヒストグラムによって推測した倍数性を確認する
ggplot(flow_cyt_data, aes(x = sample_size)) +
  geom_histogram(bins = 50) +
  geom_rug(aes(color = ploidy)) +
  geom_vline(
    data = as_tibble(size_clusters$centers),
    aes(xintercept = V1)
  )
