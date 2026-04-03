#' OWCE重叠权重计算函数
#'
#' 基于广义倾向得分（GPS）的密度比构建重叠权重，用于因果推断中的协变量平衡
#' 自动适配 1个 或 多个协变量，严格保留原始OWCE核心计算公式
#'
#' @param data 数据框，必须包含暴露变量 E，其余所有列自动作为协变量
#' @return 输入的数据框，新增4列：
#'         mu: 广义倾向得分的预测均值
#'         ex: 暴露变量的条件密度值
#'         ipw_weight: 逆概率权重
#'         overlap_weight: 最终OWCE重叠权重
#' @export
#' @examples
#' # 单协变量示例
#' set.seed(123)
#' data1 <- data.frame(E = rnorm(100), X = rnorm(100))
#' res1 <- owce_weight(data1)
#' head(res1)
#'
#' # 多协变量示例
#' data3 <- data.frame(E = rnorm(100), age = rnorm(100), bmi = rnorm(100))
#' res3 <- owce_weight(data3)
#' head(res3)
owce_weight <- function(data) {
  E <- NULL

  # 输入校验
  if (!is.data.frame(data)) stop("输入必须是数据框")
  if (!"E" %in% colnames(data)) stop("必须包含暴露变量列 E")

  # 拟合GPS模型
  gps_fit <- stats::lm(E ~ ., data = data)

  sigma_hat <- stats::sigma(gps_fit)
  data$mu <- stats::predict(gps_fit)
  ex <- stats::dnorm(data$E, mean = data$mu, sd = sigma_hat)
  data$ipw_weight <- stats::dnorm(data$E, mean(data$E), stats::sd(data$E)) / ex

  # OWCE权重核心公式
  n_sample <- nrow(data)
  data$overlap_weight <- NA
  for (j in 1:n_sample) {
    data$overlap_weight[j] <- data$ipw_weight[j] /
      mean(1 / stats::dnorm(data$E, mean = data$mu[j], sd = sigma_hat))
  }

  # 补充ex列
  data$ex <- ex

  return(data)
}
