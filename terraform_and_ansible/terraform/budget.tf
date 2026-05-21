resource "aws_budgets_budget" "cost_alert_30usd" {
  name              = "monthly-budget-alert-30usd"
  budget_type       = "COST"
  limit_amount      = "30"
  limit_unit        = "USD"
  time_period_start = "2026-05-01_00:00" 
  time_unit         = "MONTHLY"

  # Cấu hình gửi mail cảnh báo
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100        
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"    
    subscriber_email_addresses = ["tienlehoanghn2005@gmail.com"] #
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80          
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED" 
    subscriber_email_addresses = ["tienlehoanghn2005@gmail.com"]
  }
}