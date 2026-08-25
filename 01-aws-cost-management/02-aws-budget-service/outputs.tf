output "id" {
  description = "ID from AWS Budget."
  value       = aws_budgets_budget.this.id
}

output "name" {
  description = "Name AWS Budget."
  value       = aws_budgets_budget.this.name
}

output "arn" {
  description = "ARN from AWS Budget."
  value       = aws_budgets_budget.this.arn
}