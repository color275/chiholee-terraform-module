locals {
  state_tags = {
    
  }
  tags_merge = merge(var.tags, local.state_tags)
}